#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
#import "ATActor.h"
@class EGGlobal;
@class EGSettings;
@class EGShadowType;
@class EGBlendMode;
@class EGVertexBufferDesc;
@class EGMatrixStack;
@class EGMMatrixModel;
@class EGColorSource;
@class EGTexture;
@class EGContext;
@class TRForest;
@class TRForestRules;
@class TRForestType;
@class EGTextureFilter;
@class EGVBO;
@class EGVertexArray;
@class EGVertexArrayRing;
@class EGIBO;
@class EGMesh;
@class EGMutableVertexBuffer;
@class EGMutableIndexBuffer;
@protocol EGIndexSource;
@class EGRenderTarget;
@class EGCullFace;
@class EGEnablingState;
@class EGBlendFunction;
@class TRTree;
@class TRTreeType;

@class TRTreeShaderBuilder;
@class TRTreeShader;
@class TRTreeView;
@class TRTreeWriter;
typedef struct TRTreeData TRTreeData;

@interface TRTreeShaderBuilder : NSObject<EGShaderTextBuilder> {
@protected
    BOOL _shadow;
}
@property (nonatomic, readonly) BOOL shadow;

+ (instancetype)treeShaderBuilderWithShadow:(BOOL)shadow;
- (instancetype)initWithShadow:(BOOL)shadow;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
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
- (ODClassType*)type;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(EGColorSource*)param;
+ (TRTreeShader*)instanceForShadow;
+ (TRTreeShader*)instance;
+ (EGVertexBufferDesc*)vbDesc;
+ (ODClassType*)type;
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
static inline BOOL TRTreeDataEq(TRTreeData s1, TRTreeData s2) {
    return GEVec3Eq(s1.position, s2.position) && GEVec2Eq(s1.model, s2.model) && GEVec2Eq(s1.uv, s2.uv) && GEVec2Eq(s1.uvShiver, s2.uvShiver);
}
static inline NSUInteger TRTreeDataHash(TRTreeData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.position);
    hash = hash * 31 + GEVec2Hash(self.model);
    hash = hash * 31 + GEVec2Hash(self.uv);
    hash = hash * 31 + GEVec2Hash(self.uvShiver);
    return hash;
}
NSString* TRTreeDataDescription(TRTreeData self);
ODPType* trTreeDataType();
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
    EGMutableVertexBuffer* _vbo;
    EGMutableIndexBuffer* _ibo;
    EGMutableIndexBuffer* _shadowIbo;
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
- (ODClassType*)type;
- (void)prepare;
- (void)complete;
- (void)draw;
+ (ODClassType*)type;
@end


@interface TRTreeWriter : ATActor {
@protected
    TRForest* _forest;
}
@property (nonatomic, readonly) TRForest* forest;

+ (instancetype)treeWriterWithForest:(TRForest*)forest;
- (instancetype)initWithForest:(TRForest*)forest;
- (ODClassType*)type;
- (CNFuture*)writeToVbo:(TRTreeData*)vbo ibo:(unsigned int*)ibo shadowIbo:(unsigned int*)shadowIbo maxCount:(NSUInteger)maxCount;
- (CNFuture*)_writeToVbo:(TRTreeData*)vbo ibo:(unsigned int*)ibo shadowIbo:(unsigned int*)shadowIbo trees:(NSArray*)trees maxCount:(NSUInteger)maxCount;
+ (ODClassType*)type;
@end


