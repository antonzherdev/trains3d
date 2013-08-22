#import "objd.h"
@class CNCache;
@class EGTexture;

@class EGContext;

@interface EGContext : NSObject
+ (id)context;
- (id)init;
- (EGTexture*)textureForFile:(NSString*)file;
@end


