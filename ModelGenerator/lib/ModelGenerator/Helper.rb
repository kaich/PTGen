class Helper
	
	def self.help
		content=%q{
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
# -a[lsd]  generate same name 
# -u[lsd]  generate model according http response
#    -m  class mapping ,eg: 'data/student:student' , 'data/student' is path. last student is class name.
#    -k  primary key for database ,if -u contain d, you can use it ,otherwise it default the first property
# -h   help
# if your entity is subclass to other class, you can append :[superClassName] behind
# [entityName]
# example: 
# ptgen student -l name:string -s sname:string  -d *tname  #* is primary key.
#
# ptgen student:person -l name:string -s sname:string -d *tname
#
# it created Student.h and Student.m file in current path.
# property is name. and database method and json transformer method
# created
#
# version 2.0.0  new feture  :
# 1. add -alsd param , [lsd] is option. it create model file conveniently with  name property , server and db column same 
# 2. add Http get request to generate model file 
# 
# example:
# 'ptgen -ulsd "http://www.i4.cn/ajax.php?a=getoldnewsforpage&itype=2&n=20" -m /:Student'
#  it will generate model property according response of request , property name is same with server name . only support get request for json now
#  note : please replace & with @ in url string 
# 'ptgen -alsd *name:string'
#
# type :
# "string" => "NSString *"
# "int" => "NSInteger"
# "uint" => "NSUInteger"
# "float" => "float"
# "double" => "double"
# "number" => "NSNumber *"
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
    }	
	end

end
