class NimbusGenerator
	autoload :CommandTask,           'ModelGenerator/CommandTask'
	autoload :MethodGenerator,       'ModelGenerator/MethodGenerator'
	autoload :AnnotationGenerator,   'ModelGenerator/AnnotationGenerator'

	attr_reader :commandTask

	def initialize(command)
	    @commandTask=command
	    @method_generator=MethodGenerator.new(command)
	    if !@commandTask.primary_key && @commandTask.flags.join.include?("d")
	       raise "error : you must set table primary key"
	    end
	 end

	 def generate_need_methods
	 	content = ""
	 	if !self.generate_cell_class_method.empty?  || !self.generate_cell_style_method.empty?
	 		content << AnnotationGenerator.generate_mark_annotation("Nimbus method")
		 	content << self.generate_cell_class_method
		 	content << self.generate_cell_style_method
	 	end

        return content
	 end
	
	def generate_cell_class_method
		if @commandTask.flags.join.include?("n")
		  return @method_generator.generate_method("-","Class","cellClass","return <#CellClass#>;",false);
		end

        return ""
	end

	def generate_cell_style_method
		if @commandTask.flags.join.include?("n")
			return @method_generator.generate_method("-","UITableViewCellStyle","cellStyle","return <#CellStyle#>;",false);
		end

        return ""
	end

end 