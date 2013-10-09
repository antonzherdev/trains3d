#import "EGShadow.h"

#import "GEMat4.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "EGMesh.h"
#import "EGStandardShaderSystem.h"
@implementation EGShadowMap{
    GLuint _frameBuffer;
    GEMat4* _biasDepthCp;
    EGTexture* _texture;
    CNLazy* __lazy_shader;
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
        _texture = ^EGTexture*() {
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            EGTexture* t = [EGTexture texture];
            glBindTexture(GL_TEXTURE_2D, t.id);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT16, self.size.x, self.size.y, 0, GL_DEPTH_COMPONENT, GL_FLOAT, 0);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            egInitShadowTexture();
            egFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, t.id, 0);
            NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in shadow map frame buffer: %li", status];
            glBindTexture(GL_TEXTURE_2D, 0);
            [EGGlobal.context restoreDefaultFramebuffer];
            return t;
        }();
        __lazy_shader = [CNLazy lazyWithF:^EGShadowSurfaceShader*() {
            return [EGShadowSurfaceShader shadowSurfaceShader];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowMap_type = [ODClassType classTypeWithCls:[EGShadowMap class]];
    _EGShadowMap_biasMatrix = [[[GEMat4 identity] translateX:0.5 y:0.5 z:0.5] scaleX:0.5 y:0.5 z:0.5];
}

- (EGShadowSurfaceShader*)shader {
    return ((EGShadowSurfaceShader*)([__lazy_shader get]));
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
}

- (void)bind {
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    [EGGlobal.context bindTextureTexture:_texture];
    [EGGlobal.context pushViewport];
    [EGGlobal.context setViewport:geRectIApplyXYWidthHeight(0.0, 0.0, ((float)(self.size.x)), ((float)(self.size.y)))];
}

- (void)unbind {
    glFlush();
    [EGGlobal.context restoreDefaultFramebuffer];
    [EGGlobal.context popViewport];
}

- (void)draw {
    [EGGlobal.context.cullFace disabledF:^void() {
        [[self shader] drawParam:[EGColorSource applyTexture:_texture] mesh:[EGBaseViewportSurface fullScreenMesh]];
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
    _EGShadowSurfaceShaderBuilder_type = [ODClassType classTypeWithCls:[EGShadowSurfaceShaderBuilder class]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "%@ vec2 UV;\n"
        "\n"
        "uniform sampler2D texture;\n"
        "\n"
        "void main(void) {\n"
        "    vec4 col = %@(texture, UV);\n"
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
    _EGShadowSurfaceShader_type = [ODClassType classTypeWithCls:[EGShadowSurfaceShader class]];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param {
    [EGGlobal.context bindTextureTexture:((EGTexture*)([param.texture get]))];
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
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
static ODClassType* _EGShadowShaderSystem_type;

+ (void)initialize {
    [super initialize];
    _EGShadowShaderSystem_type = [ODClassType classTypeWithCls:[EGShadowShaderSystem class]];
}

+ (EGShadowShader*)shaderForParam:(EGColorSource*)param {
    if([EGShadowShaderSystem isColorShaderForParam:param]) return EGShadowShader.instanceForColor;
    else return EGShadowShader.instanceForTexture;
}

+ (BOOL)isColorShaderForParam:(EGColorSource*)param {
    return [param.texture isEmpty] || param.alphaTestLevel < 0;
}

- (ODClassType*)type {
    return [EGShadowShaderSystem type];
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
    _EGShadowShader_type = [ODClassType classTypeWithCls:[EGShadowShader class]];
    _EGShadowShader_instanceForColor = [EGShadowShader shadowShaderWithTexture:NO program:[EGShaderProgram applyVertex:[EGShadowShader vertexProgramTexture:NO] fragment:[EGShadowShader fragmentProgramTexture:NO]]];
    _EGShadowShader_instanceForTexture = [EGShadowShader shadowShaderWithTexture:YES program:[EGShaderProgram applyVertex:[EGShadowShader vertexProgramTexture:YES] fragment:[EGShadowShader fragmentProgramTexture:YES]]];
}

+ (NSString*)vertexProgramTexture:(BOOL)texture {
    return [NSString stringWithFormat:@"#version 150%@\n"
        "in vec3 position;\n"
        "uniform mat4 mwcp;\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = mwcp * vec4(position, 1);%@\n"
        "}", ((texture) ? @"\n"
        "in vec2 vertexUV;" : @""), ((texture) ? @"\n"
        "out vec2 UV;" : @""), ((texture) ? @"\n"
        "    UV = vertexUV;" : @"")];
}

+ (NSString*)fragmentProgramTexture:(BOOL)texture {
    return [NSString stringWithFormat:@"#version 150\n"
        "%@\n"
        "out float depth;\n"
        "\n"
        "void main(void) {\n"
        "%@\n"
        "    depth = gl_FragCoord.z;\n"
        "}", ((texture) ? @"\n"
        "in vec2 UV;\n"
        "uniform sampler2D texture;\n"
        "uniform float alphaTestLevel;\n" : @""), ((texture) ? @"\n"
        "    if(texture(texture, UV).a < alphaTestLevel) {\n"
        "        discard;\n"
        "    }\n" : @"")];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_mvpUniform applyMatrix:[EGGlobal.matrix.value mwcp]];
    if(_texture) {
        [((EGShaderAttribute*)([_uvSlot get])) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
        [((EGShaderUniformF4*)([_alphaTestLevelUniform get])) applyF4:param.alphaTestLevel];
        [EGGlobal.context bindTextureTexture:((EGTexture*)([param.texture get]))];
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
}
static ODClassType* _EGShadowDrawParam_type;
@synthesize percents = _percents;

+ (id)shadowDrawParamWithPercents:(id<CNSeq>)percents {
    return [[EGShadowDrawParam alloc] initWithPercents:percents];
}

- (id)initWithPercents:(id<CNSeq>)percents {
    self = [super init];
    if(self) _percents = percents;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowDrawParam_type = [ODClassType classTypeWithCls:[EGShadowDrawParam class]];
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
    return [self.percents isEqual:o.percents];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.percents hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"percents=%@", self.percents];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowDrawShaderSystem
static NSMutableDictionary* _EGShadowDrawShaderSystem_shaders;
static ODClassType* _EGShadowDrawShaderSystem_type;

+ (void)initialize {
    [super initialize];
    _EGShadowDrawShaderSystem_type = [ODClassType classTypeWithCls:[EGShadowDrawShaderSystem class]];
    _EGShadowDrawShaderSystem_shaders = [NSMutableDictionary mutableDictionary];
}

+ (EGShader*)shaderForParam:(EGShadowDrawParam*)param {
    id<CNSeq> lights = EGGlobal.context.environment.lights;
    NSUInteger directLightsCount = [[[lights chain] filter:^BOOL(EGLight* _) {
        return [_ isKindOfClass:[EGDirectLight class]] && _.hasShadows;
    }] count];
    EGShadowDrawShaderKey* key = [EGShadowDrawShaderKey shadowDrawShaderKeyWithDirectLightCount:directLightsCount];
    return ((EGShadowDrawShader*)([_EGShadowDrawShaderSystem_shaders objectForKey:key orUpdateWith:^EGShadowDrawShader*() {
        return [key shader];
    }]));
}

- (ODClassType*)type {
    return [EGShadowDrawShaderSystem type];
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
}
static ODClassType* _EGShadowDrawShaderKey_type;
@synthesize directLightCount = _directLightCount;

+ (id)shadowDrawShaderKeyWithDirectLightCount:(NSUInteger)directLightCount {
    return [[EGShadowDrawShaderKey alloc] initWithDirectLightCount:directLightCount];
}

- (id)initWithDirectLightCount:(NSUInteger)directLightCount {
    self = [super init];
    if(self) _directLightCount = directLightCount;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowDrawShaderKey_type = [ODClassType classTypeWithCls:[EGShadowDrawShaderKey class]];
}

- (EGStandardShader*)shader {
    NSString* vertexShader = [NSString stringWithFormat:@"#version 150\n"
        "in vec3 position;\n"
        "uniform mat4 mwcp;\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   gl_Position = mwcp * vec4(position, 1);\n"
        "   %@\n"
        "}", [self lightsVertexUniform], [self lightsOut], [self lightsCalculateVaryings]];
    NSString* fragmentShader = [NSString stringWithFormat:@"#version 150\n"
        "%@\n"
        "%@\n"
        "out vec4 outColor;\n"
        "\n"
        "void main(void) {\n"
        "   float visibility;\n"
        "   float a = 0;\n"
        "   %@\n"
        "   outColor = vec4(0, 0, 0, a);\n"
        "}", [self lightsIn], [self lightsFragmentUniform], [self lightsDiffuse]];
    return [EGShadowDrawShader shadowDrawShaderWithKey:self program:[EGShaderProgram applyVertex:vertexShader fragment:fragmentShader]];
}

- (NSString*)lightsVertexUniform {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform mat4 dirLightDepthMwcp%@;", i];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsIn {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"in vec3 dirLightShadowCoord%@;", i];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsOut {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"out vec3 dirLightShadowCoord%@;", i];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"dirLightShadowCoord%@ = (dirLightDepthMwcp%@ * vec4(position, 1)).xyz;", i, i];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsFragmentUniform {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform float dirLightPercent%@;\n"
            "uniform sampler2DShadow dirLightShadow%@;", i, i];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"\n"
            "visibility = texture(dirLightShadow%@, vec3(dirLightShadowCoord%@.xy, dirLightShadowCoord%@.z - 0.005));\n"
            "a += (1 - visibility)*dirLightPercent%@;\n", i, i, i, i];
    }] toStringWithDelimiter:@"\n"];
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
    return self.directLightCount == o.directLightCount;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.directLightCount;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"directLightCount=%li", self.directLightCount];
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
    _EGShadowDrawShader_type = [ODClassType classTypeWithCls:[EGShadowDrawShader class]];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGShadowDrawParam*)param {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_mwcpUniform applyMatrix:[EGGlobal.matrix.value mwcp]];
    EGEnvironment* env = EGGlobal.context.environment;
    __block NSUInteger i = 0;
    [[[env.lights chain] filter:^BOOL(EGLight* _) {
        return [_ isKindOfClass:[EGDirectLight class]] && _.hasShadows;
    }] forEach:^void(EGLight* light) {
        float p = unumf4([param.percents applyIndex:i]);
        [((EGShaderUniformF4*)([_directLightPercents applyIndex:i])) applyF4:p];
        [((EGShaderUniformMat4*)([_directLightDepthMwcp applyIndex:i])) applyMatrix:[[light shadowMap].biasDepthCp mulMatrix:[EGGlobal.matrix mw]]];
        [((EGShaderUniformI4*)([_directLightShadows applyIndex:i])) applyI4:((int)(i + 1))];
        [EGGlobal.context bindTextureSlot:GL_TEXTURE0 + i + 1 target:GL_TEXTURE_2D texture:[light shadowMap].texture];
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


