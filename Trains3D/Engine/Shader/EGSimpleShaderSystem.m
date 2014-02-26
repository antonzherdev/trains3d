#import "EGSimpleShaderSystem.h"

#import "EGMaterial.h"
#import "EGContext.h"
#import "EGShadow.h"
#import "EGTexture.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGMatrixModel.h"
@implementation EGSimpleShaderSystem
static EGSimpleShaderSystem* _EGSimpleShaderSystem_instance;
static NSMutableDictionary* _EGSimpleShaderSystem_shaders;
static ODClassType* _EGSimpleShaderSystem_type;

+ (instancetype)simpleShaderSystem {
    return [[EGSimpleShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSimpleShaderSystem class]) {
        _EGSimpleShaderSystem_type = [ODClassType classTypeWithCls:[EGSimpleShaderSystem class]];
        _EGSimpleShaderSystem_instance = [EGSimpleShaderSystem simpleShaderSystem];
        _EGSimpleShaderSystem_shaders = [NSMutableDictionary mutableDictionary];
    }
}

+ (EGShader*)colorShader {
    return [_EGSimpleShaderSystem_instance shaderForParam:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 1.0)] renderTarget:EGGlobal.context.renderTarget];
}

- (EGShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget {
    if([renderTarget isKindOfClass:[EGShadowRenderTarget class]]) {
        return [EGShadowShaderSystem.instance shaderForParam:param];
    } else {
        BOOL t = [param.texture isDefined];
        EGSimpleShaderKey* key = [EGSimpleShaderKey simpleShaderKeyWithTexture:t region:t && [((EGTexture*)([param.texture get])) isKindOfClass:[EGTextureRegion class]] blendMode:param.blendMode];
        return [_EGSimpleShaderSystem_shaders objectForKey:key orUpdateWith:^EGSimpleShader*() {
            return [EGSimpleShader simpleShaderWithKey:key];
        }];
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


@implementation EGSimpleShaderKey{
    BOOL _texture;
    BOOL _region;
    EGBlendMode* _blendMode;
    NSString* _fragment;
}
static ODClassType* _EGSimpleShaderKey_type;
@synthesize texture = _texture;
@synthesize region = _region;
@synthesize blendMode = _blendMode;
@synthesize fragment = _fragment;

+ (instancetype)simpleShaderKeyWithTexture:(BOOL)texture region:(BOOL)region blendMode:(EGBlendMode*)blendMode {
    return [[EGSimpleShaderKey alloc] initWithTexture:texture region:region blendMode:blendMode];
}

- (instancetype)initWithTexture:(BOOL)texture region:(BOOL)region blendMode:(EGBlendMode*)blendMode {
    self = [super init];
    if(self) {
        _texture = texture;
        _region = region;
        _blendMode = blendMode;
        _fragment = [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "uniform lowp vec4 color;\n"
            "\n"
            "void main(void) {\n"
            "   %@ = %@;\n"
            "}", [self fragmentHeader], ((_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 UV;\n"
            "uniform lowp sampler2D txt;", [self in]] : @""), [self fragColor], [self blendMode:_blendMode a:@"color" b:[NSString stringWithFormat:@"%@(txt, UV)", [self texture2D]]]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSimpleShaderKey class]) _EGSimpleShaderKey_type = [ODClassType classTypeWithCls:[EGSimpleShaderKey class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ highp vec3 position;\n"
        "uniform mat4 mvp;\n"
        "\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "    gl_Position = mvp * vec4(position, 1);\n"
        "%@\n"
        "}", [self vertexHeader], [self ain], ((_texture) ? [NSString stringWithFormat:@"%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;", [self ain], [self out]] : @""), ((_region) ? @"uniform mediump vec2 uvShift;\n"
        "uniform mediump vec2 uvScale;" : @""), ((_texture && _region) ? @"    UV = uvScale*vertexUV + uvShift;" : [NSString stringWithFormat:@"%@", ((_texture) ? @"\n"
        "    UV = vertexUV; " : @"")])];
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
    return [EGSimpleShaderKey type];
}

+ (ODClassType*)type {
    return _EGSimpleShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSimpleShaderKey* o = ((EGSimpleShaderKey*)(other));
    return self.texture == o.texture && self.region == o.region && self.blendMode == o.blendMode;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.texture;
    hash = hash * 31 + self.region;
    hash = hash * 31 + [self.blendMode ordinal];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"texture=%d", self.texture];
    [description appendFormat:@", region=%d", self.region];
    [description appendFormat:@", blendMode=%@", self.blendMode];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSimpleShader{
    EGSimpleShaderKey* _key;
    id _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniformMat4* _mvpUniform;
    id _colorUniform;
    id _uvScale;
    id _uvShift;
}
static ODClassType* _EGSimpleShader_type;
@synthesize key = _key;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize mvpUniform = _mvpUniform;
@synthesize colorUniform = _colorUniform;
@synthesize uvScale = _uvScale;
@synthesize uvShift = _uvShift;

+ (instancetype)simpleShaderWithKey:(EGSimpleShaderKey*)key {
    return [[EGSimpleShader alloc] initWithKey:key];
}

- (instancetype)initWithKey:(EGSimpleShaderKey*)key {
    self = [super initWithProgram:[key program]];
    if(self) {
        _key = key;
        _uvSlot = ((_key.texture) ? [CNOption applyValue:[self attributeForName:@"vertexUV"]] : [CNOption none]);
        _positionSlot = [self attributeForName:@"position"];
        _mvpUniform = [self uniformMat4Name:@"mvp"];
        _colorUniform = [self uniformVec4OptName:@"color"];
        _uvScale = ((_key.region) ? [CNOption applyValue:[self uniformVec2Name:@"uvScale"]] : [CNOption none]);
        _uvShift = ((_key.region) ? [CNOption applyValue:[self uniformVec2Name:@"uvShift"]] : [CNOption none]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSimpleShader class]) _EGSimpleShader_type = [ODClassType classTypeWithCls:[EGSimpleShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    if(_key.texture) [((EGShaderAttribute*)([_uvSlot get])) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    [_mvpUniform applyMatrix:[[EGGlobal.matrix value] mwcp]];
    if([_colorUniform isDefined]) [((EGShaderUniformVec4*)([_colorUniform get])) applyVec4:param.color];
    if(_key.texture) {
        EGTexture* tex = [param.texture get];
        [EGGlobal.context bindTextureTexture:tex];
        if(_key.region) {
            GERect r = ((EGTextureRegion*)(tex)).uv;
            [((EGShaderUniformVec2*)([_uvShift get])) applyVec2:r.p];
            [((EGShaderUniformVec2*)([_uvScale get])) applyVec2:r.size];
        }
    }
}

- (ODClassType*)type {
    return [EGSimpleShader type];
}

+ (ODClassType*)type {
    return _EGSimpleShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSimpleShader* o = ((EGSimpleShader*)(other));
    return [self.key isEqual:o.key];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.key hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"key=%@", self.key];
    [description appendString:@">"];
    return description;
}

@end


