#this class not surport override method, in future may fix it 
class Detector
  attr_reader :methods_implement_hash
  attr_reader :methods_name_implment_hash
  attr_reader :content
  
  def initialize(file_path)
     if File.exist?(file_path)
         file=File.new(file_path,"r")
         if file
             @content=file.read
         end
     end
     
     @methods_implement_hash = Hash.new
     @methods_name_implment_hash = Hash.new
  end
  
  def detect_method
    if !@content then return end 
      
    method_regular=/^[+-].*\(.*\)[\s\S]*?(\w*)[\s\S]*\n}/
    @content.gsub(method_regular).each do |method_implment|
      @methods_implement_hash[method_implment]= true
      method_name= $1
      @methods_name_implment_hash[method_name] = method_implment
      
    end
    puts 
    puts @methods_name_implment_hash
  end
  
  
  def get_method_name(method_implement)
      name = ""
      name_regular= /[+-].*\(.*\)[\s\S]*?(\w*)[\s\S]*?}/  
      method_implement.gsub(name_regular).each do |method_name|
        name = $1
      end

      return name 
  end
  
  #if same return false , else return file method implement
  def method_implment_same? (method_implement)
    
    if !methods_implement_hash then return end
    method_name=self.get_method_name(method_implement)
    file_method_implement= @methods_name_implment_hash[method_name]
    if file_method_implement
      if file_method_implement == method_implement
        return false
      else 
        return file_method_implement +"\n"
      end
    end
    
    return false
  end
  
end


a =%q/+(NSValueTransformer *)nameAtJSONTransformer
{
	return [MTLValueTransformer reversibleTransformerWithForwardBlock:^( x) {
                                 return 
                               } reverseBlock:^(NSString * x) {
                                 return 
                               }];
}/
d=Detector.new "/Users/mac/Desktop/PTFILE_TEST/StudentEntity.m"
d.detect_method
puts d.method_implment_same?(a)