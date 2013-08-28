#import "EGSimpleShaderSystem.h"

#import "EG.h"
#import "EGContext.h"
#import "EGTexture.h"
#import "EGMaterial.h"
@implementation EGSimpleShaderSystem
static EGSimpleShaderSystem* _instance;
static EGSimpleColorShader* _colorShader;
static EGSimpleTextureShader* _textureShader;

+ (id)simpleShaderSystem {
    return [[EGSimpleShaderSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _instance = [EGSimpleShaderSystem simpleShaderSystem];
    _colorShader = [EGSimpleColorShader simpleColorShader];
    _textureShader = [EGSimpleTextureShader simpleTextureShader];
}

- (EGShader*)shaderForContext:(EGContext*)context material:(EGSimpleMaterial*)material {
    EGColorSource* __case__ = material.color;
    BOOL __incomplete__ = YES;
    EGSimpleShader* __result__;
    if(__incomplete__) {
        BOOL __ok__ = YES;
        EGColor cl;
        if([__case__ isKindOfClass:[EGColorSourceColor class]]) {
            EGColorSourceColor* __case1__ = ((EGColorSourceColor*)(__case__));
            cl = [__case1__ color];
        } else {
            __ok__ = NO;
        }
        if(__ok__) {
            _colorShader.color = cl;
            __result__ = _colorShader;
            __incomplete__ = NO;
        }
    }
    if(__incomplete__) {
        BOOL __ok__ = YES;
        EGTexture* tex;
        if([__case__ isKindOfClass:[EGColorSourceTexture class]]) {
            EGColorSourceTexture* __case1__ = ((EGColorSourceTexture*)(__case__));
            tex = [__case1__ texture];
        } else {
            __ok__ = NO;
        }
        if(__ok__) {
            _textureShader.texture = tex;
            __result__ = _textureShader;
            __incomplete__ = NO;
        }
    }
    if(__incomplete__) @throw @"Case incomplete";
    return __result__;
}

- (void)applyContext:(EGContext*)context material:(id)material draw:(void(^)())draw {
    EGShader* shader = [self shaderForContext:context material:material];
    [shader applyDraw:draw];
}

+ (EGSimpleShaderSystem*)instance {
    return _instance;
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


@implementation EGSimpleShader
static NSInteger _STRIDE;
static NSInteger _POSITION_SHIFT;

+ (id)simpleShaderWithProgram:(EGShaderProgram*)program {
    return [[EGSimpleShader alloc] initWithProgram:program];
}

- (id)initWithProgram:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _STRIDE = 8 * 4;
    _POSITION_SHIFT = 5 * 4;
}

+ (NSInteger)STRIDE {
    return _STRIDE;
}

+ (NSInteger)POSITION_SHIFT {
    return _POSITION_SHIFT;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSimpleShader* o = ((EGSimpleShader*)(other));
    return [self.program isEqual:o.program];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.program hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"program=%@", self.program];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSimpleColorShader{
    EGColor _color;
    EGShaderAttribute* _positionSlot;
    EGShaderUniform* _colorUniform;
    EGShaderUniform* _mvpUniform;
}
static NSString* _colorVertexProgram = @"attribute vec3 position;\n"
    "uniform mat4 mvp;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = mvp * vec4(position, 1);\n"
    "}";
static NSString* _colorFragmentProgram = @"uniform vec4 color;\n"
    "\n"
    "void main(void) {\n"
    "    gl_FragColor = color;\n"
    "}";
@synthesize color = _color;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;
@synthesize mvpUniform = _mvpUniform;

+ (id)simpleColorShader {
    return [[EGSimpleColorShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:EGSimpleColorShader.colorVertexProgram fragment:EGSimpleColorShader.colorFragmentProgram]];
    if(self) {
        _color = EGColorMake(1.0, 1.0, 1.0, 1.0);
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformForName:@"color"];
        _mvpUniform = [self uniformForName:@"mvp"];
    }
    
    return self;
}

- (void)load {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([EGSimpleColorShader STRIDE])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)([EGSimpleColorShader POSITION_SHIFT]))];
    [_mvpUniform setMatrix:[[EG context] mvp]];
    [_colorUniform setColor:_color];
}

+ (NSString*)colorVertexProgram {
    return _colorVertexProgram;
}

+ (NSString*)colorFragmentProgram {
    return _colorFragmentProgram;
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


@implementation EGSimpleTextureShader{
    EGTexture* _texture;
    EGShaderAttribute* _positionSlot;
    EGShaderUniform* _colorUniform;
    EGShaderUniform* _mvpUniform;
}
static NSString* _textureVertexProgram = @"attribute vec3 position;\n"
    "uniform mat4 mvp;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = mvp * vec4(position, 1);\n"
    "}";
static NSString* _textureFragmentProgram = @"uniform vec4 color;\n"
    "\n"
    "void main(void) {\n"
    "   gl_FragColor = color;\n"
    "}";
@synthesize texture = _texture;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;
@synthesize mvpUniform = _mvpUniform;

+ (id)simpleTextureShader {
    return [[EGSimpleTextureShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:EGSimpleTextureShader.textureVertexProgram fragment:EGSimpleTextureShader.textureFragmentProgram]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformForName:@"color"];
        _mvpUniform = [self uniformForName:@"mvp"];
    }
    
    return self;
}

- (void)load {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([EGSimpleTextureShader STRIDE])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)([EGSimpleTextureShader POSITION_SHIFT]))];
    [_mvpUniform setMatrix:[[EG context] mvp]];
    [_colorUniform setColor:EGColorMake(0.0, 0.5, 0.0, 1.0)];
}

+ (NSString*)textureVertexProgram {
    return _textureVertexProgram;
}

+ (NSString*)textureFragmentProgram {
    return _textureFragmentProgram;
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


