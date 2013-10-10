#import "objd.h"
#import "GEVec.h"
#import "GL.h"
@class EGGlobal;
@class EGContext;
@class EGShader;

@class EGMesh;
@class EGBuffer;
@class EGVertexBufferDesc;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGVertexArray;
typedef struct EGMeshData EGMeshData;

struct EGMeshData {
    GEVec2 uv;
    GEVec3 normal;
    GEVec3 position;
};
static inline EGMeshData EGMeshDataMake(GEVec2 uv, GEVec3 normal, GEVec3 position) {
    return (EGMeshData){uv, normal, position};
}
static inline BOOL EGMeshDataEq(EGMeshData s1, EGMeshData s2) {
    return GEVec2Eq(s1.uv, s2.uv) && GEVec3Eq(s1.normal, s2.normal) && GEVec3Eq(s1.position, s2.position);
}
static inline NSUInteger EGMeshDataHash(EGMeshData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.uv);
    hash = hash * 31 + GEVec3Hash(self.normal);
    hash = hash * 31 + GEVec3Hash(self.position);
    return hash;
}
NSString* EGMeshDataDescription(EGMeshData self);
ODPType* egMeshDataType();
@interface EGMeshDataWrap : NSObject
@property (readonly, nonatomic) EGMeshData value;

+ (id)wrapWithValue:(EGMeshData)value;
- (id)initWithValue:(EGMeshData)value;
@end



@interface EGMesh : NSObject
@property (nonatomic, readonly) EGVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) EGIndexBuffer* indexBuffer;

+ (id)meshWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer;
- (id)initWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer;
- (ODClassType*)type;
+ (EGMesh*)vec2VertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (EGMesh*)applyVertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (EGMesh*)applyDesc:(EGVertexBufferDesc*)desc vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (ODClassType*)type;
@end


@interface EGBuffer : NSObject
@property (nonatomic, readonly) ODPType* dataType;
@property (nonatomic, readonly) unsigned int bufferType;
@property (nonatomic, readonly) GLuint handle;

+ (id)bufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(GLuint)handle;
- (id)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(GLuint)handle;
- (ODClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
+ (EGBuffer*)applyDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType;
- (void)dealoc;
- (id)setData:(CNPArray*)data;
- (id)setArray:(CNVoidRefArray)array;
- (id)setData:(CNPArray*)data usage:(unsigned int)usage;
- (id)setArray:(CNVoidRefArray)array usage:(unsigned int)usage;
- (id)updateStart:(NSUInteger)start count:(NSUInteger)count array:(CNVoidRefArray)array;
- (void)bind;
- (unsigned int)stride;
+ (ODClassType*)type;
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


@interface EGVertexBuffer : EGBuffer
@property (nonatomic, readonly) EGVertexBufferDesc* desc;

+ (id)vertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle;
- (id)initWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle;
- (ODClassType*)type;
+ (EGVertexBuffer*)applyDesc:(EGVertexBufferDesc*)desc;
+ (EGVertexBuffer*)vec2;
+ (EGVertexBuffer*)vec3;
+ (EGVertexBuffer*)vec4;
+ (EGVertexBuffer*)mesh;
- (void)bind;
+ (ODClassType*)type;
@end


@interface EGIndexBuffer : EGBuffer
+ (id)indexBufferWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
+ (EGIndexBuffer*)apply;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (void)drawByQuads;
- (void)bind;
+ (ODClassType*)type;
@end


@interface EGVertexArray : NSObject
@property (nonatomic, readonly) GLuint handle;
@property (nonatomic, readonly) id<CNSeq> buffers;

+ (id)vertexArrayWithHandle:(GLuint)handle buffers:(id<CNSeq>)buffers;
- (id)initWithHandle:(GLuint)handle buffers:(id<CNSeq>)buffers;
- (ODClassType*)type;
+ (EGVertexArray*)applyShader:(EGShader*)shader buffer:(EGVertexBuffer*)buffer;
+ (ODClassType*)type;
@end


