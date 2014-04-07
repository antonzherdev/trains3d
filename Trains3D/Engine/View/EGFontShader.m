#import "EGFontShader.h"

#import "EGTexture.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
@implementation EGFontShaderParam
static ODClassType* _EGFontShaderParam_type;
@synthesize texture = _texture;
@synthesize color = _color;
@synthesize shift = _shift;

+ (instancetype)fontShaderParamWithTexture:(EGTexture*)texture color:(GEVec4)color shift:(GEVec2)shift {
    return [[EGFontShaderParam alloc] initWithTexture:texture color:color shift:shift];
}

- (instancetype)initWithTexture:(EGTexture*)texture color:(GEVec4)color shift:(GEVec2)shift {
    self = [super init];
    if(self) {
        _texture = texture;
        _color = color;
        _shift = shift;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFontShaderParam class]) _EGFontShaderParam_type = [ODClassType classTypeWithCls:[EGFontShaderParam class]];
}

- (ODClassType*)type {
    return [EGFontShaderParam type];
}

+ (ODClassType*)type {
    return _EGFontShaderParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFontShaderParam* o = ((EGFontShaderParam*)(other));
    return [self.texture isEqual:o.texture] && GEVec4Eq(self.color, o.color) && GEVec2Eq(self.shift, o.shift);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.texture hash];
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + GEVec2Hash(self.shift);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%@", self.texture];
    [description appendFormat:@", color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", shift=%@", GEVec2Description(self.shift)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFontShaderBuilder
static ODClassType* _EGFontShaderBuilder_type;

+ (instancetype)fontShaderBuilder {
    return [[EGFontShaderBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFontShaderBuilder class]) _EGFontShaderBuilder_type = [ODClassType classTypeWithCls:[EGFontShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "uniform highp vec2 shift;\n"
        "%@ highp vec2 position;\n"
        "%@ mediump vec2 vertexUV;\n"
        "\n"
        "%@ mediump vec2 UV;\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = vec4(position.x + shift.x, position.y + shift.y, 0, 1);\n"
        "    UV = vertexUV;\n"
        "}", [self vertexHeader], [self ain], [self ain], [self out]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D txt;\n"
        "uniform lowp vec4 color;\n"
        "\n"
        "void main(void) {\n"
        "    %@ = color * %@(txt, UV);\n"
        "}", [self fragmentHeader], [self in], [self fragColor], [self texture2D]];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Font" vertex:[self vertex] fragment:[self fragment]];
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
    return [EGFontShaderBuilder type];
}

+ (ODClassType*)type {
    return _EGFontShaderBuilder_type;
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


@implementation EGFontShader
static EGFontShader* _EGFontShader_instance;
static ODClassType* _EGFontShader_type;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;
@synthesize shiftSlot = _shiftSlot;

+ (instancetype)fontShader {
    return [[EGFontShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[EGFontShaderBuilder fontShaderBuilder] program]];
    if(self) {
        _uvSlot = [self attributeForName:@"vertexUV"];
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformVec4Name:@"color"];
        _shiftSlot = [self uniformVec2Name:@"shift"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFontShader class]) {
        _EGFontShader_type = [ODClassType classTypeWithCls:[EGFontShader class]];
        _EGFontShader_instance = [EGFontShader fontShader];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGFontShaderParam*)param {
    [EGGlobal.context bindTextureTexture:((EGFontShaderParam*)(param)).texture];
    [_colorUniform applyVec4:((EGFontShaderParam*)(param)).color];
    [_shiftSlot applyVec2:geVec4Xy(([[EGGlobal.matrix p] mulVec4:geVec4ApplyVec2ZW(((EGFontShaderParam*)(param)).shift, 0.0, 0.0)]))];
}

- (ODClassType*)type {
    return [EGFontShader type];
}

+ (EGFontShader*)instance {
    return _EGFontShader_instance;
}

+ (ODClassType*)type {
    return _EGFontShader_type;
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


