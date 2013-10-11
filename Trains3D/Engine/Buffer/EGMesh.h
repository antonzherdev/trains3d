#import "objd.h"
#import "GEVec.h"
#import "GL.h"
@protocol EGVertexBuffer;
@protocol EGIndexSource;
@class EGVBO;
@class EGIBO;
@class EGVertexBufferDesc;
@class EGShader;
@class EGPlatform;
@class EGShadowRenderTarget;
@class EGShaderSystem;
@class EGMaterial;
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;

@class EGMesh;
@class EGMeshModel;
@class EGVertexArray;
@class EGRouteVertexArray;
@class EGSimpleVertexArray;
@class EGMaterialVertexArray;
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
@property (nonatomic, readonly) id<EGVertexBuffer> vertex;
@property (nonatomic, readonly) id<EGIndexSource> index;

+ (id)meshWithVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index;
- (id)initWithVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index;
- (ODClassType*)type;
+ (EGMesh*)vec2VertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (EGMesh*)applyVertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (EGMesh*)applyDesc:(EGVertexBufferDesc*)desc vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
- (EGVertexArray*)vaoShader:(EGShader*)shader;
- (EGVertexArray*)vaoMaterial:(id)material shadow:(BOOL)shadow;
- (EGVertexArray*)vaoShaderSystem:(EGShaderSystem*)shaderSystem material:(id)material shadow:(BOOL)shadow;
- (void)drawMaterial:(EGMaterial*)material;
+ (ODClassType*)type;
@end


@interface EGMeshModel : NSObject
@property (nonatomic, readonly) id<CNSeq> arrays;

+ (id)meshModelWithArrays:(id<CNSeq>)arrays;
- (id)initWithArrays:(id<CNSeq>)arrays;
- (ODClassType*)type;
+ (EGMeshModel*)applyMeshes:(id<CNSeq>)meshes;
+ (EGMeshModel*)applyShadow:(BOOL)shadow meshes:(id<CNSeq>)meshes;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGVertexArray : NSObject
+ (id)vertexArray;
- (id)init;
- (ODClassType*)type;
- (void)drawParam:(id)param;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGRouteVertexArray : EGVertexArray
@property (nonatomic, readonly) EGVertexArray* standard;
@property (nonatomic, readonly) EGVertexArray* shadow;

+ (id)routeVertexArrayWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow;
- (id)initWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow;
- (ODClassType*)type;
- (EGVertexArray*)mesh;
- (void)drawParam:(id)param;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGSimpleVertexArray : EGVertexArray
@property (nonatomic, readonly) GLuint handle;
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) id<CNSeq> buffers;
@property (nonatomic, readonly) id<EGIndexSource> index;

+ (id)simpleVertexArrayWithHandle:(GLuint)handle shader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index;
- (id)initWithHandle:(GLuint)handle shader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index;
- (ODClassType*)type;
+ (EGSimpleVertexArray*)applyShader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index;
- (void)bind;
- (void)unbind;
- (void)dealloc;
- (NSUInteger)count;
- (void)drawParam:(id)param;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGMaterialVertexArray : EGVertexArray
@property (nonatomic, readonly) EGVertexArray* vao;
@property (nonatomic, readonly) id material;

+ (id)materialVertexArrayWithVao:(EGVertexArray*)vao material:(id)material;
- (id)initWithVao:(EGVertexArray*)vao material:(id)material;
- (ODClassType*)type;
- (void)draw;
- (void)drawParam:(id)param;
+ (ODClassType*)type;
@end


