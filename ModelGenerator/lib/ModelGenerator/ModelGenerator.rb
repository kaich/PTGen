require 'pathname'

class ModelGenerator
  autoload :Announcement,          'ModelGenerator/Announcement'
  autoload :CommonParam,           'ModelGenerator/CommonParam'
  autoload :CommandTask,           'ModelGenerator/CommandTask'
  autoload :DBGenerator,           'ModelGenerator/DBGenerator'
  autoload :JsonGenerator,         'ModelGenerator/JsonGenerator'
  autoload :EnumGenerator,         'ModelGenerator/EnumGenerator'
    
  attr_accessor :name
  attr_accessor :author
  attr_reader :project_name
  attr_reader :organization
  attr_reader :commandTask
  attr_reader :db_generator
  attr_reader :json_generator
  attr_reader :enum_generator
  
  def initialize
    @organization="<" +"#" + "organization" + "#" + ">"
    @project_name="<" +"#" + "project_name" + "#" + ">"
    @author="Unknow Author"
  end
  
  def seek_project_info

  end
  
  def analyze_command(args)
     @commandTask=CommandTask.new(args)
     @commandTask.parseCommand
     
     @db_generator=DBGenerator.new(@commandTask)
     @json_generator=JsonGenerator.new(@commandTask)
     @enum_generator=EnumGenerator.new(@commandTask.property_em_name_type_hash)
     
     return @commandTask
  end
  
  def generate_header
      parent_path=File.expand_path('..', __FILE__)
      headerPath="#{parent_path}/resource/Model/ModelTemple.h"
      
      annouce=Announcement.new
      annouce.name=@commandTask.entity_name
      file_declare=annouce.createDeclare
      
      
      entity_name=@commandTask.parent_class ?  (@commandTask.entity_name + " : " + @commandTask.parent_class) : (@commandTask.entity_name + ": MTLModel<MTLJSONSerializing>")
     
      to_header_content=File.read(headerPath)
      if @commandTask.parent_class
          header_import="#import \"#{@commandTask.entity_name}.h\"\n"
          to_header_content.gsub!(CommonParam.header_import,header_import)
      end
      to_header_content.gsub!(CommonParam.file_declare,file_declare)
      to_header_content.gsub!(CommonParam.enum_declare,@enum_generator.generate_em_declare)
      to_header_content.gsub!(CommonParam.entity_name,entity_name)
      to_header_content.gsub!(CommonParam.property_declare,self.generate_property_list)
      
      
      f= File.new("#{Dir.pwd}/#{@commandTask.entity_name}.h","w")
      f.syswrite(to_header_content)
           
  end
  
  def generate_source
    parent_path=File.expand_path('..', __FILE__)
    source_path="#{parent_path}/resource/Model/ModelTemple.m"
    to_source_content=File.read(source_path)
    
    annouce=Announcement.new
    annouce.name=@commandTask.entity_name
    file_declare=annouce.createDeclare
    entity_name=@commandTask.entity_name
    
    
    to_source_content.gsub!(CommonParam.file_declare,file_declare)
    to_source_content.gsub!(CommonParam.entity_name,entity_name)
    if @json_generator.generate_property_mapping
        to_source_content.gsub!(CommonParam.property_mapping,@json_generator.generate_property_mapping)
    end
    if @json_generator.generate_json_column_mapping
        to_source_content.gsub!(CommonParam.json_column_mapping,@json_generator.generate_json_column_mapping)
    end
    if @json_generator.generate_formater
        to_source_content.gsub!(CommonParam.type_transformer,@json_generator.generate_formater)
    end
    if @db_generator.generate_table_column_declare
        to_source_content.gsub!(CommonParam.table_column_declare,@db_generator.generate_table_column_declare)
    end
    if @db_generator.generate_table_name
        to_source_content.gsub!(CommonParam.table_name,@db_generator.generate_table_name)
    end
    if @db_generator.generate_primary_key
        to_source_content.gsub!(CommonParam.table_primary_key,@db_generator.generate_primary_key)
    end
    if @db_generator.generate_table_mapping
        to_source_content.gsub!(CommonParam.table_mapping,@db_generator.generate_table_mapping)
    end
   
    
    f= File.new("#{Dir.pwd}/#{entity_name}.m","w")
    f.syswrite(to_source_content)
    
  end
  
  
  def generate_property_list
      property_list_content=""
      @commandTask.property_name_type_hash.each do |name,type|
          var_type=type
          reference_type=CommonParam.reference_type_mapping[var_type];
          type_name= @commandTask.property_em_name_type_hash[name]
          if type_name
              property_type=@commandTask.property_em_name_type_hash[name]
          else
              property_type=CommonParam.type_mapping[var_type]
          end
          property_name=name
          property_list_content << "@property(nonatomic,#{reference_type}) #{property_type} #{property_name};\n"
      end
      return property_list_content
  end
  
 
end
