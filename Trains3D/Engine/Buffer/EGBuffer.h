#import "objd.h"
@class NSData;
@class CNData;

@class EGBuffer;

@interface EGBuffer : NSObject
@property (nonatomic, readonly) GLenum bufferType;
@property (nonatomic, readonly) NSUInteger stride;
@property (nonatomic, readonly) GLuint handle;

+ (id)bufferWithBufferType:(GLenum)bufferType stride:(NSUInteger)stride handle:(GLuint)handle;
- (id)initWithBufferType:(GLenum)bufferType stride:(NSUInteger)stride handle:(GLuint)handle;
- (NSUInteger)length;
+ (EGBuffer*)createWithBufferType:(GLenum)bufferType stride:(NSUInteger)stride;
- (void)dealoc;
- (EGBuffer*)setData:(void*)data length:(NSUInteger)length;
- (EGBuffer*)setData:(void*)data length:(NSUInteger)length usage:(GLenum)usage;
- (void)bind;
- (void)clear;
- (void)draw;
@end


