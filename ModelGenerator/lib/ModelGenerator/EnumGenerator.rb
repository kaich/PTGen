class EnumGenerator
   autoload :AnnotationGenerator,   'ModelGenerator/AnnotationGenerator' 
    
   attr_reader :name_type_hash
   
   def initialize(args)
      @name_type_hash=args
   end
   
   def generate_em_declare
      content = ""
      @name_type_hash.each do |property_name,type_name|
        content << %Q/
typedef enum {
     <#enum_content#>
}#{type_name};/
      end
      if content.length > 0
        annotation = AnnotationGenerator.generate_single_annotation("emum declare")
        content = annotation + content
      end
      
      return content
   end
end