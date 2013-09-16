#import "objdcore.h"
#import "ODObject.h"

@class Chain;
@class Test;

@interface Chain : NSObject
- (ODClassType*)type;
+ (NSString*)prefix;
+ (ODClassType*)type;
@end


@interface Test : NSObject
- (ODClassType*)type;
+ (NSString*)prefix;
+ (ODClassType*)type;
@end


