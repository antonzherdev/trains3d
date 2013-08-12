#import <Foundation/Foundation.h>
#import "NSObject+CNOption.h"
#import "NSNull+CNOption.h"


@interface CNOption : NSObject
+ (id) none;
+ (id) opt:(id)value;
@end