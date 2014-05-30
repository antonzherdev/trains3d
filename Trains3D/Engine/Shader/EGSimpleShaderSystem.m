#import "EGSimpleShaderSystem.h"

#import "EGContext.h"
#import "EGShadow.h"
#import "EGTexture.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGMatrixModel.h"
@implementation EGSimpleShaderSystem
static EGSimpleShaderSystem* _EGSimpleShaderSystem_instance;
static CNMHashMap* _EGSimpleShaderSystem_shaders;
static CNClassType* _EGSimpleShaderSystem_type;

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
        _EGSimpleShaderSystem_type = [CNClassType classTypeWithCls:[EGSimpleShaderSystem class]];
        _EGSimpleShaderSystem_instance = [EGSimpleShaderSystem simpleShaderSystem];
        _EGSimpleShaderSystem_shaders = [CNMHashMap hashMap];
    }
}

+ (EGShader*)colorShader {
    return [_EGSimpleShaderSystem_instance shaderForParam:[EGColorSource applyColor:GEVec4Make(0.0, 0.0, 0.0, 1.0)] renderTarget:EGGlobal.context.renderTarget];
}

- (EGShader*)shaderForParam:(EGColorSource*)param renderTarget:(EGRenderTarget*)renderTarget {
    if([renderTarget isKindOfClass:[EGShadowRenderTarget class]]) {
        return [EGShadowShaderSystem.instance shaderForParam:param];
    } else {
        BOOL t = ((EGColorSource*)(param)).texture != nil;
        EGSimpleShaderKey* key = [EGSimpleShaderKey simpleShaderKeyWithTexture:t region:t && ({
            EGTexture* __tmpf_1p1b = ((EGColorSource*)(param)).texture;
            ((__tmpf_1p1b != nil) ? [((EGTexture*)(((EGColorSource*)(param)).texture)) isKindOfClass:[EGTextureRegion class]] : NO);
        }) blendMode:((EGColorSource*)(param)).blendMode];
        return ((EGShader*)([_EGSimpleShaderSystem_shaders applyKey:key orUpdateWith:^EGSimpleShader*() {
            return [EGSimpleShader simpleShaderWithKey:key];
        }]));
    }
}

- (NSString*)description {
    return @"SimpleShaderSystem";
}

- (CNClassType*)type {
    return [EGSimpleShaderSystem type];
}

+ (EGSimpleShaderSystem*)instance {
    return _EGSimpleShaderSystem_instance;
}

+ (CNClassType*)type {
    return _EGSimpleShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSimpleShaderKey
static CNClassType* _EGSimpleShaderKey_type;
@synthesize texture = _texture;
@synthesize region = _region;
@synthesize blendMode = _blendMode;
@synthesize fragment = _fragment;

+ (instancetype)simpleShaderKeyWithTexture:(BOOL)texture region:(BOOL)region blendMode:(EGBlendModeR)blendMode {
    return [[EGSimpleShaderKey alloc] initWithTexture:texture region:region blendMode:blendMode];
}

- (instancetype)initWithTexture:(BOOL)texture region:(BOOL)region blendMode:(EGBlendModeR)blendMode {
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
            "}", [self fragmentHeader], ((texture) ? [NSString stringWithFormat:@"%@ mediump vec2 UV;\n"
            "uniform lowp sampler2D txt;", [self in]] : @""), [self fragColor], [self blendMode:blendMode a:@"color" b:[NSString stringWithFormat:@"%@(txt, UV)", [self texture2D]]]];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSimpleShaderKey class]) _EGSimpleShaderKey_type = [CNClassType classTypeWithCls:[EGSimpleShaderKey class]];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"SimpleShaderKey(%d, %d, %@)", _texture, _region, [EGBlendMode value:_blendMode]];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGSimpleShaderKey class]])) return NO;
    EGSimpleShaderKey* o = ((EGSimpleShaderKey*)(to));
    return _texture == o.texture && _region == o.region && _blendMode == o.blendMode;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _texture;
    hash = hash * 31 + _region;
    hash = hash * 31 + [[EGBlendMode value:_blendMode] hash];
    return hash;
}

- (CNClassType*)type {
    return [EGSimpleShaderKey type];
}

+ (CNClassType*)type {
    return _EGSimpleShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSimpleShader
static CNClassType* _EGSimpleShader_type;
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
        _uvSlot = ((key.texture) ? [self attributeForName:@"vertexUV"] : nil);
        _positionSlot = [self attributeForName:@"position"];
        _mvpUniform = [self uniformMat4Name:@"mvp"];
        _colorUniform = [self uniformVec4OptName:@"color"];
        _uvScale = ((key.region) ? [self uniformVec2Name:@"uvScale"] : nil);
        _uvShift = ((key.region) ? [self uniformVec2Name:@"uvShift"] : nil);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSimpleShader class]) _EGSimpleShader_type = [CNClassType classTypeWithCls:[EGSimpleShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    if(_key.texture) [((EGShaderAttribute*)(_uvSlot)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    [_mvpUniform applyMatrix:[[EGGlobal.matrix value] mwcp]];
    [((EGShaderUniformVec4*)(_colorUniform)) applyVec4:((EGColorSource*)(param)).color];
    if(_key.texture) {
        EGTexture* tex = ((EGColorSource*)(param)).texture;
        if(tex != nil) {
            [EGGlobal.context bindTextureTexture:tex];
            if(_key.region) {
                GERect r = ((EGTextureRegion*)(tex)).uv;
                [((EGShaderUniformVec2*)(_uvShift)) applyVec2:r.p];
                [((EGShaderUniformVec2*)(_uvScale)) applyVec2:r.size];
            }
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SimpleShader(%@)", _key];
}

- (CNClassType*)type {
    return [EGSimpleShader type];
}

+ (CNClassType*)type {
    return _EGSimpleShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

