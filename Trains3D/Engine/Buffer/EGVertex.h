#import "objd.h"
#import "GEVec.h"
#import "EGMesh.h"
#import "EGBuffer.h"
#import "GL.h"
@class EGShader;
@class EGGlobal;
@class EGContext;

@class EGVertexBufferDesc;
@class EGVertexBuffer;
@class EGMutableVertexBuffer;
@class EGVertexArray;
@protocol EGVertexSource;

@protocol EGVertexSource<NSObject>
- (void)bindWithShader:(EGShader*)shader;
- (void)unbindWithShader:(EGShader*)shader;
- (NSUInteger)count;
@end


@interface EGVertexBufferDesc : NSObject
@property (nonatomic, readonly) ODPType* dataType;
@property (nonatomic, readonly) int position;
@property (nonatomic, readonly) int uv;
@property (nonatomic, readonly) int normal;
@property (nonatomic, readonly) int color;
@property (nonatomic, readonly) int model;

+ (id)vertexBufferDescWithDataType:(ODPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model;
- (id)initWithDataType:(ODPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model;
- (ODClassType*)type;
- (unsigned int)stride;
+ (EGVertexBufferDesc*)Vec2;
+ (EGVertexBufferDesc*)Vec3;
+ (EGVertexBufferDesc*)Vec4;
+ (EGVertexBufferDesc*)mesh;
+ (ODClassType*)type;
@end


@interface EGVertexBuffer : EGBuffer<EGVertexSource>
@property (nonatomic, readonly) EGVertexBufferDesc* desc;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger count;

+ (id)vertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle length:(NSUInteger)length count:(NSUInteger)count;
- (id)initWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle length:(NSUInteger)length count:(NSUInteger)count;
- (ODClassType*)type;
+ (EGVertexBuffer*)applyDesc:(EGVertexBufferDesc*)desc array:(CNVoidRefArray)array;
+ (EGVertexBuffer*)applyDesc:(EGVertexBufferDesc*)desc data:(CNPArray*)data;
+ (EGVertexBuffer*)vec4Data:(CNPArray*)data;
+ (EGVertexBuffer*)vec4Data:(CNPArray*)data;
+ (EGVertexBuffer*)vec2Data:(CNPArray*)data;
+ (EGVertexBuffer*)meshData:(CNPArray*)data;
- (void)bind;
- (void)bindWithShader:(EGShader*)shader;
+ (ODClassType*)type;
@end


@interface EGMutableVertexBuffer : EGMutableBuffer<EGVertexSource>
@property (nonatomic, readonly) EGVertexBufferDesc* desc;
@property (nonatomic, readonly) GLuint handle;

+ (id)mutableVertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle;
- (id)initWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle;
- (ODClassType*)type;
+ (EGMutableVertexBuffer*)applyDesc:(EGVertexBufferDesc*)desc;
+ (EGMutableVertexBuffer*)vec2;
+ (EGMutableVertexBuffer*)vec3;
+ (EGMutableVertexBuffer*)vec4;
+ (EGMutableVertexBuffer*)mesh;
- (void)bind;
- (void)bindWithShader:(EGShader*)shader;
+ (ODClassType*)type;
@end


@interface EGVertexArray : NSObject<EGVertexSource>
@property (nonatomic, readonly) GLuint handle;
@property (nonatomic, readonly) id<CNSeq> buffers;

+ (id)vertexArrayWithHandle:(GLuint)handle buffers:(id<CNSeq>)buffers;
- (id)initWithHandle:(GLuint)handle buffers:(id<CNSeq>)buffers;
- (ODClassType*)type;
+ (EGVertexArray*)applyBuffers:(id<CNSeq>)buffers;
- (void)bind;
- (void)bindWithShader:(EGShader*)shader;
- (void)unbindWithShader:(EGShader*)shader;
- (void)unbind;
- (void)dealloc;
- (NSUInteger)count;
+ (ODClassType*)type;
@end


