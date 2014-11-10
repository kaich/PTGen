class Helper
	
	def self.help
		content=%Q/
# ptgen is a tools for model. It works on mac. If you use mantle for your entity. you can use it.
# I create it for my project. The model can contain [database] [request] [nimbus] option method.
# There is not prefect now .
# when you create your model, you maybe contain manay property to create. and some for request 
# others for database . You must make your database and request column correspond to property index.
# I will fix it latter. 
# I will make it more prefect
#
# flags:
# -l   local. it's property
# -s   server. it's json column name 
# -d   database. it's table column name 
# -f   force. force to overide modified method 
# -r   not used now.
# -h   help
# if your entity is subclass to other class, you can append :[superClassName] behind
# [entityName]
# example: 
# create student -l name:string -s sname:string  -d *tname  #* is primary key.
#
# creawte student:person -l name:string -s sname:string -d *tname
#
# it created Student.h and Student.m file in current path.
# property is name. and database method and json transformer method
# created
#
# type :
# "string" => "NSString *"
# "int" => "NSInteger"
# "uint" => "NSUInteger"
# "float" => "float"
# "double" => "double"
# "number" => "NSNumber"
# "date" => "NSDate *"
# "data" => "NSData *"
# "time" => "NSTimeInterval"
# "url" => "NSURL *"
# "array" => "NSArray *"
# "marray" => "NSMutableArray *"
# "dic" => "NSDictionary *"
# "mdic" => "NSMutableDictionary *"
# "indexset" => "NSIndexSet *"
# "mindexset" => "NSIndexPath *"
# "indexpath" => "NSIndexPath *"
# "mindexpath" => "NSMutableIndexSet *"
# "bool" => "BOOL",
# "enum" => "enum",
# "mapping"
# "custom"
				/
	end

end