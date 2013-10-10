#import "objd.h"
#import "GEVec.h"
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGVertexBufferDesc;

@class EGMesh;
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


