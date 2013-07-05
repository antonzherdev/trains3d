#import "objd.h"
@class EGTexture;
@class CNCache;

@class EGContext;

@interface EGContext : NSObject
+ (id)context;
- (id)init;
- (EGTexture*)textureForFile:(NSString*)file;
@end


