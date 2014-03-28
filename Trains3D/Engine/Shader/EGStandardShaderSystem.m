#import "EGStandardShaderSystem.h"

#import "EGContext.h"
#import "EGMaterial.h"
#import "EGShadow.h"
#import "EGTexture.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
@implementation EGStandardShaderSystem
static EGStandardShaderSystem* _EGStandardShaderSystem_instance;
static NSMutableDictionary* _EGStandardShaderSystem_shaders;
static CNNotificationObserver* _EGStandardShaderSystem_settingsChangeObs;
static ODClassType* _EGStandardShaderSystem_type;

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
        _EGStandardShaderSystem_type = [ODClassType classTypeWithCls:[EGStandardShaderSystem class]];
        _EGStandardShaderSystem_instance = [EGStandardShaderSystem standardShaderSystem];
        _EGStandardShaderSystem_shaders = [NSMutableDictionary mutableDictionary];
        _EGStandardShaderSystem_settingsChangeObs = [EGSettings.shadowTypeChangedNotification observeBy:^void(EGSettings* _0, EGShadowType* _1) {
            [_EGStandardShaderSystem_shaders clear];
        }];
    }
}

- (EGShader*)shaderForParam:(EGStandardMaterial*)param renderTarget:(EGRenderTarget*)renderTarget {
    if([renderTarget isKindOfClass:[EGShadowRenderTarget class]]) {
        if([EGShadowShaderSystem isColorShaderForParam:param.diffuse]) return ((EGShader*)(EGStandardShadowShader.instanceForColor));
        else return ((EGShader*)(EGStandardShadowShader.instanceForTexture));
    } else {
        id<CNImSeq> lights = EGGlobal.context.environment.lights;
        NSUInteger directLightsWithShadowsCount = [[[lights chain] filter:^BOOL(EGLight* _) {
            return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]] && ((EGLight*)(_)).hasShadows;
        }] count];
        NSUInteger directLightsWithoutShadowsCount = [[[lights chain] filter:^BOOL(EGLight* _) {
            return [((EGLight*)(_)) isKindOfClass:[EGDirectLight class]] && !(((EGLight*)(_)).hasShadows);
        }] count];
        id texture = param.diffuse.texture;
        BOOL t = [texture isDefined];
        BOOL region = t && [((EGTexture*)([texture get])) isKindOfClass:[EGTextureRegion class]];
        BOOL spec = param.specularSize > 0;
        BOOL normalMap = [param.normalMap isDefined];
        EGStandardShaderKey* key = ((egPlatform().shadows && EGGlobal.context.considerShadows) ? [EGStandardShaderKey standardShaderKeyWithDirectLightWithShadowsCount:directLightsWithShadowsCount directLightWithoutShadowsCount:directLightsWithoutShadowsCount texture:t blendMode:param.diffuse.blendMode region:region specular:spec normalMap:normalMap] : [EGStandardShaderKey standardShaderKeyWithDirectLightWithShadowsCount:0 directLightWithoutShadowsCount:directLightsWithShadowsCount + directLightsWithoutShadowsCount texture:t blendMode:param.diffuse.blendMode region:region specular:spec normalMap:normalMap]);
        return ((EGShader*)([_EGStandardShaderSystem_shaders objectForKey:key orUpdateWith:^EGStandardShader*() {
            return [key shader];
        }]));
    }
}

- (ODClassType*)type {
    return [EGStandardShaderSystem type];
}

+ (EGStandardShaderSystem*)instance {
    return _EGStandardShaderSystem_instance;
}

+ (CNNotificationObserver*)settingsChangeObs {
    return _EGStandardShaderSystem_settingsChangeObs;
}

+ (ODClassType*)type {
    return _EGStandardShaderSystem_type;
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


@implementation EGStandardShadowShader
static EGStandardShadowShader* _EGStandardShadowShader_instanceForColor;
static EGStandardShadowShader* _EGStandardShadowShader_instanceForTexture;
static ODClassType* _EGStandardShadowShader_type;
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
        _EGStandardShadowShader_type = [ODClassType classTypeWithCls:[EGStandardShadowShader class]];
        _EGStandardShadowShader_instanceForColor = [EGStandardShadowShader standardShadowShaderWithShadowShader:EGShadowShader.instanceForColor];
        _EGStandardShadowShader_instanceForTexture = [EGStandardShadowShader standardShadowShaderWithShadowShader:EGShadowShader.instanceForTexture];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_shadowShader loadAttributesVbDesc:vbDesc];
}

- (void)loadUniformsParam:(EGStandardMaterial*)param {
    [_shadowShader loadUniformsParam:param.diffuse];
}

- (ODClassType*)type {
    return [EGStandardShadowShader type];
}

+ (EGStandardShadowShader*)instanceForColor {
    return _EGStandardShadowShader_instanceForColor;
}

+ (EGStandardShadowShader*)instanceForTexture {
    return _EGStandardShadowShader_instanceForTexture;
}

+ (ODClassType*)type {
    return _EGStandardShadowShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"shadowShader=%@", self.shadowShader];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGStandardShaderKey
static ODClassType* _EGStandardShaderKey_type;
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

+ (instancetype)standardShaderKeyWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(EGBlendMode*)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap {
    return [[EGStandardShaderKey alloc] initWithDirectLightWithShadowsCount:directLightWithShadowsCount directLightWithoutShadowsCount:directLightWithoutShadowsCount texture:texture blendMode:blendMode region:region specular:specular normalMap:normalMap];
}

- (instancetype)initWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture blendMode:(EGBlendMode*)blendMode region:(BOOL)region specular:(BOOL)specular normalMap:(BOOL)normalMap {
    self = [super init];
    if(self) {
        _directLightWithShadowsCount = directLightWithShadowsCount;
        _directLightWithoutShadowsCount = directLightWithoutShadowsCount;
        _texture = texture;
        _blendMode = blendMode;
        _region = region;
        _specular = specular;
        _normalMap = normalMap;
        _perPixel = _normalMap;
        _needUV = _normalMap || _texture;
        _directLightCount = _directLightWithShadowsCount + _directLightWithoutShadowsCount;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGStandardShaderKey class]) _EGStandardShaderKey_type = [ODClassType classTypeWithCls:[EGStandardShaderKey class]];
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
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"uniform mediump vec3 dirLightDirection%@;", i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"uniform highp mat4 dirLightDepthMwcp%@;", i] : @"")];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsIn {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCos%@;", [self in], i] : @""), ((_specular && !(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCosA%@;", [self in], i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"%@ highp vec3 dirLightShadowCoord%@;", [self in], i] : @"")];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsOut {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCos%@;", [self out], i] : @""), ((_specular && !(_perPixel)) ? [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCosA%@;", [self out], i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"%@ highp vec3 dirLightShadowCoord%@;", [self out], i] : @"")];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@\n"
            "%@\n"
            "%@\n", ((!(_perPixel)) ? [NSString stringWithFormat:@"dirLightDirectionCos%@ = max(dot(normalMWC, -dirLightDirection%@), 0.0);", i, i] : @""), ((_specular && !(_perPixel)) ? [NSString stringWithFormat:@"dirLightDirectionCosA%@ = max(dot(eyeDirection, reflect(dirLightDirection%@, normalMWC)), 0.0);", i, i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"dirLightShadowCoord%@ = (dirLightDepthMwcp%@ * vec4(position, 1)).xyz;\n"
            "dirLightShadowCoord%@.z -= 0.0005;", i, i, i] : @"")];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsFragmentUniform {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform lowp vec4 dirLightColor%@;\n"
            "%@\n"
            "%@", i, ((_perPixel) ? [NSString stringWithFormat:@"uniform mediump vec3 dirLightDirection%@;", i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"uniform highp %@ dirLightShadow%@;", [self sampler2DShadow], i] : @"")];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"\n"
            "%@\n"
            "%@\n"
            "%@\n"
            "%@\n", ((_perPixel) ? [NSString stringWithFormat:@"mediump float dirLightDirectionCos%@ = max(dot(normalMWC, -dirLightDirection%@), 0.0);", i, i] : @""), ((_specular && _perPixel) ? [NSString stringWithFormat:@"mediump float dirLightDirectionCosA%@ = max(dot(eyeDirection, reflect(dirLightDirection%@, normalMWC)), 0.0);", i, i] : @""), ((unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"visibility = %@;\n"
            "color += visibility * dirLightDirectionCos%@ * (materialColor * dirLightColor%@);", [self shadow2DTexture:[NSString stringWithFormat:@"dirLightShadow%@", i] vec3:[NSString stringWithFormat:@"dirLightShadowCoord%@", i]], i, i] : [NSString stringWithFormat:@"color += dirLightDirectionCos%@ * (materialColor * dirLightColor%@);", i, i]), ((_specular && unumi(i) < _directLightWithShadowsCount) ? [NSString stringWithFormat:@"color += max(visibility * specularColor * dirLightColor%@ * pow(dirLightDirectionCosA%@, 5.0/specularSize), vec4(0, 0, 0, 0));", i, i] : [NSString stringWithFormat:@"%@", ((_specular) ? [NSString stringWithFormat:@"color += max(specularColor * dirLightColor%@ * pow(dirLightDirectionCosA%@, 5.0/specularSize), vec4(0, 0, 0, 0));", i, i] : @"")])];
    }] toStringWithDelimiter:@"\n"];
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
    return [EGStandardShaderKey type];
}

+ (ODClassType*)type {
    return _EGStandardShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGStandardShaderKey* o = ((EGStandardShaderKey*)(other));
    return self.directLightWithShadowsCount == o.directLightWithShadowsCount && self.directLightWithoutShadowsCount == o.directLightWithoutShadowsCount && self.texture == o.texture && self.blendMode == o.blendMode && self.region == o.region && self.specular == o.specular && self.normalMap == o.normalMap;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.directLightWithShadowsCount;
    hash = hash * 31 + self.directLightWithoutShadowsCount;
    hash = hash * 31 + self.texture;
    hash = hash * 31 + [self.blendMode ordinal];
    hash = hash * 31 + self.region;
    hash = hash * 31 + self.specular;
    hash = hash * 31 + self.normalMap;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"directLightWithShadowsCount=%lu", (unsigned long)self.directLightWithShadowsCount];
    [description appendFormat:@", directLightWithoutShadowsCount=%lu", (unsigned long)self.directLightWithoutShadowsCount];
    [description appendFormat:@", texture=%d", self.texture];
    [description appendFormat:@", blendMode=%@", self.blendMode];
    [description appendFormat:@", region=%d", self.region];
    [description appendFormat:@", specular=%d", self.specular];
    [description appendFormat:@", normalMap=%d", self.normalMap];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGStandardShader
static ODClassType* _EGStandardShader_type;
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
        _normalSlot = ((_key.directLightCount > 0 && !(_key.normalMap)) ? [CNOption applyValue:[self attributeForName:@"normal"]] : [CNOption none]);
        _uvSlot = ((_key.needUV) ? [CNOption applyValue:[self attributeForName:@"vertexUV"]] : [CNOption none]);
        _diffuseTexture = ((_key.texture) ? [CNOption applyValue:[self uniformI4Name:@"diffuseTexture"]] : [CNOption none]);
        _normalMap = ((_key.normalMap) ? [CNOption applyValue:[self uniformI4Name:@"normalMap"]] : [CNOption none]);
        _uvScale = ((_key.region) ? [CNOption applyValue:[self uniformVec2Name:@"uvScale"]] : [CNOption none]);
        _uvShift = ((_key.region) ? [CNOption applyValue:[self uniformVec2Name:@"uvShift"]] : [CNOption none]);
        _ambientColor = [self uniformVec4Name:@"ambientColor"];
        _specularColor = ((_key.directLightCount > 0 && _key.specular) ? [CNOption applyValue:[self uniformVec4Name:@"specularColor"]] : [CNOption none]);
        _specularSize = ((_key.directLightCount > 0 && _key.specular) ? [CNOption applyValue:[self uniformF4Name:@"specularSize"]] : [CNOption none]);
        _diffuseColorUniform = [self uniformVec4OptName:@"diffuseColor"];
        _mwcpUniform = [self uniformMat4Name:@"mwcp"];
        _mwcUniform = ((_key.directLightCount > 0) ? [CNOption applyValue:[self uniformMat4Name:@"mwc"]] : [CNOption none]);
        _directLightDirections = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniformVec3*(id i) {
            return [self uniformVec3Name:[NSString stringWithFormat:@"dirLightDirection%@", i]];
        }] toArray];
        _directLightColors = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniformVec4*(id i) {
            return [self uniformVec4Name:[NSString stringWithFormat:@"dirLightColor%@", i]];
        }] toArray];
        _directLightShadows = [[[uintRange(_key.directLightWithShadowsCount) chain] map:^EGShaderUniformI4*(id i) {
            return [self uniformI4Name:[NSString stringWithFormat:@"dirLightShadow%@", i]];
        }] toArray];
        _directLightDepthMwcp = [[[uintRange(_key.directLightWithShadowsCount) chain] map:^EGShaderUniformMat4*(id i) {
            return [self uniformMat4Name:[NSString stringWithFormat:@"dirLightDepthMwcp%@", i]];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGStandardShader class]) _EGStandardShader_type = [ODClassType classTypeWithCls:[EGStandardShader class]];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    if(_key.needUV) [((EGShaderAttribute*)([_uvSlot get])) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
    if(_key.directLightCount > 0 && [_normalSlot isDefined]) [((EGShaderAttribute*)([_normalSlot get])) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.normal))];
}

- (void)loadUniformsParam:(EGStandardMaterial*)param {
    [_mwcpUniform applyMatrix:[[EGGlobal.matrix value] mwcp]];
    if(_key.texture) {
        EGTexture* tex = [param.diffuse.texture get];
        [EGGlobal.context bindTextureTexture:tex];
        [((EGShaderUniformI4*)([_diffuseTexture get])) applyI4:0];
        if(_key.region) {
            GERect r = ((EGTextureRegion*)(tex)).uv;
            [((EGShaderUniformVec2*)([_uvShift get])) applyVec2:r.p];
            [((EGShaderUniformVec2*)([_uvScale get])) applyVec2:r.size];
        }
    }
    if(_key.normalMap) {
        [((EGShaderUniformI4*)([_normalMap get])) applyI4:1];
        [EGGlobal.context bindTextureSlot:GL_TEXTURE1 target:GL_TEXTURE_2D texture:((EGNormalMap*)([param.normalMap get])).texture];
    }
    if([_diffuseColorUniform isDefined]) [((EGShaderUniformVec4*)([_diffuseColorUniform get])) applyVec4:param.diffuse.color];
    EGEnvironment* env = EGGlobal.context.environment;
    [_ambientColor applyVec4:env.ambientColor];
    if(_key.directLightCount > 0) {
        if(_key.specular) {
            [((EGShaderUniformVec4*)([_specularColor get])) applyVec4:param.specularColor];
            [((EGShaderUniformF4*)([_specularSize get])) applyF4:((float)(param.specularSize))];
        }
        [((EGShaderUniformMat4*)([_mwcUniform get])) applyMatrix:[[EGGlobal.context.matrixStack value] mwc]];
        __block unsigned int i = 0;
        if(_key.directLightWithShadowsCount > 0) [env.directLightsWithShadows forEach:^void(EGDirectLight* light) {
            GEVec3 dir = geVec4Xyz([[[EGGlobal.matrix value] wc] mulVec3:((EGDirectLight*)(light)).direction w:0.0]);
            [((EGShaderUniformVec3*)([_directLightDirections applyIndex:i])) applyVec3:geVec3Normalize(dir)];
            [((EGShaderUniformVec4*)([_directLightColors applyIndex:i])) applyVec4:((EGDirectLight*)(light)).color];
            [((EGShaderUniformMat4*)([_directLightDepthMwcp applyIndex:i])) applyMatrix:[[((EGDirectLight*)(light)) shadowMap].biasDepthCp mulMatrix:[EGGlobal.matrix mw]]];
            [((EGShaderUniformI4*)([_directLightShadows applyIndex:i])) applyI4:((int)(i + 2))];
            [EGGlobal.context bindTextureSlot:GL_TEXTURE0 + i + 2 target:GL_TEXTURE_2D texture:[((EGDirectLight*)(light)) shadowMap].texture];
            i++;
        }];
        if(_key.directLightWithoutShadowsCount > 0) [((EGGlobal.context.considerShadows) ? env.directLightsWithoutShadows : env.directLights) forEach:^void(EGDirectLight* light) {
            GEVec3 dir = geVec4Xyz([[[EGGlobal.matrix value] wc] mulVec3:((EGDirectLight*)(light)).direction w:0.0]);
            [((EGShaderUniformVec3*)([_directLightDirections applyIndex:i])) applyVec3:geVec3Normalize(dir)];
            [((EGShaderUniformVec4*)([_directLightColors applyIndex:i])) applyVec4:((EGDirectLight*)(light)).color];
        }];
    }
}

- (ODClassType*)type {
    return [EGStandardShader type];
}

+ (ODClassType*)type {
    return _EGStandardShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"key=%@", self.key];
    [description appendFormat:@", program=%@", self.program];
    [description appendString:@">"];
    return description;
}

@end


