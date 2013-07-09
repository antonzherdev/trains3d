#import "objd.h"
#import "EGTypes.h"

@class TRColor;

@interface TRColor : ODEnum
@property (nonatomic, readonly) EGColor color;

- (void)gl;
+ (NSArray*)values;
+ (TRColor*)orange;
+ (TRColor*)green;
+ (TRColor*)purple;
@end


