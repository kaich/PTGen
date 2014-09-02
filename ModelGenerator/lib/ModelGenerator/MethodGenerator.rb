class MethodGenerator
  def self.generate_method(method_type,return_type,methond_name,method_content,has_custom_super_class)
     if return_type.downcase.include?("dictionary") && has_custom_super_class
        current_content= method_content.gsub(/return/,"NSDictionary *subDictionary=")
        method_content =%Q/NSMutableDictionary * content=[[super #{methond_name}] mutableCopy];
    #{current_content}
    [content addEntriesFromDictionary:subDictionary];
    return content;
                         /

     elsif return_type.downcase.include?("array") && has_custom_super_class
       current_content= method_content.gsub(/return/,"NSArray *subArray=")
       method_content =%Q/NSMutableArray * content=[[super #{methond_name}] mutableCopy];
     #{current_content}
     [content addObjectsFromArray:subArray];
     return content;
                        /

     end
     return "#{method_type}(#{return_type})#{methond_name}\n{\n\t#{method_content}\n}\n"
  end
end