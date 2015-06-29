class CommandTask
  
    
  attr_reader :property_name_type_hash
  attr_reader :property_em_name_type_hash
  attr_reader :property_name_format_hash
  attr_reader :property_name_json_hash
  attr_reader :json_name_type_hash
  attr_reader :json_name_format_hash
  attr_reader :property_name_db_hash
  attr_reader :flags
  attr_reader :command
  attr_reader :isreverse
  attr_reader :is_force_reset
  attr_reader :entity_name
  attr_reader :primary_key
  attr_reader :parent_class
  
  def initialize(args)
    @command = args
    @isreverse = false
    @is_force_reset =false
    @property_name_type_hash = Hash.new
    @property_em_name_type_hash = Hash.new
    @property_name_format_hash = Hash.new
    @property_name_json_hash = Hash.new
    @json_name_type_hash = Hash.new
    @json_name_format_hash = Hash.new
    @property_name_db_hash = Hash.new
    @flags = Array.new
  end
  
  
  def parseCommand
    property_begin =false
    json_begin =false
    db_begin =false

    if @command[0].include?(":")
      class_info=@command[0].delete(" ")
      entity_info_array=class_info.split(":")
      @entity_name=entity_info_array[0].capitalize+"Entity"
      @parent_class=entity_info_array[1].capitalize+"Entity"
    else  
      @entity_name=@command[0].capitalize+"Entity"
    end
    
    property_name_array= Array.new
    json_name_array= Array.new
    db_name_array= Array.new
    @command.each do |param|
      if param[0] == "-"
        flag=param[1]
        case flag
        when "r"
            @flags << flag
            @isreverse = true
            property_begin= false
            json_begin = false
            db_begin = false
        when "l"
            @flags << flag
            property_begin = true
            json_begin = false
            db_begin =false
        when "s"
            @flags << flag
            json_begin = true
            property_begin = false
            db_begin = false
        when "d"
            @flags << flag
            db_begin = true
            json_begin = false
            property_begin = false
        when "n"
            @flags << flag
            property_begin= false
            json_begin = false
            db_begin = false
        when "f"
            @flags << flag
            @is_force_reset=true
            db_begin = false
            json_begin = false
            property_begin = false
        when "h"
            @flags << flag
            @is_force_reset=false
            db_begin = false
            json_begin = false
            property_begin = false
        when "a"
            param.each_char do |chr|  
               if chr == 'l'
                  @flags << chr
                  property_begin = true
               elsif chr == 's'
                  @flags << chr
                  json_begin = true
               elsif chr == 'd'
                  @flags << chr
                  db_begin = true
               end
            end
        end
      else

        if property_begin == true
          property_info= param.split(":")
          name = ""
          type = ""
          type_name = ""
          format = ""
          if property_info.length >=1 then name=property_info[0].delete("*") end
          if property_info.length >=2 
             type=property_info[1] 
             if type.include?("enum")
                type_info_array=type.split(".")
                type=type_info_array[0]
                type_name=type_info_array[1]
             end
          end
          if property_info.length >=3 then format=property_info[2] end
          @property_name_type_hash[name] = type
          if type_name.length >0
              @property_em_name_type_hash[name] = type_name
          end
          @property_name_format_hash[name] = format
          property_name_array << name
        end

        if json_begin == true
          json_info= param.split(":")
          name = ""
          type = ""
          format = ""
          if json_info.length >=1 then name=json_info[0].delete("*") end
          if json_info.length >=2 then type=json_info[1] end
          if json_info.length >=3 then format=json_info[2] end
          @json_name_type_hash[name] = type
          @json_name_format_hash[name] = format
          json_name_array << name
        end

        if db_begin == true
          name = param.split(":")
          db_name_array << name[0]
        end
      end
    end
    
    index =0
    property_name_array.each do |name|
      if index >= json_name_array.length
        @property_name_json_hash[name] = nil
      else
        @property_name_json_hash[name] = json_name_array[index]
      end
      
      if index >= db_name_array.length
        @property_name_db_hash[name] = nil
      else
        db_name= db_name_array[index]
        if db_name && db_name.length >=1
            if db_name[0]=="*"
               @primary_key=name
               db_name = db_name.delete("*")
            end
        end
        @property_name_db_hash[name] = db_name
      end
      index+=1
    end
    
  end
  
  
  def cacheCommand
     command_content=@command.join " "
     pwdPath=Dir.pwd
     file=File.new("#{pwdPath}/command","a")
     file << "ptgen " +command_content +"\n"
     file.chmod(0777)
     file.close
  end
  
end