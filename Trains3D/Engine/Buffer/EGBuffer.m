#import "EGBuffer.h"

#import "CNData.h"
#import "EGGL.h"
@implementation EGBuffer{
    GLuint _handle;
}
@synthesize handle = _handle;

+ (id)bufferWithHandle:(GLuint)handle {
    return [[EGBuffer alloc] initWithHandle:handle];
}

- (id)initWithHandle:(GLuint)handle {
    self = [super init];
    if(self) _handle = handle;
    
    return self;
}

+ (EGBuffer*)createWithBufferType:(GLenum)bufferType size:(NSUInteger)size data:(void*)data usage:(GLenum)usage {
    GLuint handle = egGenBuffer();
    glBindBuffer(GL_ARRAY_BUFFER, handle);
    glBufferData(GL_ARRAY_BUFFER, size, data, GL_STATIC_DRAW);
    return [EGBuffer bufferWithHandle:handle];
}

- (void)dealoc {
    egDeleteBuffer(_handle);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBuffer* o = ((EGBuffer*)(other));
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


