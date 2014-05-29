#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
#import "TRTree.h"
#import "EGTexture.h"
#import "CNActor.h"
@class EGVertexBufferDesc;
@class EGGlobal;
@class EGMatrixStack;
@class EGMMatrixModel;
@class EGColorSource;
@class EGContext;
@class EGVBO;
@class CNChain;
@class EGVertexArray;
@class EGVertexArrayRing;
@class EGMutableVertexBuffer;
@class EGIBO;
@class EGMesh;
@class EGMappedBufferData;
@class CNFuture;
@protocol EGIndexSource;
@class EGMutableIndexBuffer;
@class EGRenderTarget;
@class EGCullFace;
@class EGEnablingState;
@class EGBlendFunction;

@class TRTreeShaderBuilder;
@class TRTreeShader;
@class TRTreeView;
@class TRTreeWriter;
typedef struct TRTreeData TRTreeData;

@interface TRTreeShaderBuilder : EGShaderTextBuilder_impl {
@protected
    BOOL _shadow;
}
@property (nonatomic, readonly) BOOL shadow;

+ (instancetype)treeShaderBuilderWithShadow:(BOOL)shadow;
- (instancetype)initWithShadow:(BOOL)shadow;
- (CNClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTreeShader : EGShader {
@protected
    BOOL _shadow;
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _modelSlot;
    EGShaderAttribute* _uvSlot;
    EGShaderAttribute* _uvShiverSlot;
    EGShaderUniformMat4* _wcUniform;
    EGShaderUniformMat4* _pUniform;
}
@property (nonatomic, readonly) BOOL shadow;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* modelSlot;
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* uvShiverSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* wcUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* pUniform;

+ (instancetype)treeShaderWithProgram:(EGShaderProgram*)program shadow:(BOOL)shadow;
- (instancetype)initWithProgram:(EGShaderProgram*)program shadow:(BOOL)shadow;
- (CNClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
- (NSString*)description;
+ (TRTreeShader*)instanceForShadow;
+ (TRTreeShader*)instance;
+ (EGVertexBufferDesc*)vbDesc;
+ (CNClassType*)type;
@end


struct TRTreeData {
    GEVec3 position;
    GEVec2 model;
    GEVec2 uv;
    GEVec2 uvShiver;
};
static inline TRTreeData TRTreeDataMake(GEVec3 position, GEVec2 model, GEVec2 uv, GEVec2 uvShiver) {
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
@protected
    TRForest* _forest;
    EGTexture* _texture;
    EGColorSource* _material;
    NSArray* _vbs;
    EGVertexArray* _vao;
    EGVertexArrayRing* _vaos;
    EGColorSource* _shadowMaterial;
    EGVertexArray* _shadowVao;
    EGVertexArrayRing* _shadowVaos;
    EGMappedBufferData* _vbo;
    EGMappedBufferData* _ibo;
    EGMappedBufferData* _shadowIbo;
    TRTreeWriter* _writer;
    CNFuture* _writeFuture;
    BOOL __first;
    BOOL __firstDrawInFrame;
    NSUInteger __treesIndexCount;
}
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) EGColorSource* material;
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
@protected
    TRForest* _forest;
}
@property (nonatomic, readonly) TRForest* forest;

+ (instancetype)treeWriterWithForest:(TRForest*)forest;
- (instancetype)initWithForest:(TRForest*)forest;
- (CNClassType*)type;
- (CNFuture*)writeToVbo:(EGMappedBufferData*)vbo ibo:(EGMappedBufferData*)ibo shadowIbo:(EGMappedBufferData*)shadowIbo maxCount:(unsigned int)maxCount;
- (NSString*)description;
+ (CNClassType*)type;
@end


