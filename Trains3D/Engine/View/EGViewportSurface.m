#import "EGViewportSurface.h"

#import "EGTexture.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGMesh.h"
#import "EGIndex.h"
#import "EGVertexArray.h"
#import "EGSurface.h"
#import "ATReact.h"
@implementation EGViewportSurfaceShaderParam
static ODClassType* _EGViewportSurfaceShaderParam_type;
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
    if(self == [EGViewportSurfaceShaderParam class]) _EGViewportSurfaceShaderParam_type = [ODClassType classTypeWithCls:[EGViewportSurfaceShaderParam class]];
}

- (ODClassType*)type {
    return [EGViewportSurfaceShaderParam type];
}

+ (ODClassType*)type {
    return _EGViewportSurfaceShaderParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%@", self.texture];
    [description appendFormat:@", z=%f", self.z];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGViewportShaderBuilder
static ODClassType* _EGViewportShaderBuilder_type;

+ (instancetype)viewportShaderBuilder {
    return [[EGViewportShaderBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGViewportShaderBuilder class]) _EGViewportShaderBuilder_type = [ODClassType classTypeWithCls:[EGViewportShaderBuilder class]];
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

- (NSString*)versionString {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)vertexHeader {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)fragmentHeader {
    return [NSString stringWithFormat:@"#version %ld\n"
        "%@", (long)[self version], [self fragColorDeclaration]];
}

- (NSString*)fragColorDeclaration {
    if([self isFragColorDeclared]) return @"";
    else return @"out lowp vec4 fragColor;";
}

- (BOOL)isFragColorDeclared {
    return EGShaderProgram.version < 110;
}

- (NSInteger)version {
    return EGShaderProgram.version;
}

- (NSString*)ain {
    if([self version] < 150) return @"attribute";
    else return @"in";
}

- (NSString*)in {
    if([self version] < 150) return @"varying";
    else return @"in";
}

- (NSString*)out {
    if([self version] < 150) return @"varying";
    else return @"out";
}

- (NSString*)fragColor {
    if([self version] > 100) return @"fragColor";
    else return @"gl_FragColor";
}

- (NSString*)texture2D {
    if([self version] > 100) return @"texture";
    else return @"texture2D";
}

- (NSString*)shadowExt {
    if([self version] == 100 && [EGGlobal.settings shadowType] == EGShadowType.shadow2d) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)sampler2DShadow {
    if([EGGlobal.settings shadowType] == EGShadowType.shadow2d) return @"sampler2DShadow";
    else return @"sampler2D";
}

- (NSString*)shadow2DTexture:(NSString*)texture vec3:(NSString*)vec3 {
    if([EGGlobal.settings shadowType] == EGShadowType.shadow2d) return [NSString stringWithFormat:@"%@(%@, %@)", [self shadow2DEXT], texture, vec3];
    else return [NSString stringWithFormat:@"(%@(%@, %@.xy).x < %@.z ? 0.0 : 1.0)", [self texture2D], texture, vec3, vec3];
}

- (NSString*)blendMode:(EGBlendMode*)mode a:(NSString*)a b:(NSString*)b {
    return mode.blend(a, b);
}

- (NSString*)shadow2DEXT {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
}

- (ODClassType*)type {
    return [EGViewportShaderBuilder type];
}

+ (ODClassType*)type {
    return _EGViewportShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGViewportSurfaceShader
static EGViewportSurfaceShader* _EGViewportSurfaceShader_instance;
static ODClassType* _EGViewportSurfaceShader_type;
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
        _EGViewportSurfaceShader_type = [ODClassType classTypeWithCls:[EGViewportSurfaceShader class]];
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

- (ODClassType*)type {
    return [EGViewportSurfaceShader type];
}

+ (EGViewportSurfaceShader*)instance {
    return _EGViewportSurfaceShader_instance;
}

+ (ODClassType*)type {
    return _EGViewportSurfaceShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBaseViewportSurface
static CNLazy* _EGBaseViewportSurface__lazy_fullScreenMesh;
static CNLazy* _EGBaseViewportSurface__lazy_fullScreenVao;
static ODClassType* _EGBaseViewportSurface_type;
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
        _EGBaseViewportSurface_type = [ODClassType classTypeWithCls:[EGBaseViewportSurface class]];
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
        id __tmp_0 = wrap(GEVec2i, ((EGSurfaceRenderTarget*)(__renderTarget)).size);
        __tmp_0 == nil || !([__tmp_0 isEqual:[EGGlobal.context.viewSize value]]);
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
        id __tmp = wrap(GEVec2i, ((EGRenderTargetSurface*)(__surface)).size);
        __tmp == nil || !([__tmp isEqual:[EGGlobal.context.viewSize value]]);
    });
}

- (void)bind {
    [self maybeRecreateSurface];
    [((EGRenderTargetSurface*)(__surface)) bind];
}

- (void)unbind {
    [((EGRenderTargetSurface*)(__surface)) unbind];
}

- (ODClassType*)type {
    return [EGBaseViewportSurface type];
}

+ (ODClassType*)type {
    return _EGBaseViewportSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


