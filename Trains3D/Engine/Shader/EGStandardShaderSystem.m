#import "EGStandardShaderSystem.h"

#import "CNObserver.h"
#import "EGContext.h"
#import "EGShadow.h"
#import "CNChain.h"
#import "EGTexture.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
@implementation EGStandardShaderSystem
static EGStandardShaderSystem* _EGStandardShaderSystem_instance;
static CNMHashMap* _EGStandardShaderSystem_shaders;
static CNObserver* _EGStandardShaderSystem_settingsChangeObs;
static CNClassType* _EGStandardShaderSystem_type;

+ (instancetype)standardShaderSystem {
    return [[EGStandardShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGStandardShaderSystem class]) {
        _EGStandardShaderSystem_type = [CNClassType classTypeWithCls:[EGStandardShaderSystem class]];
        _EGStandardShaderSystem_instance = [EGStandardShaderSystem standardShaderSystem];
        _EGStandardShaderSystem_shaders = [CNMHashMap hashMap];
        _EGStandardShaderSystem_settingsChangeObs = [EGGlobal.settings.shadowTypeChanged observeF:^void(EGShadowType* _) {
            [_EGStandardShaderSystem_shaders clear];
        }];
    }
}

- (EGShader*)shaderForParam:(EGStandardMaterial*)param renderTarget:(EGRenderTarget*)renderTarget {
    if([renderTarget isKindOfClass:[EGShadowRenderTarget class]]) {
        if([EGShadowShaderSystem isColorShaderForParam:((EGStandardMaterial*)(param)).diffuse]) return ((EGShader*)(EGStandardShadowShader.instanceForColor));
        else return ((EGShader*)(EGStandardShadowShader.instanceForTexture));
    } else {
        NSArray* lights = EGGlobal.context.environment.lights;
        NSUInteger directLightsWithShadowsCount = [[[lights chain] filterWhen:^BOOL(EGLight* _) {
            return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]] && ((EGLight*)(_)).hasShadows;
        }] count];
        NSUInteger directLightsWithoutShadowsCount = [[[lights chain] filterWhen:^BOOL(EGLight* _) {
            return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]] && !(((EGLight*)(_)).hasShadows);
        }] count];
        EGTexture* texture = ((EGStandardMaterial*)(param)).diffuse.texture;
        BOOL t = texture != nil;
        BOOL region = t && ((texture != nil) ? [((EGTexture*)(nonnil(texture))) isKindOfClass:[EGTextureRegion class]] : NO);
        BOOL spec = ((EGStandardMaterial*)(param)).specularSize > 0;
        BOOL normalMap = ((EGStandardMaterial*)(param)).normalMap != nil;
        EGStandardShaderKey* key = ((egPlatform().shadows && EGGlobal.context.considerShadows) ? [EGStandardShaderKey standardShaderKeyWithDirectLightWithShadowsCount:directLightsWithShadowsCount directLightWithoutShadowsCount:directLightsWithoutShadowsCount texture:t blendMode:((EGStandardMaterial*)(param)).diffuse.blendMode region:region specular:spec normalMap:normalMap] : [EGStandardShaderKey standardShaderKeyWithDirectLightWithShadowsCount:0 directLightWithoutShadowsCount:directLightsWithShadowsCount + directLightsWithoutShadowsCount texture:t blendMode:((EGStandardMaterial*)(param)).diffuse.blendMode region:region specular:spec normalMap:normalMap]);
        return ((EGShader*)([_EGStandardShaderSystem_shaders applyKey:key orUpdateWith:^EGStandardShader*() {
            return [key shader];
        }]));
    }
}

- (NSString*)description {
    return @"StandardShaderSystem";
}

- (CNClassType*)type {
    return [EGStandardShaderSystem type];
}

+ (EGStandardShaderSystem*)instance {
    return _EGStandardShaderSystem_instance;
}

+ (CNObserver*)settingsChangeObs {
    return _EGStandardShaderSystem_settingsChangeObs;
}

+ (CNClassType*)type {
    return _EGStandardShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGStandardShadowShader
static EGStandardShadowShader* _EGStandardShadowShader_instanceForColor;
static EGStandardShadowShader* _EGStandardShadowShader_instanceForTexture;
static CNClassType* _EGStandardShadowShader_type;
@synthesize shadowShader = _shadowShader;

+ (instancetype)standardShadowShaderWithShadowShader:(EGShadowShader*)shadowShader {
    return [[EGStandardShadowShader alloc] initWithShadowShader:shadowShader];
}

- (instancetype)initWithShadowShader:(EGShadowShader*)shadowShader {
    self = [super initWithProgram:shadowShader.program];
    if(self) _shadowShader = shadowShader;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGStandardShadowShader class]) {
        _EGStandardShadowShader_type = [CNClassType classTypeWithCls:[EGStandardShadowShader class]];
        _EGStandardShadowShader_instanceForColor = [EGStandardShadowShader standardShadowShaderWithShadowShader:EGShadowShader.instanceForColor];
        _EGStandardShadowShader_instanceForTexture = [EGStandardShadowShader standardShadowShaderWithShadowShader:EGShadowShader.instanceForTexture];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_shadowShader loadAttributesVbDesc:vbDesc];
}

- (void)loadUniformsParam:(EGStandardMaterial*)param {
    [_shadowShader loadUniformsParam:((EGStandardMaterial*)(param)).diffuse];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"StandardShadowShader(%@)", _shadowShader];
}

- (CNClassType*)type {
    return [EGStandardShadowShader type];
}

+ (EGStandardShadowShader*)instanceForColor {
    return _EGStandardShadowShader_instanceForColor;
}

+ (EGStandardShadowShader*)instanceForTexture {
    return _EGStandardShadowShader_instanceForTexture;
}

+ (CNClassType*)type {
    return _EGStandardShadowShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGStandardShaderKey
static CNClassType* _EGStandardShaderKey_type;
@synthesize directLightWithShadowsCount = _directLightWithShadowsCount;
@synthesize directLightWithoutShadowsCount = _directLightWithoutShadowsCount;
@synthesize texture = _texture;
@synthesize blendMode = _blendMode;
@synthesize region = _region;
@synthesize specular = _specular;
@synthesize normalMap = _normalMap;
@synthesize perPixel = _perPixel;
@synthesize needUV = _needUV;
@synthesize directLightCount = _directLightCount;

+ (instancetype)standardShaderKeyWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(EGBlendModeR)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap {
    return [[EGStandardShaderKey alloc] initWithDirectLightWithShadowsCount:directLightWithShadowsCount directLightWithoutShadowsCount:directLightWithoutShadowsCount texture:texture blendMode:blendMode region:region specular:specular normalMap:normalMap];
}

- (instancetype)initWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(EGBlendModeR)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap {
    self = [super init];
    if(self) {
        _directLightWithShadowsCount = directLightWithShadowsCount;
        _directLightWithoutShadowsCount = directLightWithoutShadowsCount;
        _texture = texture;
        _blendMode = blendMode;
        _region = region;
        _specular = specular;
        _normalMap = normalMap;
        _perPixel = normalMap;
        _needUV = normalMap || texture;
        _directLightCount = directLightWithShadowsCount + directLightWithoutShadowsCount;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGStandardShaderKey class]) _EGStandardShaderKey_type = [CNClassType classTypeWithCls:[EGStandardShaderKey class]];
}

- (EGStandardShader*)shader {
    NSString* vertexShader = [NSString stringWithFormat:@"%@\n"
        "%@\n"
        "\n"
        "%@ highp vec3 position;\n"
        "uniform highp mat4 mwcp;\n"
        "uniform highp mat4 mwc;\n"
        "%@\n"
        "%@\n"
        "\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "%@ eyeDirection = normalize(-(mwc * vec4(position, 1)).xyz);\n"
        "%@\n"
        "   gl_Position = mwcp * vec4(position, 1);\n"
        "%@\n"
        "   %@\n"
        "}", [self vertexHeader], ((!(_normalMap)) ? [NSString stringWithFormat:@"%@ mediump vec3 normal;", [self ain]] : @""), [self ain], ((_region) ? @"uniform mediump vec2 uvShift;\n"
        "uniform mediump vec2 uvScale;" : @""), [self lightsVertexUniform], ((_needUV || _normalMap) ? [NSString stringWithFormat:@"%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;", [self ain], [self out]] : @""), ((_perPixel) ? [NSString stringWithFormat:@"%@ mediump vec3 eyeDirection;", [self out]] : @""), ((_perPixel && !(_normalMap)) ? [NSString stringWithFormat:@"   %@ mediump vec3 normalMWC;", [self out]] : @""), [self lightsOut], ((!(_perPixel)) ? @"vec3" : @""), ((!(_normalMap) || !(_perPixel)) ? [NSString stringWithFormat:@"   %@ normalMWC = normalize((mwc * vec4(normal, 0)).xyz);", ((!(_perPixel)) ? @"vec3" : @"")] : @""), ((_needUV && _region) ? @"   UV = uvScale*vertexUV + uvShift;" : [NSString stringWithFormat:@"%@", ((_needUV) ? @"\n"
        "   UV = vertexUV; " : @"")]), [self lightsCalculateVaryings]];
    NSString* fragmentShader = [NSString stringWithFormat:@"%@\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "uniform lowp vec4 diffuseColor;\n"
        "uniform lowp vec4 ambientColor;\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {%@\n"
        "   lowp vec4 materialColor = %@;\n"
        "  %@\n"
        "   lowp vec4 color = ambientColor * materialColor;\n"
        "   %@\n"
        "   %@ = color;\n"
        "}", [self fragmentHeader], [self shadowExt], ((_needUV) ? [NSString stringWithFormat:@"%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D diffuseTexture;", [self in]] : @""), ((_normalMap) ? @"uniform lowp sampler2D normalMap;" : @""), ((_specular) ? @"uniform lowp vec4 specularColor;\n"
        "uniform lowp float specularSize;" : @""), ((_perPixel) ? [NSString stringWithFormat:@"%@ mediump vec3 eyeDirection;\n"
        "   %@", [self in], ((_normalMap) ? @"    uniform highp mat4 mwc;\n"
        "   " : [NSString stringWithFormat:@"    %@ mediump vec3 normalMWC;\n"
        "   ", [self in]])] : @""), [self lightsIn], [self lightsFragmentUniform], ((_directLightWithShadowsCount > 0) ? @"\n"
        "   highp float visibility;" : @""), [self blendMode:_blendMode a:@"diffuseColor" b:[NSString stringWithFormat:@"%@(diffuseTexture, UV)", [self texture2D]]], ((_normalMap) ? [NSString stringWithFormat:@"   mediump vec3 normalMWC = normalize((mwc * vec4(2.0*%@(normalMap, UV).xyz - 1.0, 0)).xyz);\n"
        "  ", [self texture2D]] : @""), [self lightsDiffuse], [self fragColor]];
    return [EGStandardShader standardShaderWithKey:self program:[EGShaderProgram applyName:@"Standard" vertex:vertexShader fragment:fragmentShader]];
}

- (NSString*)lightsVertexUniform {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"uniform mediump vec3 dirLightDirection%@;", i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"uniform highp mat4 dirLightDepthMwcp%@;", i] : @"")];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsIn {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCos%@;", [self in], i] : @""), ((_specular && !(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCosA%@;", [self in], i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"%@ highp vec3 dirLightShadowCoord%@;", [self in], i] : @"")];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsOut {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCos%@;", [self out], i] : @""), ((_specular && !(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCosA%@;", [self out], i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"%@ highp vec3 dirLightShadowCoord%@;", [self out], i] : @"")];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"dirLightDirectionCos%@ = max(dot(normalMWC, -dirLightDirection%@), 0.0);", i, i] : @""), ((_specular && !(_perPixel)) ? [NSString stringWithFormat:@"dirLightDirectionCosA%@ = max(dot(eyeDirection, reflect(dirLightDirection%@, normalMWC)), 0.0);", i, i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"dirLightShadowCoord%@ = (dirLightDepthMwcp%@ * vec4(position, 1)).xyz;\n"
            "dirLightShadowCoord%@.z -= 0.0005;", i, i, i] : @"")];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsFragmentUniform {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform lowp vec4 dirLightColor%@;\n"
            "%@\n"
            "%@", i, ((_perPixel) ? [NSString stringWithFormat:@"uniform mediump vec3 dirLightDirection%@;", i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"uniform highp %@ dirLightShadow%@;", [self sampler2DShadow], i] : @"")];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] mapF:^NSString*(id i) {
        return [NSString stringWithFormat:@"\n"
            "%@\n"
            "%@\n"
            "%@\n"
            "%@\n", ((_perPixel) ? [NSString stringWithFormat:@"mediump float dirLightDirectionCos%@ = max(dot(normalMWC, -dirLightDirection%@), 0.0);", i, i] : @""), ((_specular && _perPixel) ? [NSString stringWithFormat:@"mediump float dirLightDirectionCosA%@ = max(dot(eyeDirection, reflect(dirLightDirection%@, normalMWC)), 0.0);", i, i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"visibility = %@;\n"
            "color += visibility * dirLightDirectionCos%@ * (materialColor * dirLightColor%@);", [self shadow2DTexture:[NSString stringWithFormat:@"dirLightShadow%@", i] vec3:[NSString stringWithFormat:@"dirLightShadowCoord%@", i]], i, i] : [NSString stringWithFormat:@"color += dirLightDirectionCos%@ * (materialColor * dirLightColor%@);", i, i]), ((_specular && unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"color += max(visibility * specularColor * dirLightColor%@ * pow(dirLightDirectionCosA%@, 5.0/specularSize), vec4(0, 0, 0, 0));", i, i] : [NSString stringWithFormat:@"%@", ((_specular) ? [NSString stringWithFormat:@"color += max(specularColor * dirLightColor%@ * pow(dirLightDirectionCosA%@, 5.0/specularSize), vec4(0, 0, 0, 0));", i, i] : @"")])];
    }] toStringDelimiter:@"\n"];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"StandardShaderKey(%lu, %lu, %d, %@, %d, %d, %d)", (unsigned long)_directLightWithShadowsCount, (unsigned long)_directLightWithoutShadowsCount, _texture, EGBlendMode_Values[_blendMode], _region, _specular, _normalMap];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[EGStandardShaderKey class]])) return NO;
    EGStandardShaderKey* o = ((EGStandardShaderKey*)(to));
    return _directLightWithShadowsCount == o.directLightWithShadowsCount && _directLightWithoutShadowsCount == o.directLightWithoutShadowsCount && _texture == o.texture && _blendMode == o.blendMode && _region == o.region && _specular == o.specular && _normalMap == o.normalMap;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + _directLightWithShadowsCount;
    hash = hash * 31 + _directLightWithoutShadowsCount;
    hash = hash * 31 + _texture;
    hash = hash * 31 + [EGBlendMode_Values[_blendMode] hash];
    hash = hash * 31 + _region;
    hash = hash * 31 + _specular;
    hash = hash * 31 + _normalMap;
    return hash;
}

- (CNClassType*)type {
    return [EGStandardShaderKey type];
}

+ (CNClassType*)type {
    return _EGStandardShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGStandardShader
static CNClassType* _EGStandardShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize normalSlot = _normalSlot;
@synthesize uvSlot = _uvSlot;
@synthesize diffuseTexture = _diffuseTexture;
@synthesize normalMap = _normalMap;
@synthesize uvScale = _uvScale;
@synthesize uvShift = _uvShift;
@synthesize ambientColor = _ambientColor;
@synthesize specularColor = _specularColor;
@synthesize specularSize = _specularSize;
@synthesize diffuseColorUniform = _diffuseColorUniform;
@synthesize mwcpUniform = _mwcpUniform;
@synthesize mwcUniform = _mwcUniform;
@synthesize directLightDirections = _directLightDirections;
@synthesize directLightColors = _directLightColors;
@synthesize directLightShadows = _directLightShadows;
@synthesize directLightDepthMwcp = _directLightDepthMwcp;

+ (instancetype)standardShaderWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program {
    return [[EGStandardShader alloc] initWithKey:key program:program];
}

- (instancetype)initWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _normalSlot = ((key.directLightCount > 0 && !(key.normalMap)) ? [self attributeForName:@"normal"] : nil);
        _uvSlot = ((key.needUV) ? [self attributeForName:@"vertexUV"] : nil);
        _diffuseTexture = ((key.texture) ? [self uniformI4Name:@"diffuseTexture"] : nil);
        _normalMap = ((key.normalMap) ? [self uniformI4Name:@"normalMap"] : nil);
        _uvScale = ((key.region) ? [self uniformVec2Name:@"uvScale"] : nil);
        _uvShift = ((key.region) ? [self uniformVec2Name:@"uvShift"] : nil);
        _ambientColor = [self uniformVec4Name:@"ambientColor"];
        _specularColor = ((key.directLightCount > 0 && key.specular) ? [self uniformVec4Name:@"specularColor"] : nil);
        _specularSize = ((key.directLightCount > 0 && key.specular) ? [self uniformF4Name:@"specularSize"] : nil);
        _diffuseColorUniform = [self uniformVec4OptName:@"diffuseColor"];
        _mwcpUniform = [self uniformMat4Name:@"mwcp"];
        _mwcUniform = ((key.directLightCount > 0) ? [self uniformMat4Name:@"mwc"] : nil);
        _directLightDirections = [[[uintRange(key.directLightCount) chain] mapF:^EGShaderUniformVec3*(id i) {
            return [self uniformVec3Name:[NSString stringWithFormat:@"dirLightDirection%@", i]];
        }] toArray];
        _directLightColors = [[[uintRange(key.directLightCount) chain] mapF:^EGShaderUniformVec4*(id i) {
            return [self uniformVec4Name:[NSString stringWithFormat:@"dirLightColor%@", i]];
        }] toArray];
        _directLightShadows = [[[uintRange(key.directLightWithShadowsCount) chain] mapF:^EGShaderUniformI4*(id i) {
            return [self uniformI4Name:[NSString stringWithFormat:@"dirLightShadow%@", i]];
        }] toArray];
        _directLightDepthMwcp = [[[uintRange(key.directLightWithShadowsCount) chain] mapF:^EGShaderUniformMat4*(id i) {
            return [self uniformMat4Name:[NSString stringWithFormat:@"dirLightDepthMwcp%@", i]];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGStandardShader class]) _EGStandardShader_type = [CNClassType classTypeWithCls:[EGStandardShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    if(_key.needUV) [((EGShaderAttribute*)(_uvSlot)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
    if(_key.directLightCount > 0) [((EGShaderAttribute*)(_normalSlot)) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.normal))];
}

- (void)loadUniformsParam:(EGStandardMaterial*)param {
    [_mwcpUniform applyMatrix:[[EGGlobal.matrix value] mwcp]];
    if(_key.texture) {
        EGTexture* tex = ((EGStandardMaterial*)(param)).diffuse.texture;
        if(tex != nil) {
            [EGGlobal.context bindTextureTexture:tex];
            [((EGShaderUniformI4*)(_diffuseTexture)) applyI4:0];
            if(_key.region) {
                GERect r = ((EGTextureRegion*)(tex)).uv;
                [((EGShaderUniformVec2*)(_uvShift)) applyVec2:r.p];
                [((EGShaderUniformVec2*)(_uvScale)) applyVec2:r.size];
            }
        }
    }
    if(_key.normalMap) {
        [((EGShaderUniformI4*)(_normalMap)) applyI4:1];
        {
            EGTexture* _ = ((EGNormalMap*)(((EGStandardMaterial*)(param)).normalMap)).texture;
            if(_ != nil) [EGGlobal.context bindTextureSlot:GL_TEXTURE1 target:GL_TEXTURE_2D texture:_];
        }
    }
    [((EGShaderUniformVec4*)(_diffuseColorUniform)) applyVec4:((EGStandardMaterial*)(param)).diffuse.color];
    EGEnvironment* env = EGGlobal.context.environment;
    [_ambientColor applyVec4:env.ambientColor];
    if(_key.directLightCount > 0) {
        if(_key.specular) {
            [((EGShaderUniformVec4*)(_specularColor)) applyVec4:((EGStandardMaterial*)(param)).specularColor];
            [((EGShaderUniformF4*)(_specularSize)) applyF4:((float)(((EGStandardMaterial*)(param)).specularSize))];
        }
        [((EGShaderUniformMat4*)(_mwcUniform)) applyMatrix:[[EGGlobal.context.matrixStack value] mwc]];
        __block unsigned int i = 0;
        if(_key.directLightWithShadowsCount > 0) for(EGDirectLight* light in env.directLightsWithShadows) {
            GEVec3 dir = geVec4Xyz([[[EGGlobal.matrix value] wc] mulVec3:((EGDirectLight*)(light)).direction w:0.0]);
            [((EGShaderUniformVec3*)([_directLightDirections applyIndex:i])) applyVec3:geVec3Normalize(dir)];
            [((EGShaderUniformVec4*)([_directLightColors applyIndex:i])) applyVec4:((EGDirectLight*)(light)).color];
            [((EGShaderUniformMat4*)([_directLightDepthMwcp applyIndex:i])) applyMatrix:[[((EGDirectLight*)(light)) shadowMap].biasDepthCp mulMatrix:[EGGlobal.matrix mw]]];
            [((EGShaderUniformI4*)([_directLightShadows applyIndex:i])) applyI4:((int)(i + 2))];
            [EGGlobal.context bindTextureSlot:GL_TEXTURE0 + i + 2 target:GL_TEXTURE_2D texture:[((EGDirectLight*)(light)) shadowMap].texture];
            i++;
        }
        if(_key.directLightWithoutShadowsCount > 0) for(EGDirectLight* light in ((EGGlobal.context.considerShadows) ? env.directLightsWithoutShadows : env.directLights)) {
            GEVec3 dir = geVec4Xyz([[[EGGlobal.matrix value] wc] mulVec3:((EGDirectLight*)(light)).direction w:0.0]);
            [((EGShaderUniformVec3*)([_directLightDirections applyIndex:i])) applyVec3:geVec3Normalize(dir)];
            [((EGShaderUniformVec4*)([_directLightColors applyIndex:i])) applyVec4:((EGDirectLight*)(light)).color];
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"StandardShader(%@)", _key];
}

- (CNClassType*)type {
    return [EGStandardShader type];
}

+ (CNClassType*)type {
    return _EGStandardShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

