#import "EGBillboard.h"

#import "EG.h"
#import "EGMaterial.h"
#import "EGMatrix.h"
#import "EGTexture.h"
#import "EGMesh.h"
@implementation EGBillboardShaderSystem
static EGBillboardShaderSystem* _EGBillboardShaderSystem_instance;
static ODClassType* _EGBillboardShaderSystem_type;

+ (id)billboardShaderSystem {
    return [[EGBillboardShaderSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardShaderSystem_type = [ODClassType classTypeWithCls:[EGBillboardShaderSystem class]];
    _EGBillboardShaderSystem_instance = [EGBillboardShaderSystem billboardShaderSystem];
}

- (EGBillboardShader*)shaderForMaterial:(EGSimpleMaterial*)material {
    EGColorSource* __case__ = material.color;
    BOOL __incomplete__ = YES;
    EGShader* __result__;
    if(__incomplete__) {
        BOOL __ok__ = YES;
        EGColor _;
        if([__case__ isKindOfClass:[EGColorSourceColor class]]) {
            EGColorSourceColor* __case1__ = ((EGColorSourceColor*)(__case__));
            _ = [__case1__ color];
        } else {
            __ok__ = NO;
        }
        if(__ok__) {
            __result__ = [EGBillboardShader instanceForColor];
            __incomplete__ = NO;
        }
    }
    if(__incomplete__) {
        BOOL __ok__ = YES;
        if(__ok__) {
            __result__ = [EGBillboardShader instanceForTexture];
            __incomplete__ = NO;
        }
    }
    if(__incomplete__) @throw @"Case incomplete";
    return __result__;
}

- (ODClassType*)type {
    return [EGBillboardShaderSystem type];
}

+ (EGBillboardShaderSystem*)instance {
    return _EGBillboardShaderSystem_instance;
}

+ (ODClassType*)type {
    return _EGBillboardShaderSystem_type;
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


@implementation EGBillboardShader{
    BOOL _texture;
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _modelSlot;
    id _uvSlot;
    id _colorUniform;
    EGShaderUniform* _wcUniform;
    EGShaderUniform* _pUniform;
}
static CNLazy* _EGBillboardShader__lazy_instanceForColor;
static CNLazy* _EGBillboardShader__lazy_instanceForTexture;
static ODClassType* _EGBillboardShader_type;
@synthesize texture = _texture;
@synthesize positionSlot = _positionSlot;
@synthesize modelSlot = _modelSlot;
@synthesize uvSlot = _uvSlot;
@synthesize colorUniform = _colorUniform;
@synthesize wcUniform = _wcUniform;
@synthesize pUniform = _pUniform;

+ (id)billboardShaderWithProgram:(EGShaderProgram*)program texture:(BOOL)texture {
    return [[EGBillboardShader alloc] initWithProgram:program texture:texture];
}

- (id)initWithProgram:(EGShaderProgram*)program texture:(BOOL)texture {
    self = [super initWithProgram:program];
    if(self) {
        _texture = texture;
        _positionSlot = [self attributeForName:@"position"];
        _modelSlot = [self attributeForName:@"model"];
        _uvSlot = [CNOption opt:((_texture) ? [self attributeForName:@"vertexUV"] : nil)];
        _colorUniform = [CNOption none];
        _wcUniform = [self uniformForName:@"wc"];
        _pUniform = [self uniformForName:@"p"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboardShader_type = [ODClassType classTypeWithCls:[EGBillboardShader class]];
    _EGBillboardShader__lazy_instanceForColor = [CNLazy lazyWithF:^EGShader*() {
        return [EGShader shaderWithProgram:[EGShaderProgram applyVertex:[EGBillboardShader vertexTextWithTexture:NO parameters:@"" code:@""] fragment:[EGBillboardShader fragmentTextWithTexture:NO parameters:@"" code:@""]]];
    }];
    _EGBillboardShader__lazy_instanceForTexture = [CNLazy lazyWithF:^EGShader*() {
        return [EGShader shaderWithProgram:[EGShaderProgram applyVertex:[EGBillboardShader vertexTextWithTexture:NO parameters:@"" code:@""] fragment:[EGBillboardShader fragmentTextWithTexture:NO parameters:@"" code:@""]]];
    }];
}

+ (EGShader*)instanceForColor {
    return [_EGBillboardShader__lazy_instanceForColor get];
}

+ (EGShader*)instanceForTexture {
    return [_EGBillboardShader__lazy_instanceForTexture get];
}

+ (NSString*)vertexTextWithTexture:(BOOL)texture parameters:(NSString*)parameters code:(NSString*)code {
    return [NSString stringWithFormat:@"attribute vec3 position;\n"
        "attribute vec2 model;%@\n"
        "\n"
        "uniform mat4 wc;\n"
        "uniform mat4 p;\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "   float size = 0.03;\n"
        "   vec4 pos = wc*vec4(position, 1);\n"
        "   pos.x += model.x;\n"
        "   pos.y += model.y;\n"
        "   gl_Position = p*pos;\n"
        "   UV = vertexUV;\n"
        "   %@\n"
        "}", ((texture) ? @"\n"
        "attribute vec2 vertexUV; " : @""), ((texture) ? @"\n"
        "varying vec2 UV; " : @""), parameters, code];
}

+ (NSString*)fragmentTextWithTexture:(BOOL)texture parameters:(NSString*)parameters code:(NSString*)code {
    return [NSString stringWithFormat:@"\n"
        "%@\n"
        "\n"
        "%@\n"
        "void main(void) {%@%@\n"
        "   %@\n"
        "}", ((texture) ? @"\n"
        "varying vec2 UV;\n"
        "uniform sampler2D texture;" : @"\n"
        "uniform vec4 color;"), parameters, ((texture) ? @"\n"
        "   gl_FragColor = texture2D(texture, UV); " : @""), ((!(texture)) ? @"\n"
        "   gl_FragColor = color; " : @""), code];
}

- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGSimpleMaterial*)material {
    [_positionSlot setFromBufferWithStride:vertexBuffer.stride valuesCount:3 valuesType:GL_FLOAT shift:0];
    [_modelSlot setFromBufferWithStride:vertexBuffer.stride valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(3 * 4))];
    [_wcUniform setMatrix:[EG.matrix.value wc]];
    [_pUniform setMatrix:EG.matrix.value.p];
    if(_texture) {
        [_uvSlot forEach:^void(EGShaderAttribute* _) {
            [_ setFromBufferWithStride:vertexBuffer.stride valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(5 * 4))];
        }];
        [((EGColorSourceTexture*)(material.color)).texture bind];
    } else {
        [((EGShaderUniform*)([_colorUniform get])) setColor:((EGColorSourceColor*)(material.color)).color];
    }
}

- (void)unloadMaterial:(EGSimpleMaterial*)material {
    if(_texture) [EGTexture unbind];
}

- (ODClassType*)type {
    return [EGBillboardShader type];
}

+ (ODClassType*)type {
    return _EGBillboardShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBillboardShader* o = ((EGBillboardShader*)(other));
    return [self.program isEqual:o.program] && self.texture == o.texture;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.program hash];
    hash = hash * 31 + self.texture;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"program=%@", self.program];
    [description appendFormat:@", texture=%d", self.texture];
    [description appendString:@">"];
    return description;
}

@end


