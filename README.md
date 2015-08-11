#####what's ptgen
ptgen is a commandline model generator for ios development.If you use [mantle](https://github.com/Mantle/Mantle) or [LKDBHelper](https://github.com/li6185377/LKDBHelper-SQLite-ORM) in your ios project, you can use it to generate your own model like rails style.  

#####feature:
* avoid repeating code 
* according http request auto generate model file
* property and table column mapping
* type and format transform

#####ptgen use
ptgen is commandline, you can use it create model file like rails.

	ptgen -[option] [property_list]
    -option:
    -a  all 
    -l  local property list
    -s  server property list
    -d  database column list
    -help detail help 

######common use
Please use `ptgen -h` for detail. simple example as below:

	ptgen student -l name:string age:int sex:string -s sname:string age:int sex:string

it will create `StudentEntity.h` and `StudentEntity.m` in current path. header file content as below: 

	//
	//  StudentEntity.h
	//  your_project_name
	//
	//  Created by CK on 15-08-11.
	//  Copyright (c) 2015年 CK. All rights reserved.
	
	#import <MTLModel.h>
	#import <MTLJSONAdapter.h>
	
	
	
	
	@interface StudentEntity: MTLModel<MTLJSONSerializing>
	@property(nonatomic,strong) NSString * name;
	@property(nonatomic,assign) NSInteger age;
	@property(nonatomic,strong) NSString * sex;
	
	@end
	
`StudentEntity.m` file content as below:

	//
	//  StudentEntity.h
	//  your_project_name
	//
	//  Created by CK on 15-08-11.
	//  Copyright (c) 2015年 CK. All rights reserved.
	
	#import "StudentEntity.h"
	#import <MTLValueTransformer.h>
	 
	//json column declare
	static NSString * NameJsonKey = @"sname";
	static NSString * AgeJsonKey = @"age";
	static NSString * SexJsonKey = @"sex";
	
	
	
	@implementation StudentEntity
	
	#pragma mark - json method
	+(NSDictionary *)JSONKeyPathsByPropertyKey
	{
		return @{
	            @"name":NameJsonKey,
	            @"age":AgeJsonKey,
	            @"sex":SexJsonKey
	           };
	}
	@end
	
That's the model you want! It contain server json convert to local property!Of course you can add -d option to add database surpport:

	ptgen student -l name:string age:int sex:string -s sname:string age:int sex:string -d *t_name t_age t_sex 

*is a table primary key. your must set primary key if you use -d.

If you want your server property name and local property name same , you can use as below:

	ptgen DownloadModel -als title:string *imgUrlString:string downloadFinalPath:string totalContentSize:string speed:string retryCount:string isNeedResum:bool type:enum.RoleType

######according server http response
If your server respons data is beautiful. you can create model according http response data (this version only support json) as below:

	ptgen -ulsd "http://www.i4.cn/ajax.php?a=getoldnewsforpage&itype=2&n=20" -m /:Student
	
#####future
ptgen contain nimbus cell support in version 2. But it's not very good. I will add it in future.If you any useful common function , you can tell . I'll add it in future.