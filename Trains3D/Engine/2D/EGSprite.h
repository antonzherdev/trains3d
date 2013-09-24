#import "objd.h"
#import "EGMesh.h"
#import "GEVec.h"
@class EGColorSource;
@class EGTexture;
@class EGGlobal;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
@class GEMat4;

@class EGSprite;

@interface EGSprite : NSObject
- (ODClassType*)type;
+ (void)drawMaterial:(EGColorSource*)material in:(GERect)in;
+ (void)drawMaterial:(EGColorSource*)material in:(GERect)in uv:(GERect)uv;
+ (void)fixedDrawMaterial:(EGColorSource*)material uv:(GERect)uv at:(GEVec2)at alignment:(GEVec2)alignment;
+ (ODClassType*)type;
@end


