#import "objd.h"

@class EGFont;

@interface EGFont : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSInteger size;

+ (id)fontWithName:(NSString*)name size:(NSInteger)size;
- (id)initWithName:(NSString*)name size:(NSInteger)size;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


