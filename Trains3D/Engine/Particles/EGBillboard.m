#import "EGBillboard.h"

#import "EG.h"
#import "EGMaterial.h"
#import "EGMatrix.h"
#import "EGTexture.h"
#import "EGMesh.h"
@implementation EGBillboard
static ODClassType* _EGBillboard_type;

+ (id)billboard {
    return [[EGBillboard alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBillboard_type = [ODClassType classTypeWithCls:[EGBillboard class]];
}

+ (void)drawWithMaterial:(EGSimpleMaterial*)material size:(EGVec2)size {
}

- (ODClassType*)type {
    return [EGBillboard type];
}

+ (ODClassType*)type {
    return _EGBillboard_type;
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


