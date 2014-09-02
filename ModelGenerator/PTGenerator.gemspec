Gem::Specification.new do |s|  
  s.name        = 'PTGenerator'  
  s.version     = '1.0.0'  
  s.date        = '2010-09-01'  
  s.summary     = "use command line to create project temple file. This version function only for entity model"  
  s.description = "-m create model file"  
  s.authors     = ["cheng kai"]  
  s.email       = '710317434@qq.com'  
  s.files       = Dir["lib/ModelGenerator/*"] + Dir["lib/ModelGenerator/resource/Model/*"]+ Dir["lib/*"] +%w{ bin/ptgen}
  s.executables   = %w{ ptgen }
  s.require_paths = %w{ lib }
  s.homepage    ='http://rubygems.org/gems/PTGenerator'  
end