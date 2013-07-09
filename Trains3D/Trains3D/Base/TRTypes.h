#import "objd.h"
#import "EGTypes.h"

@class TRColor;

@interface TRColor : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSUInteger ordinal;
@property (nonatomic, readonly) EGColor color;

- (void)gl;
+ (TRColor*)orange;
+ (TRColor*)green;
+ (TRColor*)purple;
+ (NSArray*)values;
@end


