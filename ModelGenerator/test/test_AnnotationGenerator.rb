require 'minitest/autorun'
require 'ModelGenerator/AnnotationGenerator'

class AnnotationGeneratorTest < MiniTest::Test
  def test_generate_single_annotation
    content = "this is a property declare"
    assert_equal "//#{content}\n" , AnnotationGenerator.generate_single_annotation(content)  
  end     

  def test_generate_mark_annotation
    content = 'UITableView delete and datasource' 
    assert_equal "#pragma mark - #{content}\n", AnnotationGenerator.generate_mark_annotation(content)
  end
end
