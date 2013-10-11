#import "objd.h"
#import "GEVec.h"
#import "EGMesh.h"
#import "EGBuffer.h"
#import "GL.h"
@class EGGlobal;
@class EGContext;

@class EGVertexBufferDesc;
@class EGVertexBuffer;
@class EGMutableVertexBuffer;

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


@interface EGVertexBuffer : EGBuffer
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
+ (ODClassType*)type;
@end


@interface EGMutableVertexBuffer : EGMutableBuffer
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
+ (ODClassType*)type;
@end


