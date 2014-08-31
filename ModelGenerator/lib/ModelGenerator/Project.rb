require 'xcodeproj'

class ProjectInfo
  attr_reader :project_path
  attr_reader :project
  
  def seek_xcodeproj(cmd_path)
    Dir.foreach(cmd_path) do  |filename|
      if File.extname(filename)==".xcodeproj" 
         @project_path=filename 
         @project=Xcodeproj::Project.open(@project_path)
          puts @project_path
         puts @Project.build_configuration_list
        
      end
    end
  end
  
  def organization
    
  end
  
end


test = ProjectInfo.new
test.seek_xcodeproj("/Users/mac/Desktop/备份/")