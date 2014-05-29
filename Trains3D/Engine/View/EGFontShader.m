#import "EGFontShader.h"

#import "EGTexture.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGContext.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
@implementation EGFontShaderParam
static CNClassType* _EGFontShaderParam_type;
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
    if(self == [EGFontShaderParam class]) _EGFontShaderParam_type = [CNClassType classTypeWithCls:[EGFontShaderParam class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"FontShaderParam(%@, %@, %@)", _texture, geVec4Description(_color), geVec2Description(_shift)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGFontShaderParam class]])) return NO;
    EGFontShaderParam* o = ((EGFontShaderParam*)(to));
    return [_texture isEqual:o.texture] && geVec4IsEqualTo(_color, o.color) && geVec2IsEqualTo(_shift, o.shift);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_texture hash];
    hash = hash * 31 + geVec4Hash(_color);
    hash = hash * 31 + geVec2Hash(_shift);
    return hash;
}

- (CNClassType*)type {
    return [EGFontShaderParam type];
}

+ (CNClassType*)type {
    return _EGFontShaderParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGFontShaderBuilder
static CNClassType* _EGFontShaderBuilder_type;

+ (instancetype)fontShaderBuilder {
    return [[EGFontShaderBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFontShaderBuilder class]) _EGFontShaderBuilder_type = [CNClassType classTypeWithCls:[EGFontShaderBuilder class]];
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

- (NSString*)description {
    return @"FontShaderBuilder";
}

- (CNClassType*)type {
    return [EGFontShaderBuilder type];
}

+ (CNClassType*)type {
    return _EGFontShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGFontShader
static EGFontShader* _EGFontShader_instance;
static CNClassType* _EGFontShader_type;
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
        _EGFontShader_type = [CNClassType classTypeWithCls:[EGFontShader class]];
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

- (NSString*)description {
    return @"FontShader";
}

- (CNClassType*)type {
    return [EGFontShader type];
}

+ (EGFontShader*)instance {
    return _EGFontShader_instance;
}

+ (CNClassType*)type {
    return _EGFontShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

