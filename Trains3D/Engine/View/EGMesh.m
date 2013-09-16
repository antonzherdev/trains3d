#import "EGMesh.h"

ODType* egMeshDataType() {
    static ODType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGMeshDataWrap class] name:@"EGMeshData" size:sizeof(EGMeshData) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGMeshData, ((EGMeshData*)(data))[i]);
    }];
    return _ret;
}
@implementation EGMeshDataWrap{
    EGMeshData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGMeshData)value {
    return [[EGMeshDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGMeshData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGMeshDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMeshDataWrap* o = ((EGMeshDataWrap*)(other));
    return EGMeshDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGMeshDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation EGMesh{
    EGVertexBuffer* _vertexBuffer;
    EGIndexBuffer* _indexBuffer;
}
static ODType* _EGMesh_type;
@synthesize vertexBuffer = _vertexBuffer;
@synthesize indexBuffer = _indexBuffer;

+ (id)meshWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer {
    return [[EGMesh alloc] initWithVertexBuffer:vertexBuffer indexBuffer:indexBuffer];
}

- (id)initWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer {
    self = [super init];
    if(self) {
        _vertexBuffer = vertexBuffer;
        _indexBuffer = indexBuffer;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMesh_type = [ODClassType classTypeWithCls:[EGMesh class]];
}

+ (EGMesh*)applyDataType:(ODPType*)dataType vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGMesh meshWithVertexBuffer:[[EGVertexBuffer applyDataType:dataType] setData:vertexData] indexBuffer:[[EGIndexBuffer apply] setData:indexData]];
}

+ (EGMesh*)quadVertexBuffer:(EGVertexBuffer*)vertexBuffer {
    return [EGMesh meshWithVertexBuffer:vertexBuffer indexBuffer:[[EGIndexBuffer apply] setData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]]];
}

- (ODClassType*)type {
    return [EGMesh type];
}

+ (ODType*)type {
    return _EGMesh_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMesh* o = ((EGMesh*)(other));
    return [self.vertexBuffer isEqual:o.vertexBuffer] && [self.indexBuffer isEqual:o.indexBuffer];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.vertexBuffer hash];
    hash = hash * 31 + [self.indexBuffer hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vertexBuffer=%@", self.vertexBuffer];
    [description appendFormat:@", indexBuffer=%@", self.indexBuffer];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBuffer{
    ODPType* _dataType;
    GLenum _bufferType;
    GLuint _handle;
    NSUInteger __length;
    NSUInteger __count;
}
static ODType* _EGBuffer_type;
@synthesize dataType = _dataType;
@synthesize bufferType = _bufferType;
@synthesize handle = _handle;

+ (id)bufferWithDataType:(ODPType*)dataType bufferType:(GLenum)bufferType handle:(GLuint)handle {
    return [[EGBuffer alloc] initWithDataType:dataType bufferType:bufferType handle:handle];
}

- (id)initWithDataType:(ODPType*)dataType bufferType:(GLenum)bufferType handle:(GLuint)handle {
    self = [super init];
    if(self) {
        _dataType = dataType;
        _bufferType = bufferType;
        _handle = handle;
        __length = 0;
        __count = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBuffer_type = [ODClassType classTypeWithCls:[EGBuffer class]];
}

- (NSUInteger)length {
    return __length;
}

- (NSUInteger)count {
    return __count;
}

+ (EGBuffer*)applyDataType:(ODPType*)dataType bufferType:(GLenum)bufferType {
    return [EGBuffer bufferWithDataType:dataType bufferType:bufferType handle:egGenBuffer()];
}

- (void)dealoc {
    egDeleteBuffer(_handle);
}

- (id)setData:(CNPArray*)data {
    return [self setData:data usage:GL_STATIC_DRAW];
}

- (id)setArray:(CNVoidRefArray)array {
    return [self setArray:array usage:GL_STATIC_DRAW];
}

- (id)setData:(CNPArray*)data usage:(GLenum)usage {
    glBindBuffer(_bufferType, _handle);
    glBufferData(_bufferType, data.length, data.bytes, GL_STATIC_DRAW);
    glBindBuffer(_bufferType, 0);
    __length = data.length;
    __count = data.count;
    return self;
}

- (id)setArray:(CNVoidRefArray)array usage:(GLenum)usage {
    glBindBuffer(_bufferType, _handle);
    glBufferData(_bufferType, array.length, array.bytes, GL_STATIC_DRAW);
    glBindBuffer(_bufferType, 0);
    __length = array.length;
    __count = array.length / _dataType.size;
    return self;
}

- (id)updateStart:(NSUInteger)start count:(NSUInteger)count array:(CNVoidRefArray)array {
    glBindBuffer(_bufferType, _handle);
    glBufferSubData(_bufferType, start * _dataType.size, count * _dataType.size, array.bytes);
    glBindBuffer(_bufferType, 0);
    return self;
}

- (void)bind {
    glBindBuffer(_bufferType, _handle);
}

- (void)unbind {
    glBindBuffer(_bufferType, 0);
}

- (void)applyDraw:(void(^)())draw {
    [self bind];
    ((void(^)())(draw))();
    [self unbind];
}

- (NSUInteger)stride {
    return _dataType.size;
}

- (ODClassType*)type {
    return [EGBuffer type];
}

+ (ODType*)type {
    return _EGBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBuffer* o = ((EGBuffer*)(other));
    return [self.dataType isEqual:o.dataType] && GLenumEq(self.bufferType, o.bufferType) && GLuintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.dataType hash];
    hash = hash * 31 + GLenumHash(self.bufferType);
    hash = hash * 31 + GLuintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"dataType=%@", self.dataType];
    [description appendFormat:@", bufferType=%@", GLenumDescription(self.bufferType)];
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVertexBuffer
static ODType* _EGVertexBuffer_type;

+ (id)vertexBufferWithDataType:(ODPType*)dataType handle:(GLuint)handle {
    return [[EGVertexBuffer alloc] initWithDataType:dataType handle:handle];
}

- (id)initWithDataType:(ODPType*)dataType handle:(GLuint)handle {
    self = [super initWithDataType:dataType bufferType:GL_ARRAY_BUFFER handle:handle];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVertexBuffer_type = [ODClassType classTypeWithCls:[EGVertexBuffer class]];
}

+ (EGVertexBuffer*)applyDataType:(ODPType*)dataType {
    return [EGVertexBuffer vertexBufferWithDataType:dataType handle:egGenBuffer()];
}

- (ODClassType*)type {
    return [EGVertexBuffer type];
}

+ (ODType*)type {
    return _EGVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVertexBuffer* o = ((EGVertexBuffer*)(other));
    return [self.dataType isEqual:o.dataType] && GLuintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.dataType hash];
    hash = hash * 31 + GLuintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"dataType=%@", self.dataType];
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGIndexBuffer
static ODType* _EGIndexBuffer_type;

+ (id)indexBufferWithHandle:(GLuint)handle {
    return [[EGIndexBuffer alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super initWithDataType:oduInt4Type() bufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGIndexBuffer_type = [ODClassType classTypeWithCls:[EGIndexBuffer class]];
}

+ (EGIndexBuffer*)apply {
    return [EGIndexBuffer indexBufferWithHandle:egGenBuffer()];
}

- (void)draw {
    [self bind];
    glDrawElements(GL_TRIANGLES, [self count], GL_UNSIGNED_INT, 0);
    [self unbind];
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [self bind];
    glDrawElements(GL_TRIANGLES, count, GL_UNSIGNED_INT, 4 * start);
    [self unbind];
}

- (void)drawByQuads {
    [self bind];
    NSInteger i = 0;
    while(i + 6 <= [self count]) {
        glDrawElements(GL_TRIANGLES, 6, GL_UNSIGNED_INT, 4 * i);
        i += 6;
    }
    [self unbind];
}

- (ODClassType*)type {
    return [EGIndexBuffer type];
}

+ (ODType*)type {
    return _EGIndexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGIndexBuffer* o = ((EGIndexBuffer*)(other));
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


