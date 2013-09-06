#import "EGMesh.h"

#import "CNData.h"
#import "EGSimpleShaderSystem.h"
@implementation EGMesh{
    EGVertexBuffer* _vertexBuffer;
    EGIndexBuffer* _indexBuffer;
}
static ODClassType* _EGMesh_type;
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

+ (EGMesh*)applyVertexData:(CNPArray*)vertexData index:(CNPArray*)index {
    return [EGMesh meshWithVertexBuffer:[[EGVertexBuffer applyStride:((NSUInteger)(8 * 4))] setData:vertexData] indexBuffer:[[EGIndexBuffer apply] setData:index]];
}

+ (EGMesh*)quadVertexBuffer:(EGVertexBuffer*)vertexBuffer {
    return [EGMesh applyVertexData:vertexBuffer index:[[EGIndexBuffer apply] setData:[ arrui4(6) {0, 1, 2, 2, 3, 0}]]];
}

- (ODClassType*)type {
    return [EGMesh type];
}

+ (ODClassType*)type {
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
    GLenum _bufferType;
    GLuint _handle;
    NSUInteger __length;
    NSUInteger __count;
}
static ODClassType* _EGBuffer_type;
@synthesize bufferType = _bufferType;
@synthesize handle = _handle;

+ (id)bufferWithBufferType:(GLenum)bufferType handle:(GLuint)handle {
    return [[EGBuffer alloc] initWithBufferType:bufferType handle:handle];
}

- (id)initWithBufferType:(GLenum)bufferType handle:(GLuint)handle {
    self = [super init];
    if(self) {
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

+ (EGBuffer*)applyBufferType:(GLenum)bufferType {
    return [EGBuffer bufferWithBufferType:bufferType handle:egGenBuffer()];
}

- (void)dealoc {
    egDeleteBuffer(_handle);
}

- (id)setData:(CNPArray*)data {
    return [self setData:data usage:GL_STATIC_DRAW];
}

- (id)setData:(CNPArray*)data usage:(GLenum)usage {
    glBindBuffer(_bufferType, _handle);
    glBufferData(_bufferType, data.length, data.bytes, GL_STATIC_DRAW);
    glBindBuffer(_bufferType, 0);
    __length = data.length;
    __count = data.count;
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

- (ODClassType*)type {
    return [EGBuffer type];
}

+ (ODClassType*)type {
    return _EGBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBuffer* o = ((EGBuffer*)(other));
    return GLenumEq(self.bufferType, o.bufferType) && GLuintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GLenumHash(self.bufferType);
    hash = hash * 31 + GLuintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"bufferType=%@", GLenumDescription(self.bufferType)];
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVertexBuffer{
    NSUInteger _stride;
}
static ODClassType* _EGVertexBuffer_type;
@synthesize stride = _stride;

+ (id)vertexBufferWithStride:(NSUInteger)stride handle:(GLuint)handle {
    return [[EGVertexBuffer alloc] initWithStride:stride handle:handle];
}

- (id)initWithStride:(NSUInteger)stride handle:(GLuint)handle {
    self = [super initWithBufferType:GL_ARRAY_BUFFER handle:handle];
    if(self) _stride = stride;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVertexBuffer_type = [ODClassType classTypeWithCls:[EGVertexBuffer class]];
}

+ (EGVertexBuffer*)applyStride:(NSUInteger)stride {
    return [EGVertexBuffer vertexBufferWithStride:stride handle:egGenBuffer()];
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
    return self.stride == o.stride && GLuintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.stride;
    hash = hash * 31 + GLuintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"stride=%li", self.stride];
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGIndexBuffer
static ODClassType* _EGIndexBuffer_type;

+ (id)indexBufferWithHandle:(GLuint)handle {
    return [[EGIndexBuffer alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super initWithBufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle];
    
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

+ (ODClassType*)type {
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


