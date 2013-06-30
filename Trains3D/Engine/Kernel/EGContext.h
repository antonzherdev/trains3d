#import "objd.h"
#import "EGTexture.h"

@interface EGContext : NSObject
+ (EGContext*)current;
- (EGTexture*)textureForFile:(NSString*)file;
@end


