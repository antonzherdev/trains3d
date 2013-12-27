#import "objd.h"
#import "EGBillboard.h"
#import "EGMesh.h"
#import "GEVec.h"
#import "EGShader.h"
#import "EGFont.h"
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGEmptyIndexSource;
@class EGSimpleShaderSystem;
@class EGColorSource;
@class EGTexture;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;
@class EGMatrixStack;
@class EGMatrixModel;
@class GEMat4;
@class EGBlendMode;
@class EGVertexBufferDesc;
@protocol EGEvent;

@class EGD2D;
@class EGCircleShaderBuilder;
@class EGCircleParam;
@class EGCircleSegment;
@class EGCircleShader;
@class EGSprite;
@class EGLine2d;
@class EGButton;

@interface EGD2D : NSObject
- (ODClassType*)type;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at rect:(GERect)rect;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad;
+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv;
+ (CNVoidRefArray)writeSpriteIn:(CNVoidRefArray)in material:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv;
+ (CNVoidRefArray)writeQuadIndexIn:(CNVoidRefArray)in i:(unsigned int)i;
+ (void)drawLineMaterial:(EGColorSource*)material p0:(GEVec2)p0 p1:(GEVec2)p1;
+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative segmentColor:(GEVec4)segmentColor start:(CGFloat)start end:(CGFloat)end;
+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative;
+ (ODClassType*)type;
@end


@interface EGCircleShaderBuilder : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) BOOL segment;

+ (id)circleShaderBuilderWithSegment:(BOOL)segment;
- (id)initWithSegment:(BOOL)segment;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGCircleParam : NSObject
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) GEVec4 strokeColor;
@property (nonatomic, readonly) GEVec3 position;
@property (nonatomic, readonly) GEVec2 radius;
@property (nonatomic, readonly) GEVec2 relative;
@property (nonatomic, readonly) id segment;

+ (id)circleParamWithColor:(GEVec4)color strokeColor:(GEVec4)strokeColor position:(GEVec3)position radius:(GEVec2)radius relative:(GEVec2)relative segment:(id)segment;
- (id)initWithColor:(GEVec4)color strokeColor:(GEVec4)strokeColor position:(GEVec3)position radius:(GEVec2)radius relative:(GEVec2)relative segment:(id)segment;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGCircleSegment : NSObject
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) float start;
@property (nonatomic, readonly) float end;

+ (id)circleSegmentWithColor:(GEVec4)color start:(float)start end:(float)end;
- (id)initWithColor:(GEVec4)color start:(float)start end:(float)end;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGCircleShader : EGShader
@property (nonatomic, readonly) BOOL segment;
@property (nonatomic, readonly) EGShaderAttribute* model;
@property (nonatomic, readonly) EGShaderUniformVec4* pos;
@property (nonatomic, readonly) EGShaderUniformMat4* p;
@property (nonatomic, readonly) EGShaderUniformVec2* radius;
@property (nonatomic, readonly) EGShaderUniformVec4* color;
@property (nonatomic, readonly) EGShaderUniformVec4* strokeColor;
@property (nonatomic, readonly) id sectorColor;
@property (nonatomic, readonly) id startTg;
@property (nonatomic, readonly) id endTg;

+ (id)circleShaderWithSegment:(BOOL)segment;
- (id)initWithSegment:(BOOL)segment;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGCircleParam*)param;
+ (EGCircleShader*)withSegment;
+ (EGCircleShader*)withoutSegment;
+ (ODClassType*)type;
@end


@interface EGSprite : NSObject
+ (id)sprite;
- (id)init;
- (ODClassType*)type;
+ (EGSprite*)applyMaterial:(EGColorSource*)material;
+ (EGSprite*)applyMaterial:(EGColorSource*)material rect:(GERect)rect;
- (EGColorSource*)material;
- (void)setMaterial:(EGColorSource*)material;
- (void)draw;
- (GEVec2)position;
- (void)setPosition:(GEVec2)position;
- (GEVec2)size;
- (void)setSize:(GEVec2)size;
- (GERect)rect;
- (void)setRect:(GERect)rect;
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


@interface EGButton : NSObject
@property (nonatomic, readonly) void(^onDraw)(GERect);
@property (nonatomic, readonly) void(^onClick)();
@property (nonatomic) GERect rect;

+ (id)buttonWithOnDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick;
- (id)initWithOnDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick;
- (ODClassType*)type;
+ (EGButton*)applyRect:(GERect)rect onDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick;
- (BOOL)tapEvent:(id<EGEvent>)event;
- (void)draw;
+ (void(^)(GERect))drawTextFont:(EGFont*(^)())font color:(GEVec4)color text:(NSString*)text;
+ (ODClassType*)type;
@end


