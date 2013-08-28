#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
@class EG;
#import "EGGL.h"

@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;

@interface EGBuffer : NSObject
@property (nonatomic, readonly) GLenum bufferType;
@property (nonatomic, readonly) GLuint handle;

+ (id)bufferWithBufferType:(GLenum)bufferType handle:(GLuint)handle;
- (id)initWithBufferType:(GLenum)bufferType handle:(GLuint)handle;
- (NSUInteger)length;
+ (EGBuffer*)applyBufferType:(GLenum)bufferType;
- (void)dealoc;
- (id)setData:(CNPArray*)data;
- (id)setData:(CNPArray*)data usage:(GLenum)usage;
- (void)bind;
- (void)unbind;
- (void)applyDraw:(void(^)())draw;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGVertexBuffer : EGBuffer
@property (nonatomic, readonly) NSUInteger stride;

+ (id)vertexBufferWithStride:(NSUInteger)stride handle:(GLuint)handle;
- (id)initWithStride:(NSUInteger)stride handle:(GLuint)handle;
+ (EGVertexBuffer*)applyStride:(NSUInteger)stride;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGIndexBuffer : EGBuffer
+ (id)indexBufferWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
+ (EGIndexBuffer*)apply;
- (void)draw;
- (ODType*)type;
+ (ODType*)type;
@end


