class DBGenerator
  autoload :CommonParam,           'ModelGenerator/CommonParam'
  autoload :CommandTask,           'ModelGenerator/CommandTask'
  autoload :AnnotationGenerator,   'ModelGenerator/AnnotationGenerator'
  
  attr_reader :commandTask

  def initialize(command)
    @commandTask=command
  end
  
  def generate_table_column_declare
    if @commandTask.flags.join.start_with?("d")
        return ""
    end
    
    db_column_mappings_content=""
    @commandTask.property_name_db_hash.keys.each do |name|
        column=@commandTask.property_name_db_hash[name]
        if(column)
          db_column_mappings_content << "static const NSString * #{name.capitalize}TableKey = @\"#{column}\";\n"
        end
    end
    if db_column_mappings_content.length > 0
        annotation = AnnotationGenerator.generate_single_annotation("table column declare")
        db_column_mappings_content = annotation + db_column_mappings_content
    end
    return db_column_mappings_content
  end
  
  def generate_table_name
    if @commandTask.flags.join.start_with?("d")
        annotation = AnnotationGenerator.generate_mark_annotation("DB method")
        content = "+(NSString *)getTableName\n{" + "\t\t\treturn tb_#{@commandTask.command[0].downcase};\n" + "}"
        return (annotation + content)
    end
    
    return ""
  end
  
  def generate_primary_key
    if @commandTask.flags.join.start_with?("d")
        content = "+(NSString *)getPrimaryKey\n{" + "\t\t\treturn #{@commandTask.primary_key.capitalize}TableKey;\n" + "}"
        return content
    end
    return ""
  end
  
  def generate_table_mapping
    if @commandTask.flags.join.start_with?("d")
    
        hasDBColumn=false
        long_space="           "
        property_mapping_content="return @{\n"
         @commandTask.property_name_db_hash.each do |key , value|
             if value
               hasDBColumn=true
               property_mapping_content << "#{long_space} #{key}:#{value.capitalize}TableKey,\n"
             end
         end

         property_mapping_content=property_mapping_content.chomp(",\n")
         property_mapping_content << "\n"
         property_mapping_content << "#{long_space}}"

         if hasDBColumn
           content = "+(NSDictionary *)getTableMapping\n{" + "\t\t\t" + property_mapping_content + "\n}"
           return property_mapping_content
         else
           return "nil"
         end
         
    end
    
    return ""
    
  end
  
  
end