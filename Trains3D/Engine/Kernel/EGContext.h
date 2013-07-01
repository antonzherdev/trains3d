#import "objd.h"
#import "EGTexture.h"
#import "CNCache.h"

@interface EGContext : NSObject
+ (id)context;
- (id)init;
- (EGTexture*)textureForFile:(NSString*)file;
@end


