#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
@class EGVertexBufferDesc;
@class EGGlobal;
@class EGMatrixStack;
@class EGMMatrixModel;
@class GEMat4;

@class EGCircleShaderBuilder;
@class EGCircleParam;
@class EGCircleSegment;
@class EGCircleShader;

@interface EGCircleShaderBuilder : EGShaderTextBuilder_impl {
@protected
    BOOL _segment;
}
@property (nonatomic, readonly) BOOL segment;

+ (instancetype)circleShaderBuilderWithSegment:(BOOL)segment;
- (instancetype)initWithSegment:(BOOL)segment;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGCircleParam : NSObject {
@protected
    GEVec4 _color;
    GEVec4 _strokeColor;
    GEVec3 _position;
    GEVec2 _radius;
    GEVec2 _relative;
    EGCircleSegment* _segment;
}
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) GEVec4 strokeColor;
@property (nonatomic, readonly) GEVec3 position;
@property (nonatomic, readonly) GEVec2 radius;
@property (nonatomic, readonly) GEVec2 relative;
@property (nonatomic, readonly) EGCircleSegment* segment;

+ (instancetype)circleParamWithColor:(GEVec4)color strokeColor:(GEVec4)strokeColor position:(GEVec3)position radius:(GEVec2)radius relative:(GEVec2)relative segment:(EGCircleSegment*)segment;
- (instancetype)initWithColor:(GEVec4)color strokeColor:(GEVec4)strokeColor position:(GEVec3)position radius:(GEVec2)radius relative:(GEVec2)relative segment:(EGCircleSegment*)segment;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGCircleSegment : NSObject {
@protected
    GEVec4 _color;
    float _start;
    float _end;
}
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) float start;
@property (nonatomic, readonly) float end;

+ (instancetype)circleSegmentWithColor:(GEVec4)color start:(float)start end:(float)end;
- (instancetype)initWithColor:(GEVec4)color start:(float)start end:(float)end;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGCircleShader : EGShader {
@protected
    BOOL _segment;
    EGShaderAttribute* _model;
    EGShaderUniformVec4* _pos;
    EGShaderUniformMat4* _p;
    EGShaderUniformVec2* _radius;
    EGShaderUniformVec4* _color;
    EGShaderUniformVec4* _strokeColor;
    EGShaderUniformVec4* _sectorColor;
    EGShaderUniformF4* _startTg;
    EGShaderUniformF4* _endTg;
}
@property (nonatomic, readonly) BOOL segment;
@property (nonatomic, readonly) EGShaderAttribute* model;
@property (nonatomic, readonly) EGShaderUniformVec4* pos;
@property (nonatomic, readonly) EGShaderUniformMat4* p;
@property (nonatomic, readonly) EGShaderUniformVec2* radius;
@property (nonatomic, readonly) EGShaderUniformVec4* color;
@property (nonatomic, readonly) EGShaderUniformVec4* strokeColor;
@property (nonatomic, readonly) EGShaderUniformVec4* sectorColor;
@property (nonatomic, readonly) EGShaderUniformF4* startTg;
@property (nonatomic, readonly) EGShaderUniformF4* endTg;

+ (instancetype)circleShaderWithSegment:(BOOL)segment;
- (instancetype)initWithSegment:(BOOL)segment;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGCircleParam*)param;
- (NSString*)description;
+ (EGCircleShader*)withSegment;
+ (EGCircleShader*)withoutSegment;
+ (CNClassType*)type;
@end


