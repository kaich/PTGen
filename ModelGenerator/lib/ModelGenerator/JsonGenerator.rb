class JsonGenerator
  autoload :CommonParam,           'ModelGenerator/CommonParam'
  autoload :CommandTask,           'ModelGenerator/CommandTask'
  autoload :AnnotationGenerator,   'ModelGenerator/AnnotationGenerator'
  autoload :FormatTransformer,     'ModelGenerator/FormatTransformer'
  autoload :MethodGenerator,       'ModelGenerator/MethodGenerator'
  
  attr_reader :commandTask
  attr_reader :method_generator

  def initialize(command)
    @commandTask=command
    @method_generator=MethodGenerator.new(command)
  end
  
  def generate_json_column_mapping
     json_column_mappings_content=""
     @commandTask.property_name_json_hash.keys.each do |name|
         column=@commandTask.property_name_json_hash[name]
         if(column)
           json_column_mappings_content << "static NSString * #{name.capitalize}JsonKey = @\"#{column}\";\n"
         end
     end
     if json_column_mappings_content.length > 0
         annotation = AnnotationGenerator.generate_single_annotation("json column declare")
         json_column_mappings_content = annotation + json_column_mappings_content
     end
     return json_column_mappings_content
   end

   def generate_property_mapping
       hasJsonColumn=false
       long_space="           "
       property_mapping_content="return @{\n"
       @commandTask.property_name_json_hash.each do |key , value|
           if value
             hasJsonColumn=true
             property_mapping_content << "#{long_space} @\"#{key}\":#{key.capitalize}JsonKey,\n"
           end
       end

       property_mapping_content=property_mapping_content.chomp(",\n")
       property_mapping_content << "\n"
       property_mapping_content << "#{long_space}};"

       if hasJsonColumn
         has_super=@commandTask.parent_class
         content =@method_generator.generate_method("+","NSDictionary *","JSONKeyPathsByPropertyKey","#{property_mapping_content}",has_super)
         annotation = AnnotationGenerator.generate_mark_annotation("json method")
         content = annotation + content
         return content
       else
         return ""
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
             has_super=@commandTask.parent_class
             formater_content=@method_generator.generate_method("+","NSValueTransformer *" , "#{key}AtJSONTransformer","#{formater_method_content}",has_super)
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
           content = %Q/return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(#{CommonParam.type_mapping[json_type]} x) {
                                 return #{FormatTransformer.transform(property_type,property_format,json_type,json_formate)}
                               } reverseBlock:^(#{CommonParam.type_mapping[property_type]} x) {
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