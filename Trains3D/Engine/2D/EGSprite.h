#import "objd.h"
#import "EGBillboard.h"
#import "EGMesh.h"
#import "GEVec.h"
#import "EGShader.h"
#import "EGFont.h"
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGVertexArray;
@class EGEmptyIndexSource;
@class EGBillboardShaderSpace;
@class EGBillboardShaderKey;
@class EGBillboardShaderSystem;
@class EGSimpleShaderSystem;
@class EGColorSource;
@class EGTexture;
@class EGGlobal;
@class EGContext;
@class EGCullFace;
@class EGMatrixStack;
@class EGMMatrixModel;
@class GEMat4;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;
@class EGVertexBufferDesc;
@class ATReact;
@class ATReactFlag;
@class ATSignal;
@class EGDirector;
@protocol EGEvent;

@class EGD2D;
@class EGCircleShaderBuilder;
@class EGCircleParam;
@class EGCircleSegment;
@class EGCircleShader;
@class EGSprite;
@class EGButton;

@interface EGD2D : NSObject
- (ODClassType*)type;
+ (void)install;
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


@interface EGCircleShaderBuilder : NSObject<EGShaderTextBuilder> {
@private
    BOOL _segment;
}
@property (nonatomic, readonly) BOOL segment;

+ (instancetype)circleShaderBuilderWithSegment:(BOOL)segment;
- (instancetype)initWithSegment:(BOOL)segment;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface EGCircleParam : NSObject {
@private
    GEVec4 _color;
    GEVec4 _strokeColor;
    GEVec3 _position;
    GEVec2 _radius;
    GEVec2 _relative;
    id _segment;
}
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) GEVec4 strokeColor;
@property (nonatomic, readonly) GEVec3 position;
@property (nonatomic, readonly) GEVec2 radius;
@property (nonatomic, readonly) GEVec2 relative;
@property (nonatomic, readonly) id segment;

+ (instancetype)circleParamWithColor:(GEVec4)color strokeColor:(GEVec4)strokeColor position:(GEVec3)position radius:(GEVec2)radius relative:(GEVec2)relative segment:(id)segment;
- (instancetype)initWithColor:(GEVec4)color strokeColor:(GEVec4)strokeColor position:(GEVec3)position radius:(GEVec2)radius relative:(GEVec2)relative segment:(id)segment;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGCircleSegment : NSObject {
@private
    GEVec4 _color;
    float _start;
    float _end;
}
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) float start;
@property (nonatomic, readonly) float end;

+ (instancetype)circleSegmentWithColor:(GEVec4)color start:(float)start end:(float)end;
- (instancetype)initWithColor:(GEVec4)color start:(float)start end:(float)end;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGCircleShader : EGShader {
@private
    BOOL _segment;
    EGShaderAttribute* _model;
    EGShaderUniformVec4* _pos;
    EGShaderUniformMat4* _p;
    EGShaderUniformVec2* _radius;
    EGShaderUniformVec4* _color;
    EGShaderUniformVec4* _strokeColor;
    id _sectorColor;
    id _startTg;
    id _endTg;
}
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

+ (instancetype)circleShaderWithSegment:(BOOL)segment;
- (instancetype)initWithSegment:(BOOL)segment;
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGCircleParam*)param;
+ (EGCircleShader*)withSegment;
+ (EGCircleShader*)withoutSegment;
+ (ODClassType*)type;
@end


@interface EGSprite : NSObject {
@private
    ATReact* _visible;
    ATReact* _material;
    ATReact* _position;
    ATReact* _rect;
    EGMutableVertexBuffer* _vb;
    EGVertexArray* _vao;
    ATReactFlag* __changed;
    ATReactFlag* __materialChanged;
    ATSignal* _tap;
}
@property (nonatomic, readonly) ATReact* visible;
@property (nonatomic, readonly) ATReact* material;
@property (nonatomic, readonly) ATReact* position;
@property (nonatomic, readonly) ATReact* rect;
@property (nonatomic, readonly) ATSignal* tap;

+ (instancetype)spriteWithVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position rect:(ATReact*)rect;
- (instancetype)initWithVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position rect:(ATReact*)rect;
- (ODClassType*)type;
+ (EGSprite*)applyVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position anchor:(GEVec2)anchor;
+ (EGSprite*)applyMaterial:(ATReact*)material position:(ATReact*)position anchor:(GEVec2)anchor;
+ (ATReact*)rectReactMaterial:(ATReact*)material anchor:(GEVec2)anchor;
- (void)draw;
- (GERect)rectInViewport;
- (BOOL)containsViewportVec2:(GEVec2)vec2;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (EGSprite*)applyVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position;
+ (EGSprite*)applyMaterial:(ATReact*)material position:(ATReact*)position rect:(ATReact*)rect;
+ (EGSprite*)applyMaterial:(ATReact*)material position:(ATReact*)position;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
@end


@interface EGButton : NSObject {
@private
    EGSprite* _sprite;
    EGText* _text;
}
@property (nonatomic, readonly) EGSprite* sprite;
@property (nonatomic, readonly) EGText* text;

+ (instancetype)buttonWithSprite:(EGSprite*)sprite text:(EGText*)text;
- (instancetype)initWithSprite:(EGSprite*)sprite text:(EGText*)text;
- (ODClassType*)type;
- (ATSignal*)tap;
- (void)draw;
- (BOOL)tapEvent:(id<EGEvent>)event;
+ (EGButton*)applyVisible:(ATReact*)visible font:(ATReact*)font text:(ATReact*)text textColor:(ATReact*)textColor backgroundMaterial:(ATReact*)backgroundMaterial position:(ATReact*)position rect:(ATReact*)rect;
+ (EGButton*)applyFont:(ATReact*)font text:(ATReact*)text textColor:(ATReact*)textColor backgroundMaterial:(ATReact*)backgroundMaterial position:(ATReact*)position rect:(ATReact*)rect;
+ (ODClassType*)type;
@end


