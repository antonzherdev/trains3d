#import "objd.h"
#import "EGTypes.h"

@class TRColor;

@interface TRColor : ODEnum
@property (nonatomic, readonly) EGColor color;

- (void)set;
- (void)setMaterial;
+ (TRColor*)orange;
+ (TRColor*)green;
+ (TRColor*)purple;
+ (TRColor*)grey;
+ (NSArray*)values;
@end


