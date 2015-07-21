require 'minitest/autorun'
require 'ModelGenerator/DBGenerator'
require 'ModelGenerator/CommandTask'
require 'ModelGenerator/AnnotationGenerator'
require 'ModelGenerator/MethodGenerator'

class DBGeneratorTest < MiniTest::Test
   def setup
     @task = CommandTask.new ["student", "-l" , "name:string" , 'id:int','-s','sname:string' ,'sid:int','-d','tname','*tid']
     @task.parseCommand
     @db_gen = DBGenerator.new @task
     @method_generator=MethodGenerator.new @task 
   end

   def test_generate_table_column_declare
     annotation = AnnotationGenerator.generate_single_annotation("table column declare")
     expect_reuslt = annotation + "static NSString * NameTableKey = @\"tname\";\nstatic NSString * EntityIdTableKey = @\"tid\";\n" 

     assert_equal expect_reuslt , @db_gen.generate_table_column_declare
   end

   def test_generate_table_name
     annotation = AnnotationGenerator.generate_mark_annotation("DB method")
     content = content =@method_generator.generate_method("+","NSString *","getTableName","return @\"tb_student\";",false) 
     expect_result = annotation + content
     assert_equal expect_result , @db_gen.generate_table_name
   end

   def test_generate_primary_key
     expect_result =@method_generator.generate_method("+","NSString *","getPrimaryKey","return EntityIdTableKey;",false)
     assert_equal expect_result , @db_gen.generate_primary_key
   end

   def test_generate_table_mapping
     content = %Q{return @{
            @\"name\":NameTableKey,
            @\"entityId\":EntityIdTableKey
           };} 

     expect_result =@method_generator.generate_method("+","NSDictionary *","getTableMapping",content,false)
     assert_equal expect_result , @db_gen.generate_table_mapping
   end
end
