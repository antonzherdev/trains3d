#import "EGSimpleShaderSystem.h"

#import "EGContext.h"
#import "EGShadow.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "GL.h"
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

- (EGShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget {
    if([renderTarget isKindOfClass:[EGShadowRenderTarget class]]) {
        return [EGShadowShaderSystem.instance shaderForParam:param];
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

+ (EGSimpleColorShader*)colorShader {
    return _EGSimpleShaderSystem_colorShader;
}

+ (EGSimpleTextureShader*)textureShader {
    return _EGSimpleShaderSystem_textureShader;
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


@implementation EGSimpleShaderBuilder{
    BOOL _texture;
    NSString* _fragment;
}
static ODClassType* _EGSimpleShaderBuilder_type;
@synthesize texture = _texture;
@synthesize fragment = _fragment;

+ (id)simpleShaderBuilderWithTexture:(BOOL)texture {
    return [[EGSimpleShaderBuilder alloc] initWithTexture:texture];
}

- (id)initWithTexture:(BOOL)texture {
    self = [super init];
    if(self) {
        _texture = texture;
        _fragment = [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "uniform lowp vec4 color;\n"
            "\n"
            "void main(void) {\n"
            "   %@\n"
            "}", [self fragmentHeader], ((_texture) ? [NSString stringWithFormat:@"\n"
            "%@ mediump vec2 UV;\n"
            "uniform lowp sampler2D txt;\n", [self in]] : @""), ((_texture) ? [NSString stringWithFormat:@"\n"
            "    %@ = color * %@(txt, UV);\n"
            "   ", [self fragColor], [self texture2D]] : [NSString stringWithFormat:@"\n"
            "    %@ = color;\n"
            "   ", [self fragColor]])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleShaderBuilder_type = [ODClassType classTypeWithCls:[EGSimpleShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ highp vec3 position;\n"
        "uniform mat4 mvp;\n"
        "\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = mvp * vec4(position, 1);%@\n"
        "}", [self vertexHeader], [self ain], ((_texture) ? [NSString stringWithFormat:@"\n"
        "%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;\n", [self ain], [self out]] : @""), ((_texture) ? @"\n"
        "    UV = vertexUV; " : @"")];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Simple" vertex:[self vertex] fragment:_fragment];
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
    if([self version] == 100) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)shadow2D {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
}

- (NSString*)blendMode:(EGBlendMode*)mode a:(NSString*)a b:(NSString*)b {
    return mode.blend(a, b);
}

- (ODClassType*)type {
    return [EGSimpleShaderBuilder type];
}

+ (ODClassType*)type {
    return _EGSimpleShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSimpleShaderBuilder* o = ((EGSimpleShaderBuilder*)(other));
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


@implementation EGSimpleColorShader{
    EGShaderAttribute* _positionSlot;
    EGShaderUniformVec4* _colorUniform;
    EGShaderUniformMat4* _mvpUniform;
}
static ODClassType* _EGSimpleColorShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;
@synthesize mvpUniform = _mvpUniform;

+ (id)simpleColorShader {
    return [[EGSimpleColorShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[[EGSimpleShaderBuilder simpleShaderBuilderWithTexture:NO] program]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformVec4Name:@"color"];
        _mvpUniform = [self uniformMat4Name:@"mvp"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleColorShader_type = [ODClassType classTypeWithCls:[EGSimpleColorShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    [_mvpUniform applyMatrix:[EGGlobal.matrix.value mwcp]];
    [_colorUniform applyVec4:param.color];
}

- (ODClassType*)type {
    return [EGSimpleColorShader type];
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
    EGShaderUniformMat4* _mvpUniform;
    EGShaderUniformVec4* _colorUniform;
}
static ODClassType* _EGSimpleTextureShader_type;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize mvpUniform = _mvpUniform;
@synthesize colorUniform = _colorUniform;

+ (id)simpleTextureShader {
    return [[EGSimpleTextureShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[[EGSimpleShaderBuilder simpleShaderBuilderWithTexture:YES] program]];
    if(self) {
        _uvSlot = [self attributeForName:@"vertexUV"];
        _positionSlot = [self attributeForName:@"position"];
        _mvpUniform = [self uniformMat4Name:@"mvp"];
        _colorUniform = [self uniformVec4Name:@"color"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleTextureShader_type = [ODClassType classTypeWithCls:[EGSimpleTextureShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    [_mvpUniform applyMatrix:[EGGlobal.matrix.value mwcp]];
    [_colorUniform applyVec4:param.color];
    [EGGlobal.context bindTextureTexture:[param.texture get]];
}

- (ODClassType*)type {
    return [EGSimpleTextureShader type];
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


