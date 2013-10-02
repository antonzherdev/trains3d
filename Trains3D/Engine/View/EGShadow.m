#import "EGShadow.h"

#import "GEMat4.h"
#import "EGTexture.h"
#import "EGMaterial.h"
#import "EGMesh.h"
#import "EGContext.h"
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
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_R_TO_TEXTURE);
            glFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, t.id, 0);
            glDrawBuffer(GL_NONE);
            NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in shadow map frame buffer: %li", status];
            glBindTexture(GL_TEXTURE_2D, 0);
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
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
    [_texture bind];
    glViewport(0, 0, self.size.x, self.size.y);
}

- (void)unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
}

- (void)draw {
    glDisable(GL_CULL_FACE);
    [[self shader] drawParam:[EGColorSource applyTexture:_texture] mesh:[EGBaseViewportSurface fullScreenMesh]];
    glEnable(GL_CULL_FACE);
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


@implementation EGShadowSurfaceShader{
    EGShaderAttribute* _positionSlot;
}
static NSString* _EGShadowSurfaceShader_fragment = @"#version 150\n"
    "in vec2 UV;\n"
    "\n"
    "uniform sampler2D texture;\n"
    "out vec4 outColor;\n"
    "\n"
    "void main(void) {\n"
    "   vec4 col = texture(texture, UV);\n"
    "   outColor = vec4(col.x, col.x, col.x, 1);\n"
    "}";
static ODClassType* _EGShadowSurfaceShader_type;
@synthesize positionSlot = _positionSlot;

+ (id)shadowSurfaceShader {
    return [[EGShadowSurfaceShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:EGViewportSurfaceShader.vertex fragment:_EGShadowSurfaceShader_fragment]];
    if(self) _positionSlot = [self.program attributeForName:@"position"];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowSurfaceShader_type = [ODClassType classTypeWithCls:[EGShadowSurfaceShader class]];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param {
    [((EGTexture*)([param.texture get])) bind];
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
}

- (void)unloadParam:(EGViewportSurfaceShaderParam*)param {
    [EGTexture unbind];
    [_positionSlot unbind];
}

- (ODClassType*)type {
    return [EGShadowSurfaceShader type];
}

+ (NSString*)fragment {
    return _EGShadowSurfaceShader_fragment;
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
    EGShaderUniform* _mvpUniform;
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
        _mvpUniform = [self uniformForName:@"mwcp"];
        _alphaTestLevelUniform = ((_texture) ? [CNOption applyValue:[self uniformForName:@"alphaTestLevel"]] : [CNOption none]);
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
    [_mvpUniform setMatrix:[EGGlobal.matrix.value mwcp]];
    if(_texture) {
        [((EGShaderAttribute*)([_uvSlot get])) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
        [((EGShaderUniform*)([_alphaTestLevelUniform get])) setF4:param.alphaTestLevel];
        [((EGTexture*)([param.texture get])) bind];
    }
}

- (void)unloadParam:(EGColorSource*)param {
    [EGTexture unbind];
    [_positionSlot unbind];
    [_uvSlot forEach:^void(EGShaderAttribute* _) {
        [_ unbind];
    }];
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


@implementation EGShadowSub{
    EGColorSource* _color;
    id<CNSeq> _percents;
}
static ODClassType* _EGShadowSub_type;
@synthesize color = _color;
@synthesize percents = _percents;

+ (id)shadowSubWithColor:(EGColorSource*)color percents:(id<CNSeq>)percents {
    return [[EGShadowSub alloc] initWithColor:color percents:percents];
}

- (id)initWithColor:(EGColorSource*)color percents:(id<CNSeq>)percents {
    self = [super init];
    if(self) {
        _color = color;
        _percents = percents;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowSub_type = [ODClassType classTypeWithCls:[EGShadowSub class]];
}

- (ODClassType*)type {
    return [EGShadowSub type];
}

+ (ODClassType*)type {
    return _EGShadowSub_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowSub* o = ((EGShadowSub*)(other));
    return [self.color isEqual:o.color] && self.percents == o.percents;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.color hash];
    hash = hash * 31 + 0;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", self.color];
    [description appendFormat:@", percents=[]"];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowSubShaderSystem
static EGStandardShaderSystem* _EGShadowSubShaderSystem_instance;
static NSMutableDictionary* _EGShadowSubShaderSystem_shaders;
static ODClassType* _EGShadowSubShaderSystem_type;

+ (id)shadowSubShaderSystem {
    return [[EGShadowSubShaderSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowSubShaderSystem_type = [ODClassType classTypeWithCls:[EGShadowSubShaderSystem class]];
    _EGShadowSubShaderSystem_instance = [EGStandardShaderSystem standardShaderSystem];
    _EGShadowSubShaderSystem_shaders = [NSMutableDictionary mutableDictionary];
}

- (EGShader*)shaderForParam:(EGColorSource*)param {
    id<CNSeq> lights = EGGlobal.context.environment.lights;
    NSUInteger directLightsCount = [[[lights chain] filter:^BOOL(EGLight* _) {
        return [_ isKindOfClass:[EGDirectLight class]] && _.hasShadows;
    }] count];
    EGShadowSubShaderKey* key = [EGShadowSubShaderKey shadowSubShaderKeyWithDirectLightCount:directLightsCount texture:[param.texture isDefined]];
    return ((EGShadowSubShader*)([_EGShadowSubShaderSystem_shaders objectForKey:key orUpdateWith:^EGShadowSubShader*() {
        return [key shader];
    }]));
}

- (ODClassType*)type {
    return [EGShadowSubShaderSystem type];
}

+ (EGStandardShaderSystem*)instance {
    return _EGShadowSubShaderSystem_instance;
}

+ (ODClassType*)type {
    return _EGShadowSubShaderSystem_type;
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


@implementation EGShadowSubShaderKey{
    NSUInteger _directLightCount;
    BOOL _texture;
}
static ODClassType* _EGShadowSubShaderKey_type;
@synthesize directLightCount = _directLightCount;
@synthesize texture = _texture;

+ (id)shadowSubShaderKeyWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture {
    return [[EGShadowSubShaderKey alloc] initWithDirectLightCount:directLightCount texture:texture];
}

- (id)initWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture {
    self = [super init];
    if(self) {
        _directLightCount = directLightCount;
        _texture = texture;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowSubShaderKey_type = [ODClassType classTypeWithCls:[EGShadowSubShaderKey class]];
}

- (EGStandardShader*)shader {
    NSString* vertexShader = [NSString stringWithFormat:@"#version 150%@\n"
        "in vec3 position;\n"
        "uniform mat4 mwcp;\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   gl_Position = mwcp * vec4(position, 1);%@\n"
        "   %@\n"
        "}", ((_texture) ? @"\n"
        "in vec2 vertexUV; " : @""), [self lightsVertexUniform], ((_texture) ? @"\n"
        "out vec2 UV; " : @""), [self lightsOut], ((_texture) ? @"\n"
        "   UV = vertexUV; " : @""), [self lightsCalculateVaryings]];
    NSString* fragmentShader = [NSString stringWithFormat:@"#version 150\n"
        "%@\n"
        "uniform vec4 color;\n"
        "%@\n"
        "%@\n"
        "out vec4 outColor;\n"
        "\n"
        "void main(void) {%@%@\n"
        "   outColor = col;\n"
        "   %@\n"
        "\n"
        "}", ((_texture) ? @"\n"
        "in vec2 UV;\n"
        "uniform sampler2D texture;\n" : @""), [self lightsIn], [self lightsFragmentUniform], ((!(_texture)) ? @"\n"
        "   vec4 col = color; " : @""), ((_texture) ? @"\n"
        "   vec4 col = color * texture(texture, UV); " : @""), [self lightsDiffuse]];
    return [EGShadowSubShader shadowSubShaderWithKey:self program:[EGShaderProgram applyVertex:vertexShader fragment:fragmentShader]];
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
        return [NSString stringWithFormat:@"dirLightShadowCoord%@= (dirLightDepthMwcp%@* vec4(position, 1)).xyz;", i, i];
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
            "outColor -= (1 - visibility)*dirLightPercent%@*col;\n", i, i, i, i];
    }] toStringWithDelimiter:@"\n"];
}

- (ODClassType*)type {
    return [EGShadowSubShaderKey type];
}

+ (ODClassType*)type {
    return _EGShadowSubShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowSubShaderKey* o = ((EGShadowSubShaderKey*)(other));
    return self.directLightCount == o.directLightCount && self.texture == o.texture;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.directLightCount;
    hash = hash * 31 + self.texture;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"directLightCount=%li", self.directLightCount];
    [description appendFormat:@", texture=%d", self.texture];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShadowSubShader{
    EGShadowSubShaderKey* _key;
    EGShaderAttribute* _positionSlot;
    id _uvSlot;
    id _diffuseTexture;
    EGShaderUniform* _diffuseColorUniform;
    EGShaderUniform* _mwcpUniform;
    id<CNSeq> _directLightPercents;
    id<CNSeq> _directLightDepthMwcp;
    id<CNSeq> _directLightShadows;
}
static ODClassType* _EGShadowSubShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize uvSlot = _uvSlot;
@synthesize diffuseTexture = _diffuseTexture;
@synthesize diffuseColorUniform = _diffuseColorUniform;
@synthesize mwcpUniform = _mwcpUniform;
@synthesize directLightPercents = _directLightPercents;
@synthesize directLightDepthMwcp = _directLightDepthMwcp;
@synthesize directLightShadows = _directLightShadows;

+ (id)shadowSubShaderWithKey:(EGShadowSubShaderKey*)key program:(EGShaderProgram*)program {
    return [[EGShadowSubShader alloc] initWithKey:key program:program];
}

- (id)initWithKey:(EGShadowSubShaderKey*)key program:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    __weak EGShadowSubShader* _weakSelf = self;
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _uvSlot = ((_key.texture) ? [CNOption applyValue:[self attributeForName:@"vertexUV"]] : [CNOption none]);
        _diffuseTexture = ((_key.texture) ? [CNOption applyValue:[self uniformForName:@"texture"]] : [CNOption none]);
        _diffuseColorUniform = [self uniformForName:@"color"];
        _mwcpUniform = [self uniformForName:@"mwcp"];
        _directLightPercents = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniform*(id i) {
            return [_weakSelf uniformForName:[NSString stringWithFormat:@"dirLightPercent%@", i]];
        }] toArray];
        _directLightDepthMwcp = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniform*(id i) {
            return [_weakSelf uniformForName:[NSString stringWithFormat:@"dirLightDepthMwcp%@", i]];
        }] toArray];
        _directLightShadows = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniform*(id i) {
            return [_weakSelf uniformForName:[NSString stringWithFormat:@"dirLightShadow%@", i]];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowSubShader_type = [ODClassType classTypeWithCls:[EGShadowSubShader class]];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGShadowSub*)param {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_mwcpUniform setMatrix:[EGGlobal.matrix.value mwcp]];
    if(_key.texture) {
        [((EGShaderAttribute*)([_uvSlot get])) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
        [((EGTexture*)([param.color.texture get])) bind];
        [((EGShaderUniform*)([_diffuseTexture get])) setI4:0];
    }
    [_diffuseColorUniform setVec4:param.color.color];
    EGEnvironment* env = EGGlobal.context.environment;
    __block NSUInteger i = 0;
    [[[env.lights chain] filter:^BOOL(EGLight* _) {
        return [_ isKindOfClass:[EGDirectLight class]] && _.hasShadows;
    }] forEach:^void(EGLight* light) {
        float p = unumf4([param.percents applyIndex:i]);
        [((EGShaderUniform*)([_directLightPercents applyIndex:i])) setF4:p];
        [((EGShaderUniform*)([_directLightDepthMwcp applyIndex:i])) setMatrix:[[light shadowMap].biasDepthCp mulMatrix:[EGGlobal.matrix mw]]];
        [((EGShaderUniform*)([_directLightShadows applyIndex:i])) setI4:((int)(i + 1))];
        glActiveTexture(GL_TEXTURE0 + i + 1);
        [[light shadowMap].texture bind];
        glActiveTexture(GL_TEXTURE0);
        i++;
    }];
}

- (void)unloadParam:(EGShadowSub*)param {
    if(_key.texture) {
        [EGTexture unbind];
        [((EGShaderAttribute*)([_uvSlot get])) unbind];
    }
    [_positionSlot unbind];
}

- (ODClassType*)type {
    return [EGShadowSubShader type];
}

+ (ODClassType*)type {
    return _EGShadowSubShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowSubShader* o = ((EGShadowSubShader*)(other));
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


