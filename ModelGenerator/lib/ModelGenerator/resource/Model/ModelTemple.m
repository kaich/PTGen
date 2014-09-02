[DECLARE]

#import "[NAME].h"
#import <MTLValueTransformer.h>
 
 
[JSON_COLUMN_MAPPING]

@implementation CKAppleItemModel


+(NSDictionary*) JSONKeyPathsByPropertyKey
{
    return [PROPERTY_MAPPING];
}

[TYPE_TRANSFORMER]

@end
