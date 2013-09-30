#import "EGSimpleShaderSystem.h"

#import "EGContext.h"
#import "EGShadow.h"
#import "EGMaterial.h"
#import "EGMesh.h"
#import "GL.h"
#import "EGTexture.h"
@implementation EGSimpleShaderSystem
static EGSimpleShaderSystem* _EGSimpleShaderSystem_instance;
static EGSimpleColorShader* _EGSimpleShaderSystem_colorShader;
static EGSimpleTextureShader* _EGSimpleShaderSystem_textureShader;
static ODClassType* _EGSimpleShaderSystem_type;

+ (id)simpleShaderSystem {
    return [[EGSimpleShaderSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleShaderSystem_type = [ODClassType classTypeWithCls:[EGSimpleShaderSystem class]];
    _EGSimpleShaderSystem_instance = [EGSimpleShaderSystem simpleShaderSystem];
    _EGSimpleShaderSystem_colorShader = [EGSimpleColorShader simpleColorShader];
    _EGSimpleShaderSystem_textureShader = [EGSimpleTextureShader simpleTextureShader];
}

- (EGShader*)shaderForParam:(EGColorSource*)param {
    if(EGGlobal.context.isShadowsDrawing) {
        return [EGShadowShaderSystem shaderForParam:param];
    } else {
        if([param.texture isEmpty]) return _EGSimpleShaderSystem_colorShader;
        else return _EGSimpleShaderSystem_textureShader;
    }
}

- (ODClassType*)type {
    return [EGSimpleShaderSystem type];
}

+ (EGSimpleShaderSystem*)instance {
    return _EGSimpleShaderSystem_instance;
}

+ (ODClassType*)type {
    return _EGSimpleShaderSystem_type;
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


@implementation EGSimpleColorShader{
    EGShaderAttribute* _positionSlot;
    EGShaderUniform* _colorUniform;
    EGShaderUniform* _mvpUniform;
}
static NSString* _EGSimpleColorShader_colorVertexProgram = @"#version 150\n"
    "in vec3 position;\n"
    "uniform mat4 mvp;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = mvp * vec4(position, 1);\n"
    "}";
static NSString* _EGSimpleColorShader_colorFragmentProgram = @"#version 150\n"
    "uniform vec4 color;\n"
    "out vec4 outColor;\n"
    "void main(void) {\n"
    "    outColor = color;\n"
    "}";
static ODClassType* _EGSimpleColorShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;
@synthesize mvpUniform = _mvpUniform;

+ (id)simpleColorShader {
    return [[EGSimpleColorShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:EGSimpleColorShader.colorVertexProgram fragment:EGSimpleColorShader.colorFragmentProgram]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformForName:@"color"];
        _mvpUniform = [self uniformForName:@"mvp"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleColorShader_type = [ODClassType classTypeWithCls:[EGSimpleColorShader class]];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_mvpUniform setMatrix:[EGGlobal.matrix.value mwcp]];
    [_colorUniform setVec4:param.color];
}

- (void)unloadParam:(EGColorSource*)param {
    [_positionSlot unbind];
}

- (ODClassType*)type {
    return [EGSimpleColorShader type];
}

+ (NSString*)colorVertexProgram {
    return _EGSimpleColorShader_colorVertexProgram;
}

+ (NSString*)colorFragmentProgram {
    return _EGSimpleColorShader_colorFragmentProgram;
}

+ (ODClassType*)type {
    return _EGSimpleColorShader_type;
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


@implementation EGSimpleTextureShader{
    EGShaderAttribute* _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniform* _mvpUniform;
    EGShaderUniform* _colorUniform;
}
static NSString* _EGSimpleTextureShader_textureVertexProgram = @"#version 150\n"
    "in vec2 vertexUV;\n"
    "in vec3 position;\n"
    "uniform mat4 mvp;\n"
    "\n"
    "out vec2 UV;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = mvp * vec4(position, 1);\n"
    "   UV = vertexUV;\n"
    "}";
static NSString* _EGSimpleTextureShader_textureFragmentProgram = @"#version 150\n"
    "in vec2 UV;\n"
    "uniform sampler2D texture;\n"
    "uniform vec4 color;\n"
    "out vec4 outColor;\n"
    "\n"
    "void main(void) {\n"
    "    outColor = color * texture(texture, UV);\n"
    "}";
static ODClassType* _EGSimpleTextureShader_type;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize mvpUniform = _mvpUniform;
@synthesize colorUniform = _colorUniform;

+ (id)simpleTextureShader {
    return [[EGSimpleTextureShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:EGSimpleTextureShader.textureVertexProgram fragment:EGSimpleTextureShader.textureFragmentProgram]];
    if(self) {
        _uvSlot = [self attributeForName:@"vertexUV"];
        _positionSlot = [self attributeForName:@"position"];
        _mvpUniform = [self uniformForName:@"mvp"];
        _colorUniform = [self uniformForName:@"color"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleTextureShader_type = [ODClassType classTypeWithCls:[EGSimpleTextureShader class]];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGColorSource*)param {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_mvpUniform setMatrix:[EGGlobal.matrix.value mwcp]];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
    [_colorUniform setVec4:param.color];
    [((EGTexture*)([param.texture get])) bind];
}

- (void)unloadParam:(EGColorSource*)param {
    [EGTexture unbind];
    [_positionSlot unbind];
    [_uvSlot unbind];
}

- (ODClassType*)type {
    return [EGSimpleTextureShader type];
}

+ (NSString*)textureVertexProgram {
    return _EGSimpleTextureShader_textureVertexProgram;
}

+ (NSString*)textureFragmentProgram {
    return _EGSimpleTextureShader_textureFragmentProgram;
}

+ (ODClassType*)type {
    return _EGSimpleTextureShader_type;
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


