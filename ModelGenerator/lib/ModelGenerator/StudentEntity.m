//
//  entity_nameEntity.h
//  your_project_name
//
//  Created by CK on 14-09-01.
//  Copyright (c) 2014年 CK. All rights reserved.

#import "StudentEntity.h"
#import <MTLValueTransformer.h>
 
 
static const NSString * TitleJsonKey = @"title";


@implementation CKAppleItemModel


+(NSDictionary*) JSONKeyPathsByPropertyKey
{
    return @{
            name:TitleJsonKey
           };
}






@end
