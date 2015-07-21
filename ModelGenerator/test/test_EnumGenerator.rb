require 'minitest/autorun'
require 'ModelGenerator/EnumGenerator'
require 'ModelGenerator/AnnotationGenerator'

class EnumGeneratorTest < MiniTest::Test
  def setup
    @enum_gen = EnumGenerator.new({'type'=>'PersonType'}) 
  end

  def test_name_type_hash
    assert_equal({'type'=>'PersonType'}, @enum_gen.name_type_hash )
  end

  def test_generate_em_declare
    content = %Q/
typedef enum {
     <#enum_content#>
}PersonType;/
    annotation = AnnotationGenerator.generate_single_annotation("emum declare")
    expect_result = annotation + content
    assert_equal expect_result, @enum_gen.generate_em_declare
  end

end
