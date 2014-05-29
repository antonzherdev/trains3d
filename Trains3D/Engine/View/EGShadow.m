#import "EGShadow.h"

#import "GEMat4.h"
#import "GL.h"
#import "EGTexture.h"
#import "EGTexturePlat.h"
#import "EGVertexArray.h"
#import "EGMesh.h"
#import "EGDirector.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGMatrixModel.h"
#import "EGMultisamplingSurface.h"
#import "CNObserver.h"
#import "CNChain.h"
@implementation EGShadowMap
static GEMat4* _EGShadowMap_biasMatrix;
static CNClassType* _EGShadowMap_type;
@synthesize frameBuffer = _frameBuffer;
@synthesize biasDepthCp = _biasDepthCp;
@synthesize texture = _texture;

+ (instancetype)shadowMapWithSize:(GEVec2i)size {
    return [[EGShadowMap alloc] initWithSize:size];
}

- (instancetype)initWithSize:(GEVec2i)size {
    self = [super initWithSize:size];
    if(self) {
        _frameBuffer = egGenFrameBuffer();
        _biasDepthCp = [GEMat4 identity];
        _texture = ({
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            EGEmptyTexture* t = [EGEmptyTexture emptyTextureWithSize:geVec2ApplyVec2i(size)];
            [EGGlobal.context bindTextureTexture:t];
            egInitShadowTexture(size);
            egCheckError();
            egFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, t.id, 0);
            int status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in shadow map frame buffer: %d", status];
            t;
        });
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
        _EGShadowMap_type = [CNClassType classTypeWithCls:[EGShadowMap class]];
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
    unsigned int fb = _frameBuffer;
    [[EGDirector current] onGLThreadF:^void() {
        egDeleteFrameBuffer(fb);
    }];
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [EGGlobal.context setViewport:geRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
    egCheckError();
}

- (void)draw {
    EGCullFace* __tmp__il__0self = EGGlobal.context.cullFace;
    {
        unsigned int __il__0oldValue = [__tmp__il__0self disable];
        [[self vao] drawParam:[EGColorSource applyTexture:_texture]];
        if(__il__0oldValue != GL_NONE) [__tmp__il__0self setValue:__il__0oldValue];
    }
}

- (NSString*)description {
    return @"ShadowMap";
}

- (CNClassType*)type {
    return [EGShadowMap type];
}

+ (GEMat4*)biasMatrix {
    return _EGShadowMap_biasMatrix;
}

+ (CNClassType*)type {
    return _EGShadowMap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShadowSurfaceShaderBuilder
static CNClassType* _EGShadowSurfaceShaderBuilder_type;

+ (instancetype)shadowSurfaceShaderBuilder {
    return [[EGShadowSurfaceShaderBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowSurfaceShaderBuilder class]) _EGShadowSurfaceShaderBuilder_type = [CNClassType classTypeWithCls:[EGShadowSurfaceShaderBuilder class]];
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

- (NSString*)description {
    return @"ShadowSurfaceShaderBuilder";
}

- (CNClassType*)type {
    return [EGShadowSurfaceShaderBuilder type];
}

+ (CNClassType*)type {
    return _EGShadowSurfaceShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShadowSurfaceShader
static CNClassType* _EGShadowSurfaceShader_type;
@synthesize positionSlot = _positionSlot;

+ (instancetype)shadowSurfaceShader {
    return [[EGShadowSurfaceShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[EGShadowSurfaceShaderBuilder shadowSurfaceShaderBuilder] program]];
    if(self) _positionSlot = [self.program attributeForName:@"position"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowSurfaceShader class]) _EGShadowSurfaceShader_type = [CNClassType classTypeWithCls:[EGShadowSurfaceShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    EGTexture* _ = ((EGColorSource*)(param)).texture;
    if(_ != nil) [EGGlobal.context bindTextureTexture:_];
}

- (NSString*)description {
    return @"ShadowSurfaceShader";
}

- (CNClassType*)type {
    return [EGShadowSurfaceShader type];
}

+ (CNClassType*)type {
    return _EGShadowSurfaceShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShadowShaderSystem
static EGShadowShaderSystem* _EGShadowShaderSystem_instance;
static CNClassType* _EGShadowShaderSystem_type;

+ (instancetype)shadowShaderSystem {
    return [[EGShadowShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowShaderSystem class]) {
        _EGShadowShaderSystem_type = [CNClassType classTypeWithCls:[EGShadowShaderSystem class]];
        _EGShadowShaderSystem_instance = [EGShadowShaderSystem shadowShaderSystem];
    }
}

- (EGShadowShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget {
    if([EGShadowShaderSystem isColorShaderForParam:param]) return EGShadowShader.instanceForColor;
    else return EGShadowShader.instanceForTexture;
}

+ (BOOL)isColorShaderForParam:(EGColorSource*)param {
    return param.texture == nil || param.alphaTestLevel < 0;
}

- (NSString*)description {
    return @"ShadowShaderSystem";
}

- (CNClassType*)type {
    return [EGShadowShaderSystem type];
}

+ (EGShadowShaderSystem*)instance {
    return _EGShadowShaderSystem_instance;
}

+ (CNClassType*)type {
    return _EGShadowShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShadowShaderText
static CNClassType* _EGShadowShaderText_type;
@synthesize texture = _texture;

+ (instancetype)shadowShaderTextWithTexture:(BOOL)texture {
    return [[EGShadowShaderText alloc] initWithTexture:texture];
}

- (instancetype)initWithTexture:(BOOL)texture {
    self = [super init];
    if(self) _texture = texture;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowShaderText class]) _EGShadowShaderText_type = [CNClassType classTypeWithCls:[EGShadowShaderText class]];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowShaderText(%d)", _texture];
}

- (CNClassType*)type {
    return [EGShadowShaderText type];
}

+ (CNClassType*)type {
    return _EGShadowShaderText_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShadowShader
static EGShadowShader* _EGShadowShader_instanceForColor;
static EGShadowShader* _EGShadowShader_instanceForTexture;
static CNClassType* _EGShadowShader_type;
@synthesize texture = _texture;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize mvpUniform = _mvpUniform;
@synthesize alphaTestLevelUniform = _alphaTestLevelUniform;

+ (instancetype)shadowShaderWithTexture:(BOOL)texture program:(EGShaderProgram*)program {
    return [[EGShadowShader alloc] initWithTexture:texture program:program];
}

- (instancetype)initWithTexture:(BOOL)texture program:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    if(self) {
        _texture = texture;
        _uvSlot = ((texture) ? [self attributeForName:@"vertexUV"] : nil);
        _positionSlot = [self attributeForName:@"position"];
        _mvpUniform = [self uniformMat4Name:@"mwcp"];
        _alphaTestLevelUniform = ((texture) ? [self uniformF4Name:@"alphaTestLevel"] : nil);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowShader class]) {
        _EGShadowShader_type = [CNClassType classTypeWithCls:[EGShadowShader class]];
        _EGShadowShader_instanceForColor = [EGShadowShader shadowShaderWithTexture:NO program:[[EGShadowShaderText shadowShaderTextWithTexture:NO] program]];
        _EGShadowShader_instanceForTexture = [EGShadowShader shadowShaderWithTexture:YES program:[[EGShadowShaderText shadowShaderTextWithTexture:YES] program]];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    if(_texture) [((EGShaderAttribute*)(_uvSlot)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    [_mvpUniform applyMatrix:[[EGGlobal.matrix value] mwcp]];
    if(_texture) {
        [((EGShaderUniformF4*)(_alphaTestLevelUniform)) applyF4:((EGColorSource*)(param)).alphaTestLevel];
        {
            EGTexture* _ = ((EGColorSource*)(param)).texture;
            if(_ != nil) [EGGlobal.context bindTextureTexture:_];
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowShader(%d)", _texture];
}

- (CNClassType*)type {
    return [EGShadowShader type];
}

+ (EGShadowShader*)instanceForColor {
    return _EGShadowShader_instanceForColor;
}

+ (EGShadowShader*)instanceForTexture {
    return _EGShadowShader_instanceForTexture;
}

+ (CNClassType*)type {
    return _EGShadowShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShadowDrawParam
static CNClassType* _EGShadowDrawParam_type;
@synthesize percents = _percents;
@synthesize viewportSurface = _viewportSurface;

+ (instancetype)shadowDrawParamWithPercents:(id<CNSeq>)percents viewportSurface:(EGViewportSurface*)viewportSurface {
    return [[EGShadowDrawParam alloc] initWithPercents:percents viewportSurface:viewportSurface];
}

- (instancetype)initWithPercents:(id<CNSeq>)percents viewportSurface:(EGViewportSurface*)viewportSurface {
    self = [super init];
    if(self) {
        _percents = percents;
        _viewportSurface = viewportSurface;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowDrawParam class]) _EGShadowDrawParam_type = [CNClassType classTypeWithCls:[EGShadowDrawParam class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowDrawParam(%@, %@)", _percents, _viewportSurface];
}

- (CNClassType*)type {
    return [EGShadowDrawParam type];
}

+ (CNClassType*)type {
    return _EGShadowDrawParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShadowDrawShaderSystem
static EGShadowDrawShaderSystem* _EGShadowDrawShaderSystem_instance;
static CNObserver* _EGShadowDrawShaderSystem_settingsChangeObs;
static CNMHashMap* _EGShadowDrawShaderSystem_shaders;
static CNClassType* _EGShadowDrawShaderSystem_type;

+ (instancetype)shadowDrawShaderSystem {
    return [[EGShadowDrawShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowDrawShaderSystem class]) {
        _EGShadowDrawShaderSystem_type = [CNClassType classTypeWithCls:[EGShadowDrawShaderSystem class]];
        _EGShadowDrawShaderSystem_instance = [EGShadowDrawShaderSystem shadowDrawShaderSystem];
        _EGShadowDrawShaderSystem_settingsChangeObs = [EGGlobal.settings.shadowTypeChanged observeF:^void(EGShadowType* _) {
            [_EGShadowDrawShaderSystem_shaders clear];
        }];
        _EGShadowDrawShaderSystem_shaders = [CNMHashMap hashMap];
    }
}

- (EGShadowDrawShader*)shaderForParam:(EGShadowDrawParam*)param renderTarget:(EGRenderTarget*)renderTarget {
    NSArray* lights = EGGlobal.context.environment.lights;
    NSUInteger directLightsCount = [[[lights chain] filterWhen:^BOOL(EGLight* _) {
        return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]] && ((EGLight*)(_)).hasShadows;
    }] count];
    EGShadowDrawShaderKey* key = [EGShadowDrawShaderKey shadowDrawShaderKeyWithDirectLightCount:directLightsCount viewportSurface:((EGShadowDrawParam*)(param)).viewportSurface != nil];
    return [_EGShadowDrawShaderSystem_shaders applyKey:key orUpdateWith:^EGShadowDrawShader*() {
        return [key shader];
    }];
}

- (NSString*)description {
    return @"ShadowDrawShaderSystem";
}

- (CNClassType*)type {
    return [EGShadowDrawShaderSystem type];
}

+ (EGShadowDrawShaderSystem*)instance {
    return _EGShadowDrawShaderSystem_instance;
}

+ (CNObserver*)settingsChangeObs {
    return _EGShadowDrawShaderSystem_settingsChangeObs;
}

+ (CNClassType*)type {
    return _EGShadowDrawShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShadowDrawShaderKey
static CNClassType* _EGShadowDrawShaderKey_type;
@synthesize directLightCount = _directLightCount;
@synthesize viewportSurface = _viewportSurface;

+ (instancetype)shadowDrawShaderKeyWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface {
    return [[EGShadowDrawShaderKey alloc] initWithDirectLightCount:directLightCount viewportSurface:viewportSurface];
}

- (instancetype)initWithDirectLightCount:(NSUInteger)directLightCount viewportSurface:(BOOL)viewportSurface {
    self = [super init];
    if(self) {
        _directLightCount = directLightCount;
        _viewportSurface = viewportSurface;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowDrawShaderKey class]) _EGShadowDrawShaderKey_type = [CNClassType classTypeWithCls:[EGShadowDrawShaderKey class]];
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
    if([EGShadowType_Values[[EGGlobal.settings shadowType]] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform mat4 dirLightDepthMwcp%@;", i];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsIn {
    if([EGShadowType_Values[[EGGlobal.settings shadowType]] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@ mediump vec3 dirLightShadowCoord%@;", [self in], i];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsOut {
    if([EGShadowType_Values[[EGGlobal.settings shadowType]] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@ mediump vec3 dirLightShadowCoord%@;", [self out], i];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        if([EGShadowType_Values[[EGGlobal.settings shadowType]] isOff]) return @"";
        else return [NSString stringWithFormat:@"dirLightShadowCoord%@ = (dirLightDepthMwcp%@ * vec4(position, 1)).xyz;\n"
            "dirLightShadowCoord%@.z -= 0.005;", i, i, i];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsFragmentUniform {
    if([EGShadowType_Values[[EGGlobal.settings shadowType]] isOff]) return @"";
    else return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform lowp float dirLightPercent%@;\n"
            "uniform mediump %@ dirLightShadow%@;", i, [self sampler2DShadow], i];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"a += dirLightPercent%@*(1.0 - %@);", i, [self shadow2DTexture:[NSString stringWithFormat:@"dirLightShadow%@", i] vec3:[NSString stringWithFormat:@"dirLightShadowCoord%@", i]]];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowDrawShaderKey(%lu, %d)", (unsigned long)_directLightCount, _viewportSurface];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGShadowDrawShaderKey class]])) return NO;
    EGShadowDrawShaderKey* o = ((EGShadowDrawShaderKey*)(to));
    return _directLightCount == o.directLightCount && _viewportSurface == o.viewportSurface;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _directLightCount;
    hash = hash * 31 + _viewportSurface;
    return hash;
}

- (CNClassType*)type {
    return [EGShadowDrawShaderKey type];
}

+ (CNClassType*)type {
    return _EGShadowDrawShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShadowDrawShader
static CNClassType* _EGShadowDrawShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize mwcpUniform = _mwcpUniform;
@synthesize directLightPercents = _directLightPercents;
@synthesize directLightDepthMwcp = _directLightDepthMwcp;
@synthesize directLightShadows = _directLightShadows;

+ (instancetype)shadowDrawShaderWithKey:(EGShadowDrawShaderKey*)key program:(EGShaderProgram*)program {
    return [[EGShadowDrawShader alloc] initWithKey:key program:program];
}

- (instancetype)initWithKey:(EGShadowDrawShaderKey*)key program:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _mwcpUniform = [self uniformMat4Name:@"mwcp"];
        _directLightPercents = [[[uintRange(key.directLightCount) chain] mapF:^EGShaderUniformF4*(id i) {
            return [self uniformF4Name:[NSString stringWithFormat:@"dirLightPercent%@", i]];
        }] toArray];
        _directLightDepthMwcp = [[[uintRange(key.directLightCount) chain] mapF:^EGShaderUniformMat4*(id i) {
            return [self uniformMat4Name:[NSString stringWithFormat:@"dirLightDepthMwcp%@", i]];
        }] toArray];
        _directLightShadows = [[[uintRange(key.directLightCount) chain] mapF:^EGShaderUniformI4*(id i) {
            return [self uniformI4Name:[NSString stringWithFormat:@"dirLightShadow%@", i]];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShadowDrawShader class]) _EGShadowDrawShader_type = [CNClassType classTypeWithCls:[EGShadowDrawShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
}

- (void)loadUniformsParam:(EGShadowDrawParam*)param {
    [_mwcpUniform applyMatrix:[[EGGlobal.matrix value] mwcp]];
    EGEnvironment* env = EGGlobal.context.environment;
    {
        EGViewportSurface* _ = ((EGShadowDrawParam*)(param)).viewportSurface;
        if(_ != nil) [EGGlobal.context bindTextureTexture:[((EGViewportSurface*)(_)) texture]];
    }
    __block unsigned int i = 0;
    [[[env.lights chain] filterWhen:^BOOL(EGLight* _) {
        return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]] && ((EGLight*)(_)).hasShadows;
    }] forEach:^void(EGLight* light) {
        float p = ((float)(unumf(nonnil([((EGShadowDrawParam*)(param)).percents applyIndex:((NSUInteger)(i))]))));
        [((EGShaderUniformF4*)([_directLightPercents applyIndex:i])) applyF4:p];
        [((EGShaderUniformMat4*)([_directLightDepthMwcp applyIndex:i])) applyMatrix:[[((EGLight*)(light)) shadowMap].biasDepthCp mulMatrix:[EGGlobal.matrix mw]]];
        [((EGShaderUniformI4*)([_directLightShadows applyIndex:i])) applyI4:((int)(i + 1))];
        [EGGlobal.context bindTextureSlot:GL_TEXTURE0 + i + 1 target:GL_TEXTURE_2D texture:[((EGLight*)(light)) shadowMap].texture];
        i++;
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShadowDrawShader(%@)", _key];
}

- (CNClassType*)type {
    return [EGShadowDrawShader type];
}

+ (CNClassType*)type {
    return _EGShadowDrawShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

