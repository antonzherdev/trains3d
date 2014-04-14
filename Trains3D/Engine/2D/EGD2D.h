#import "objd.h"
#import "EGBillboard.h"
#import "EGMesh.h"
#import "GEVec.h"
@class EGMutableVertexBuffer;
@class EGSprite;
@class EGVBO;
@class EGVertexArray;
@class EGEmptyIndexSource;
@class EGBillboardShaderSpace;
@class EGBillboardShaderKey;
@class EGBillboardShaderSystem;
@class EGSimpleShaderSystem;
@class EGCircleShader;
@class EGColorSource;
@class EGTexture;
@class EGGlobal;
@class EGContext;
@class EGCullFace;
@class EGCircleSegment;
@class EGCircleParam;
@class EGMatrixStack;
@class EGMMatrixModel;
@class GEMat4;

@class EGD2D;

@interface EGD2D : NSObject
- (ODClassType*)type;
+ (void)install;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at rect:(GERect)rect;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv;
+ (void)drawLineMaterial:(EGColorSource*)material p0:(GEVec2)p0 p1:(GEVec2)p1;
+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative segmentColor:(GEVec4)segmentColor start:(CGFloat)start end:(CGFloat)end;
+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative;
+ (ODClassType*)type;
@end


