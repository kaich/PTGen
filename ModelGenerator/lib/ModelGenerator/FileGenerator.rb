require_relative './ModelGenerator.rb'
class FileGenerator
  attr_reader :model_generator
  def initialize
    @model_generator=ModelGenerator.new
    @model_generator.analyze_command(ARGV)
    @model_generator.generate_header
    @model_generator.generate_source
  end
  
end

FileGenerator.new