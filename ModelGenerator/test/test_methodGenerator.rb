require 'minitest/autorun'
require 'ModelGenerator/MethodGenerator'
require 'ModelGenerator/CommandTask'

class MethodGeneratorTest < MiniTest::Test
  def setup
    task = CommandTask.new(["student", "-l" , "name:string",'-s','sname:string' ,'-d','*tname'])
    @method_gen = MethodGenerator.new task 
  end

  def test_generate_method_no_super_class_array
    content =  @method_gen.generate_method '-' ,'NSArray*','getTableMapping','return @{};',false
    expect_content = %Q!\
-(NSArray*)getTableMapping
{
\treturn @{};
}
!

    assert_equal expect_content ,content
  end    


  def test_case_name_super_class_array
     content  =   @method_gen.generate_method '-' ,'NSArray*','getTableMapping','return @{};',true
    expect_content = %Q!-(NSArray*)getTableMapping
{
\tNSMutableArray * content=[[super getTableMapping] mutableCopy];
     NSArray *subArray= @{};
     [content addObjectsFromArray:subArray];
     return content;
                        
}
!

    assert_equal expect_content ,content
  end


  def test_generate_method_no_super_class_dictionary
    content =  @method_gen.generate_method '-' ,'NSDictionary*','getTableMapping','return @{};',false
    expect_content = %Q!\
-(NSDictionary*)getTableMapping
{
\treturn @{};
}
!

    assert_equal expect_content ,content
  end   


  def test_case_name_super_class_dictionary
     content  =   @method_gen.generate_method '-' ,'NSDictionary*','getTableMapping','return @{};',true
    expect_content = %Q!-(NSDictionary*)getTableMapping
{
\tNSMutableDictionary * content=[[super getTableMapping] mutableCopy];
    NSDictionary *subDictionary= @{};
    [content addEntriesFromDictionary:subDictionary];
    return content;
                         
}
!

    assert_equal expect_content ,content
  end
end
