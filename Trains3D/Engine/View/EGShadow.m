#import "EGShadow.h"

#import "EGTexture.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "EGMesh.h"
@implementation EGShadowMapSurface{
    GLuint _frameBuffer;
    EGTexture* _texture;
}
static ODClassType* _EGShadowMapSurface_type;
@synthesize frameBuffer = _frameBuffer;
@synthesize texture = _texture;

+ (id)shadowMapSurfaceWithSize:(GEVec2i)size {
    return [[EGShadowMapSurface alloc] initWithSize:size];
}

- (id)initWithSize:(GEVec2i)size {
    self = [super initWithSize:size];
    if(self) {
        _frameBuffer = egGenFrameBuffer();
        _texture = ^EGTexture*() {
            EGTexture* t = [EGTexture texture];
            glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
            glBindTexture(GL_TEXTURE_2D, t.id);
            glTexImage2D(GL_TEXTURE_2D, 0, GL_DEPTH_COMPONENT32, self.size.x, self.size.y, 0, GL_DEPTH_COMPONENT, GL_FLOAT, 0);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_FUNC, GL_LEQUAL);
            glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_COMPARE_MODE, GL_COMPARE_R_TO_TEXTURE);
            glFramebufferTexture(GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, t.id, 0);
            NSInteger status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
            if(status != GL_FRAMEBUFFER_COMPLETE) @throw [NSString stringWithFormat:@"Error in shadow map frame buffer: %li", status];
            glBindTexture(GL_TEXTURE_2D, 0);
            glBindFramebuffer(GL_FRAMEBUFFER, 0);
            return t;
        }();
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowMapSurface_type = [ODClassType classTypeWithCls:[EGShadowMapSurface class]];
}

- (void)dealloc {
    egDeleteFrameBuffer(_frameBuffer);
}

- (void)bind {
    glPushAttrib(GL_VIEWPORT_BIT);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glViewport(0, 0, self.size.x, self.size.y);
    glDrawBuffer(GL_NONE);
}

- (void)unbind {
    glBindFramebuffer(GL_FRAMEBUFFER, 0);
    glPopAttrib();
}

- (ODClassType*)type {
    return [EGShadowMapSurface type];
}

+ (ODClassType*)type {
    return _EGShadowMapSurface_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShadowMapSurface* o = ((EGShadowMapSurface*)(other));
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


@implementation EGShadowMap
static ODClassType* _EGShadowMap_type;

+ (id)shadowMap {
    return [[EGShadowMap alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShadowMap_type = [ODClassType classTypeWithCls:[EGShadowMap class]];
}

- (EGSurface*)createSurface {
    return [EGShadowMapSurface shadowMapSurfaceWithSize:[EGGlobal.context viewport].size];
}

- (EGTexture*)texture {
    return ((EGShadowMapSurface*)(((EGSurface*)([[self surface] get])))).texture;
}

- (ODClassType*)type {
    return [EGShadowMap type];
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
    return [param.texture isEmpty] || eqf4(param.alphaTestLevel, 0);
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


