module FileGenerator

    autoload :Announcement,           'ModelGenerator/Announcement'
    autoload :CommandTask,            'ModelGenerator/CommandTask'
    autoload :CommonParam,            'ModelGenerator/CommonParam'
    autoload :FormatTransformer,      'ModelGenerator/FormatTransformer'
    autoload :ModelGenerator,         'ModelGenerator/ModelGenerator'
    autoload :HooksManager,           'ModelGenerator/Project'


  def self.generate_model
    if ARGV.length==0 || ARGV == nil
    puts "error: Parameter does not match,there is not any parameter"
    return nil
    end
    
    begin
      @model_generator=ModelGenerator.new
      commandTask = @model_generator.analyze_command(ARGV)
      @model_generator.generate_header
      @model_generator.generate_source
    rescue Exception => e
      puts e
    else  
      commandTask.cacheCommand
    end
    
  end
  
end