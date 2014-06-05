#import "objd.h"
#import "PGShader.h"
#import "PGVec.h"
#import "TRTree.h"
#import "PGTexture.h"
#import "CNActor.h"
@class PGVertexBufferDesc;
@class PGGlobal;
@class PGMatrixStack;
@class PGMMatrixModel;
@class PGColorSource;
@class PGContext;
@class PGVBO;
@class CNChain;
@class PGVertexArray;
@class PGVertexArrayRing;
@class PGMutableVertexBuffer;
@class PGIBO;
@class PGMesh;
@class PGMappedBufferData;
@class CNFuture;
@protocol PGIndexSource;
@class PGMutableIndexBuffer;
@class PGRenderTarget;
@class PGCullFace;
@class PGEnablingState;
@class PGBlendFunction;

@class TRTreeShaderBuilder;
@class TRTreeShader;
@class TRTreeView;
@class TRTreeWriter;
typedef struct TRTreeData TRTreeData;

@interface TRTreeShaderBuilder : PGShaderTextBuilder_impl {
@public
    BOOL _shadow;
}
@property (nonatomic, readonly) BOOL shadow;

+ (instancetype)treeShaderBuilderWithShadow:(BOOL)shadow;
- (instancetype)initWithShadow:(BOOL)shadow;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (PGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTreeShader : PGShader {
@public
    BOOL _shadow;
    PGShaderAttribute* _positionSlot;
    PGShaderAttribute* _modelSlot;
    PGShaderAttribute* _uvSlot;
    PGShaderAttribute* _uvShiverSlot;
    PGShaderUniformMat4* _wcUniform;
    PGShaderUniformMat4* _pUniform;
}
@property (nonatomic, readonly) BOOL shadow;
@property (nonatomic, readonly) PGShaderAttribute* positionSlot;
@property (nonatomic, readonly) PGShaderAttribute* modelSlot;
@property (nonatomic, readonly) PGShaderAttribute* uvSlot;
@property (nonatomic, readonly) PGShaderAttribute* uvShiverSlot;
@property (nonatomic, readonly) PGShaderUniformMat4* wcUniform;
@property (nonatomic, readonly) PGShaderUniformMat4* pUniform;

+ (instancetype)treeShaderWithProgram:(PGShaderProgram*)program shadow:(BOOL)shadow;
- (instancetype)initWithProgram:(PGShaderProgram*)program shadow:(BOOL)shadow;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(PGColorSource*)param;
- (NSString*)description;
+ (TRTreeShader*)instanceForShadow;
+ (TRTreeShader*)instance;
+ (PGVertexBufferDesc*)vbDesc;
+ (CNClassType*)type;
@end


struct TRTreeData {
    PGVec3 position;
    PGVec2 model;
    PGVec2 uv;
    PGVec2 uvShiver;
};
static inline TRTreeData TRTreeDataMake(PGVec3 position, PGVec2 model, PGVec2 uv, PGVec2 uvShiver) {
    return (TRTreeData){position, model, uv, uvShiver};
}
NSString* trTreeDataDescription(TRTreeData self);
BOOL trTreeDataIsEqualTo(TRTreeData self, TRTreeData to);
NSUInteger trTreeDataHash(TRTreeData self);
CNPType* trTreeDataType();
@interface TRTreeDataWrap : NSObject
@property (readonly, nonatomic) TRTreeData value;

+ (id)wrapWithValue:(TRTreeData)value;
- (id)initWithValue:(TRTreeData)value;
@end



@interface TRTreeView : NSObject {
@public
    TRForest* _forest;
    PGTexture* _texture;
    PGColorSource* _material;
    NSArray* _vbs;
    PGVertexArray* _vao;
    PGVertexArrayRing* _vaos;
    PGColorSource* _shadowMaterial;
    PGVertexArray* _shadowVao;
    PGVertexArrayRing* _shadowVaos;
    PGMappedBufferData* _vbo;
    PGMappedBufferData* _ibo;
    PGMappedBufferData* _shadowIbo;
    TRTreeWriter* _writer;
    CNFuture* _writeFuture;
    BOOL __first;
    BOOL __firstDrawInFrame;
    NSUInteger __treesIndexCount;
}
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) PGTexture* texture;
@property (nonatomic, readonly) PGColorSource* material;
@property (nonatomic, readonly) NSArray* vbs;

+ (instancetype)treeViewWithForest:(TRForest*)forest;
- (instancetype)initWithForest:(TRForest*)forest;
- (CNClassType*)type;
- (void)prepare;
- (void)complete;
- (void)draw;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTreeWriter : CNActor {
@public
    TRForest* _forest;
}
@property (nonatomic, readonly) TRForest* forest;

+ (instancetype)treeWriterWithForest:(TRForest*)forest;
- (instancetype)initWithForest:(TRForest*)forest;
- (CNClassType*)type;
- (CNFuture*)writeToVbo:(PGMappedBufferData*)vbo ibo:(PGMappedBufferData*)ibo shadowIbo:(PGMappedBufferData*)shadowIbo maxCount:(unsigned int)maxCount;
- (NSString*)description;
+ (CNClassType*)type;
@end


