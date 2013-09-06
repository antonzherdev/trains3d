#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
@class CNMutablePArray;
#import "EGGL.h"
@class EGSimpleShaderSystem;
@class EGSimpleShader;
@class EGSimpleColorShader;
@class EGSimpleTextureShader;
#import "EGTypes.h"

@class EGMesh;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;

@interface EGMesh : NSObject
@property (nonatomic, readonly) EGVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) EGIndexBuffer* indexBuffer;

+ (id)meshWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer;
- (id)initWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer;
- (ODClassType*)type;
+ (EGMesh*)applyVertexData:(CNPArray*)vertexData index:(CNPArray*)index;
+ (EGMesh*)quadVertexBuffer:(EGVertexBuffer*)vertexBuffer;
+ (ODClassType*)type;
@end


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


