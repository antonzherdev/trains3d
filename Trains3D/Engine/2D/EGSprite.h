#import "objd.h"
#import "EGMesh.h"
#import "GEVec.h"
@class EGColorSource;

@class EGSprite;

@interface EGSprite : NSObject
- (ODClassType*)type;
+ (void)drawMaterial:(EGColorSource*)material in:(GERect)in;
+ (void)drawMaterial:(EGColorSource*)material in:(GERect)in uv:(GERect)uv;
+ (ODClassType*)type;
@end


