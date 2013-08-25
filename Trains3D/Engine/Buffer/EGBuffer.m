#import "EGBuffer.h"

#import "CNData.h"
@implementation EGBuffer{
    GLenum _bufferType;
    GLuint _handle;
    NSUInteger __length;
}
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
    }
    
    return self;
}

- (NSUInteger)length {
    return __length;
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
    __length = [self length];
    return self;
}

- (void)bind {
    glBindBuffer(_bufferType, _handle);
}

- (void)clear {
    glBindBuffer(_bufferType, 0);
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
@synthesize stride = _stride;

+ (id)vertexBufferWithStride:(NSUInteger)stride handle:(GLuint)handle {
    return [[EGVertexBuffer alloc] initWithStride:stride handle:handle];
}

- (id)initWithStride:(NSUInteger)stride handle:(GLuint)handle {
    self = [super initWithBufferType:GL_ARRAY_BUFFER handle:handle];
    if(self) _stride = stride;
    
    return self;
}

+ (EGVertexBuffer*)applyStride:(NSUInteger)stride {
    return [EGVertexBuffer vertexBufferWithStride:stride handle:egGenBuffer()];
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

+ (id)indexBufferWithHandle:(GLuint)handle {
    return [[EGIndexBuffer alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super initWithBufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle];
    
    return self;
}

+ (EGIndexBuffer*)apply {
    return [EGIndexBuffer indexBufferWithHandle:egGenBuffer()];
}

- (void)draw {
    [self bind];
    glDrawElements(GL_TRIANGLES, [self length], GL_UNSIGNED_BYTE, 0);
    [self clear];
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


