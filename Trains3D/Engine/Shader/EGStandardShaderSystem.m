#import "EGStandardShaderSystem.h"

#import "EGMaterial.h"
#import "EGContext.h"
#import "EGTexture.h"
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
    _EGStandardShaderSystem_instance = [EGStandardShaderSystem standardShaderSystem];
    _EGStandardShaderSystem_shaders = [NSMutableDictionary mutableDictionary];
    _EGStandardShaderSystem_type = [ODType typeWithCls:[EGStandardShaderSystem class]];
}

- (EGShader*)shaderForContext:(EGContext*)context material:(EGStandardMaterial*)material {
    id<CNMap> lightMap = [[[context.environment.lights chain] groupBy:^ODType*(EGLight* _) {
        return [_ type];
    }] toMap];
    id<CNSeq> directLights = [[lightMap applyKey:EGDirectLight.type] getOrElse:^id<CNSeq>() {
        return (@[]);
    }];
    EGStandardShaderKey* key = [EGStandardShaderKey standardShaderKeyWithDirectLightCount:[directLights count] texture:[material.diffuse isKindOfClass:[EGColorSourceTexture class]]];
    return ((EGStandardShader*)([_EGStandardShaderSystem_shaders objectForKey:key orUpdateWith:^EGStandardShader*() {
        return [key shader];
    }]));
}

- (ODType*)type {
    return _EGStandardShaderSystem_type;
}

- (void)applyContext:(EGContext*)context material:(id)material draw:(void(^)())draw {
    EGShader* shader = [self shaderForContext:context material:material];
    [shader applyContext:context material:material draw:draw];
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
    _EGStandardShaderKey_type = [ODType typeWithCls:[EGStandardShaderKey class]];
}

- (EGStandardShader*)shader {
    NSString* vertexShader = [NSString stringWithFormat:@"attribute vec3 normal;%@\n"
        "attribute vec3 position;\n"
        "uniform mat4 mwcp;\n"
        "uniform mat4 m;\n"
        "%@\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   gl_Position = mwcp * vec4(position, 1);%@\n"
        "   %@\n"
        "}", ((_texture) ? @"\n"
        "attribute vec2 vertexUV; " : @""), [self lightsVertexUniform], ((_texture) ? @"\n"
        "varying vec2 UV; " : @""), [self lightsVaryings], ((_texture) ? @"\n"
        "   UV = vertexUV; " : @""), [self lightsCalculateVaryings]];
    NSString* fragmentShader = [NSString stringWithFormat:@"\n"
        "%@\n"
        "uniform vec4 ambientColor;\n"
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
        return [NSString stringWithFormat:@"varying float dirLightDirectionCos%@;", i];
    }] toStringWithDelimiter:@"n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"dirLightDirectionCos%@= max(dot(normalize((m * vec4(normal, 0)).xyz), -normalize(dirLightDirection%@)), 0.0);", i, i];
    }] toStringWithDelimiter:@"n"];
}

- (NSString*)lightsFragmentUniform {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"uniform vec4 dirLightColor%@;", i];
    }] toStringWithDelimiter:@"n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return [NSString stringWithFormat:@"color += dirLightDirectionCos%@* (materialColor * dirLightColor%@);", i, i];
    }] toStringWithDelimiter:@"n"];
}

- (ODType*)type {
    return _EGStandardShaderKey_type;
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
    EGShaderUniform* _diffuseUniform;
    EGShaderUniform* _mwcpUniform;
    id _mUniform;
    id<CNSeq> _directLightDirections;
    id<CNSeq> _directLightColors;
}
static NSInteger _EGStandardShader_STRIDE;
static NSInteger _EGStandardShader_UV_SHIFT = 0;
static NSInteger _EGStandardShader_NORMAL_SHIFT;
static NSInteger _EGStandardShader_POSITION_SHIFT;
static ODType* _EGStandardShader_type;
@synthesize key = _key;
@synthesize positionSlot = _positionSlot;
@synthesize normalSlot = _normalSlot;
@synthesize uvSlot = _uvSlot;
@synthesize ambientColor = _ambientColor;
@synthesize diffuseUniform = _diffuseUniform;
@synthesize mwcpUniform = _mwcpUniform;
@synthesize mUniform = _mUniform;
@synthesize directLightDirections = _directLightDirections;
@synthesize directLightColors = _directLightColors;

+ (id)standardShaderWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program {
    return [[EGStandardShader alloc] initWithKey:key program:program];
}

- (id)initWithKey:(EGStandardShaderKey*)key program:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    if(self) {
        _key = key;
        _positionSlot = [self attributeForName:@"position"];
        _normalSlot = [CNOption opt:((_key.directLightCount > 0) ? [self attributeForName:@"normal"] : nil)];
        _uvSlot = [CNOption opt:((_key.texture) ? [self attributeForName:@"vertexUV"] : nil)];
        _ambientColor = [self uniformForName:@"ambientColor"];
        _diffuseUniform = [self uniformForName:@"diffuse"];
        _mwcpUniform = [self uniformForName:@"mwcp"];
        _mUniform = [CNOption opt:((_key.directLightCount > 0) ? [self uniformForName:@"m"] : nil)];
        _directLightDirections = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniform*(id i) {
            return [self uniformForName:[NSString stringWithFormat:@"dirLightDirection%@", i]];
        }] toArray];
        _directLightColors = [[[uintRange(_key.directLightCount) chain] map:^EGShaderUniform*(id i) {
            return [self uniformForName:[NSString stringWithFormat:@"dirLightColor%@", i]];
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStandardShader_STRIDE = 8 * 4;
    _EGStandardShader_NORMAL_SHIFT = 2 * 4;
    _EGStandardShader_POSITION_SHIFT = 5 * 4;
    _EGStandardShader_type = [ODType typeWithCls:[EGStandardShader class]];
}

- (void)loadContext:(EGContext*)context material:(EGStandardMaterial*)material {
    [_positionSlot setFromBufferWithStride:((NSUInteger)(_EGStandardShader_STRIDE)) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(_EGStandardShader_POSITION_SHIFT))];
    [_mwcpUniform setMatrix:[context mwcp]];
    if(_key.texture) {
        [((EGShaderAttribute*)([_uvSlot get])) setFromBufferWithStride:((NSUInteger)(_EGStandardShader_STRIDE)) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(_EGStandardShader_UV_SHIFT))];
        [((EGColorSourceTexture*)(material.diffuse)).texture bind];
    } else {
        [_diffuseUniform setColor:((EGColorSourceColor*)(material.diffuse)).color];
    }
    EGEnvironment* env = context.environment;
    [_ambientColor setColor:env.ambientColor];
    if(_key.directLightCount > 0) {
        [((EGShaderUniform*)([_mUniform get])) setMatrix:[context m]];
        [((EGShaderAttribute*)([_normalSlot get])) setFromBufferWithStride:((NSUInteger)(_EGStandardShader_STRIDE)) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(_EGStandardShader_NORMAL_SHIFT))];
        [[[[env.lights chain] filterCast:EGDirectLight.type] zip3A:_directLightDirections b:_directLightColors by:^EGDirectLight*(EGDirectLight* light, EGShaderUniform* dirSlot, EGShaderUniform* colorSlot) {
            [dirSlot setVec3:light.direction];
            [colorSlot setColor:light.color];
            return light;
        }] count];
    }
}

- (ODType*)type {
    return _EGStandardShader_type;
}

+ (NSInteger)STRIDE {
    return _EGStandardShader_STRIDE;
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

