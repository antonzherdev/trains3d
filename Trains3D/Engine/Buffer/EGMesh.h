#import "objd.h"
#import "GEVec.h"
@class GEMat4;
@protocol EGVertexBuffer;
@protocol EGIndexSource;
@class EGVBO;
@class EGIBO;
@class EGVertexBufferDesc;
@class EGShader;
@class EGShadowShaderSystem;
@class EGColorSource;
@class EGPlatform;
@class EGShadowRenderTarget;
@class EGShaderSystem;
@class EGMaterial;
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;
@class EGMutableVertexBuffer;
@class EGMutableIndexBuffer;
@class EGMatrixStack;

@class EGMeshDataModel;
@class EGMesh;
@class EGMeshModel;
@class EGVertexArray;
@class EGRouteVertexArray;
@class EGSimpleVertexArray;
@class EGMaterialVertexArray;
@class EGMeshUnite;
@class EGMeshWriter;
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
EGMeshData egMeshDataMulMat4(EGMeshData self, GEMat4* mat4);
EGMeshData egMeshDataUvAddVec2(EGMeshData self, GEVec2 vec2);
ODPType* egMeshDataType();
@interface EGMeshDataWrap : NSObject
@property (readonly, nonatomic) EGMeshData value;

+ (id)wrapWithValue:(EGMeshData)value;
- (id)initWithValue:(EGMeshData)value;
@end



@interface EGMeshDataModel : NSObject
@property (nonatomic, readonly) CNPArray* vertex;
@property (nonatomic, readonly) CNPArray* index;

+ (id)meshDataModelWithVertex:(CNPArray*)vertex index:(CNPArray*)index;
- (id)initWithVertex:(CNPArray*)vertex index:(CNPArray*)index;
- (ODClassType*)type;
+ (ODClassType*)type;
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
- (EGVertexArray*)vaoShadow;
- (EGVertexArray*)vaoShadowMaterial:(EGColorSource*)material;
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
- (void)drawOnly:(unsigned int)only;
+ (ODClassType*)type;
@end


@interface EGVertexArray : NSObject
+ (id)vertexArray;
- (id)init;
- (ODClassType*)type;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
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
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGSimpleVertexArray : EGVertexArray
@property (nonatomic, readonly) unsigned int handle;
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) id<CNSeq> buffers;
@property (nonatomic, readonly) id<EGIndexSource> index;
@property (nonatomic, readonly) BOOL isMutable;

+ (id)simpleVertexArrayWithHandle:(unsigned int)handle shader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index;
- (id)initWithHandle:(unsigned int)handle shader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index;
- (ODClassType*)type;
+ (EGSimpleVertexArray*)applyShader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index;
- (void)bind;
- (void)unbind;
- (void)dealloc;
- (NSUInteger)count;
- (void)drawParam:(id)param;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
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
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
+ (ODClassType*)type;
@end


@interface EGMeshUnite : NSObject
@property (nonatomic, readonly) CNPArray* vertexSample;
@property (nonatomic, readonly) CNPArray* indexSample;
@property (nonatomic, readonly) EGVertexArray*(^createVao)(EGMesh*);
@property (nonatomic, readonly) EGMesh* mesh;
@property (nonatomic, readonly) EGVertexArray* vao;

+ (id)meshUniteWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(EGVertexArray*(^)(EGMesh*))createVao;
- (id)initWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(EGVertexArray*(^)(EGMesh*))createVao;
- (ODClassType*)type;
+ (EGMeshUnite*)applyMeshModel:(EGMeshDataModel*)meshModel createVao:(EGVertexArray*(^)(EGMesh*))createVao;
- (void)writeCount:(unsigned int)count f:(void(^)(EGMeshWriter*))f;
- (void)writeMat4Array:(id<CNIterable>)mat4Array;
- (EGMeshWriter*)writerCount:(unsigned int)count;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGMeshWriter : NSObject
@property (nonatomic, readonly) EGMutableVertexBuffer* vbo;
@property (nonatomic, readonly) EGMutableIndexBuffer* ibo;
@property (nonatomic, readonly) unsigned int count;
@property (nonatomic, readonly) CNPArray* vertexSample;
@property (nonatomic, readonly) CNPArray* indexSample;

+ (id)meshWriterWithVbo:(EGMutableVertexBuffer*)vbo ibo:(EGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample;
- (id)initWithVbo:(EGMutableVertexBuffer*)vbo ibo:(EGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample;
- (ODClassType*)type;
- (void)writeMat4:(GEMat4*)mat4;
- (void)writeVertex:(CNPArray*)vertex mat4:(GEMat4*)mat4;
- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index mat4:(GEMat4*)mat4;
- (void)writeMap:(EGMeshData(^)(EGMeshData))map;
- (void)writeVertex:(CNPArray*)vertex map:(EGMeshData(^)(EGMeshData))map;
- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index map:(EGMeshData(^)(EGMeshData))map;
- (void)flush;
- (void)dealloc;
+ (ODClassType*)type;
@end


