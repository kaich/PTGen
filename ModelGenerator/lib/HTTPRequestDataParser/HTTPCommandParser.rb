class HTTPCommandParser

    autoload :HTTPRequestDataParser,          'HTTPRequestDataParser/HTTPRequestDataParser'
     
    attr_accessor :path_class_mapping , :url_str , :params, :primary_key
  
  def initialize(args)
    @command = args
    @path_class_mapping  = Hash.new
    @url_str = ""
    @params = ""
    @primary_key = ""
  end
  
  
  def parseCommand
    url_begin = false 
    path_class_mapping_begin = false;
    primary_key_begin = false

    @command.each do |param|
      if param[0] == "-"
        flag=param[1]
        case flag
        when "u"
             url_begin = true
             path_class_mapping_begin = false
             @params = param.gsub '-u' , '-a'
        when "m"
             path_class_mapping_begin = true
             url_begin = false
        when "k"
             primary_key_begin = true
             path_class_mapping_begin = false
             url_begin = false
        end
      else 
        if url_begin
          @url_str = param.delete "\""
        elsif path_class_mapping_begin
           components = param.split(":")
           if components.length >=2
             path = components[0]
             class_name = components[1] 
             @path_class_mapping[path] = class_name
           else
             puts "command params error : please use -m [path]:[class_name] style"
           end
        elsif primary_key_begin
          @primary_key = param
        end
      end

    end
   if @url_str !=nil && @url_str !=""
     parser = HTTPRequestDataParser.new
     parser.flags = @params
     parser.primary_key = @primary_key
     parser.fetch(@url_str,@path_class_mapping)
     return true
   else
     return false
   end
  end
  
end
