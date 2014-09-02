class AnnotationGenerator
  
  def self.generate_single_annotation(content)
     return "//#{content}\n"
  end
  
  def self.generate_mark_annotation(content)
    return "#pragma mark - #{content}\n"
  end
end