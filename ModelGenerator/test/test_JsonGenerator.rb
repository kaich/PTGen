require 'minitest/autorun'
require 'ModelGenerator/JsonGenerator'
require 'ModelGenerator/CommonParam'
require 'ModelGenerator/FormatTransformer'

class JsonGeneratorTest < MiniTest::Test
   def setup
     @task = CommandTask.new ["student", "-l" , "name:string" , 'id:int','-s','sname:string' ,'sid:int','-d','tname','*tid']
     @task.parseCommand
     @json_gen = JsonGenerator.new @task
     @method_generator=MethodGenerator.new @task 
   end    

   def test_generate_json_column_mapping
     content = "static NSString * NameJsonKey = @\"sname\";\nstatic NSString * EntityIdJsonKey = @\"sid\";\n" 
     annotation = AnnotationGenerator.generate_single_annotation("json column declare")
     expect_result = annotation + content
     assert_equal expect_result, @json_gen.generate_json_column_mapping
   end

   def test_generate_property_mapping
     method_content = %Q{return @{
            @\"name\":NameJsonKey,
            @\"entityId\":EntityIdJsonKey
           };}

     content =@method_generator.generate_method("+","NSDictionary *","JSONKeyPathsByPropertyKey","#{method_content}",false)
     annotation = AnnotationGenerator.generate_mark_annotation("json method")
     expect_result = annotation + content
     assert_equal expect_result, @json_gen.generate_property_mapping
   end

   def test_generate_formater
     assert_equal "" , @json_gen.generate_formater
   end
end
