require 'net/http'
require 'json'
 
 class HTTPRequestDataParser
  
  autoload :ModelGenerator,         'ModelGenerator/ModelGenerator'

   attr_accessor :flags
   attr_accessor :primary_key

 	def type_mapping(parse_object)
 		if  parse_object.kind_of? Fixnum
 			return  "int"
    elsif parse_object.kind_of? Float
      return "float"
    elsif parse_object.kind_of? String
 	    	return "string"
    elsif parse_object.kind_of? Array
 			  return "array"
    elsif parse_object.kind_of? FalseClass
        return "bool"
    elsif parse_object.kind_of? TrueClass
        return "bool"
 		end
 	end
 	
 	def fetch(urlString,class_mapping)
     puts  "start request #{urlString}..."
 		 uri = URI(urlString)
 		 res = Net::HTTP.get_response(uri)
		 if res.is_a?(Net::HTTPSuccess) 
		 	  json_objects = JSON.parse(res.body)
        parse(json_objects,class_mapping)
		 end
 	end

    def get_hash_from_array(json_object)
    	if  json_object.instance_of? Array
	    	 if json_object.length > 0  
	    	    json_object = json_object[0]
	    	    json_object = get_hash_from_array(json_object)
	    	 else
                return json_object
	    	 end
	    else
	    	return json_object
	    end
    end

 	def parse(json_object,class_mapping)
        
      json_object = get_hash_from_array(json_object)
      
      model_generator=ModelGenerator.new
	    class_mapping.each_pair do |key , value|

	    	command_line = value
        command_line = command_line + " "  + @flags  if @flags
	    	path_components = key.split "/"
            
            final_object = json_object 
            path_components.each do |compoment|
               compoment_value = final_object[compoment]
               if compoment_value == nil || compoment_value.length ==0
                   puts "Make sure your http response is JSON and your JSON content path is correct"
               else
               	  final_object = get_hash_from_array(compoment_value)
               end
            end 
            #parse finnal object to command_line
            index = 0
            final_object.each_pair do |key ,value|
                param = @primary_key == key || (@primary_key.empty? && index==0) ? "*" : ""
                param += "#{key}:#{type_mapping value}"
                command_line = command_line + " " + param
            end
            
            foo_argv = command_line.split " "
            commandTask = model_generator.analyze_command(foo_argv)
            model_generator.generate_header
            model_generator.generate_source

            puts  "generate #{value} entity"
	    end
	           
 	end

 end




