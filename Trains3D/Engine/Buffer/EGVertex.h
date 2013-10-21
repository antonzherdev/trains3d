#import "objd.h"
#import "GEVec.h"
#import "EGMesh.h"
#import "GL.h"
#import "EGBuffer.h"
@class EGGlobal;
@class EGContext;

@class EGVertexBufferDesc;
@class EGVBO;
@class EGImmutableVertexBuffer;
@class EGMutableVertexBuffer;
@protocol EGVertexBuffer;

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


@interface EGVBO : NSObject
- (ODClassType*)type;
+ (id<EGVertexBuffer>)applyDesc:(EGVertexBufferDesc*)desc array:(CNVoidRefArray)array;
+ (id<EGVertexBuffer>)applyDesc:(EGVertexBufferDesc*)desc data:(CNPArray*)data;
+ (id<EGVertexBuffer>)vec4Data:(CNPArray*)data;
+ (id<EGVertexBuffer>)vec3Data:(CNPArray*)data;
+ (id<EGVertexBuffer>)vec2Data:(CNPArray*)data;
+ (id<EGVertexBuffer>)meshData:(CNPArray*)data;
+ (EGMutableVertexBuffer*)mutDesc:(EGVertexBufferDesc*)desc;
+ (EGMutableVertexBuffer*)mutVec2;
+ (EGMutableVertexBuffer*)mutVec3;
+ (EGMutableVertexBuffer*)mutVec4;
+ (EGMutableVertexBuffer*)mutMesh;
+ (ODClassType*)type;
@end


@protocol EGVertexBuffer<NSObject>
- (EGVertexBufferDesc*)desc;
- (void)bind;
- (NSUInteger)count;
- (GLuint)handle;
- (BOOL)isMutable;
@end


@interface EGImmutableVertexBuffer : EGBuffer<EGVertexBuffer>
@property (nonatomic, readonly) EGVertexBufferDesc* desc;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger count;

+ (id)immutableVertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle length:(NSUInteger)length count:(NSUInteger)count;
- (id)initWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle length:(NSUInteger)length count:(NSUInteger)count;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGMutableVertexBuffer : EGMutableBuffer<EGVertexBuffer>
@property (nonatomic, readonly) EGVertexBufferDesc* desc;
@property (nonatomic, readonly) GLuint handle;

+ (id)mutableVertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle;
- (id)initWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle;
- (ODClassType*)type;
- (BOOL)isMutable;
+ (ODClassType*)type;
@end


