//
//  entity_nameEntity.h
//  your_project_name
//
//  Created by CK on 14-09-01.
//  Copyright (c) 2014年 CK. All rights reserved.

#import <MTLModel.h>
#import <MTLJSONAdapter.h>

@interface StudentEntity : MTLModel<MTLJSONSerializing>
@property(nonatomic,strong) NSString * name;

@end
