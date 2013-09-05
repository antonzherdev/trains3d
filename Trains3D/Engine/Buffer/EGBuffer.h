#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
@class CNMutablePArray;
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGGL.h"
@class EGMatrix;

@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;

@interface EGBuffer : NSObject
@property (nonatomic, readonly) GLenum bufferType;
@property (nonatomic, readonly) GLuint handle;

+ (id)bufferWithBufferType:(GLenum)bufferType handle:(GLuint)handle;
- (id)initWithBufferType:(GLenum)bufferType handle:(GLuint)handle;
- (ODClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
+ (EGBuffer*)applyBufferType:(GLenum)bufferType;
- (void)dealoc;
- (id)setData:(CNPArray*)data;
- (id)setData:(CNPArray*)data usage:(GLenum)usage;
- (void)bind;
- (void)unbind;
- (void)applyDraw:(void(^)())draw;
+ (ODClassType*)type;
@end


@interface EGVertexBuffer : EGBuffer
@property (nonatomic, readonly) NSUInteger stride;

+ (id)vertexBufferWithStride:(NSUInteger)stride handle:(GLuint)handle;
- (id)initWithStride:(NSUInteger)stride handle:(GLuint)handle;
- (ODClassType*)type;
+ (EGVertexBuffer*)applyStride:(NSUInteger)stride;
+ (ODClassType*)type;
@end


@interface EGIndexBuffer : EGBuffer
+ (id)indexBufferWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
+ (EGIndexBuffer*)apply;
- (void)draw;
- (void)drawByQuads;
+ (ODClassType*)type;
@end


