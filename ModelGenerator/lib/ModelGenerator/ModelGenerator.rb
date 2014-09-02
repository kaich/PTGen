require 'pathname'

class ModelGenerator
  autoload :Announcement,          'ModelGenerator/Announcement'
  autoload :CommonParam,           'ModelGenerator/CommonParam'
  autoload :FormatTransformer,     'ModelGenerator/FormatTransformer'
  autoload :CommandTask,           'ModelGenerator/CommandTask'
    
  attr_accessor :name
  attr_accessor :author
  attr_reader :project_name
  attr_reader :organization
  attr_reader :commandTask
  
  
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
  end
  
  def generate_header
      parent_path=File.expand_path('..', __FILE__)
      headerPath="#{parent_path}/resource/Model/ModelTemple.h"
      
      annouce=Announcement.new
      file_declare=annouce.createDeclare
      entity_name=@commandTask.entity_name
      
      to_header_content=File.read(headerPath)
      to_header_content.gsub!(CommonParam.file_declare,file_declare)
      to_header_content.gsub!(CommonParam.entity_name,entity_name)
      to_header_content.gsub!(CommonParam.property_declare,self.generate_property_list)
      
      
      f= File.new("#{Dir.pwd}/#{entity_name}.h","w")
      f.syswrite(to_header_content)
           
  end
  
  def generate_property_list
      property_list_content=""
      @commandTask.property_name_type_hash.each do |name,type|
          var_type=type
          reference_type=CommonParam.reference_type_mapping[var_type];
          property_type=CommonParam.type_mapping[var_type]
          property_name=name
          property_list_content << "@property(nonatomic,#{reference_type}) #{property_type} #{property_name};\n"
      end
      return property_list_content
  end
  
  def generate_source
    parent_path=File.expand_path('..', __FILE__)
    source_path="#{parent_path}/resource/Model/ModelTemple.m"
    to_source_content=File.read(source_path)
    
    annouce=Announcement.new
    file_declare=annouce.createDeclare
    entity_name=@commandTask.entity_name
    
    
    to_source_content.gsub!(CommonParam.file_declare,file_declare)
    to_source_content.gsub!(CommonParam.entity_name,entity_name)
    to_source_content.gsub!(CommonParam.property_mapping,self.generate_property_mapping)
    to_source_content.gsub!(CommonParam.json_column_mapping,self.generate_json_column_mapping)
    to_source_content.gsub!(CommonParam.type_transformer,self.generate_formater)
    
    f= File.new("#{Dir.pwd}/#{entity_name}.m","w")
    f.syswrite(to_source_content)
    
  end
  
  def generate_json_column_mapping
    json_column_mappings_content=""
    json_columns=@commandTask.property_name_json_hash.values
    json_columns.each do |column|
        if(column)
          json_column_mappings_content << "static const NSString * #{column.capitalize}JsonKey = @\"#{column}\";\n"
        end
    end
    return json_column_mappings_content
  end
  
  def generate_property_mapping
      hasJsonColumn=false
      long_space="           "
      property_mapping_content="@{\n"
      @commandTask.property_name_json_hash.each do |key , value|
          if value
            hasJsonColumn=true
            property_mapping_content << "#{long_space} #{key}:#{value.capitalize}JsonKey,\n"
          end
      end
      
      property_mapping_content=property_mapping_content.chomp(",\n")
      property_mapping_content << "\n"
      property_mapping_content << "#{long_space}}"
      
      if hasJsonColumn
        return property_mapping_content
      else
        return "nil"
      end
  end
  
  def generate_formater
      formater_content=""
      @commandTask.property_name_type_hash.each do |key , value|
          json_column=@commandTask.property_name_json_hash[key]
          json_type=@commandTask.json_name_type_hash[json_column]
          json_format=@commandTask.json_name_format_hash[json_column]
          property_format=@commandTask.property_name_format_hash[key]
          
          formater_method_content= generate_formater_method_content(key,value,property_format,json_type,json_format)
          if formater_method_content !=nil && json_column
            formater_content= "+(NSValueTransformer *) #{key}AtJSONTransformer {\n    #{formater_method_content}\n}"
          end
      end
      
      return formater_content
  end
  
  def generate_formater_method_content(property_name,property_type,property_format,json_type,json_formate)
      
      content=""
      
      if property_type=="url" && json_type=="string"
          content << "return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];\n"
      elsif (property_type=="bool" && json_type=="int")
          content << "return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];\n"
      elsif property_type != json_type || (property_type == json_type  && property_format != json_formate)
          content = %Q/return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(#{CommonParam.type_mapping[json_type]} *x) {
                                return #{FormatTransformer.transform(property_type,property_format,json_type,json_formate)}
                              } reverseBlock:^(#{CommonParam.type_mapping[property_type]} *x) {
                                return #{FormatTransformer.transform(json_type,json_formate,property_type,property_format)}
                              }];/
      elsif property_type=="mapping" && json_type=="mapping"
          content = %Q/return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                               <#dictionary_content#>
                             }];/

      elsif !CommonParam.type_mapping[property_type]
          content << "return [NSValueTransformer mtl_JSONDictionaryTransformerWithModelClass:#{property_name}.class];"
      elsif property_type=="custom"
            content = %Q/return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSString *str) {
                            return <#ConvertFormat#>;
                        } reverseBlock:^(NSDate *date) {
                            return <#ReverseConvertFormat#>;
                        }];/
      else
        content=nil
      end
      return content
  end

end
