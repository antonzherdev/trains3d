#import "EGShadow.h"

#import "GEMat4.h"
#import "GL.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "EGTexturePlat.h"
#import "EGVertexArray.h"
#import "EGMesh.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGMatrixModel.h"
#import "EGMultisamplingSurface.h"
@implementation EGShadowMap{
    unsigned int _frameBuffer;
    GEMat4* _biasDepthCp;
    EGTexture* _texture;
    CNLazy* __lazy_shader;
    CNLazy* __lazy_vao;
}
static GEMat4* _EGShadowMap_biasMatrix;
static ODClassType* _EGShadowMap_type;
@synthesize frameBuffer = _frameBuffer;
@synthesize biasDepthCp = _biasDepthCp;
@synthesize texture = _texture;

+ (id)shadowMapWithSize:(GEVec2i)size {
    return [[EGShadowMap alloc] initWithSize:size];
}

- (id)initWithSize:(GEVec2i)size {
    self = [super initWithSize:size];
    if(self) {
        _frameBuffer = egGenFrameBuffer();
        _biasDepthCp = [GEMat4 identity];
        _texture = ^EGEmptyTexture*() {
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            EGEmptyTexture* t = [EGEmptyTexture emptyTextureWithSize:geVec2ApplyVec2i(self.size)];
            [EGGlobal.context bindTextureTexture:t];
            egInitShadowTexture(self.size);
            egCheckError();
            egFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, t.id, 0);
            int status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in shadow map frame buffer: %d", status];
            return t;
        }();
        __lazy_shader = [CNLazy lazyWithF:^EGShadowSurfaceShader*() {
            return [EGShadowSurfaceShader shadowSurfaceShader];
        }];
        __lazy_vao = [CNLazy lazyWithF:^EGVertexArray*() {
            return [[EGBaseViewportSurface fullScreenMesh] vaoShader:[EGShadowSurfaceShader shadowSurfaceShader]];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowMap class]) {
        _EGShadowMap_type = [ODClassType classTypeWithCls:[EGShadowMap class]];
        _EGShadowMap_biasMatrix = [[[GEMat4 identity] translateX:0.5 y:0.5 z:0.5] scaleX:0.5 y:0.5 z:0.5];
    }
}

- (EGShadowSurfaceShader*)shader {
    return [__lazy_shader get];
}

- (EGVertexArray*)vao {
    return [__lazy_vao get];
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [EGGlobal.context setViewport:geRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
    egCheckError();
}

- (void)draw {
    [EGGlobal.context.cullFace disabledF:^void() {
        [[self vao] drawParam:[EGColorSource applyTexture:_texture]];
    }];
}

- (ODClassType*)type {
    return [EGShadowMap type];
}

+ (GEMat4*)biasMatrix {
    return _EGShadowMap_biasMatrix;
}

+ (ODClassType*)type {
    return _EGShadowMap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowMap* o = ((EGShadowMap*)(other));
    return GEVec2iEq(self.size, o.size);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowSurfaceShaderBuilder
static ODClassType* _EGShadowSurfaceShaderBuilder_type;

+ (id)shadowSurfaceShaderBuilder {
    return [[EGShadowSurfaceShaderBuilder alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowSurfaceShaderBuilder class]) _EGShadowSurfaceShaderBuilder_type = [ODClassType classTypeWithCls:[EGShadowSurfaceShaderBuilder class]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "uniform mediump sampler2D txt;\n"
        "\n"
        "void main(void) {\n"
        "    lowp vec4 col = %@(txt, UV);\n"
        "    %@ = vec4(col.x, col.x, col.x, 1);\n"
        "}", [self fragmentHeader], [self in], [self texture2D], [self fragColor]];
}

- (ODClassType*)type {
    return [EGShadowSurfaceShaderBuilder type];
}

+ (ODClassType*)type {
    return _EGShadowSurfaceShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowSurfaceShader{
    EGShaderAttribute* _positionSlot;
}
static ODClassType* _EGShadowSurfaceShader_type;
@synthesize positionSlot = _positionSlot;

+ (id)shadowSurfaceShader {
    return [[EGShadowSurfaceShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[[EGShadowSurfaceShaderBuilder shadowSurfaceShaderBuilder] program]];
    if(self) _positionSlot = [self.program attributeForName:@"position"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowSurfaceShader class]) _EGShadowSurfaceShader_type = [ODClassType classTypeWithCls:[EGShadowSurfaceShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    [EGGlobal.context bindTextureTexture:[param.texture get]];
}

- (ODClassType*)type {
    return [EGShadowSurfaceShader type];
}

+ (ODClassType*)type {
    return _EGShadowSurfaceShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowShaderSystem
static EGShadowShaderSystem* _EGShadowShaderSystem_instance;
static ODClassType* _EGShadowShaderSystem_type;

+ (id)shadowShaderSystem {
    return [[EGShadowShaderSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowShaderSystem class]) {
        _EGShadowShaderSystem_type = [ODClassType classTypeWithCls:[EGShadowShaderSystem class]];
        _EGShadowShaderSystem_instance = [EGShadowShaderSystem shadowShaderSystem];
    }
}

- (EGShadowShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget {
    if([EGShadowShaderSystem isColorShaderForParam:param]) return EGShadowShader.instanceForColor;
    else return EGShadowShader.instanceForTexture;
}

+ (BOOL)isColorShaderForParam:(EGColorSource*)param {
    return [param.texture isEmpty] || param.alphaTestLevel < 0;
}

- (ODClassType*)type {
    return [EGShadowShaderSystem type];
}

+ (EGShadowShaderSystem*)instance {
    return _EGShadowShaderSystem_instance;
}

+ (ODClassType*)type {
    return _EGShadowShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowShaderText{
    BOOL _texture;
}
static ODClassType* _EGShadowShaderText_type;
@synthesize texture = _texture;

+ (id)shadowShaderTextWithTexture:(BOOL)texture {
    return [[EGShadowShaderText alloc] initWithTexture:texture];
}

- (id)initWithTexture:(BOOL)texture {
    self = [super init];
    if(self) _texture = texture;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowShaderText class]) _EGShadowShaderText_type = [ODClassType classTypeWithCls:[EGShadowShaderText class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@\n"
        "%@ highp vec3 position;\n"
        "uniform mat4 mwcp;\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = mwcp * vec4(position, 1);%@\n"
        "}", [self vertexHeader], ((_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;", [self ain], [self out]] : @""), [self ain], ((_texture) ? @"\n"
        "    UV = vertexUV;" : @"")];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"#version %ld\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   %@\n"
        "   %@\n"
        "}", (long)[self version], ((_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D txt;\n"
        "uniform lowp float alphaTestLevel;", [self in]] : @""), (([self version] > 100) ? @"out float depth;" : @""), ((_texture) ? [NSString stringWithFormat:@"    if(%@(txt, UV).a < alphaTestLevel) {\n"
        "        discard;\n"
        "    }\n"
        "   ", [self texture2D]] : @""), (([self version] > 100) ? @"    depth = gl_FragCoord.z;\n"
        "   " : @"")];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Shadow" vertex:[self vertex] fragment:[self fragment]];
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
    return [EGShadowShaderText type];
}

+ (ODClassType*)type {
    return _EGShadowShaderText_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowShaderText* o = ((EGShadowShaderText*)(other));
    return self.texture == o.texture;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.texture;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%d", self.texture];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowShader{
    BOOL _texture;
    id _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformMat4* _mvpUniform;
    id _alphaTestLevelUniform;
}
static EGShadowShader* _EGShadowShader_instanceForColor;
static EGShadowShader* _EGShadowShader_instanceForTexture;
static ODClassType* _EGShadowShader_type;
@synthesize texture = _texture;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize mvpUniform = _mvpUniform;
@synthesize alphaTestLevelUniform = _alphaTestLevelUniform;

+ (id)shadowShaderWithTexture:(BOOL)texture program:(EGShaderProgram*)program {
    return [[EGShadowShader alloc] initWithTexture:texture program:program];
}

- (id)initWithTexture:(BOOL)texture program:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    if(self) {
        _texture = texture;
        _uvSlot = ((_texture) ? [CNOption applyValue:[self attributeForName:@"vertexUV"]] : [CNOption none]);
        _positionSlot = [self attributeForName:@"position"];
        _mvpUniform = [self uniformMat4Name:@"mwcp"];
        _alphaTestLevelUniform = ((_texture) ? [CNOption applyValue:[self uniformF4Name:@"alphaTestLevel"]] : [CNOption none]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowShader class]) {
        _EGShadowShader_type = [ODClassType classTypeWithCls:[EGShadowShader class]];
        _EGShadowShader_instanceForColor = [EGShadowShader shadowShaderWithTexture:NO program:[[EGShadowShaderText shadowShaderTextWithTexture:NO] program]];
        _EGShadowShader_instanceForTexture = [EGShadowShader shadowShaderWithTexture:YES program:[[EGShadowShaderText shadowShaderTextWithTexture:YES] program]];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    if(_texture) [((EGShaderAttribute*)([_uvSlot get])) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    [_mvpUniform applyMatrix:[[EGGlobal.matrix value] mwcp]];
    if(_texture) {
        [((EGShaderUniformF4*)([_alphaTestLevelUniform get])) applyF4:param.alphaTestLevel];
        [EGGlobal.context bindTextureTexture:[param.texture get]];
    }
}

- (ODClassType*)type {
    return [EGShadowShader type];
}

+ (EGShadowShader*)instanceForColor {
    return _EGShadowShader_instanceForColor;
}

+ (EGShadowShader*)instanceForTexture {
    return _EGShadowShader_instanceForTexture;
}

+ (ODClassType*)type {
    return _EGShadowShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowShader* o = ((EGShadowShader*)(other));
    return self.texture == o.texture && [self.program isEqual:o.program];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.texture;
    hash = hash * 31 + [self.program hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%d", self.texture];
    [description appendFormat:@", program=%@", self.program];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowDrawParam{
    id<CNSeq> _percents;
    id _viewportSurface;
}
static ODClassType* _EGShadowDrawParam_type;
@synthesize percents = _percents;
@synthesize viewportSurface = _viewportSurface;

+ (id)shadowDrawParamWithPercents:(id<CNSeq>)percents viewportSurface:(id)viewportSurface {
    return [[EGShadowDrawParam alloc] initWithPercents:percents viewportSurface:viewportSurface];
}

- (id)initWithPercents:(id<CNSeq>)percents viewportSurface:(id)viewportSurface {
    self = [super init];
    if(self) {
        _percents = percents;
        _viewportSurface = viewportSurface;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowDrawParam class]) _EGShadowDrawParam_type = [ODClassType classTypeWithCls:[EGShadowDrawParam class]];
}

- (ODClassType*)type {
    return [EGShadowDrawParam type];
}

+ (ODClassType*)type {
    return _EGShadowDrawParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowDrawParam* o = ((EGShadowDrawParam*)(other));
    return [self.percents isEqual:o.percents] && [self.viewportSurface isEqual:o.viewportSurface];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.percents hash];
    hash = hash * 31 + [self.viewportSurface hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"percents=%@", self.percents];
    [description appendFormat:@", viewportSurface=%@", self.viewportSurface];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowDrawShaderSystem
static EGShadowDrawShaderSystem* _EGShadowDrawShaderSystem_instance;
static CNNotificationObserver* _EGShadowDrawShaderSystem_settingsChangeObs;
static NSMutableDictionary* _EGShadowDrawShaderSystem_shaders;
static ODClassType* _EGShadowDrawShaderSystem_type;

+ (id)shadowDrawShaderSystem {
    return [[EGShadowDrawShaderSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowDrawShaderSystem class]) {
        _EGShadowDrawShaderSystem_type = [ODClassType classTypeWithCls:[EGShadowDrawShaderSystem class]];
        _EGShadowDrawShaderSystem_instance = [EGShadowDrawShaderSystem shadowDrawShaderSystem];
        _EGShadowDrawShaderSystem_settingsChangeObs = [EGSettings.shadowTypeChangedNotification observeBy:^void(EGSettings* _0, EGShadowType* _1) {
            [_EGShadowDrawShaderSystem_shaders clear];
        }];
        _EGShadowDrawShaderSystem_shaders = [NSMutableDictionary mutableDictionary];
    }
}

- (EGShadowDrawShader*)shaderForParam:(EGShadowDrawParam*)param renderTarget:(EGRenderTarget*)renderTarget {
    id<CNSeq> lights = EGGlobal.context.environment.lights;
    NSUInteger directLightsCount = [[[lights chain] filter:^BOOL(EGLight* _) {
        return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]] && ((EGLight*)(_)).hasShadows;
    }] count];
    EGShadowDrawShaderKey* key = [EGShadowDrawShaderKey shadowDrawShaderKeyWithDirectLightCount:directLightsCount viewportSurface:[param.viewportSurface isDefined]];
    return [_EGShadowDrawShaderSystem_shaders objectForKey:key orUpdateWith:^EGShadowDrawShader*() {
        return [key shader];
    }];
}

- (ODClassType*)type {
    return [EGShadowDrawShaderSystem type];
}

+ (EGShadowDrawShaderSystem*)instance {
    return _EGShadowDrawShaderSystem_instance;
}

+ (CNNotificationObserver*)settingsChangeObs {
    return _EGShadowDrawShaderSystem_settingsChangeObs;
}

+ (ODClassType*)type {
    return _EGShadowDrawShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowDrawShaderKey{
    NSUInteger _directLightCount;
    BOOL _viewportSurface;
}
static ODClassType* _EGShadowDrawShaderKey_type;
@synthesize directLightCount = _directLightCount;
@synthesize viewportSurface = _viewportSurface;

+ (id)shadowDrawShaderKeyWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface {
    return [[EGShadowDrawShaderKey alloc] initWithDirectLightCount:directLightCount viewportSurface:viewportSurface];
}

- (id)initWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface {
    self = [super init];
    if(self) {
        _directLightCount = directLightCount;
        _viewportSurface = viewportSurface;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowDrawShaderKey class]) _EGShadowDrawShaderKey_type = [ODClassType classTypeWithCls:[EGShadowDrawShaderKey class]];
}

- (EGShadowDrawShader*)shader {
    NSString* vertexShader = [NSString stringWithFormat:@"%@\n"
        "%@ highp vec3 position;\n"
        "uniform mat4 mwcp;\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   gl_Position = mwcp * vec4(position, 1);\n"
        "  %@\n"
        "   %@\n"
        "}", [self vertexHeader], [self ain], [self lightsVertexUniform], [self lightsOut], ((_viewportSurface) ? [NSString stringWithFormat:@"%@ mediump vec2 viewportUV;", [self out]] : @""), ((_viewportSurface) ? @"   viewportUV = gl_Position.xy*0.5 + vec2(0.5, 0.5);\n"
        "  " : @""), [self lightsCalculateVaryings]];
    NSString* fragmentShader = [NSString stringWithFormat:@"%@\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   lowp float visibility;\n"
        "   lowp float a = 0.0;\n"
        "   %@\n"
        "   %@ = vec4(0, 0, 0, a) + (1.0 - a)*%@(viewport, viewportUV);\n"
        "}", [self fragmentHeader], [self shadowExt], ((_viewportSurface) ? [NSString stringWithFormat:@"uniform lowp sampler2D viewport;\n"
        "%@ mediump vec2 viewportUV;", [self in]] : @""), [self lightsIn], [self lightsFragmentUniform], [self lightsDiffuse], [self fragColor], [self texture2D]];
    return [EGShadowDrawShader shadowDrawShaderWithKey:self program:[EGShaderProgram applyName:@"ShadowDraw" vertex:vertexShader fragment:fragmentShader]];
}

- (NSString*)lightsVertexUniform {
    if([[EGGlobal.settings shadowType] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform mat4 dirLightDepthMwcp%@;", i];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsIn {
    if([[EGGlobal.settings shadowType] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@ mediump vec3 dirLightShadowCoord%@;", [self in], i];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsOut {
    if([[EGGlobal.settings shadowType] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@ mediump vec3 dirLightShadowCoord%@;", [self out], i];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        if([[EGGlobal.settings shadowType] isOff]) return @"";
        else return [NSString stringWithFormat:@"dirLightShadowCoord%@ = (dirLightDepthMwcp%@ * vec4(position, 1)).xyz;\n"
            "dirLightShadowCoord%@.z -= 0.005;", i, i, i];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsFragmentUniform {
    if([[EGGlobal.settings shadowType] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform lowp float dirLightPercent%@;\n"
            "uniform mediump %@ dirLightShadow%@;", i, [self sampler2DShadow], i];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"a += dirLightPercent%@*(1.0 - %@);", i, [self shadow2DTexture:[NSString stringWithFormat:@"dirLightShadow%@", i] vec3:[NSString stringWithFormat:@"dirLightShadowCoord%@", i]]];
    }] toStringWithDelimiter:@"\n"];
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
    return [EGShadowDrawShaderKey type];
}

+ (ODClassType*)type {
    return _EGShadowDrawShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowDrawShaderKey* o = ((EGShadowDrawShaderKey*)(other));
    return self.directLightCount == o.directLightCount && self.viewportSurface == o.viewportSurface;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.directLightCount;
    hash = hash * 31 + self.viewportSurface;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"directLightCount=%lu", (unsigned long)self.directLightCount];
    [description appendFormat:@", viewportSurface=%d", self.viewportSurface];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowDrawShader{
    EGShadowDrawShaderKey* _key;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformMat4* _mwcpUniform;
    id<CNSeq> _directLightPercents;
    id<CNSeq> _directLightDepthMwcp;
    id<CNSeq> _directLightShadows;
}
static ODClassType* _EGShadowDrawShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize mwcpUniform = _mwcpUniform;
@synthesize directLightPercents = _directLightPercents;
@synthesize directLightDepthMwcp = _directLightDepthMwcp;
@synthesize directLightShadows = _directLightShadows;

+ (id)shadowDrawShaderWithKey:(EGShadowDrawShaderKey*)key program:(EGShaderProgram*)program {
    return [[EGShadowDrawShader alloc] initWithKey:key program:program];
}

- (id)initWithKey:(EGShadowDrawShaderKey*)key program:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    __weak EGShadowDrawShader* _weakSelf = self;
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _mwcpUniform = [self uniformMat4Name:@"mwcp"];
        _directLightPercents = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniformF4*(id i) {
            return [_weakSelf uniformF4Name:[NSString stringWithFormat:@"dirLightPercent%@", i]];
        }] toArray];
        _directLightDepthMwcp = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniformMat4*(id i) {
            return [_weakSelf uniformMat4Name:[NSString stringWithFormat:@"dirLightDepthMwcp%@", i]];
        }] toArray];
        _directLightShadows = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniformI4*(id i) {
            return [_weakSelf uniformI4Name:[NSString stringWithFormat:@"dirLightShadow%@", i]];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowDrawShader class]) _EGShadowDrawShader_type = [ODClassType classTypeWithCls:[EGShadowDrawShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
}

- (void)loadUniformsParam:(EGShadowDrawParam*)param {
    [_mwcpUniform applyMatrix:[[EGGlobal.matrix value] mwcp]];
    EGEnvironment* env = EGGlobal.context.environment;
    [param.viewportSurface forEach:^void(EGViewportSurface* _) {
        [EGGlobal.context bindTextureTexture:[((EGViewportSurface*)(_)) texture]];
    }];
    __block unsigned int i = 0;
    [[[env.lights chain] filter:^BOOL(EGLight* _) {
        return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]] && ((EGLight*)(_)).hasShadows;
    }] forEach:^void(EGLight* light) {
        float p = unumf4([param.percents applyIndex:((NSUInteger)(i))]);
        [((EGShaderUniformF4*)([_directLightPercents applyIndex:i])) applyF4:p];
        [((EGShaderUniformMat4*)([_directLightDepthMwcp applyIndex:i])) applyMatrix:[[((EGLight*)(light)) shadowMap].biasDepthCp mulMatrix:[EGGlobal.matrix mw]]];
        [((EGShaderUniformI4*)([_directLightShadows applyIndex:i])) applyI4:((int)(i + 1))];
        [EGGlobal.context bindTextureSlot:GL_TEXTURE0 + i + 1 target:GL_TEXTURE_2D texture:[((EGLight*)(light)) shadowMap].texture];
        i++;
    }];
}

- (ODClassType*)type {
    return [EGShadowDrawShader type];
}

+ (ODClassType*)type {
    return _EGShadowDrawShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowDrawShader* o = ((EGShadowDrawShader*)(other));
    return [self.key isEqual:o.key] && [self.program isEqual:o.program];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.key hash];
    hash = hash * 31 + [self.program hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"key=%@", self.key];
    [description appendFormat:@", program=%@", self.program];
    [description appendString:@">"];
    return description;
}

@end


