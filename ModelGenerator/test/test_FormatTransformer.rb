require 'minitest/autorun'
require 'ModelGenerator/FormatTransformer'

class FormatTransformerTest < MiniTest::Test
   def test_string_from_string
     expect_result = "[NSString stringWithFormat:@\"%@\",x];" 
     assert_equal expect_result, FormatTransformer.transform('string', '%@' , 'string' ,'?%@')
   end

   def test_string_from_string_same_format
     expect_result = nil 
     assert_equal expect_result,  FormatTransformer.transform('string', '' , 'string' ,'')
   end

   def test_string_from_int_no_format
     expect_result = "[NSString stringWithFormat:@\"%ld\",(long)x];"
     assert_equal expect_result,  FormatTransformer.transform('string', '' , 'int' ,'')
   end

   def test_string_from_float_or_double_no_format
      expect_result = "[NSString stringWithFormat:@\"%f\",x];"
     assert_equal expect_result,  FormatTransformer.transform('string', '' , 'double' ,'')
   end

   def test_string_from_float_or_double
     expect_result = "[NSString stringWithFormat:@\"%.3f\",x];"
     assert_equal expect_result,  FormatTransformer.transform('string', '%.3f' , 'double','')
   end
      
   def test_string_from_date
     expect_result = %Q/NSDateFormatter * formatter=[[NSDateFormatter alloc] init],\\
                        \t\t\t formatter.dateFormat=@\"yy-MM-dd\",\\
                        \t\t\t  NSDate * date=[formatter stringFromDate:@\"x\"],\\
                        \t\t\t date;/
     assert_equal expect_result,  FormatTransformer.transform('string', 'yy-MM-dd' , 'date','')
   end

   def test_int_from_string
     expect_result = "[x integerValue];"
     assert_equal expect_result,  FormatTransformer.transform('int', '' , 'string','') 
   end

   def test_int_from_number
     expect_result = "[x integerValue];"
     assert_equal expect_result,  FormatTransformer.transform('int', '' , 'string','') 
   end

   def test_int_from_others
     expect_result = "<#"+"custom"+"#>" 
     assert_equal expect_result,  FormatTransformer.transform('int', '' ,'enum','') 
   end

   def test_float_from_string
     expect_result = '[x floatValue];'
     assert_equal expect_result,  FormatTransformer.transform('float', '' ,'number','') 
   end


   def test_float_from_number
     expect_result = '[x floatValue];'
     assert_equal expect_result,  FormatTransformer.transform('float', '' ,'number','') 
   end


   def test_double_from_number
     expect_result = '[x floatValue];'
     assert_equal expect_result,  FormatTransformer.transform('float', '' ,'number','') 
   end


   def test_double_from_string
     expect_result = '[x floatValue];'
     assert_equal expect_result,  FormatTransformer.transform('float', '' ,'number','') 
   end

   
   def test_date_from_string
     expect_result = %Q/NSDateFormatter * formatter=[[NSDateFormatter alloc] init],\\
                        \t\t\t formatter.dateFormat=@\"yy-MM-dd\",\\
                        \t\t\t NSDate * date=[formatter dateFromString:@\"x\"],\\
                        \t\t\t date;/
     assert_equal expect_result,  FormatTransformer.transform('date', '' ,'string','yy-MM-dd') 
   end


   def test_date_from_time
     expect_result = " [NSDate dateWithTimeIntervalSinceReferenceDate:x];" 
     assert_equal expect_result , FormatTransformer.transform('date','','time','')
   end

end
