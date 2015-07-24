require 'minitest/autorun'
require 'HTTPRequestDataParser/HTTPCommandParser'
require 'HTTPRequestDataParser/HTTPRequestDataParser'

class HTTPCommandParserTest < MiniTest::Test
  def setup 
     command =  ["student" ,"-u" , "\"http://localhost:3000/lists.json\"" ,"-m" ,'/:List' , '-k' ,'id']
     @parser = HTTPCommandParser.new  command
     @parser.parseCommand
  end

  def test_parser_property
    assert_equal({'/'=>'List'} , @parser.path_class_mapping)
    assert_equal 'http://localhost:3000/lists.json', @parser.url_str
    assert_equal '-a', @parser.params
    assert_equal 'id', @parser.primary_key
  end

end
