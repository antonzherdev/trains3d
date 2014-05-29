#import "EGShader.h"

#import "GL.h"
#import "EGVertex.h"
#import "EGIndex.h"
#import "EGMesh.h"
#import "EGVertexArray.h"
#import "GEMat4.h"
@implementation EGShaderProgram
static NSInteger _EGShaderProgram_version;
static CNClassType* _EGShaderProgram_type;
@synthesize name = _name;
@synthesize handle = _handle;

+ (instancetype)shaderProgramWithName:(NSString*)name handle:(unsigned int)handle {
    return [[EGShaderProgram alloc] initWithName:name handle:handle];
}

- (instancetype)initWithName:(NSString*)name handle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _name = name;
        _handle = handle;
        if([self class] == [EGShaderProgram class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShaderProgram class]) {
        _EGShaderProgram_type = [CNClassType classTypeWithCls:[EGShaderProgram class]];
        _EGShaderProgram_version = ((NSInteger)(egGLSLVersion()));
    }
}

+ (EGShaderProgram*)loadFromFilesName:(NSString*)name vertex:(NSString*)vertex fragment:(NSString*)fragment {
    return [EGShaderProgram applyName:name vertex:[CNBundle readToStringResource:vertex] fragment:[CNBundle readToStringResource:fragment]];
}

+ (EGShaderProgram*)applyName:(NSString*)name vertex:(NSString*)vertex fragment:(NSString*)fragment {
    unsigned int vertexShader = [EGShaderProgram compileShaderForShaderType:GL_VERTEX_SHADER source:vertex];
    unsigned int fragmentShader = [EGShaderProgram compileShaderForShaderType:GL_FRAGMENT_SHADER source:fragment];
    EGShaderProgram* program = [EGShaderProgram linkFromShadersName:name vertex:vertexShader fragment:fragmentShader];
    glDeleteShader(vertexShader);
    glDeleteShader(fragmentShader);
    return program;
}

+ (EGShaderProgram*)linkFromShadersName:(NSString*)name vertex:(unsigned int)vertex fragment:(unsigned int)fragment {
    unsigned int handle = glCreateProgram();
    glAttachShader(handle, vertex);
    glAttachShader(handle, fragment);
    glLinkProgram(handle);
    {
        NSString* _ = egGetProgramError(handle);
        if(_ != nil) @throw [@"Error in shader program linking: " stringByAppendingFormat:@"%@", _];
    }
    return [EGShaderProgram shaderProgramWithName:name handle:handle];
}

+ (unsigned int)compileShaderForShaderType:(unsigned int)shaderType source:(NSString*)source {
    unsigned int shader = glCreateShader(shaderType);
    egShaderSource(shader, source);
    glCompileShader(shader);
    {
        NSString* _ = egGetShaderError(shader);
        if(_ != nil) @throw [[@"Error in shader compiling : " stringByAppendingFormat:@"%@", _] stringByAppendingString:source];
    }
    return shader;
}

- (void)_init {
    egLabelShaderProgram(_handle, _name);
}

- (void)dealloc {
    [EGGlobal.context deleteShaderProgramId:_handle];
}

- (EGShaderAttribute*)attributeForName:(NSString*)name {
    int h = egGetAttribLocation(_handle, name);
    if(h < 0) @throw [@"Could not found attribute for name " stringByAppendingString:name];
    EGShaderAttribute* ret = [EGShaderAttribute shaderAttributeWithHandle:((unsigned int)(h))];
    return ret;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderProgram(%@, %u)", _name, _handle];
}

- (CNClassType*)type {
    return [EGShaderProgram type];
}

+ (NSInteger)version {
    return _EGShaderProgram_version;
}

+ (CNClassType*)type {
    return _EGShaderProgram_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShader
static CNClassType* _EGShader_type;
@synthesize program = _program;

+ (instancetype)shaderWithProgram:(EGShaderProgram*)program {
    return [[EGShader alloc] initWithProgram:program];
}

- (instancetype)initWithProgram:(EGShaderProgram*)program {
    self = [super init];
    if(self) _program = program;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShader class]) _EGShader_type = [CNClassType classTypeWithCls:[EGShader class]];
}

- (void)drawParam:(id)param vertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index {
    [EGGlobal.context bindShaderProgramProgram:_program];
    [vertex bind];
    [self loadAttributesVbDesc:[vertex desc]];
    [self loadUniformsParam:param];
    [index bind];
    [index draw];
}

- (void)drawParam:(id)param mesh:(EGMesh*)mesh {
    [self drawParam:param vertex:mesh.vertex index:mesh.index];
}

- (void)drawParam:(id)param vao:(EGSimpleVertexArray*)vao {
    [vao bind];
    [EGGlobal.context bindShaderProgramProgram:_program];
    [self loadUniformsParam:param];
    [vao.index draw];
    [vao unbind];
}

- (void)drawParam:(id)param vao:(EGSimpleVertexArray*)vao start:(NSUInteger)start end:(NSUInteger)end {
    [vao bind];
    [EGGlobal.context bindShaderProgramProgram:_program];
    [self loadUniformsParam:param];
    [vao.index drawWithStart:start count:end];
    [vao unbind];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    @throw @"Method loadAttributes is abstract";
}

- (void)loadUniformsParam:(id)param {
    @throw @"Method loadUniforms is abstract";
}

- (int)uniformName:(NSString*)name {
    int h = egGetUniformLocation(_program.handle, name);
    if(h < 0) @throw [@"Could not found attribute for name " stringByAppendingString:name];
    return h;
}

- (id)uniformOptName:(NSString*)name {
    int h = egGetUniformLocation(_program.handle, name);
    if(h < 0) nil;
    return numi4(h);
}

- (EGShaderUniformMat4*)uniformMat4Name:(NSString*)name {
    return [EGShaderUniformMat4 shaderUniformMat4WithHandle:((unsigned int)([self uniformName:name]))];
}

- (EGShaderUniformVec4*)uniformVec4Name:(NSString*)name {
    return [EGShaderUniformVec4 shaderUniformVec4WithHandle:((unsigned int)([self uniformName:name]))];
}

- (EGShaderUniformVec3*)uniformVec3Name:(NSString*)name {
    return [EGShaderUniformVec3 shaderUniformVec3WithHandle:((unsigned int)([self uniformName:name]))];
}

- (EGShaderUniformVec2*)uniformVec2Name:(NSString*)name {
    return [EGShaderUniformVec2 shaderUniformVec2WithHandle:((unsigned int)([self uniformName:name]))];
}

- (EGShaderUniformF4*)uniformF4Name:(NSString*)name {
    return [EGShaderUniformF4 shaderUniformF4WithHandle:((unsigned int)([self uniformName:name]))];
}

- (EGShaderUniformI4*)uniformI4Name:(NSString*)name {
    return [EGShaderUniformI4 shaderUniformI4WithHandle:((unsigned int)([self uniformName:name]))];
}

- (EGShaderUniformMat4*)uniformMat4OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [EGShaderUniformMat4 shaderUniformMat4WithHandle:unumui4(_)];
    else return nil;
}

- (EGShaderUniformVec4*)uniformVec4OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [EGShaderUniformVec4 shaderUniformVec4WithHandle:unumui4(_)];
    else return nil;
}

- (EGShaderUniformVec3*)uniformVec3OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [EGShaderUniformVec3 shaderUniformVec3WithHandle:unumui4(_)];
    else return nil;
}

- (EGShaderUniformVec2*)uniformVec2OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [EGShaderUniformVec2 shaderUniformVec2WithHandle:unumui4(_)];
    else return nil;
}

- (EGShaderUniformF4*)uniformF4OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [EGShaderUniformF4 shaderUniformF4WithHandle:unumui4(_)];
    else return nil;
}

- (EGShaderUniformI4*)uniformI4OptName:(NSString*)name {
    id _ = [self uniformOptName:name];
    if(_ != nil) return [EGShaderUniformI4 shaderUniformI4WithHandle:unumui4(_)];
    else return nil;
}

- (EGShaderAttribute*)attributeForName:(NSString*)name {
    return [_program attributeForName:name];
}

- (EGSimpleVertexArray*)vaoVbo:(id<EGVertexBuffer>)vbo ibo:(id<EGIndexSource>)ibo {
    EGSimpleVertexArray* vao = [EGSimpleVertexArray applyShader:self buffers:(@[vbo]) index:ibo];
    [vao bind];
    [vbo bind];
    [ibo bind];
    [self loadAttributesVbDesc:[vbo desc]];
    [vao unbind];
    return vao;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Shader(%@)", _program];
}

- (CNClassType*)type {
    return [EGShader type];
}

+ (CNClassType*)type {
    return _EGShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShaderAttribute
static CNClassType* _EGShaderAttribute_type;
@synthesize handle = _handle;

+ (instancetype)shaderAttributeWithHandle:(unsigned int)handle {
    return [[EGShaderAttribute alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) _handle = handle;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShaderAttribute class]) _EGShaderAttribute_type = [CNClassType classTypeWithCls:[EGShaderAttribute class]];
}

- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(unsigned int)valuesType shift:(NSUInteger)shift {
    glEnableVertexAttribArray(((int)(_handle)));
    egVertexAttribPointer(_handle, ((unsigned int)(valuesCount)), valuesType, GL_FALSE, ((unsigned int)(stride)), ((unsigned int)(shift)));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderAttribute(%u)", _handle];
}

- (CNClassType*)type {
    return [EGShaderAttribute type];
}

+ (CNClassType*)type {
    return _EGShaderAttribute_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShaderUniformMat4
static CNClassType* _EGShaderUniformMat4_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformMat4WithHandle:(unsigned int)handle {
    return [[EGShaderUniformMat4 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = [GEMat4 null];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShaderUniformMat4 class]) _EGShaderUniformMat4_type = [CNClassType classTypeWithCls:[EGShaderUniformMat4 class]];
}

- (void)applyMatrix:(GEMat4*)matrix {
    if(!([matrix isEqual:__last])) {
        __last = matrix;
        glUniformMatrix4fv(_handle, 1, GL_FALSE, matrix.array);
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformMat4(%u)", _handle];
}

- (CNClassType*)type {
    return [EGShaderUniformMat4 type];
}

+ (CNClassType*)type {
    return _EGShaderUniformMat4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShaderUniformVec4
static CNClassType* _EGShaderUniformVec4_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformVec4WithHandle:(unsigned int)handle {
    return [[EGShaderUniformVec4 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = GEVec4Make(0.0, 0.0, 0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShaderUniformVec4 class]) _EGShaderUniformVec4_type = [CNClassType classTypeWithCls:[EGShaderUniformVec4 class]];
}

- (void)applyVec4:(GEVec4)vec4 {
    if(!(geVec4IsEqualTo(vec4, __last))) {
        egUniformVec4(_handle, vec4);
        __last = vec4;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformVec4(%u)", _handle];
}

- (CNClassType*)type {
    return [EGShaderUniformVec4 type];
}

+ (CNClassType*)type {
    return _EGShaderUniformVec4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShaderUniformVec3
static CNClassType* _EGShaderUniformVec3_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformVec3WithHandle:(unsigned int)handle {
    return [[EGShaderUniformVec3 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = GEVec3Make(0.0, 0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShaderUniformVec3 class]) _EGShaderUniformVec3_type = [CNClassType classTypeWithCls:[EGShaderUniformVec3 class]];
}

- (void)applyVec3:(GEVec3)vec3 {
    if(!(geVec3IsEqualTo(vec3, __last))) {
        egUniformVec3(_handle, vec3);
        __last = vec3;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformVec3(%u)", _handle];
}

- (CNClassType*)type {
    return [EGShaderUniformVec3 type];
}

+ (CNClassType*)type {
    return _EGShaderUniformVec3_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShaderUniformVec2
static CNClassType* _EGShaderUniformVec2_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformVec2WithHandle:(unsigned int)handle {
    return [[EGShaderUniformVec2 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = GEVec2Make(0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShaderUniformVec2 class]) _EGShaderUniformVec2_type = [CNClassType classTypeWithCls:[EGShaderUniformVec2 class]];
}

- (void)applyVec2:(GEVec2)vec2 {
    if(!(geVec2IsEqualTo(vec2, __last))) {
        egUniformVec2(_handle, vec2);
        __last = vec2;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformVec2(%u)", _handle];
}

- (CNClassType*)type {
    return [EGShaderUniformVec2 type];
}

+ (CNClassType*)type {
    return _EGShaderUniformVec2_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShaderUniformF4
static CNClassType* _EGShaderUniformF4_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformF4WithHandle:(unsigned int)handle {
    return [[EGShaderUniformF4 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShaderUniformF4 class]) _EGShaderUniformF4_type = [CNClassType classTypeWithCls:[EGShaderUniformF4 class]];
}

- (void)applyF4:(float)f4 {
    if(!(eqf4(f4, __last))) {
        glUniform1f(_handle, f4);
        __last = f4;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformF4(%u)", _handle];
}

- (CNClassType*)type {
    return [EGShaderUniformF4 type];
}

+ (CNClassType*)type {
    return _EGShaderUniformF4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShaderUniformI4
static CNClassType* _EGShaderUniformI4_type;
@synthesize handle = _handle;

+ (instancetype)shaderUniformI4WithHandle:(unsigned int)handle {
    return [[EGShaderUniformI4 alloc] initWithHandle:handle];
}

- (instancetype)initWithHandle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _handle = handle;
        __last = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShaderUniformI4 class]) _EGShaderUniformI4_type = [CNClassType classTypeWithCls:[EGShaderUniformI4 class]];
}

- (void)applyI4:(int)i4 {
    if(i4 != __last) {
        glUniform1i(_handle, i4);
        __last = i4;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ShaderUniformI4(%u)", _handle];
}

- (CNClassType*)type {
    return [EGShaderUniformI4 type];
}

+ (CNClassType*)type {
    return _EGShaderUniformI4_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShaderSystem
static CNClassType* _EGShaderSystem_type;

+ (instancetype)shaderSystem {
    return [[EGShaderSystem alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGShaderSystem class]) _EGShaderSystem_type = [CNClassType classTypeWithCls:[EGShaderSystem class]];
}

- (void)drawParam:(id)param vertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index {
    EGShader* shader = [self shaderForParam:param];
    [shader drawParam:param vertex:vertex index:index];
}

- (void)drawParam:(id)param vao:(EGSimpleVertexArray*)vao {
    EGShader* shader = [self shaderForParam:param];
    [shader drawParam:param vao:vao];
}

- (void)drawParam:(id)param mesh:(EGMesh*)mesh {
    EGShader* shader = [self shaderForParam:param];
    [shader drawParam:param mesh:mesh];
}

- (EGShader*)shaderForParam:(id)param {
    return [self shaderForParam:param renderTarget:EGGlobal.context.renderTarget];
}

- (EGShader*)shaderForParam:(id)param renderTarget:(EGRenderTarget*)renderTarget {
    @throw @"Method shaderFor is abstract";
}

- (EGVertexArray*)vaoParam:(id)param vbo:(id<EGVertexBuffer>)vbo ibo:(id<EGIndexSource>)ibo {
    return [[self shaderForParam:param] vaoVbo:vbo ibo:ibo];
}

- (NSString*)description {
    return @"ShaderSystem";
}

- (CNClassType*)type {
    return [EGShaderSystem type];
}

+ (CNClassType*)type {
    return _EGShaderSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGShaderTextBuilder_impl

+ (instancetype)shaderTextBuilder_impl {
    return [[EGShaderTextBuilder_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (NSString*)versionString {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)vertexHeader {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)fragmentHeader {
    return [NSString stringWithFormat:@"#version %ld\n"
        "%@", (long)[self version], [self fragColorDeclaration]];
}

- (NSString*)fragColorDeclaration {
    if([self isFragColorDeclared]) return @"";
    else return @"out lowp vec4 fragColor;";
}

- (BOOL)isFragColorDeclared {
    return EGShaderProgram.version < 110;
}

- (NSInteger)version {
    return EGShaderProgram.version;
}

- (NSString*)ain {
    if([self version] < 150) return @"attribute";
    else return @"in";
}

- (NSString*)in {
    if([self version] < 150) return @"varying";
    else return @"in";
}

- (NSString*)out {
    if([self version] < 150) return @"varying";
    else return @"out";
}

- (NSString*)fragColor {
    if([self version] > 100) return @"fragColor";
    else return @"gl_FragColor";
}

- (NSString*)texture2D {
    if([self version] > 100) return @"texture";
    else return @"texture2D";
}

- (NSString*)shadowExt {
    if([self version] == 100 && [EGGlobal.settings shadowType] == EGShadowType_shadow2d) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)sampler2DShadow {
    if([EGGlobal.settings shadowType] == EGShadowType_shadow2d) return @"sampler2DShadow";
    else return @"sampler2D";
}

- (NSString*)shadow2DTexture:(NSString*)texture vec3:(NSString*)vec3 {
    if([EGGlobal.settings shadowType] == EGShadowType_shadow2d) return [NSString stringWithFormat:@"%@(%@, %@)", [self shadow2DEXT], texture, vec3];
    else return [NSString stringWithFormat:@"(%@(%@, %@.xy).x < %@.z ? 0.0 : 1.0)", [self texture2D], texture, vec3, vec3];
}

- (NSString*)blendMode:(EGBlendModeR)mode a:(NSString*)a b:(NSString*)b {
    return EGBlendMode_Values[mode].blend(a, b);
}

- (NSString*)shadow2DEXT {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

