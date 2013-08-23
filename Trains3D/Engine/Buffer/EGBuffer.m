#import "EGBuffer.h"

#import "CNData.h"
#import "EGGL.h"
@implementation EGBuffer{
    GLenum _bufferType;
    NSUInteger _stride;
    GLuint _handle;
    NSUInteger __length;
}
@synthesize bufferType = _bufferType;
@synthesize stride = _stride;
@synthesize handle = _handle;

+ (id)bufferWithBufferType:(GLenum)bufferType stride:(NSUInteger)stride handle:(GLuint)handle {
    return [[EGBuffer alloc] initWithBufferType:bufferType stride:stride handle:handle];
}

- (id)initWithBufferType:(GLenum)bufferType stride:(NSUInteger)stride handle:(GLuint)handle {
    self = [super init];
    if(self) {
        _bufferType = bufferType;
        _stride = stride;
        _handle = handle;
        __length = ((NSUInteger)(0));
    }
    
    return self;
}

- (NSUInteger)length {
    return __length;
}

+ (EGBuffer*)applyBufferType:(GLenum)bufferType stride:(NSUInteger)stride {
    return [EGBuffer bufferWithBufferType:bufferType stride:stride handle:egGenBuffer()];
}

- (void)dealoc {
    egDeleteBuffer(_handle);
}

- (EGBuffer*)setData:(void*)data length:(NSUInteger)length {
    return [self setData:data length:length usage:GL_STATIC_DRAW];
}

- (EGBuffer*)setData:(void*)data length:(NSUInteger)length usage:(GLenum)usage {
    glBindBuffer(_bufferType, _handle);
    glBufferData(_bufferType, length, data, GL_STATIC_DRAW);
    glBindBuffer(_bufferType, 0);
    __length = length;
    return self;
}

- (void)bind {
    glBindBuffer(_bufferType, _handle);
}

- (void)clear {
    glBindBuffer(_bufferType, 0);
}

- (void)draw {
    [self bind];
    glDrawElements(GL_TRIANGLES, __length, GL_UNSIGNED_BYTE, 0);
    [self clear];
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBuffer* o = ((EGBuffer*)(other));
    return GLenumEq(self.bufferType, o.bufferType) && self.stride == o.stride && GLuintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GLenumHash(self.bufferType);
    hash = hash * 31 + self.stride;
    hash = hash * 31 + GLuintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"bufferType=%@", GLenumDescription(self.bufferType)];
    [description appendFormat:@", stride=%li", self.stride];
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


