#import "objd.h"
#import "GEVec.h"
@class GEMat4;
@protocol EGVertexBuffer;
@protocol EGIndexSource;
@class EGVBO;
@class EGIBO;
@class EGVertexBufferDesc;
@class EGVertexArray;
@class EGShader;
@class EGShadowShaderSystem;
@class EGColorSource;
@class EGMaterialVertexArray;
@class EGPlatform;
@class EGShadowRenderTarget;
@class EGShaderSystem;
@class EGRouteVertexArray;
@class EGMaterial;
@class CNChain;
@class EGMutableVertexBuffer;
@class EGMutableIndexBuffer;
@class EGGlobal;
@class EGMatrixStack;
@class EGMMatrixModel;

@class EGMeshDataModel;
@class EGMesh;
@class EGMeshModel;
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
EGMeshData egMeshDataMulMat4(EGMeshData self, GEMat4* mat4);
EGMeshData egMeshDataUvAddVec2(EGMeshData self, GEVec2 vec2);
NSString* egMeshDataDescription(EGMeshData self);
BOOL egMeshDataIsEqualTo(EGMeshData self, EGMeshData to);
NSUInteger egMeshDataHash(EGMeshData self);
CNPType* egMeshDataType();
@interface EGMeshDataWrap : NSObject
@property (readonly, nonatomic) EGMeshData value;

+ (id)wrapWithValue:(EGMeshData)value;
- (id)initWithValue:(EGMeshData)value;
@end



@interface EGMeshDataModel : NSObject {
@protected
    CNPArray* _vertex;
    CNPArray* _index;
}
@property (nonatomic, readonly) CNPArray* vertex;
@property (nonatomic, readonly) CNPArray* index;

+ (instancetype)meshDataModelWithVertex:(CNPArray*)vertex index:(CNPArray*)index;
- (instancetype)initWithVertex:(CNPArray*)vertex index:(CNPArray*)index;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGMesh : NSObject {
@protected
    id<EGVertexBuffer> _vertex;
    id<EGIndexSource> _index;
}
@property (nonatomic, readonly) id<EGVertexBuffer> vertex;
@property (nonatomic, readonly) id<EGIndexSource> index;

+ (instancetype)meshWithVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index;
- (instancetype)initWithVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index;
- (CNClassType*)type;
+ (EGMesh*)vec2VertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (EGMesh*)applyVertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (EGMesh*)applyDesc:(EGVertexBufferDesc*)desc vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
- (EGVertexArray*)vaoShader:(EGShader*)shader;
- (EGVertexArray*)vaoShadow;
- (EGVertexArray*)vaoShadowMaterial:(EGColorSource*)material;
- (EGVertexArray*)vaoMaterial:(id)material shadow:(BOOL)shadow;
- (EGVertexArray*)vaoShaderSystem:(EGShaderSystem*)shaderSystem material:(id)material shadow:(BOOL)shadow;
- (void)drawMaterial:(EGMaterial*)material;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGMeshModel : NSObject {
@protected
    NSArray* _arrays;
}
@property (nonatomic, readonly) NSArray* arrays;

+ (instancetype)meshModelWithArrays:(NSArray*)arrays;
- (instancetype)initWithArrays:(NSArray*)arrays;
- (CNClassType*)type;
+ (EGMeshModel*)applyMeshes:(NSArray*)meshes;
+ (EGMeshModel*)applyShadow:(BOOL)shadow meshes:(NSArray*)meshes;
- (void)draw;
- (void)drawOnly:(unsigned int)only;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGMeshUnite : NSObject {
@protected
    CNPArray* _vertexSample;
    CNPArray* _indexSample;
    EGVertexArray*(^_createVao)(EGMesh*);
    EGMutableVertexBuffer* _vbo;
    EGMutableIndexBuffer* _ibo;
    EGMesh* _mesh;
    EGVertexArray* _vao;
    unsigned int __count;
}
@property (nonatomic, readonly) CNPArray* vertexSample;
@property (nonatomic, readonly) CNPArray* indexSample;
@property (nonatomic, readonly) EGVertexArray*(^createVao)(EGMesh*);
@property (nonatomic, readonly) EGMesh* mesh;
@property (nonatomic, readonly) EGVertexArray* vao;

+ (instancetype)meshUniteWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(EGVertexArray*(^)(EGMesh*))createVao;
- (instancetype)initWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(EGVertexArray*(^)(EGMesh*))createVao;
- (CNClassType*)type;
+ (EGMeshUnite*)applyMeshModel:(EGMeshDataModel*)meshModel createVao:(EGVertexArray*(^)(EGMesh*))createVao;
- (void)writeCount:(unsigned int)count f:(void(^)(EGMeshWriter*))f;
- (void)writeMat4Array:(id<CNIterable>)mat4Array;
- (EGMeshWriter*)writerCount:(unsigned int)count;
- (void)draw;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGMeshWriter : NSObject {
@protected
    EGMutableVertexBuffer* _vbo;
    EGMutableIndexBuffer* _ibo;
    unsigned int _count;
    CNPArray* _vertexSample;
    CNPArray* _indexSample;
    EGMeshData* _vertex;
    unsigned int* _index;
    EGMeshData* __vp;
    unsigned int* __ip;
    unsigned int __indexShift;
}
@property (nonatomic, readonly) EGMutableVertexBuffer* vbo;
@property (nonatomic, readonly) EGMutableIndexBuffer* ibo;
@property (nonatomic, readonly) unsigned int count;
@property (nonatomic, readonly) CNPArray* vertexSample;
@property (nonatomic, readonly) CNPArray* indexSample;

+ (instancetype)meshWriterWithVbo:(EGMutableVertexBuffer*)vbo ibo:(EGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample;
- (instancetype)initWithVbo:(EGMutableVertexBuffer*)vbo ibo:(EGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample;
- (CNClassType*)type;
- (void)writeMat4:(GEMat4*)mat4;
- (void)writeVertex:(CNPArray*)vertex mat4:(GEMat4*)mat4;
- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index mat4:(GEMat4*)mat4;
- (void)writeMap:(EGMeshData(^)(EGMeshData))map;
- (void)writeVertex:(CNPArray*)vertex map:(EGMeshData(^)(EGMeshData))map;
- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index map:(EGMeshData(^)(EGMeshData))map;
- (void)flush;
- (void)dealloc;
- (NSString*)description;
+ (CNClassType*)type;
@end


