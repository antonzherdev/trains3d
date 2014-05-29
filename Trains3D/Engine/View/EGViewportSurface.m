#import "EGViewportSurface.h"

#import "EGTexture.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGContext.h"
#import "EGMesh.h"
#import "EGIndex.h"
#import "EGVertexArray.h"
#import "EGSurface.h"
#import "CNReact.h"
@implementation EGViewportSurfaceShaderParam
static CNClassType* _EGViewportSurfaceShaderParam_type;
@synthesize texture = _texture;
@synthesize z = _z;

+ (instancetype)viewportSurfaceShaderParamWithTexture:(EGTexture*)texture z:(float)z {
    return [[EGViewportSurfaceShaderParam alloc] initWithTexture:texture z:z];
}

- (instancetype)initWithTexture:(EGTexture*)texture z:(float)z {
    self = [super init];
    if(self) {
        _texture = texture;
        _z = z;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGViewportSurfaceShaderParam class]) _EGViewportSurfaceShaderParam_type = [CNClassType classTypeWithCls:[EGViewportSurfaceShaderParam class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ViewportSurfaceShaderParam(%@, %f)", _texture, _z];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGViewportSurfaceShaderParam class]])) return NO;
    EGViewportSurfaceShaderParam* o = ((EGViewportSurfaceShaderParam*)(to));
    return [_texture isEqual:o.texture] && eqf4(_z, o.z);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_texture hash];
    hash = hash * 31 + float4Hash(_z);
    return hash;
}

- (CNClassType*)type {
    return [EGViewportSurfaceShaderParam type];
}

+ (CNClassType*)type {
    return _EGViewportSurfaceShaderParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGViewportShaderBuilder
static CNClassType* _EGViewportShaderBuilder_type;

+ (instancetype)viewportShaderBuilder {
    return [[EGViewportShaderBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGViewportShaderBuilder class]) _EGViewportShaderBuilder_type = [CNClassType classTypeWithCls:[EGViewportShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@ highp vec2 position;\n"
        "uniform lowp float z;\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = vec4(2.0*position.x - 1.0, 2.0*position.y - 1.0, z, 1);\n"
        "    UV = position;\n"
        "}", [self vertexHeader], [self ain], [self out]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "uniform lowp sampler2D txt;\n"
        "\n"
        "void main(void) {\n"
        "    %@ = %@(txt, UV);\n"
        "}", [self fragmentHeader], [self in], [self fragColor], [self texture2D]];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Viewport" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)description {
    return @"ViewportShaderBuilder";
}

- (CNClassType*)type {
    return [EGViewportShaderBuilder type];
}

+ (CNClassType*)type {
    return _EGViewportShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGViewportSurfaceShader
static EGViewportSurfaceShader* _EGViewportSurfaceShader_instance;
static CNClassType* _EGViewportSurfaceShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize zUniform = _zUniform;

+ (instancetype)viewportSurfaceShader {
    return [[EGViewportSurfaceShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[EGViewportShaderBuilder viewportShaderBuilder] program]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _zUniform = [self uniformF4Name:@"z"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGViewportSurfaceShader class]) {
        _EGViewportSurfaceShader_type = [CNClassType classTypeWithCls:[EGViewportSurfaceShader class]];
        _EGViewportSurfaceShader_instance = [EGViewportSurfaceShader viewportSurfaceShader];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
}

- (void)loadUniformsParam:(EGViewportSurfaceShaderParam*)param {
    [EGGlobal.context bindTextureTexture:((EGViewportSurfaceShaderParam*)(param)).texture];
    [_zUniform applyF4:((EGViewportSurfaceShaderParam*)(param)).z];
}

- (NSString*)description {
    return @"ViewportSurfaceShader";
}

- (CNClassType*)type {
    return [EGViewportSurfaceShader type];
}

+ (EGViewportSurfaceShader*)instance {
    return _EGViewportSurfaceShader_instance;
}

+ (CNClassType*)type {
    return _EGViewportSurfaceShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGBaseViewportSurface
static CNLazy* _EGBaseViewportSurface__lazy_fullScreenMesh;
static CNLazy* _EGBaseViewportSurface__lazy_fullScreenVao;
static CNClassType* _EGBaseViewportSurface_type;
@synthesize createRenderTarget = _createRenderTarget;

+ (instancetype)baseViewportSurfaceWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget {
    return [[EGBaseViewportSurface alloc] initWithCreateRenderTarget:createRenderTarget];
}

- (instancetype)initWithCreateRenderTarget:(EGSurfaceRenderTarget*(^)(GEVec2i))createRenderTarget {
    self = [super init];
    if(self) {
        _createRenderTarget = [createRenderTarget copy];
        __surface = nil;
        __renderTarget = nil;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBaseViewportSurface class]) {
        _EGBaseViewportSurface_type = [CNClassType classTypeWithCls:[EGBaseViewportSurface class]];
        _EGBaseViewportSurface__lazy_fullScreenMesh = [CNLazy lazyWithF:^EGMesh*() {
            return [EGMesh meshWithVertex:[EGVBO vec2Data:[ arrs(GEVec2, 4) {GEVec2Make(0.0, 0.0), GEVec2Make(1.0, 0.0), GEVec2Make(0.0, 1.0), GEVec2Make(1.0, 1.0)}]] index:EGEmptyIndexSource.triangleStrip];
        }];
        _EGBaseViewportSurface__lazy_fullScreenVao = [CNLazy lazyWithF:^EGVertexArray*() {
            return [[EGBaseViewportSurface fullScreenMesh] vaoShader:EGViewportSurfaceShader.instance];
        }];
    }
}

+ (EGMesh*)fullScreenMesh {
    return [_EGBaseViewportSurface__lazy_fullScreenMesh get];
}

+ (EGVertexArray*)fullScreenVao {
    return [_EGBaseViewportSurface__lazy_fullScreenVao get];
}

- (EGRenderTargetSurface*)surface {
    return __surface;
}

- (EGSurfaceRenderTarget*)renderTarget {
    if(__renderTarget == nil || ({
        id __tmp_0cb = wrap(GEVec2i, ((EGSurfaceRenderTarget*)(__renderTarget)).size);
        __tmp_0cb == nil || !([__tmp_0cb isEqual:[EGGlobal.context.viewSize value]]);
    })) __renderTarget = _createRenderTarget((uwrap(GEVec2i, [EGGlobal.context.viewSize value])));
    return ((EGSurfaceRenderTarget*)(nonnil(__renderTarget)));
}

- (void)maybeRecreateSurface {
    if([self needRedraw]) __surface = [self createSurface];
}

- (EGRenderTargetSurface*)createSurface {
    @throw @"Method createSurface is abstract";
}

- (EGTexture*)texture {
    return ((EGSurfaceRenderTargetTexture*)([self renderTarget])).texture;
}

- (unsigned int)renderBuffer {
    return ((EGSurfaceRenderTargetRenderBuffer*)([self renderTarget])).renderBuffer;
}

- (BOOL)needRedraw {
    return __surface == nil || ({
        id __tmpb = wrap(GEVec2i, ((EGRenderTargetSurface*)(__surface)).size);
        __tmpb == nil || !([__tmpb isEqual:[EGGlobal.context.viewSize value]]);
    });
}

- (void)bind {
    [self maybeRecreateSurface];
    [((EGRenderTargetSurface*)(__surface)) bind];
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    draw();
    [self unbind];
}

- (void)maybeDraw:(void(^)())draw {
    if([self needRedraw]) {
        [self bind];
        draw();
        [self unbind];
    }
}

- (void)maybeForce:(BOOL)force draw:(void(^)())draw {
    if(force || [self needRedraw]) {
        [self bind];
        draw();
        [self unbind];
    }
}

- (void)unbind {
    [((EGRenderTargetSurface*)(__surface)) unbind];
}

- (NSString*)description {
    return [NSString stringWithFormat:@")"];
}

- (CNClassType*)type {
    return [EGBaseViewportSurface type];
}

+ (CNClassType*)type {
    return _EGBaseViewportSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

