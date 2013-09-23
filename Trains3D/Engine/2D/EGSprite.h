#import "objd.h"
#import "EGMesh.h"
#import "GEVec.h"
@class EGMaterial;

@class EGSprite;

@interface EGSprite : NSObject
- (ODClassType*)type;
+ (void)drawMaterial:(EGMaterial*)material in:(GERect)in;
+ (void)drawMaterial:(EGMaterial*)material in:(GERect)in uv:(GERect)uv;
+ (ODClassType*)type;
@end


