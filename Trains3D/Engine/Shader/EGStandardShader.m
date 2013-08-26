#import "EGStandardShader.h"

#import "EG.h"
#import "EGContext.h"
@implementation EGStandardShader
static NSInteger _STRIDE;
static NSInteger _POSITION_SHIFT;

+ (id)standardShaderWithProgram:(EGShaderProgram*)program {
    return [[EGStandardShader alloc] initWithProgram:program];
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
    EGStandardShader* o = ((EGStandardShader*)(other));
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
static EGSimpleColorShader* _instance;
@synthesize color = _color;
@synthesize positionSlot = _positionSlot;
@synthesize colorUniform = _colorUniform;
@synthesize mvpUniform = _mvpUniform;

+ (id)simpleColorShader {
    return [[EGSimpleColorShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[EGShaderProgram loadFromFilesVertex:@"Simple.vsh" fragment:@"SimpleColor.fsh"]];
    if(self) {
        _color = EGColorMake(1.0, 1.0, 1.0, 1.0);
        _positionSlot = [self attributeForName:@"position"];
        _colorUniform = [self uniformForName:@"color"];
        _mvpUniform = [self uniformForName:@"mvp"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _instance = [EGSimpleColorShader simpleColorShader];
}

- (void)load {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([EGSimpleColorShader STRIDE])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)([EGSimpleColorShader POSITION_SHIFT]))];
    [_mvpUniform setMatrix:[[EG context] mvp]];
    [_colorUniform setColor:_color];
}

+ (EGSimpleColorShader*)instance {
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


