#import "EGShader.h"

#import "EGMesh.h"
#import "GEMat4.h"
@implementation EGShaderProgram{
    GLuint _handle;
}
static ODClassType* _EGShaderProgram_type;
@synthesize handle = _handle;

+ (id)shaderProgramWithHandle:(GLuint)handle {
    return [[EGShaderProgram alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super init];
    if(self) _handle = handle;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShaderProgram_type = [ODClassType classTypeWithCls:[EGShaderProgram class]];
}

+ (EGShaderProgram*)loadFromFilesVertex:(NSString*)vertex fragment:(NSString*)fragment {
    return [EGShaderProgram applyVertex:[CNBundle readToStringResource:vertex] fragment:[CNBundle readToStringResource:fragment]];
}

+ (EGShaderProgram*)applyVertex:(NSString*)vertex fragment:(NSString*)fragment {
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

+ (GLuint)compileShaderForShaderType:(unsigned int)shaderType source:(NSString*)source {
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

- (void)applyDraw:(void(^)())draw {
    glUseProgram(_handle);
    ((void(^)())(draw))();
    glUseProgram(0);
}

- (EGShaderAttribute*)attributeForName:(NSString*)name {
    GLint h = egGetAttribLocation(_handle, name);
    if(h < 0) @throw [@"Could not found attribute for name " stringByAppendingString:name];
    EGShaderAttribute* ret = [EGShaderAttribute shaderAttributeWithHandle:h];
    return ret;
}

- (EGShaderUniform*)uniformForName:(NSString*)name {
    GLint h = egGetUniformLocation(_handle, name);
    if(h < 0) @throw [@"Could not found attribute for name " stringByAppendingString:name];
    return [EGShaderUniform shaderUniformWithHandle:h];
}

- (ODClassType*)type {
    return [EGShaderProgram type];
}

+ (ODClassType*)type {
    return _EGShaderProgram_type;
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
static ODClassType* _EGShader_type;
@synthesize program = _program;

+ (id)shaderWithProgram:(EGShaderProgram*)program {
    return [[EGShader alloc] initWithProgram:program];
}

- (id)initWithProgram:(EGShaderProgram*)program {
    self = [super init];
    if(self) _program = program;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShader_type = [ODClassType classTypeWithCls:[EGShader class]];
}

- (void)drawParam:(id)param mesh:(EGMesh*)mesh {
    [self drawParam:param mesh:mesh start:0 count:[mesh.indexBuffer count]];
}

- (void)drawParam:(id)param mesh:(EGMesh*)mesh start:(NSUInteger)start count:(NSUInteger)count {
    glUseProgram(_program.handle);
    [mesh.vertexBuffer applyDraw:^void() {
        [self loadVbDesc:mesh.vertexBuffer.desc param:param];
        [mesh.indexBuffer drawWithStart:start count:count];
        [self unloadParam:param];
    }];
    glUseProgram(0);
}

- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb index:(CNPArray*)index mode:(unsigned int)mode {
    glUseProgram(_program.handle);
    [vb applyDraw:^void() {
        [self loadVbDesc:vb.desc param:param];
        glDrawElements(mode, index.count, GL_UNSIGNED_INT, index.bytes);
        [self unloadParam:param];
    }];
    glUseProgram(0);
}

- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb mode:(unsigned int)mode {
    glUseProgram(_program.handle);
    [vb applyDraw:^void() {
        [self loadVbDesc:vb.desc param:param];
        glDrawArrays(mode, 0, [vb count]);
        [self unloadParam:param];
    }];
    glUseProgram(0);
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(id)param {
    @throw @"Method load is abstract";
}

- (void)unloadParam:(id)param {
    @throw @"Method unload is abstract";
}

- (EGShaderAttribute*)attributeForName:(NSString*)name {
    return [_program attributeForName:name];
}

- (EGShaderUniform*)uniformForName:(NSString*)name {
    return [_program uniformForName:name];
}

- (ODClassType*)type {
    return [EGShader type];
}

+ (ODClassType*)type {
    return _EGShader_type;
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
    GLuint _handle;
}
static ODClassType* _EGShaderAttribute_type;
@synthesize handle = _handle;

+ (id)shaderAttributeWithHandle:(GLuint)handle {
    return [[EGShaderAttribute alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super init];
    if(self) _handle = handle;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShaderAttribute_type = [ODClassType classTypeWithCls:[EGShaderAttribute class]];
}

- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(unsigned int)valuesType shift:(NSUInteger)shift {
    glEnableVertexAttribArray(_handle);
    egVertexAttribPointer(_handle, valuesCount, valuesType, GL_FALSE, stride, shift);
}

- (void)unbind {
    glDisableVertexAttribArray(_handle);
}

- (ODClassType*)type {
    return [EGShaderAttribute type];
}

+ (ODClassType*)type {
    return _EGShaderAttribute_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShaderAttribute* o = ((EGShaderAttribute*)(other));
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


@implementation EGShaderUniform{
    GLuint _handle;
}
static ODClassType* _EGShaderUniform_type;
@synthesize handle = _handle;

+ (id)shaderUniformWithHandle:(GLuint)handle {
    return [[EGShaderUniform alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super init];
    if(self) _handle = handle;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShaderUniform_type = [ODClassType classTypeWithCls:[EGShaderUniform class]];
}

- (void)setMatrix:(GEMat4*)matrix {
    glUniformMatrix4fv(_handle, 1, GL_FALSE, [matrix array]);
}

- (void)setVec4:(GEVec4)vec4 {
    egUniformVec4(_handle, vec4);
}

- (void)setVec3:(GEVec3)vec3 {
    egUniformVec3(_handle, vec3);
}

- (void)setF4:(float)f4 {
    glUniform1f(_handle, f4);
}

- (ODClassType*)type {
    return [EGShaderUniform type];
}

+ (ODClassType*)type {
    return _EGShaderUniform_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShaderUniform* o = ((EGShaderUniform*)(other));
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


@implementation EGShaderSystem
static ODClassType* _EGShaderSystem_type;

+ (id)shaderSystem {
    return [[EGShaderSystem alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShaderSystem_type = [ODClassType classTypeWithCls:[EGShaderSystem class]];
}

- (void)drawParam:(id)param mesh:(EGMesh*)mesh {
    EGShader* shader = [self shaderForParam:param];
    [shader drawParam:param mesh:mesh];
}

- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb index:(CNPArray*)index mode:(unsigned int)mode {
    EGShader* shader = [self shaderForParam:param];
    [shader drawParam:param vb:vb index:index mode:mode];
}

- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb mode:(unsigned int)mode {
    EGShader* shader = [self shaderForParam:param];
    [shader drawParam:param vb:vb mode:mode];
}

- (EGShader*)shaderForParam:(id)param {
    @throw @"Method shaderFor is abstract";
}

- (ODClassType*)type {
    return [EGShaderSystem type];
}

+ (ODClassType*)type {
    return _EGShaderSystem_type;
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


