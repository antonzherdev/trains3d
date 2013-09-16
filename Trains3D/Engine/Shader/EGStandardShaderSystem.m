#import "EGStandardShaderSystem.h"

#import "EG.h"
#import "EGTypes.h"
#import "EGMaterial.h"
#import "EGMesh.h"
#import "EGGL.h"
#import "EGTexture.h"
#import "GEMat4.h"
@implementation EGStandardShaderSystem
static EGStandardShaderSystem* _EGStandardShaderSystem_instance;
static NSMutableDictionary* _EGStandardShaderSystem_shaders;
static ODType* _EGStandardShaderSystem_type;

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

- (EGShader*)shaderForMaterial:(EGStandardMaterial*)material {
    id<CNMap> lightMap = [[[EG.context.environment.lights chain] groupBy:^ODType*(EGLight* _) {
        return _.type;
    }] toMap];
    id<CNSeq> directLights = [[lightMap applyKey:EGDirectLight.type] getOrElse:^id<CNSeq>() {
        return (@[]);
    }];
    EGStandardShaderKey* key = [EGStandardShaderKey standardShaderKeyWithDirectLightCount:[directLights count] texture:[material.diffuse isKindOfClass:[EGColorSourceTexture class]]];
    return ((EGStandardShader*)([_EGStandardShaderSystem_shaders objectForKey:key orUpdateWith:^EGStandardShader*() {
        return [key shader];
    }]));
}

- (ODClassType*)type {
    return [EGStandardShaderSystem type];
}

+ (EGStandardShaderSystem*)instance {
    return _EGStandardShaderSystem_instance;
}

+ (ODType*)type {
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


@implementation EGStandardShaderKey{
    NSUInteger _directLightCount;
    BOOL _texture;
}
static ODType* _EGStandardShaderKey_type;
@synthesize directLightCount = _directLightCount;
@synthesize texture = _texture;

+ (id)standardShaderKeyWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture {
    return [[EGStandardShaderKey alloc] initWithDirectLightCount:directLightCount texture:texture];
}

- (id)initWithDirectLightCount:(NSUInteger)directLightCount texture:(BOOL)texture {
    self = [super init];
    if(self) {
        _directLightCount = directLightCount;
        _texture = texture;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStandardShaderKey_type = [ODClassType classTypeWithCls:[EGStandardShaderKey class]];
}

- (EGStandardShader*)shader {
    NSString* vertexShader = [NSString stringWithFormat:@"attribute vec3 normal;%@\n"
        "attribute vec3 position;\n"
        "uniform mat4 mwcp;\n"
        "uniform mat4 mwc;\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   vec3 normalMWC = normalize((mwc * vec4(normal, 0)).xyz);\n"
        "   vec3 eyeDirection = normalize(-(mwc * vec4(position, 1)).xyz);\n"
        "   gl_Position = mwcp * vec4(position, 1);%@\n"
        "   %@\n"
        "}", ((_texture) ? @"\n"
        "attribute vec2 vertexUV; " : @""), [self lightsVertexUniform], ((_texture) ? @"\n"
        "varying vec2 UV; " : @""), [self lightsVaryings], ((_texture) ? @"\n"
        "   UV = vertexUV; " : @""), [self lightsCalculateVaryings]];
    NSString* fragmentShader = [NSString stringWithFormat:@"\n"
        "%@\n"
        "uniform vec4 ambientColor;\n"
        "uniform vec4 specularColor;\n"
        "uniform float specularSize;\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {%@%@\n"
        "   vec4 color = ambientColor * materialColor;\n"
        "   %@\n"
        "   gl_FragColor = color;\n"
        "}", ((_texture) ? @"\n"
        "varying vec2 UV;\n"
        "uniform sampler2D diffuse;" : @"\n"
        "uniform vec4 diffuse;"), [self lightsVaryings], [self lightsFragmentUniform], ((!(_texture)) ? @"\n"
        "   vec4 materialColor = diffuse; " : @""), ((_texture) ? @"\n"
        "   vec4 materialColor = texture2D(diffuse, UV); " : @""), [self lightsDiffuse]];
    return [EGStandardShader standardShaderWithKey:self program:[EGShaderProgram applyVertex:vertexShader fragment:fragmentShader]];
}

- (NSString*)lightsVertexUniform {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform vec3 dirLightDirection%@;", i];
    }] toStringWithDelimiter:@"n"];
}

- (NSString*)lightsVaryings {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"varying float dirLightDirectionCos%@;\n"
            "varying float dirLightDirectionCosA%@;", i, i];
    }] toStringWithDelimiter:@"n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"dirLightDirectionCos%@= max(dot(normalMWC, -normalize(dirLightDirection%@)), 0.0);\n"
            "dirLightDirectionCosA%@= max(dot(eyeDirection, reflect(normalize(dirLightDirection%@), normalMWC)), 0.0);", i, i, i, i];
    }] toStringWithDelimiter:@"n"];
}

- (NSString*)lightsFragmentUniform {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform vec4 dirLightColor%@;", i];
    }] toStringWithDelimiter:@"n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"color += dirLightDirectionCos%@* (materialColor * dirLightColor%@);\n"
            "color += specularColor * dirLightColor%@* pow(dirLightDirectionCosA%@, 5.0/specularSize);", i, i, i, i];
    }] toStringWithDelimiter:@"n"];
}

- (ODClassType*)type {
    return [EGStandardShaderKey type];
}

+ (ODType*)type {
    return _EGStandardShaderKey_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGStandardShaderKey* o = ((EGStandardShaderKey*)(other));
    return self.directLightCount == o.directLightCount && self.texture == o.texture;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.directLightCount;
    hash = hash * 31 + self.texture;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"directLightCount=%li", self.directLightCount];
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
    EGShaderUniform* _ambientColor;
    EGShaderUniform* _specularColor;
    EGShaderUniform* _specularSize;
    EGShaderUniform* _diffuseUniform;
    EGShaderUniform* _mwcpUniform;
    id _mwcUniform;
    id<CNSeq> _directLightDirections;
    id<CNSeq> _directLightColors;
}
static NSInteger _EGStandardShader_UV_SHIFT = 0;
static NSInteger _EGStandardShader_NORMAL_SHIFT;
static NSInteger _EGStandardShader_POSITION_SHIFT;
static ODType* _EGStandardShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize normalSlot = _normalSlot;
@synthesize uvSlot = _uvSlot;
@synthesize ambientColor = _ambientColor;
@synthesize specularColor = _specularColor;
@synthesize specularSize = _specularSize;
@synthesize diffuseUniform = _diffuseUniform;
@synthesize mwcpUniform = _mwcpUniform;
@synthesize mwcUniform = _mwcUniform;
@synthesize directLightDirections = _directLightDirections;
@synthesize directLightColors = _directLightColors;

+ (id)standardShaderWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program {
    return [[EGStandardShader alloc] initWithKey:key program:program];
}

- (id)initWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    __weak EGStandardShader* _weakSelf = self;
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _normalSlot = ((_key.directLightCount > 0) ? [CNOption opt:[self attributeForName:@"normal"]] : [CNOption none]);
        _uvSlot = ((_key.texture) ? [CNOption opt:[self attributeForName:@"vertexUV"]] : [CNOption none]);
        _ambientColor = [self uniformForName:@"ambientColor"];
        _specularColor = [self uniformForName:@"specularColor"];
        _specularSize = [self uniformForName:@"specularSize"];
        _diffuseUniform = [self uniformForName:@"diffuse"];
        _mwcpUniform = [self uniformForName:@"mwcp"];
        _mwcUniform = ((_key.directLightCount > 0) ? [CNOption opt:[self uniformForName:@"mwc"]] : [CNOption none]);
        _directLightDirections = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniform*(id i) {
            return [_weakSelf uniformForName:[NSString stringWithFormat:@"dirLightDirection%@", i]];
        }] toArray];
        _directLightColors = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniform*(id i) {
            return [_weakSelf uniformForName:[NSString stringWithFormat:@"dirLightColor%@", i]];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStandardShader_type = [ODClassType classTypeWithCls:[EGStandardShader class]];
    _EGStandardShader_NORMAL_SHIFT = 2 * 4;
    _EGStandardShader_POSITION_SHIFT = 5 * 4;
}

- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGStandardMaterial*)material {
    [_positionSlot setFromBufferWithStride:[vertexBuffer stride] valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(_EGStandardShader_POSITION_SHIFT))];
    [_mwcpUniform setMatrix:[EG.matrix.value mwcp]];
    if(_key.texture) {
        [((EGShaderAttribute*)([_uvSlot get])) setFromBufferWithStride:[vertexBuffer stride] valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(_EGStandardShader_UV_SHIFT))];
        [((EGColorSourceTexture*)(material.diffuse)).texture bind];
    } else {
        [_diffuseUniform setColor:((EGColorSourceColor*)(material.diffuse)).color];
    }
    [_specularColor setColor:material.specularColor];
    [_specularSize setNumber:((float)(material.specularSize))];
    EGEnvironment* env = EG.context.environment;
    [_ambientColor setColor:env.ambientColor];
    if(_key.directLightCount > 0) {
        [((EGShaderUniform*)([_mwcUniform get])) setMatrix:[EG.context.matrixStack.value mwc]];
        [((EGShaderAttribute*)([_normalSlot get])) setFromBufferWithStride:[vertexBuffer stride] valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(_EGStandardShader_NORMAL_SHIFT))];
        [[[[env.lights chain] filterCast:EGDirectLight.type] zip3A:_directLightDirections b:_directLightColors by:^EGDirectLight*(EGDirectLight* light, EGShaderUniform* dirSlot, EGShaderUniform* colorSlot) {
            GEVec3 dir = geVec4Xyz([[EG.matrix.value wc] mulVec3:light.direction w:0.0]);
            [dirSlot setVec3:dir];
            [colorSlot setColor:light.color];
            return light;
        }] count];
    }
}

- (void)unloadMaterial:(EGSimpleMaterial*)material {
    if(_key.texture) [EGTexture unbind];
}

- (ODClassType*)type {
    return [EGStandardShader type];
}

+ (NSInteger)UV_SHIFT {
    return _EGStandardShader_UV_SHIFT;
}

+ (NSInteger)NORMAL_SHIFT {
    return _EGStandardShader_NORMAL_SHIFT;
}

+ (NSInteger)POSITION_SHIFT {
    return _EGStandardShader_POSITION_SHIFT;
}

+ (ODType*)type {
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


