#import "EGStandardShaderSystem.h"

#import "EGContext.h"
#import "EGMaterial.h"
#import "EGShadow.h"
#import "GL.h"
#import "EGPlatform.h"
#import "EGMesh.h"
#import "EGTexture.h"
#import "GEMat4.h"
@implementation EGStandardShaderSystem
static EGStandardShaderSystem* _EGStandardShaderSystem_instance;
static NSMutableDictionary* _EGStandardShaderSystem_shaders;
static ODClassType* _EGStandardShaderSystem_type;

+ (id)standardShaderSystem {
    return [[EGStandardShaderSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStandardShaderSystem_type = [ODClassType classTypeWithCls:[EGStandardShaderSystem class]];
    _EGStandardShaderSystem_instance = [EGStandardShaderSystem standardShaderSystem];
    _EGStandardShaderSystem_shaders = [NSMutableDictionary mutableDictionary];
}

- (EGShader*)shaderForParam:(EGStandardMaterial*)param {
    if([EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]]) {
        if([EGShadowShaderSystem isColorShaderForParam:param.diffuse]) return EGStandardShadowShader.instanceForColor;
        else return EGStandardShadowShader.instanceForTexture;
    } else {
        id<CNSeq> lights = EGGlobal.context.environment.lights;
        NSUInteger directLightsWithShadowsCount = [[[lights chain] filter:^BOOL(EGLight* _) {
            return [_ isKindOfClass:[EGDirectLight class]] && _.hasShadows;
        }] count];
        NSUInteger directLightsWithoutShadowsCount = [[[lights chain] filter:^BOOL(EGLight* _) {
            return [_ isKindOfClass:[EGDirectLight class]] && !(_.hasShadows);
        }] count];
        EGStandardShaderKey* key = ((egPlatform().shadows && EGGlobal.context.considerShadows) ? [EGStandardShaderKey standardShaderKeyWithDirectLightWithShadowsCount:directLightsWithShadowsCount directLightWithoutShadowsCount:directLightsWithoutShadowsCount texture:[param.diffuse.texture isDefined]] : [EGStandardShaderKey standardShaderKeyWithDirectLightWithShadowsCount:0 directLightWithoutShadowsCount:directLightsWithShadowsCount + directLightsWithoutShadowsCount texture:[param.diffuse.texture isDefined]]);
        return ((EGStandardShader*)([_EGStandardShaderSystem_shaders objectForKey:key orUpdateWith:^EGStandardShader*() {
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

+ (ODClassType*)type {
    return _EGStandardShaderSystem_type;
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


@implementation EGStandardShadowShader{
    EGShadowShader* _shadowShader;
}
static EGStandardShadowShader* _EGStandardShadowShader_instanceForColor;
static EGStandardShadowShader* _EGStandardShadowShader_instanceForTexture;
static ODClassType* _EGStandardShadowShader_type;
@synthesize shadowShader = _shadowShader;

+ (id)standardShadowShaderWithShadowShader:(EGShadowShader*)shadowShader {
    return [[EGStandardShadowShader alloc] initWithShadowShader:shadowShader];
}

- (id)initWithShadowShader:(EGShadowShader*)shadowShader {
    self = [super initWithProgram:shadowShader.program];
    if(self) _shadowShader = shadowShader;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStandardShadowShader_type = [ODClassType classTypeWithCls:[EGStandardShadowShader class]];
    _EGStandardShadowShader_instanceForColor = [EGStandardShadowShader standardShadowShaderWithShadowShader:EGShadowShader.instanceForColor];
    _EGStandardShadowShader_instanceForTexture = [EGStandardShadowShader standardShadowShaderWithShadowShader:EGShadowShader.instanceForTexture];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGStandardMaterial*)param {
    [_shadowShader loadVbDesc:vbDesc param:param.diffuse];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGStandardShadowShader* o = ((EGStandardShadowShader*)(other));
    return [self.shadowShader isEqual:o.shadowShader];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.shadowShader hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"shadowShader=%@", self.shadowShader];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGStandardShaderKey{
    NSUInteger _directLightWithShadowsCount;
    NSUInteger _directLightWithoutShadowsCount;
    BOOL _texture;
    NSUInteger _directLightCount;
}
static ODClassType* _EGStandardShaderKey_type;
@synthesize directLightWithShadowsCount = _directLightWithShadowsCount;
@synthesize directLightWithoutShadowsCount = _directLightWithoutShadowsCount;
@synthesize texture = _texture;
@synthesize directLightCount = _directLightCount;

+ (id)standardShaderKeyWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture {
    return [[EGStandardShaderKey alloc] initWithDirectLightWithShadowsCount:directLightWithShadowsCount directLightWithoutShadowsCount:directLightWithoutShadowsCount texture:texture];
}

- (id)initWithDirectLightWithShadowsCount:(NSUInteger)directLightWithShadowsCount directLightWithoutShadowsCount:(NSUInteger)directLightWithoutShadowsCount texture:(BOOL)texture {
    self = [super init];
    if(self) {
        _directLightWithShadowsCount = directLightWithShadowsCount;
        _directLightWithoutShadowsCount = directLightWithoutShadowsCount;
        _texture = texture;
        _directLightCount = _directLightWithShadowsCount + _directLightWithoutShadowsCount;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStandardShaderKey_type = [ODClassType classTypeWithCls:[EGStandardShaderKey class]];
}

- (EGStandardShader*)shader {
    NSString* vertexShader = [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec3 normal;\n"
        "\n"
        "%@ highp vec3 position;\n"
        "uniform mat4 mwcp;\n"
        "uniform mat4 mwc;\n"
        "%@\n"
        "\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   vec3 normalMWC = normalize((mwc * vec4(normal, 0)).xyz);\n"
        "   vec3 eyeDirection = normalize(-(mwc * vec4(position, 1)).xyz);\n"
        "   gl_Position = mwcp * vec4(position, 1);%@\n"
        "   %@\n"
        "}", [self vertexHeader], [self ain], [self ain], [self lightsVertexUniform], ((_texture) ? [NSString stringWithFormat:@"\n"
        "%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 UV;\n", [self ain], [self out]] : @""), [self lightsOut], ((_texture) ? @"\n"
        "   UV = vertexUV; " : @""), [self lightsCalculateVaryings]];
    NSString* fragmentShader = [NSString stringWithFormat:@"%@\n"
        "%@\n"
        "uniform lowp vec4 diffuseColor;\n"
        "uniform lowp vec4 ambientColor;\n"
        "uniform lowp vec4 specularColor;\n"
        "uniform lowp float specularSize;\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {%@\n"
        "  %@\n"
        "   lowp vec4 color = ambientColor * materialColor;\n"
        "   %@\n"
        "   %@ = color;\n"
        "}", [self fragmentHeader], ((_texture) ? [NSString stringWithFormat:@"\n"
        "%@ mediump vec2 UV;\n"
        "uniform lowp sampler2D diffuseTexture;\n", [self in]] : @""), [self lightsIn], [self lightsFragmentUniform], ((_directLightWithShadowsCount > 0) ? @"\n"
        "   mediump float visibility;" : @""), ((_texture) ? [NSString stringWithFormat:@"\n"
        "   lowp vec4 materialColor = diffuseColor * %@(diffuseTexture, UV);\n"
        "  ", [self texture2D]] : @"\n"
        "   lowp vec4 materialColor = diffuseColor;\n"
        "  "), [self lightsDiffuse], [self fragColor]];
    return [EGStandardShader standardShaderWithKey:self program:[EGShaderProgram applyVertex:vertexShader fragment:fragmentShader]];
}

- (NSString*)lightsVertexUniform {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform mediump vec3 dirLightDirection%@;\n"
            "%@\n", i, ((i < numui(_directLightWithShadowsCount)) ? [NSString stringWithFormat:@"\n"
            "uniform mat4 dirLightDepthMwcp%@;\n", i] : @"")];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsIn {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCos%@;\n"
            "%@ mediump float dirLightDirectionCosA%@;\n"
            "%@\n", [self in], i, [self in], i, ((i < numui(_directLightWithShadowsCount)) ? [NSString stringWithFormat:@"\n"
            "%@ mediump vec3 dirLightShadowCoord%@;\n", [self in], i] : @"")];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsOut {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"%@ mediump float dirLightDirectionCos%@;\n"
            "%@ mediump float dirLightDirectionCosA%@;\n"
            "%@\n", [self out], i, [self out], i, ((i < numui(_directLightWithShadowsCount)) ? [NSString stringWithFormat:@"\n"
            "%@ mediump vec3 dirLightShadowCoord%@;\n", [self out], i] : @"")];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"dirLightDirectionCos%@ = max(dot(normalMWC, -dirLightDirection%@), 0.0);\n"
            "dirLightDirectionCosA%@ = max(dot(eyeDirection, reflect(dirLightDirection%@, normalMWC)), 0.0);\n"
            "%@\n", i, i, i, i, ((i < numui(_directLightWithShadowsCount)) ? [NSString stringWithFormat:@"\n"
            "dirLightShadowCoord%@ = (dirLightDepthMwcp%@ * vec4(position, 1)).xyz;\n", i, i] : @"")];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsFragmentUniform {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform lowp vec4 dirLightColor%@;\n"
            "%@", i, ((i < numui(_directLightWithShadowsCount)) ? [NSString stringWithFormat:@"\n"
            "uniform mediump sampler2DShadow dirLightShadow%@;\n", i] : @"")];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"\n"
            "%@\n", ((i < numui(_directLightWithShadowsCount)) ? [NSString stringWithFormat:@"\n"
            "visibility = texture(dirLightShadow%@, vec3(dirLightShadowCoord%@.xy, dirLightShadowCoord%@.z - 0.005));\n"
            "color += visibility * dirLightDirectionCos%@ * (materialColor * dirLightColor%@);\n"
            "color += visibility * specularColor * dirLightColor%@ * pow(dirLightDirectionCosA%@, 5.0/specularSize);\n", i, i, i, i, i, i, i] : [NSString stringWithFormat:@"\n"
            "color += dirLightDirectionCos%@ * (materialColor * dirLightColor%@);\n"
            "color += specularColor * dirLightColor%@ * pow(dirLightDirectionCosA%@, 5.0/specularSize);\n", i, i, i, i])];
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)versionString {
    return [NSString stringWithFormat:@"#version %li", [self version]];
}

- (NSString*)vertexHeader {
    return [NSString stringWithFormat:@"#version %li", [self version]];
}

- (NSString*)fragmentHeader {
    return [NSString stringWithFormat:@"#version %li\n"
        "%@", [self version], [self fragColorDeclaration]];
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
    return self.directLightWithShadowsCount == o.directLightWithShadowsCount && self.directLightWithoutShadowsCount == o.directLightWithoutShadowsCount && self.texture == o.texture;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.directLightWithShadowsCount;
    hash = hash * 31 + self.directLightWithoutShadowsCount;
    hash = hash * 31 + self.texture;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"directLightWithShadowsCount=%li", self.directLightWithShadowsCount];
    [description appendFormat:@", directLightWithoutShadowsCount=%li", self.directLightWithoutShadowsCount];
    [description appendFormat:@", texture=%d", self.texture];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGStandardShader{
    EGStandardShaderKey* _key;
    EGShaderAttribute* _positionSlot;
    id _normalSlot;
    id _uvSlot;
    id _diffuseTexture;
    EGShaderUniformVec4* _ambientColor;
    EGShaderUniformVec4* _specularColor;
    EGShaderUniformF4* _specularSize;
    EGShaderUniformVec4* _diffuseColorUniform;
    EGShaderUniformMat4* _mwcpUniform;
    id _mwcUniform;
    id<CNSeq> _directLightDirections;
    id<CNSeq> _directLightColors;
    id<CNSeq> _directLightShadows;
    id<CNSeq> _directLightDepthMwcp;
}
static ODClassType* _EGStandardShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize normalSlot = _normalSlot;
@synthesize uvSlot = _uvSlot;
@synthesize diffuseTexture = _diffuseTexture;
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

+ (id)standardShaderWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program {
    return [[EGStandardShader alloc] initWithKey:key program:program];
}

- (id)initWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    __weak EGStandardShader* _weakSelf = self;
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _normalSlot = ((_key.directLightCount > 0) ? [CNOption applyValue:[self attributeForName:@"normal"]] : [CNOption none]);
        _uvSlot = ((_key.texture) ? [CNOption applyValue:[self attributeForName:@"vertexUV"]] : [CNOption none]);
        _diffuseTexture = ((_key.texture) ? [CNOption applyValue:[self uniformI4Name:@"diffuseTexture"]] : [CNOption none]);
        _ambientColor = [self uniformVec4Name:@"ambientColor"];
        _specularColor = [self uniformVec4Name:@"specularColor"];
        _specularSize = [self uniformF4Name:@"specularSize"];
        _diffuseColorUniform = [self uniformVec4Name:@"diffuseColor"];
        _mwcpUniform = [self uniformMat4Name:@"mwcp"];
        _mwcUniform = ((_key.directLightCount > 0) ? [CNOption applyValue:[self uniformMat4Name:@"mwc"]] : [CNOption none]);
        _directLightDirections = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniformVec3*(id i) {
            return [_weakSelf uniformVec3Name:[NSString stringWithFormat:@"dirLightDirection%@", i]];
        }] toArray];
        _directLightColors = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniformVec4*(id i) {
            return [_weakSelf uniformVec4Name:[NSString stringWithFormat:@"dirLightColor%@", i]];
        }] toArray];
        _directLightShadows = [[[uintRange(_key.directLightWithShadowsCount) chain] map:^EGShaderUniformI4*(id i) {
            return [_weakSelf uniformI4Name:[NSString stringWithFormat:@"dirLightShadow%@", i]];
        }] toArray];
        _directLightDepthMwcp = [[[uintRange(_key.directLightWithShadowsCount) chain] map:^EGShaderUniformMat4*(id i) {
            return [_weakSelf uniformMat4Name:[NSString stringWithFormat:@"dirLightDepthMwcp%@", i]];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStandardShader_type = [ODClassType classTypeWithCls:[EGStandardShader class]];
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(EGStandardMaterial*)param {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_mwcpUniform applyMatrix:[EGGlobal.matrix.value mwcp]];
    if(_key.texture) {
        [((EGShaderAttribute*)([_uvSlot get])) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
        [((EGTexture*)([param.diffuse.texture get])) bind];
        [((EGShaderUniformI4*)([_diffuseTexture get])) applyI4:0];
    }
    [_diffuseColorUniform applyVec4:param.diffuse.color];
    [_specularColor applyVec4:param.specularColor];
    [_specularSize applyF4:((float)(param.specularSize))];
    EGEnvironment* env = EGGlobal.context.environment;
    [_ambientColor applyVec4:env.ambientColor];
    if(_key.directLightCount > 0) {
        [((EGShaderUniformMat4*)([_mwcUniform get])) applyMatrix:[EGGlobal.context.matrixStack.value mwc]];
        [((EGShaderAttribute*)([_normalSlot get])) setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.normal))];
        __block NSUInteger i = 0;
        if(_key.directLightWithShadowsCount > 0) [[[env.lights chain] filter:^BOOL(EGLight* _) {
            return [_ isKindOfClass:[EGDirectLight class]] && _.hasShadows;
        }] forEach:^void(EGLight* light) {
            GEVec3 dir = geVec4Xyz([[EGGlobal.matrix.value wc] mulVec3:((EGDirectLight*)(light)).direction w:0.0]);
            [((EGShaderUniformVec3*)([_directLightDirections applyIndex:i])) applyVec3:geVec3Normalize(dir)];
            [((EGShaderUniformVec4*)([_directLightColors applyIndex:i])) applyVec4:light.color];
            [((EGShaderUniformMat4*)([_directLightDepthMwcp applyIndex:i])) applyMatrix:[[light shadowMap].biasDepthCp mulMatrix:[EGGlobal.matrix mw]]];
            [((EGShaderUniformI4*)([_directLightShadows applyIndex:i])) applyI4:((int)(i + 1))];
            glActiveTexture(GL_TEXTURE0 + i + 1);
            [[light shadowMap].texture bind];
            glActiveTexture(GL_TEXTURE0);
            i++;
        }];
        if(_key.directLightWithoutShadowsCount > 0) [[[env.lights chain] filter:^BOOL(EGLight* _) {
            return [_ isKindOfClass:[EGDirectLight class]] && (!(_.hasShadows) || !(EGGlobal.context.considerShadows));
        }] forEach:^void(EGLight* light) {
            GEVec3 dir = geVec4Xyz([[EGGlobal.matrix.value wc] mulVec3:((EGDirectLight*)(light)).direction w:0.0]);
            [((EGShaderUniformVec3*)([_directLightDirections applyIndex:i])) applyVec3:geVec3Normalize(dir)];
            [((EGShaderUniformVec4*)([_directLightColors applyIndex:i])) applyVec4:light.color];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGStandardShader* o = ((EGStandardShader*)(other));
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


