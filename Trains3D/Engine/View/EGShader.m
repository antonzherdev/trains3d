#import "EGShader.h"

#import "CNFile.h"
#import "EGBuffer.h"
#import "EGMatrix.h"
@implementation EGShaderProgram{
    GLuint _handle;
}
@synthesize handle = _handle;

+ (id)shaderProgramWithHandle:(GLuint)handle {
    return [[EGShaderProgram alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super init];
    if(self) _handle = handle;
    
    return self;
}

+ (EGShaderProgram*)loadFromFilesVertex:(NSString*)vertex fragment:(NSString*)fragment {
    return [EGShaderProgram linkFromStringsVertex:[CNBundle readToStringResource:vertex] fragment:[CNBundle readToStringResource:fragment]];
}

+ (EGShaderProgram*)linkFromStringsVertex:(NSString*)vertex fragment:(NSString*)fragment {
    GLuint vertexShader = [EGShaderProgram compileShaderForShaderType:GL_VERTEX_SHADER source:vertex];
    GLuint fragmentShader = [EGShaderProgram compileShaderForShaderType:GL_FRAGMENT_SHADER source:fragment];
    EGShaderProgram* program = [EGShaderProgram linkFromShadersVertex:vertexShader fragment:fragmentShader];
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    return program;
}

+ (EGShaderProgram*)linkFromShadersVertex:(GLuint)vertex fragment:(GLuint)fragment {
    GLuint handle = glCreateProgram();
    glAttachShader(handle, vertex);
    glAttachShader(handle, fragment);
    glLinkProgram(handle);
    [egGetProgramError(handle) forEach:^void(NSString* _) {
        @throw [@"Error in shader program linking: " stringByAppendingString:_];
    }];
    return [EGShaderProgram shaderProgramWithHandle:handle];
}

+ (GLuint)compileShaderForShaderType:(GLenum)shaderType source:(NSString*)source {
    GLuint shader = glCreateShader(shaderType);
    egShaderSource(shader, source);
    glCompileShader(shader);
    [egGetShaderError(shader) forEach:^void(NSString* _) {
        @throw [[@"Error in shader compiling : " stringByAppendingString:_] stringByAppendingString:source];
    }];
    return shader;
}

- (void)dealoc {
    glDeleteProgram(_handle);
}

- (void)set {
    glUseProgram(_handle);
}

- (void)clear {
    glUseProgram(0);
}

- (void)drawF:(void(^)())f {
    glUseProgram(_handle);
    ((void(^)())(f))();
    glUseProgram(0);
}

- (EGShaderAttribute*)attributeForName:(NSString*)name {
    EGShaderAttribute* ret = [EGShaderAttribute shaderAttributeWithHandle:egGetAttribLocation(_handle, name)];
    glEnableVertexAttribArray(ret.handle);
    return ret;
}

- (EGShaderUniform*)uniformForName:(NSString*)name {
    return [EGShaderUniform shaderUniformWithHandle:egGetUniformLocation(_handle, name)];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShaderProgram* o = ((EGShaderProgram*)(other));
    return GLuintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GLuintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShader{
    EGShaderProgram* _program;
}
@synthesize program = _program;

+ (id)shaderWithProgram:(EGShaderProgram*)program {
    return [[EGShader alloc] initWithProgram:program];
}

- (id)initWithProgram:(EGShaderProgram*)program {
    self = [super init];
    if(self) _program = program;
    
    return self;
}

- (void)drawF:(void(^)())f {
    glUseProgram(_program.handle);
    [self load];
    ((void(^)())(f))();
    glUseProgram(0);
}

- (void)set {
    glUseProgram(_program.handle);
    [self load];
}

- (void)load {
    @throw @"Method load is abstract";
}

- (void)clear {
    glUseProgram(0);
}

- (EGShaderAttribute*)attributeForName:(NSString*)name {
    return [_program attributeForName:name];
}

- (EGShaderUniform*)uniformForName:(NSString*)name {
    return [_program uniformForName:name];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShader* o = ((EGShader*)(other));
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


@implementation EGShaderAttribute{
    GLint _handle;
}
@synthesize handle = _handle;

+ (id)shaderAttributeWithHandle:(GLint)handle {
    return [[EGShaderAttribute alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLint)handle {
    self = [super init];
    if(self) _handle = handle;
    
    return self;
}

- (NSUInteger)setFromBuffer:(EGVertexBuffer*)buffer valuesCount:(NSUInteger)valuesCount valuesType:(GLenum)valuesType shift:(NSUInteger)shift {
    egVertexAttribPointer(_handle, valuesCount, valuesType, GL_FALSE, buffer.stride, shift);
    if(GLenumEq(valuesType, GL_DOUBLE)) {
        return valuesCount * 8 + shift;
    } else {
        if(GLenumEq(valuesType, GL_FLOAT)) {
            return valuesCount * 4 + shift;
        } else {
            if(GLenumEq(valuesType, GL_BYTE)) {
                return valuesCount + shift;
            } else {
                if(GLenumEq(valuesType, GL_UNSIGNED_BYTE)) return valuesCount + shift;
                else @throw @"Unknown type";
            }
        }
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShaderAttribute* o = ((EGShaderAttribute*)(other));
    return GLintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GLintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%@", GLintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGShaderUniform{
    GLint _handle;
}
@synthesize handle = _handle;

+ (id)shaderUniformWithHandle:(GLint)handle {
    return [[EGShaderUniform alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLint)handle {
    self = [super init];
    if(self) _handle = handle;
    
    return self;
}

- (void)setMatrix:(EGMatrix*)matrix {
    glUniformMatrix4fv(_handle, 1, GL_FALSE, [matrix array]);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShaderUniform* o = ((EGShaderUniform*)(other));
    return GLintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GLintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%@", GLintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


