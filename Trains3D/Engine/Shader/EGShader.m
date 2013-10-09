#import "EGShader.h"

#import "EGMesh.h"
#import "EGContext.h"
#import "GEMat4.h"
@implementation EGShaderProgram{
    GLuint _handle;
}
static NSInteger _EGShaderProgram_version;
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
    _EGShaderProgram_version = ((NSInteger)(egGLSLVersion()));
}

+ (EGShaderProgram*)loadFromFilesVertex:(NSString*)vertex fragment:(NSString*)fragment {
    return [EGShaderProgram applyVertex:[OSBundle readToStringResource:vertex] fragment:[OSBundle readToStringResource:fragment]];
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

- (EGShaderAttribute*)attributeForName:(NSString*)name {
    GLint h = egGetAttribLocation(_handle, name);
    if(h < 0) @throw [@"Could not found attribute for name " stringByAppendingString:name];
    EGShaderAttribute* ret = [EGShaderAttribute shaderAttributeWithHandle:h];
    return ret;
}

- (ODClassType*)type {
    return [EGShaderProgram type];
}

+ (NSInteger)version {
    return _EGShaderProgram_version;
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
    [EGGlobal.context bindShaderProgramProgram:_program];
    [mesh.vertexBuffer bind];
    [self loadVbDesc:mesh.vertexBuffer.desc param:param];
    [mesh.indexBuffer drawWithStart:start count:count];
}

- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb index:(CNPArray*)index mode:(unsigned int)mode {
    [EGGlobal.context bindShaderProgramProgram:_program];
    [vb bind];
    [self loadVbDesc:vb.desc param:param];
    glDrawElements(mode, index.count, GL_UNSIGNED_INT, index.bytes);
}

- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb indexRef:(CNVoidRefArray)indexRef mode:(unsigned int)mode {
    [EGGlobal.context bindShaderProgramProgram:_program];
    [vb bind];
    [self loadVbDesc:vb.desc param:param];
    glDrawElements(mode, indexRef.length / 4, GL_UNSIGNED_INT, indexRef.bytes);
}

- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb mode:(unsigned int)mode {
    [EGGlobal.context bindShaderProgramProgram:_program];
    [vb bind];
    [self loadVbDesc:vb.desc param:param];
    glDrawArrays(mode, 0, [vb count]);
}

- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(id)param {
    @throw @"Method load is abstract";
}

- (GLint)uniformName:(NSString*)name {
    GLint h = egGetUniformLocation(_program.handle, name);
    if(h < 0) @throw [@"Could not found attribute for name " stringByAppendingString:name];
    return h;
}

- (EGShaderUniformMat4*)uniformMat4Name:(NSString*)name {
    return [EGShaderUniformMat4 shaderUniformMat4WithHandle:[self uniformName:name]];
}

- (EGShaderUniformVec4*)uniformVec4Name:(NSString*)name {
    return [EGShaderUniformVec4 shaderUniformVec4WithHandle:[self uniformName:name]];
}

- (EGShaderUniformVec3*)uniformVec3Name:(NSString*)name {
    return [EGShaderUniformVec3 shaderUniformVec3WithHandle:[self uniformName:name]];
}

- (EGShaderUniformF4*)uniformF4Name:(NSString*)name {
    return [EGShaderUniformF4 shaderUniformF4WithHandle:[self uniformName:name]];
}

- (EGShaderUniformI4*)uniformI4Name:(NSString*)name {
    return [EGShaderUniformI4 shaderUniformI4WithHandle:[self uniformName:name]];
}

- (EGShaderAttribute*)attributeForName:(NSString*)name {
    return [_program attributeForName:name];
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
    if(self) {
        _handle = handle;
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShaderAttribute_type = [ODClassType classTypeWithCls:[EGShaderAttribute class]];
}

- (void)_init {
    glEnableVertexAttribArray(_handle);
}

- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(unsigned int)valuesType shift:(NSUInteger)shift {
    egVertexAttribPointer(_handle, valuesCount, valuesType, GL_FALSE, stride, shift);
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


@implementation EGShaderUniformMat4{
    GLuint _handle;
    GEMat4* __last;
}
static ODClassType* _EGShaderUniformMat4_type;
@synthesize handle = _handle;

+ (id)shaderUniformMat4WithHandle:(GLuint)handle {
    return [[EGShaderUniformMat4 alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = [GEMat4 null];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShaderUniformMat4_type = [ODClassType classTypeWithCls:[EGShaderUniformMat4 class]];
}

- (void)applyMatrix:(GEMat4*)matrix {
    if(!([matrix isEqual:__last])) {
        __last = matrix;
        glUniformMatrix4fv(_handle, 1, GL_FALSE, [matrix array]);
    }
}

- (ODClassType*)type {
    return [EGShaderUniformMat4 type];
}

+ (ODClassType*)type {
    return _EGShaderUniformMat4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShaderUniformMat4* o = ((EGShaderUniformMat4*)(other));
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


@implementation EGShaderUniformVec4{
    GLuint _handle;
    GEVec4 __last;
}
static ODClassType* _EGShaderUniformVec4_type;
@synthesize handle = _handle;

+ (id)shaderUniformVec4WithHandle:(GLuint)handle {
    return [[EGShaderUniformVec4 alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = GEVec4Make(0.0, 0.0, 0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShaderUniformVec4_type = [ODClassType classTypeWithCls:[EGShaderUniformVec4 class]];
}

- (void)applyVec4:(GEVec4)vec4 {
    if(!(GEVec4Eq(vec4, __last))) {
        egUniformVec4(_handle, vec4);
        __last = vec4;
    }
}

- (ODClassType*)type {
    return [EGShaderUniformVec4 type];
}

+ (ODClassType*)type {
    return _EGShaderUniformVec4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShaderUniformVec4* o = ((EGShaderUniformVec4*)(other));
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


@implementation EGShaderUniformVec3{
    GLuint _handle;
    GEVec3 __last;
}
static ODClassType* _EGShaderUniformVec3_type;
@synthesize handle = _handle;

+ (id)shaderUniformVec3WithHandle:(GLuint)handle {
    return [[EGShaderUniformVec3 alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = GEVec3Make(0.0, 0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShaderUniformVec3_type = [ODClassType classTypeWithCls:[EGShaderUniformVec3 class]];
}

- (void)applyVec3:(GEVec3)vec3 {
    if(!(GEVec3Eq(vec3, __last))) {
        egUniformVec3(_handle, vec3);
        __last = vec3;
    }
}

- (ODClassType*)type {
    return [EGShaderUniformVec3 type];
}

+ (ODClassType*)type {
    return _EGShaderUniformVec3_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShaderUniformVec3* o = ((EGShaderUniformVec3*)(other));
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


@implementation EGShaderUniformF4{
    GLuint _handle;
    float __last;
}
static ODClassType* _EGShaderUniformF4_type;
@synthesize handle = _handle;

+ (id)shaderUniformF4WithHandle:(GLuint)handle {
    return [[EGShaderUniformF4 alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShaderUniformF4_type = [ODClassType classTypeWithCls:[EGShaderUniformF4 class]];
}

- (void)applyF4:(float)f4 {
    if(!(eqf4(f4, __last))) {
        glUniform1f(_handle, f4);
        __last = f4;
    }
}

- (ODClassType*)type {
    return [EGShaderUniformF4 type];
}

+ (ODClassType*)type {
    return _EGShaderUniformF4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShaderUniformF4* o = ((EGShaderUniformF4*)(other));
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


@implementation EGShaderUniformI4{
    GLuint _handle;
    int __last;
}
static ODClassType* _EGShaderUniformI4_type;
@synthesize handle = _handle;

+ (id)shaderUniformI4WithHandle:(GLuint)handle {
    return [[EGShaderUniformI4 alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGShaderUniformI4_type = [ODClassType classTypeWithCls:[EGShaderUniformI4 class]];
}

- (void)applyI4:(int)i4 {
    if(i4 != __last) {
        glUniform1i(_handle, i4);
        __last = i4;
    }
}

- (ODClassType*)type {
    return [EGShaderUniformI4 type];
}

+ (ODClassType*)type {
    return _EGShaderUniformI4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGShaderUniformI4* o = ((EGShaderUniformI4*)(other));
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


