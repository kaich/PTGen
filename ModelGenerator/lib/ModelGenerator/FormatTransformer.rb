class FormatTransformer
  $json_var="x"  
  def FormatTransformer.transform(property_type,property_format,json_type,json_formate)
     if property_type == "string" 
       if json_type == property_type && property_format != json_formate
          return "[NSString stringWithFormat:@\"#{property_format}\",#{$json_var}];"
        elsif json_type=="int" || json_type=="double" || json_type=="float"
          return "[NSString stringWithFormat:@\"#{property_format}\",#{$json_var}];"
        elsif json_type=="date"
          return  %Q/NSDateFormatter * formatter=[[NSDateFormatter alloc] init],\\
                        \t\t\t formatter.dateFormat=@\"#{json_formate}\",\\
                        \t\t\t  NSDate * date=[formatter stringFromDate:@\"#{$json_var}\"],\\
                        \t\t\t date;/
        else
          return nil
       end
     elsif property_type =="int"
       if json_type == "string" || json_type == "number"
          return "[#{$json_var} integerValue];"
       else 
          return "<#"+"custom"+"#>"
       end
      elsif property_type =="float"
        if json_type == "string" || json_type == "number"
           return "[#{$json_var} floatValue];"
        else 
           return "<#"+"custom"+"#>"
        end
      elsif property_type =="double" || property_type =="time"
        if json_type == "string" || json_type == "number"
           return "[#{$json_var} doubleValue]"
        elsif json_type=="date"
           return "[#{$json_var} timeIntervalSinceReferenceDate];"
        else 
           return "<#"+"custom"+"#>"
        end
      elsif property_type =="date"
        if json_type == "string"
           return %Q/NSDateFormatter * formatter=[[NSDateFormatter alloc] init],\\
                        \t\t\t formatter.dateFormat=@\"#{json_formate}\",\\
                        \t\t\t NSDate * date=[formatter dateFromString:@\"#{$json_var}\"],\\
                        \t\t\t date;/
        elsif json_type=="time" || json_type=="double"
           return " [NSDate dateWithTimeIntervalSinceReferenceDate:#{$json_var}];"
        else 
           return "<#"+"custom"+"#>"
        end
     end
      
  end
  
end