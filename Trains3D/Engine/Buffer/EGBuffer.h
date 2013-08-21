#import "objd.h"
@class NSData;
@class CNData;

@class EGBuffer;

@interface EGBuffer : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)bufferWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
+ (EGBuffer*)createWithBufferType:(GLenum)bufferType size:(NSUInteger)size data:(void*)data usage:(GLenum)usage;
- (void)dealoc;
@end


