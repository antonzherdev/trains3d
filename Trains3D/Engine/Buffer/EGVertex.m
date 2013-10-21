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


@implementation EGVBO
static ODClassType* _EGVBO_type;

+ (void)initialize {
    [super initialize];
    _EGVBO_type = [ODClassType classTypeWithCls:[EGVBO class]];
}

+ (id<EGVertexBuffer>)applyDesc:(EGVertexBufferDesc*)desc array:(CNVoidRefArray)array {
    EGImmutableVertexBuffer* vb = [EGImmutableVertexBuffer immutableVertexBufferWithDesc:desc handle:egGenBuffer() length:array.length count:array.length / desc.dataType.size];
    [vb bind];
    glBufferData(GL_ARRAY_BUFFER, array.length, array.bytes, GL_STATIC_DRAW);
    return vb;
}

+ (id<EGVertexBuffer>)applyDesc:(EGVertexBufferDesc*)desc data:(CNPArray*)data {
    EGImmutableVertexBuffer* vb = [EGImmutableVertexBuffer immutableVertexBufferWithDesc:desc handle:egGenBuffer() length:data.length count:data.count];
    [vb bind];
    glBufferData(GL_ARRAY_BUFFER, data.length, data.bytes, GL_STATIC_DRAW);
    return vb;
}

+ (id<EGVertexBuffer>)vec4Data:(CNPArray*)data {
    return [EGVBO applyDesc:[EGVertexBufferDesc Vec4] data:data];
}

+ (id<EGVertexBuffer>)vec3Data:(CNPArray*)data {
    return [EGVBO applyDesc:[EGVertexBufferDesc Vec3] data:data];
}

+ (id<EGVertexBuffer>)vec2Data:(CNPArray*)data {
    return [EGVBO applyDesc:[EGVertexBufferDesc Vec2] data:data];
}

+ (id<EGVertexBuffer>)meshData:(CNPArray*)data {
    return [EGVBO applyDesc:[EGVertexBufferDesc mesh] data:data];
}

+ (EGMutableVertexBuffer*)mutDesc:(EGVertexBufferDesc*)desc {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:desc handle:egGenBuffer()];
}

+ (EGMutableVertexBuffer*)mutVec2 {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc Vec2] handle:egGenBuffer()];
}

+ (EGMutableVertexBuffer*)mutVec3 {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc Vec3] handle:egGenBuffer()];
}

+ (EGMutableVertexBuffer*)mutVec4 {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc Vec4] handle:egGenBuffer()];
}

+ (EGMutableVertexBuffer*)mutMesh {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc mesh] handle:egGenBuffer()];
}

- (ODClassType*)type {
    return [EGVBO type];
}

+ (ODClassType*)type {
    return _EGVBO_type;
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


@implementation EGImmutableVertexBuffer{
    EGVertexBufferDesc* _desc;
    NSUInteger _length;
    NSUInteger _count;
}
static ODClassType* _EGImmutableVertexBuffer_type;
@synthesize desc = _desc;
@synthesize length = _length;
@synthesize count = _count;

+ (id)immutableVertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle length:(NSUInteger)length count:(NSUInteger)count {
    return [[EGImmutableVertexBuffer alloc] initWithDesc:desc handle:handle length:length count:count];
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
    _EGImmutableVertexBuffer_type = [ODClassType classTypeWithCls:[EGImmutableVertexBuffer class]];
}

- (void)bind {
    [EGGlobal.context bindVertexBufferBuffer:self];
}

- (BOOL)isMutable {
    return NO;
}

- (ODClassType*)type {
    return [EGImmutableVertexBuffer type];
}

+ (ODClassType*)type {
    return _EGImmutableVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGImmutableVertexBuffer* o = ((EGImmutableVertexBuffer*)(other));
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
    [description appendFormat:@", length=%lu", (unsigned long)self.length];
    [description appendFormat:@", count=%lu", (unsigned long)self.count];
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

- (BOOL)isMutable {
    return YES;
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


