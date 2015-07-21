require 'minitest/autorun'
require 'ModelGenerator/Detector'

class DetectorTest < MiniTest::Test
    def setup 
        @content = %Q!-(NSDictionary*)getTableMapping{
\tNSMutableDictionary * content=[[super getTableMapping] mutableCopy];
    NSDictionary *subDictionary= @{};
    [content addEntriesFromDictionary:subDictionary];
    return content;
}!
      @file_path = "#{Dir.pwd}/DetectorSampleFile.m"
      @file = File.new(@file_path,'w')
      @file.syswrite @content 
      @detector = Detector.new @file_path
      @detector.detect_method   
    end


    def teardown
      File.delete  @file_path
    end


    def test_get_method_name    

      assert_equal "getTableMapping", @detector.get_method_name(@content)
    end

    def test_method_implement_same
        content = %Q!-(NSString*)getTableMapping{

    return nil;
                         
}!

    assert_equal @content + "\n" , @detector.method_implment_same?(content)
    end

    def test_detect_method
      assert_equal({"getTableMapping"=>@content},  @detector.methods_name_implment_hash )
    end

end
