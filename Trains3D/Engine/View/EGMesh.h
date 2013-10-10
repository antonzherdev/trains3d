#import "objd.h"
#import "GEVec.h"
@protocol EGVertexSource;
@protocol EGIndexSource;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGVertexBufferDesc;
@class EGShader;
@class EGMaterial;
@class EGShadowRenderTarget;
@class EGShaderSystem;
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;

@class EGMesh;
@class EGSimpleMesh;
@class EGRouteMesh;
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
+ (id)mesh;
- (id)init;
- (ODClassType*)type;
- (id<EGVertexSource>)vertex;
- (id<EGIndexSource>)index;
+ (EGMesh*)vec2VertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (EGMesh*)applyVertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (EGMesh*)applyDesc:(EGVertexBufferDesc*)desc vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (EGSimpleMesh*)applyVertex:(id<EGVertexSource>)vertex index:(id<EGIndexSource>)index;
- (EGMesh*)vaoWithShader:(EGShader*)shader;
- (EGMesh*)vaoWithMaterial:(EGMaterial*)material shadow:(BOOL)shadow;
- (EGMesh*)vaoWithShaderSystem:(EGShaderSystem*)shaderSystem material:(id)material shadow:(BOOL)shadow;
+ (ODClassType*)type;
@end


@interface EGSimpleMesh : EGMesh
@property (nonatomic, readonly) id<EGVertexSource> vertex;
@property (nonatomic, readonly) id<EGIndexSource> index;

+ (id)simpleMeshWithVertex:(id<EGVertexSource>)vertex index:(id<EGIndexSource>)index;
- (id)initWithVertex:(id<EGVertexSource>)vertex index:(id<EGIndexSource>)index;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGRouteMesh : EGMesh
@property (nonatomic, readonly) id<EGIndexSource> index;
@property (nonatomic, readonly) id<EGVertexSource> standard;
@property (nonatomic, readonly) id<EGVertexSource> shadow;

+ (id)routeMeshWithIndex:(id<EGIndexSource>)index standard:(id<EGVertexSource>)standard shadow:(id<EGVertexSource>)shadow;
- (id)initWithIndex:(id<EGIndexSource>)index standard:(id<EGVertexSource>)standard shadow:(id<EGVertexSource>)shadow;
- (ODClassType*)type;
- (id<EGVertexSource>)vertex;
+ (ODClassType*)type;
@end


