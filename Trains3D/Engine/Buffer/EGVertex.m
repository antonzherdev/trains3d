#import "EGVertex.h"

#import "EGShader.h"
#import "EGContext.h"
@implementation EGVertexBufferDesc{
    ODPType* _dataType;
    int _position;
    int _uv;
    int _normal;
    int _color;
    int _model;
}
static ODClassType* _EGVertexBufferDesc_type;
@synthesize dataType = _dataType;
@synthesize position = _position;
@synthesize uv = _uv;
@synthesize normal = _normal;
@synthesize color = _color;
@synthesize model = _model;

+ (id)vertexBufferDescWithDataType:(ODPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model {
    return [[EGVertexBufferDesc alloc] initWithDataType:dataType position:position uv:uv normal:normal color:color model:model];
}

- (id)initWithDataType:(ODPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model {
    self = [super init];
    if(self) {
        _dataType = dataType;
        _position = position;
        _uv = uv;
        _normal = normal;
        _color = color;
        _model = model;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVertexBufferDesc_type = [ODClassType classTypeWithCls:[EGVertexBufferDesc class]];
}

- (unsigned int)stride {
    return ((unsigned int)(_dataType.size));
}

+ (EGVertexBufferDesc*)Vec2 {
    return [EGVertexBufferDesc vertexBufferDescWithDataType:geVec2Type() position:-1 uv:0 normal:-1 color:-1 model:0];
}

+ (EGVertexBufferDesc*)Vec3 {
    return [EGVertexBufferDesc vertexBufferDescWithDataType:geVec3Type() position:0 uv:0 normal:0 color:-1 model:0];
}

+ (EGVertexBufferDesc*)Vec4 {
    return [EGVertexBufferDesc vertexBufferDescWithDataType:geVec4Type() position:0 uv:0 normal:0 color:0 model:0];
}

+ (EGVertexBufferDesc*)mesh {
    return [EGVertexBufferDesc vertexBufferDescWithDataType:egMeshDataType() position:((int)(5 * 4)) uv:0 normal:((int)(2 * 4)) color:-1 model:-1];
}

- (ODClassType*)type {
    return [EGVertexBufferDesc type];
}

+ (ODClassType*)type {
    return _EGVertexBufferDesc_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVertexBufferDesc* o = ((EGVertexBufferDesc*)(other));
    return [self.dataType isEqual:o.dataType] && self.position == o.position && self.uv == o.uv && self.normal == o.normal && self.color == o.color && self.model == o.model;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.dataType hash];
    hash = hash * 31 + self.position;
    hash = hash * 31 + self.uv;
    hash = hash * 31 + self.normal;
    hash = hash * 31 + self.color;
    hash = hash * 31 + self.model;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"dataType=%@", self.dataType];
    [description appendFormat:@", position=%d", self.position];
    [description appendFormat:@", uv=%d", self.uv];
    [description appendFormat:@", normal=%d", self.normal];
    [description appendFormat:@", color=%d", self.color];
    [description appendFormat:@", model=%d", self.model];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVertexBuffer{
    EGVertexBufferDesc* _desc;
}
static ODClassType* _EGVertexBuffer_type;
@synthesize desc = _desc;

+ (id)vertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle {
    return [[EGVertexBuffer alloc] initWithDesc:desc handle:handle];
}

- (id)initWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle {
    self = [super initWithDataType:desc.dataType bufferType:GL_ARRAY_BUFFER handle:handle];
    if(self) _desc = desc;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVertexBuffer_type = [ODClassType classTypeWithCls:[EGVertexBuffer class]];
}

+ (EGVertexBuffer*)applyDesc:(EGVertexBufferDesc*)desc {
    return [EGVertexBuffer vertexBufferWithDesc:desc handle:egGenBuffer()];
}

+ (EGVertexBuffer*)vec2 {
    return [EGVertexBuffer vertexBufferWithDesc:[EGVertexBufferDesc Vec2] handle:egGenBuffer()];
}

+ (EGVertexBuffer*)vec3 {
    return [EGVertexBuffer vertexBufferWithDesc:[EGVertexBufferDesc Vec3] handle:egGenBuffer()];
}

+ (EGVertexBuffer*)vec4 {
    return [EGVertexBuffer vertexBufferWithDesc:[EGVertexBufferDesc Vec4] handle:egGenBuffer()];
}

+ (EGVertexBuffer*)mesh {
    return [EGVertexBuffer vertexBufferWithDesc:[EGVertexBufferDesc mesh] handle:egGenBuffer()];
}

- (void)bind {
    [EGGlobal.context bindVertexBufferBuffer:self];
}

- (void)bindWithShader:(EGShader*)shader {
    [EGGlobal.context bindVertexBufferBuffer:self];
    [shader loadAttributesVbDesc:_desc];
}

- (void)unbindWithShader:(EGShader*)shader {
}

- (ODClassType*)type {
    return [EGVertexBuffer type];
}

+ (ODClassType*)type {
    return _EGVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVertexBuffer* o = ((EGVertexBuffer*)(other));
    return [self.desc isEqual:o.desc] && GLuintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.desc hash];
    hash = hash * 31 + GLuintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"desc=%@", self.desc];
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVertexArray{
    GLuint _handle;
    id<CNSeq> _buffers;
}
static ODClassType* _EGVertexArray_type;
@synthesize handle = _handle;
@synthesize buffers = _buffers;

+ (id)vertexArrayWithHandle:(GLuint)handle buffers:(id<CNSeq>)buffers {
    return [[EGVertexArray alloc] initWithHandle:handle buffers:buffers];
}

- (id)initWithHandle:(GLuint)handle buffers:(id<CNSeq>)buffers {
    self = [super init];
    if(self) {
        _handle = handle;
        _buffers = buffers;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVertexArray_type = [ODClassType classTypeWithCls:[EGVertexArray class]];
}

+ (EGVertexArray*)applyShader:(EGShader*)shader buffer:(EGVertexBuffer*)buffer {
    GLuint h = egGenVertexArray();
    [EGGlobal.context bindVertexArrayHandle:h];
    [buffer bind];
    [shader loadAttributesVbDesc:buffer.desc];
    [EGGlobal.context bindDefaultVertexArray];
    return [EGVertexArray vertexArrayWithHandle:h buffers:(@[buffer])];
}

- (void)bind {
    [EGGlobal.context bindVertexArrayHandle:_handle];
}

- (void)bindWithShader:(EGShader*)shader {
    [EGGlobal.context bindVertexArrayHandle:_handle];
}

- (void)unbindWithShader:(EGShader*)shader {
    [EGGlobal.context bindDefaultVertexArray];
}

- (void)dealloc {
    egDeleteVertexArray(_handle);
}

- (NSUInteger)count {
    return [((EGVertexBuffer*)([_buffers head])) count];
}

- (ODClassType*)type {
    return [EGVertexArray type];
}

+ (ODClassType*)type {
    return _EGVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVertexArray* o = ((EGVertexArray*)(other));
    return GLuintEq(self.handle, o.handle) && [self.buffers isEqual:o.buffers];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GLuintHash(self.handle);
    hash = hash * 31 + [self.buffers hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%@", GLuintDescription(self.handle)];
    [description appendFormat:@", buffers=%@", self.buffers];
    [description appendString:@">"];
    return description;
}

@end


