#import "objd.h"
#import "EGBillboard.h"
#import "EGMesh.h"
#import "GEVec.h"
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGEmptyIndexSource;
@class EGSimpleShaderSystem;
@class EGColorSource;
@class EGTexture;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;

@class EGD2D;
@class EGSprite;
@class EGLine2d;

@interface EGD2D : NSObject
- (ODClassType*)type;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at rect:(GERect)rect;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv;
+ (CNVoidRefArray)writeSpriteIn:(CNVoidRefArray)in material:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv;
+ (CNVoidRefArray)writeQuadIndexIn:(CNVoidRefArray)in i:(unsigned int)i;
+ (void)drawLineMaterial:(EGColorSource*)material p0:(GEVec2)p0 p1:(GEVec2)p1;
+ (void)drawCircleMaterial:(EGColorSource*)material at:(GEVec3)at radius:(float)radius segments:(unsigned int)segments start:(CGFloat)start end:(CGFloat)end;
+ (ODClassType*)type;
@end


@interface EGSprite : NSObject
@property (nonatomic, retain) EGColorSource* material;
@property (nonatomic) GEVec2 position;
@property (nonatomic) GEVec2 size;

+ (id)sprite;
- (id)init;
- (ODClassType*)type;
- (void)draw;
- (GERect)rect;
+ (EGSprite*)applyMaterial:(EGColorSource*)material size:(GEVec2)size;
+ (EGSprite*)applyTexture:(EGTexture*)texture;
- (void)adjustSize;
- (BOOL)containsVec2:(GEVec2)vec2;
+ (ODClassType*)type;
@end


@interface EGLine2d : NSObject
@property (nonatomic, retain) EGColorSource* material;
@property (nonatomic) GEVec2 p0;
@property (nonatomic) GEVec2 p1;

+ (id)line2d;
- (id)init;
- (ODClassType*)type;
+ (EGLine2d*)applyMaterial:(EGColorSource*)material;
- (void)draw;
+ (ODClassType*)type;
@end


