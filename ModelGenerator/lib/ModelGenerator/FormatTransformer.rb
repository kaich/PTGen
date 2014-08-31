class FormatTransformer
  $json_var="x"  
  def FormatTransformer.transform(property_type,property_format,json_type,json_formate)
     if property_type == "string" && json_type != "string"
       return "[NSString stringWithFormat:\"#{property_format}\",#{$json_var}];"
     else
       return nil
     end
  end
  
end