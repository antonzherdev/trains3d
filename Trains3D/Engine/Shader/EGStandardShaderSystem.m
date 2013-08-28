#import "EGStandardShaderSystem.h"

#import "EGMaterial.h"
#import "EGContext.h"
@implementation EGStandardShaderSystem
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
    return ((EGShader*)([_EGStandardShaderSystem_shaders objectForKey:key orUpdateWith:^EGShader*() {
        return [key shader];
    }]));
}

- (ODType*)type {
    return _EGStandardShaderSystem_type;
}

- (void)applyContext:(EGContext*)context material:(id)material draw:(void(^)())draw {
    EGShader* shader = [self shaderForContext:context material:material];
    [shader applyDraw:draw];
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

- (EGShader*)shader {
    NSString* vertexShader = @"attribute vec3 normal;\n"
        "attribute vec3 vertexUV; $when(texture)\n"
        "attribute vec3 position;\n"
        "uniform mat4 mvp;\n"
        "$lightsVertexUniform\n"
        "\n"
        "varying vec2 UV; $when(texture)\n"
        "$lightsVaryings\n"
        "\n"
        "void main(void) {\n"
        "   gl_Position = mvp * vec4(position, 1);\n"
        "   UV = vertexUV; $when(texture)\n"
        "   $lightsCalculateVaryings\n"
        "}";
    NSString* fragmentShader = @"\n"
        "if(texture)\n"
        "varying vec2 UV;\n"
        "uniform sampler2D texture;\n"
        "else\n"
        "uniform vec4 color;\n"
        "endif\n"
        "$lightsVaryings\n"
        "$lightsFragmentUniform\n"
        "\n"
        "void main(void) {\n"
        "   vec4 matericalColor = color $when(!texture)\n"
        "   vec4 matericalColor = texture2D(texture, UV); $when(texture)\n"
        "   vec4 diffuse = vec4(0, 0, 0, 0)\n"
        "   $lightsDiffuse\n"
        "   gl_FragColor = diffuse;\n"
        "}";
    return [EGShader shaderWithProgram:[EGShaderProgram applyVertex:vertexShader fragment:fragmentShader]];
}

- (NSString*)lightsVertexUniform {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return @"uniform vec3 lightDirection$i;";
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsVaryings {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return @"varying float lightDirectionCos$i;";
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsCalculateVaryings {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return @"lightDirectionCos$i = clamp(dot(normal, normalize(lightDirection$i)), 0, 1);";
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsFragmentUniform {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return @"uniform vec4 lightDirectionColor$i;";
    }] toStringWithDelimiter:@"\n"];
}

- (NSString*)lightsDiffuse {
    return [[[uintRange(_directLightCount) chain] map:^NSString*(id i) {
        return @"diffuse += lightDirectionCos$i * (matericalColor * lightDirectionColor$i);";
    }] toStringWithDelimiter:@"\n"];
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


@implementation EGStanda
static ODType* _EGStanda_type;

+ (id)standa {
    return [[EGStanda alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGStanda_type = [ODType typeWithCls:[EGStanda class]];
}

- (ODType*)type {
    return _EGStanda_type;
}

+ (ODType*)type {
    return _EGStanda_type;
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


