require 'minitest/autorun'
require 'ModelGenerator/CommandTask.rb'

class CommandTaskTest < MiniTest::Test
   def setup
     @task = CommandTask.new(["student", "-l" , "name:string",'-s','sname:string' ,'-d','*tname'])
     @task.parseCommand
   end 

   def test_property_name_should_nil
     @task = CommandTask.new([""])
     @task.parseCommand
     assert_equal  0,@task.property_name_type_hash.length 
     assert_equal  0,@task.property_em_name_type_hash.length 
     assert_equal  0,@task.property_name_format_hash.length 
     assert_equal  0,@task.property_name_json_hash.length 
   end

   def test_property_and_json
     assert_equal @task.property_name_type_hash , {"name" => "string"}
     assert_equal @task.property_em_name_type_hash  , {} 
     assert_equal @task.property_name_format_hash , {"name"=>""} 
     assert_equal @task.property_name_json_hash , {"name" => "sname"}

     assert_equal @task.json_name_type_hash, {"sname" => "string"}
     assert_equal @task.json_name_format_hash, {"sname" => ""}
   end

   def test_db 
     assert_equal @task.property_name_db_hash , {"name" => "tname"} 
     assert_equal "name" ,@task.primary_key 
   end


   def test_flags
     assert_equal ['l','s','d'] , @task.flags
   end

   def test_command
     assert_equal ["student", "-l" , "name:string",'-s','sname:string' ,'-d','*tname'] , @task.command
   end

   def test_isreverse_false
     refute @task.isreverse 
   end

   def test_isreverse 
     @task = CommandTask.new ["student", "-l" , "name:string",'-s','sname:string' ,'-d','*tname' ,'-r']
     @task.parseCommand
     assert @task.isreverse
   end

   def test_is_force_reset_false
     refute @task.is_force_reset
   end

   def test_is_force_reset
     @task = CommandTask.new ["student", "-l" , "name:string",'-s','sname:string' ,'-d','*tname' ,'-r','-f']
     @task.parseCommand
     assert @task.is_force_reset
   end

   def test_entity_name 
     assert_equal "StudentEntity" ,@task.entity_name  
   end

   def test_parent_class_nil
     assert_nil  @task.parent_class 
   end

   def test_parent_class_person
     @task = CommandTask.new ["student:person", "-l" , "name:string",'-s','sname:string' ,'-d','*tname' ,'-r','-f']
     @task.parseCommand
     assert_equal "PersonEntity" ,@task.parent_class 
   end

    def test_mutil_property
     @task = CommandTask.new ["student:person", "-l" , "name:string" , 'id:int','-s','sname:string' ,'sid:int','-d','*tname','tid']
     @task.parseCommand
    assert_equal @task.property_name_type_hash , {"name" => "string",'entityId'=>'int'}
     assert_equal @task.property_em_name_type_hash  , {} 
     assert_equal @task.property_name_format_hash , {"name"=>"",'entityId' => ''} 
     assert_equal @task.property_name_json_hash , {"name" => "sname",'entityId' => 'sid'}

     assert_equal @task.json_name_type_hash, {"sname" => "string",'sid' => 'int'}
     assert_equal @task.json_name_format_hash, {"sname" => "",'sid' => ''}
   end
  
   def test_cache_command
     @task.cacheCommand 
     dpath = "#{Dir.pwd}/command" 
     assert File.exist?  dpath
     File.delete dpath
   end
end
