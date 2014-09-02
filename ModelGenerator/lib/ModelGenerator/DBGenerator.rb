class DBGenerator
  autoload :CommonParam,           'ModelGenerator/CommonParam'
  autoload :CommandTask,           'ModelGenerator/CommandTask'
  autoload :AnnotationGenerator,   'ModelGenerator/AnnotationGenerator'
  autoload :MethodGenerator,       'ModelGenerator/MethodGenerator'
  
  attr_reader :commandTask

  def initialize(command)
    @commandTask=command
  end
  
  def generate_table_column_declare
    if @commandTask.flags.join.include?("d")
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
    
    return ""
  end
  
  def generate_table_name
    if @commandTask.flags.join.include?("d")
        annotation = AnnotationGenerator.generate_mark_annotation("DB method")
        has_super=@commandTask.parent_class
        content =MethodGenerator.generate_method("+","NSString *","getTableName","return tb_#{@commandTask.command[0].downcase}",has_super)
        return (annotation + content)
    end
    
    return ""
  end
  
  def generate_primary_key
    if @commandTask.flags.join.include?("d")
        has_super=@commandTask.parent_class
        content =MethodGenerator.generate_method("+","NSString *","getPrimaryKey","return #{@commandTask.primary_key.capitalize}TableKey;",has_super)
        return content
    end
    return ""
  end
  
  def generate_table_mapping
    if @commandTask.flags.join.include?("d")
    
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
           has_super=@commandTask.parent_class
           content =MethodGenerator.generate_method("+","NSDictionary *","getTableMapping",property_mapping_content,has_super)
           return content
         else
           return ""
         end
         
    end
    
    return ""
    
  end
  
  
end