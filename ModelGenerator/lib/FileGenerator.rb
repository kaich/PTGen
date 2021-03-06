module FileGenerator

    autoload :Announcement,           'ModelGenerator/Announcement'
    autoload :CommandTask,            'ModelGenerator/CommandTask'
    autoload :CommonParam,            'ModelGenerator/CommonParam'
    autoload :FormatTransformer,      'ModelGenerator/FormatTransformer'
    autoload :ModelGenerator,         'ModelGenerator/ModelGenerator'
    autoload :HooksManager,           'ModelGenerator/Project'
    autoload :Helper,       'ModelGenerator/Helper'
    autoload :HTTPCommandParser, 'HTTPRequestDataParser/HTTPCommandParser'


  def self.generate_model
    if ARGV.length==0 || ARGV == nil
    puts "error: Parameter does not match,there is not any parameter"
    return nil
    end
    
    begin
      @model_generator=ModelGenerator.new
      commandTask = @model_generator.analyze_command(ARGV)
      if commandTask.flags.join.include?("h")
          puts Helper.help
          return nil
      end

      commandParse = HTTPCommandParser.new(ARGV)
      is_ok =commandParse.parseCommand

      if is_ok == false
          @model_generator.generate_header
          @model_generator.generate_source
      end

    rescue Exception => e
      puts e
    else  
      commandTask.cacheCommand
    end
    
  end
  
end