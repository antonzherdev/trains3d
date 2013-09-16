#import "EGSimpleShaderSystem.h"

#import "EGMaterial.h"
#import "EGMesh.h"
#import "EGGL.h"
#import "EG.h"
#import "EGTexture.h"
@implementation EGSimpleShaderSystem
static EGSimpleShaderSystem* _EGSimpleShaderSystem_instance;
static EGSimpleColorShader* _EGSimpleShaderSystem_colorShader;
static EGSimpleTextureShader* _EGSimpleShaderSystem_textureShader;
static ODClassType* _EGSimpleShaderSystem_type;

+ (id)simpleShaderSystem {
    return [[EGSimpleShaderSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleShaderSystem_type = [ODClassType classTypeWithCls:[EGSimpleShaderSystem class]];
    _EGSimpleShaderSystem_instance = [EGSimpleShaderSystem simpleShaderSystem];
    _EGSimpleShaderSystem_colorShader = [EGSimpleColorShader simpleColorShader];
    _EGSimpleShaderSystem_textureShader = [EGSimpleTextureShader simpleTextureShader];
}

- (EGShader*)shaderForMaterial:(EGSimpleMaterial*)material {
    EGColorSource* __case__ = material.color;
    BOOL __incomplete__ = YES;
    EGSimpleShader* __result__;
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
            __result__ = _EGSimpleShaderSystem_colorShader;
            __incomplete__ = NO;
        }
    }
    if(__incomplete__) {
        BOOL __ok__ = YES;
        EGTexture* _;
        if([__case__ isKindOfClass:[EGColorSourceTexture class]]) {
            EGColorSourceTexture* __case1__ = ((EGColorSourceTexture*)(__case__));
            _ = [__case1__ texture];
        } else {
            __ok__ = NO;
        }
        if(__ok__) {
            __result__ = _EGSimpleShaderSystem_textureShader;
            __incomplete__ = NO;
        }
    }
    if(__incomplete__) @throw @"Case incomplete";
    return __result__;
}

- (ODClassType*)type {
    return [EGSimpleShaderSystem type];
}

+ (EGSimpleShaderSystem*)instance {
    return _EGSimpleShaderSystem_instance;
}

+ (ODClassType*)type {
    return _EGSimpleShaderSystem_type;
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
static NSInteger _EGSimpleShader_UV_SHIFT = 0;
static NSInteger _EGSimpleShader_POSITION_SHIFT;
static ODClassType* _EGSimpleShader_type;

+ (id)simpleShaderWithProgram:(EGShaderProgram*)program {
    return [[EGSimpleShader alloc] initWithProgram:program];
}

- (id)initWithProgram:(EGShaderProgram*)program {
    self = [super initWithProgram:program];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleShader_type = [ODClassType classTypeWithCls:[EGSimpleShader class]];
    _EGSimpleShader_POSITION_SHIFT = 5 * 4;
}

- (ODClassType*)type {
    return [EGSimpleShader type];
}

+ (NSInteger)UV_SHIFT {
    return _EGSimpleShader_UV_SHIFT;
}

+ (NSInteger)POSITION_SHIFT {
    return _EGSimpleShader_POSITION_SHIFT;
}

+ (ODClassType*)type {
    return _EGSimpleShader_type;
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
    EGShaderAttribute* _positionSlot;
    EGShaderUniform* _colorUniform;
    EGShaderUniform* _mvpUniform;
}
static NSString* _EGSimpleColorShader_colorVertexProgram = @"attribute vec3 position;\n"
    "uniform mat4 mvp;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = mvp * vec4(position, 1);\n"
    "}";
static NSString* _EGSimpleColorShader_colorFragmentProgram = @"uniform vec4 color;\n"
    "\n"
    "void main(void) {\n"
    "    gl_FragColor = color;\n"
    "}";
static ODClassType* _EGSimpleColorShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;
@synthesize mvpUniform = _mvpUniform;

+ (id)simpleColorShader {
    return [[EGSimpleColorShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:EGSimpleColorShader.colorVertexProgram fragment:EGSimpleColorShader.colorFragmentProgram]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformForName:@"color"];
        _mvpUniform = [self uniformForName:@"mvp"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleColorShader_type = [ODClassType classTypeWithCls:[EGSimpleColorShader class]];
}

- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGSimpleMaterial*)material {
    [_positionSlot setFromBufferWithStride:[vertexBuffer stride] valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)([EGSimpleColorShader POSITION_SHIFT]))];
    [_mvpUniform setMatrix:[EG.matrix.value mwcp]];
    [_colorUniform setColor:((EGColorSourceColor*)(material.color)).color];
}

- (ODClassType*)type {
    return [EGSimpleColorShader type];
}

+ (NSString*)colorVertexProgram {
    return _EGSimpleColorShader_colorVertexProgram;
}

+ (NSString*)colorFragmentProgram {
    return _EGSimpleColorShader_colorFragmentProgram;
}

+ (ODClassType*)type {
    return _EGSimpleColorShader_type;
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
    EGShaderAttribute* _uvSlot;
    EGShaderAttribute* _positionSlot;
    EGShaderUniform* _mvpUniform;
}
static NSString* _EGSimpleTextureShader_textureVertexProgram = @"attribute vec2 vertexUV;\n"
    "attribute vec3 position;\n"
    "uniform mat4 mvp;\n"
    "\n"
    "varying vec2 UV;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = mvp * vec4(position, 1);\n"
    "   UV = vertexUV;\n"
    "}";
static NSString* _EGSimpleTextureShader_textureFragmentProgram = @"varying vec2 UV;\n"
    "uniform sampler2D texture;\n"
    "\n"
    "void main(void) {\n"
    "   gl_FragColor = texture2D(texture, UV);\n"
    "}";
static ODClassType* _EGSimpleTextureShader_type;
@synthesize uvSlot = _uvSlot;
@synthesize positionSlot = _positionSlot;
@synthesize mvpUniform = _mvpUniform;

+ (id)simpleTextureShader {
    return [[EGSimpleTextureShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram applyVertex:EGSimpleTextureShader.textureVertexProgram fragment:EGSimpleTextureShader.textureFragmentProgram]];
    if(self) {
        _uvSlot = [self attributeForName:@"vertexUV"];
        _positionSlot = [self attributeForName:@"position"];
        _mvpUniform = [self uniformForName:@"mvp"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleTextureShader_type = [ODClassType classTypeWithCls:[EGSimpleTextureShader class]];
}

- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(EGSimpleMaterial*)material {
    [_positionSlot setFromBufferWithStride:[vertexBuffer stride] valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)([EGSimpleTextureShader POSITION_SHIFT]))];
    [_mvpUniform setMatrix:[EG.matrix.value mwcp]];
    [_uvSlot setFromBufferWithStride:[vertexBuffer stride] valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)([EGSimpleTextureShader UV_SHIFT]))];
    [((EGColorSourceTexture*)(material.color)).texture bind];
}

- (void)unloadMaterial:(EGSimpleMaterial*)material {
    [EGTexture unbind];
}

- (ODClassType*)type {
    return [EGSimpleTextureShader type];
}

+ (NSString*)textureVertexProgram {
    return _EGSimpleTextureShader_textureVertexProgram;
}

+ (NSString*)textureFragmentProgram {
    return _EGSimpleTextureShader_textureFragmentProgram;
}

+ (ODClassType*)type {
    return _EGSimpleTextureShader_type;
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


