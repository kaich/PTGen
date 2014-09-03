class CommonParam
  def CommonParam.entity_name
    return /\[NAME\]/
  end
  
  def CommonParam.file_declare
    return /\[DECLARE\]/
  end
  
  def CommonParam.property_declare
    return /\[PROPERTY_DECLARE\]/
  end
  
  def CommonParam.json_column_mapping
      return /\[JSON_COLUMN_MAPPING\]/
  end
  
  def CommonParam.property_mapping
      return /\[PROPERTY_MAPPING\]/
  end
  
  def CommonParam.type_transformer
      return /\[TYPE_TRANSFORMER\]/
  end
  
  def CommonParam.table_column_declare
      return /\[TABLE_COLUMN_DECLARE\]/
  end
  
  def CommonParam.table_name
      return /\[TABLE_NAME\]/
  end
  
  def CommonParam.table_primary_key
      return /\[TABLE_PRIMARY_KEY\]/
  end
  
  def CommonParam.table_mapping
      return /\[TABLE_MAPPING\]/
  end
  
  def CommonParam.enum_declare
      return /\[ENUM_DECLARE\]/
  end
  
  def CommonParam.type_mapping
    return {"string" => "NSString *",
            "int" => "NSInteger",
            "uint" => "NSUInteger",
            "float" => "float",
            "double" => "double",
            "number" => "NSNumber",
            "date" => "NSDate *",
            "data" => "NSData *",
            "time" => "NSTimeInterval",
            "url" => "NSURL *",
            "array" => "NSArray *",
            "marray" => "NSMutableArray *",
            "dic" => "NSDictionary *",
            "mdic" => "NSMutableDictionary *",
            "indexset" => "NSIndexSet *",
            "mindexset" => "NSIndexPath *",
            "indexpath" => "NSIndexPath *",
            "mindexpath" => "NSMutableIndexSet *",
            "bool" => "BOOL",
            "enum" => "enum",
            "mapping" => "<#mapping#>",
            "custom" => "<#custom#>"}
  end
  
  def CommonParam.reference_type_mapping
    return  {"string" => "strong",
              "int" => "assign",
              "float" => "assign",
              "double" => "assign",
              "number" => "strong",
              "uint" => "assign",
              "date" => "strong",
              "data" => "strong",
              "time" => "assign",
              "url" => "strong",
              "array" => "strong",
              "marray" => "strong",
              "dic" => "strong",
              "mdic" => "strong",
              "index" => "strong",
              "mindex" => "strong",
              "indexpath" => "strong",
              "mindexpath" => "strong",
              "bool" => "assign",
              "enum" => "assign",
              "mapping" => "strong",
              "custom" => "<#refrence_type#>"}
  end
end