#import "objd.h"
#import "EGTypes.h"

@class TRColor;

@interface TRColor : ODEnum
@property (nonatomic, readonly) EGColor color;

- (void)set;
+ (TRColor*)orange;
+ (TRColor*)green;
+ (TRColor*)purple;
+ (NSArray*)values;
@end


