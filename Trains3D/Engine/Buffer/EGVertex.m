#import "EGVertex.h"

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
    NSUInteger _length;
    NSUInteger _count;
}
static ODClassType* _EGVertexBuffer_type;
@synthesize desc = _desc;
@synthesize length = _length;
@synthesize count = _count;

+ (id)vertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle length:(NSUInteger)length count:(NSUInteger)count {
    return [[EGVertexBuffer alloc] initWithDesc:desc handle:handle length:length count:count];
}

- (id)initWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle length:(NSUInteger)length count:(NSUInteger)count {
    self = [super initWithDataType:desc.dataType bufferType:GL_ARRAY_BUFFER handle:handle];
    if(self) {
        _desc = desc;
        _length = length;
        _count = count;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVertexBuffer_type = [ODClassType classTypeWithCls:[EGVertexBuffer class]];
}

+ (EGVertexBuffer*)applyDesc:(EGVertexBufferDesc*)desc array:(CNVoidRefArray)array {
    EGVertexBuffer* vb = [EGVertexBuffer vertexBufferWithDesc:desc handle:egGenBuffer() length:array.length count:array.length / desc.dataType.size];
    [vb bind];
    glBufferData(GL_ARRAY_BUFFER, array.length, array.bytes, GL_STATIC_DRAW);
    return vb;
}

+ (EGVertexBuffer*)applyDesc:(EGVertexBufferDesc*)desc data:(CNPArray*)data {
    EGVertexBuffer* vb = [EGVertexBuffer vertexBufferWithDesc:desc handle:egGenBuffer() length:data.length count:data.count];
    [vb bind];
    glBufferData(GL_ARRAY_BUFFER, data.length, data.bytes, GL_STATIC_DRAW);
    return vb;
}

+ (EGVertexBuffer*)vec4Data:(CNPArray*)data {
    return [EGVertexBuffer applyDesc:[EGVertexBufferDesc Vec4] data:data];
}

+ (EGVertexBuffer*)vec2Data:(CNPArray*)data {
    return [EGVertexBuffer applyDesc:[EGVertexBufferDesc Vec4] data:data];
}

+ (EGVertexBuffer*)meshData:(CNPArray*)data {
    return [EGVertexBuffer applyDesc:[EGVertexBufferDesc mesh] data:data];
}

- (void)bind {
    [EGGlobal.context bindVertexBufferBuffer:self];
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
    return [self.desc isEqual:o.desc] && GLuintEq(self.handle, o.handle) && self.length == o.length && self.count == o.count;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.desc hash];
    hash = hash * 31 + GLuintHash(self.handle);
    hash = hash * 31 + self.length;
    hash = hash * 31 + self.count;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"desc=%@", self.desc];
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendFormat:@", length=%li", self.length];
    [description appendFormat:@", count=%li", self.count];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableVertexBuffer{
    EGVertexBufferDesc* _desc;
    GLuint _handle;
}
static ODClassType* _EGMutableVertexBuffer_type;
@synthesize desc = _desc;
@synthesize handle = _handle;

+ (id)mutableVertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle {
    return [[EGMutableVertexBuffer alloc] initWithDesc:desc handle:handle];
}

- (id)initWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle {
    self = [super initWithDataType:desc.dataType bufferType:GL_ARRAY_BUFFER handle:handle];
    if(self) {
        _desc = desc;
        _handle = handle;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMutableVertexBuffer_type = [ODClassType classTypeWithCls:[EGMutableVertexBuffer class]];
}

+ (EGMutableVertexBuffer*)applyDesc:(EGVertexBufferDesc*)desc {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:desc handle:egGenBuffer()];
}

+ (EGMutableVertexBuffer*)vec2 {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc Vec2] handle:egGenBuffer()];
}

+ (EGMutableVertexBuffer*)vec3 {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc Vec3] handle:egGenBuffer()];
}

+ (EGMutableVertexBuffer*)vec4 {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc Vec4] handle:egGenBuffer()];
}

+ (EGMutableVertexBuffer*)mesh {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc mesh] handle:egGenBuffer()];
}

- (void)bind {
    [EGGlobal.context bindVertexBufferBuffer:self];
}

- (ODClassType*)type {
    return [EGMutableVertexBuffer type];
}

+ (ODClassType*)type {
    return _EGMutableVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMutableVertexBuffer* o = ((EGMutableVertexBuffer*)(other));
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


