class CommandTask
  attr_reader :property_name_type_hash
  attr_reader :property_name_format_hash
  attr_reader :property_name_json_hash
  attr_reader :json_name_type_hash
  attr_reader :json_name_format_hash
  attr_reader :flags
  attr_reader :command
  attr_reader :isreserve
  attr_reader :entity_name
  
  def initialize(args)
    @command = args
    @isreserve = false
    @property_name_type_hash = Hash.new
    @property_name_format_hash = Hash.new
    @property_name_json_hash = Hash.new
    @json_name_type_hash = Hash.new
    @json_name_format_hash = Hash.new
    @flags = Array.new
  end
  
  
  def parseCommand
    self.cacheCommand
    property_begin =false
    json_begin =false
    @entity_name=@command[0].capitalize+"Entity"
    property_name_array= Array.new
    json_name_array= Array.new
    @command.each do |param|
      if param[0] == "-"
        flag=param[1]
        case flag
        when "r"
            @flags << flag
            @isreserve = true
        when "l"
          property_begin = true
          json_begin = false
        when "s"
          json_begin = true
          property_begin = false
        end
      elsif property_begin == true 
        property_info= param.split(":")
        name = ""
        type = ""
        format = ""
        if property_info.length >=1 then name=property_info[0] end
        if property_info.length >=2 then type=property_info[1] end
        if property_info.length >=3 then format=property_info[2] end
        @property_name_type_hash[name] = type
        @property_name_format_hash[name] = format
        property_name_array << name
      elsif json_begin == true
        json_info= param.split(":")
        name = ""
        type = ""
        format = ""
        if json_info.length >=1 then name=json_info[0] end
        if json_info.length >=2 then type=json_info[1] end
        if json_info.length >=3 then format=json_info[2] end
        @json_name_type_hash[name] = type
        @json_name_format_hash[name] = format
        json_name_array << name
      end
    end
    
    index =0
    property_name_array.each do |name|
      if index >= json_name_array.length
        @property_name_json_hash[name] = "<" +"#" + "json#{name}" + "#" + ">"
      else
        @property_name_json_hash[name] = json_name_array[index]
      end
      index+=1
    end
    
  end
  
  
  def cacheCommand
     command_content=@command.join
     pwdPath=Dir.pwd
     file=File.new("#{pwdPath}/command","w")
     file << command_content +"\n"
     file.chmod("a+x")
     file.close
  end
  
end