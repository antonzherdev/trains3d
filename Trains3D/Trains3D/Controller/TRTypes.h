#import "objd.h"
#import "EGTypes.h"

@interface TRColor : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSInteger ordinal;
@property (nonatomic, readonly) EGColor color;

+ (TRColor*)orange;
+ (TRColor*)green;
+ (TRColor*)purple;
+ (NSArray*)values;
@end


