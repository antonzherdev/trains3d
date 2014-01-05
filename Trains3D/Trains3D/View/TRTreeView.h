#import "objd.h"
#import "EGShader.h"
#import "GEVec.h"
@class EGBlendMode;
@class EGVertexBufferDesc;
@class EGGlobal;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGColorSource;
@class EGContext;
@class TRForest;
@class EGTexture;
@class TRForestRules;
@class TRForestType;
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGMutableIndexBuffer;
@class EGIBO;
@class EGVertexArray;
@class EGMesh;
@class EGD2D;
@class EGBlendFunction;
@class EGRenderTarget;
@class EGEnablingState;
@class TRTree;
@class TRTreeType;

@class TRTreeShaderBuilder;
@class TRTreeShader;
@class TRTreeView;
typedef struct TRTreeData TRTreeData;

@interface TRTreeShaderBuilder : NSObject<EGShaderTextBuilder>
@property (nonatomic, readonly) BOOL shadow;

+ (id)treeShaderBuilderWithShadow:(BOOL)shadow;
- (id)initWithShadow:(BOOL)shadow;
- (ODClassType*)type;
- (NSString*)vertex;
- (NSString*)fragment;
- (EGShaderProgram*)program;
+ (ODClassType*)type;
@end


@interface TRTreeShader : EGShader
@property (nonatomic, readonly) BOOL shadow;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* modelSlot;
@property (nonatomic, readonly) EGShaderAttribute* uvSlot;
@property (nonatomic, readonly) EGShaderAttribute* uvShiverSlot;
@property (nonatomic, readonly) EGShaderUniformMat4* wcUniform;
@property (nonatomic, readonly) EGShaderUniformMat4* pUniform;

+ (id)treeShaderWithProgram:(EGShaderProgram*)program shadow:(BOOL)shadow;
- (id)initWithProgram:(EGShaderProgram*)program shadow:(BOOL)shadow;
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



@interface TRTreeView : NSObject
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) EGColorSource* material;

+ (id)treeViewWithForest:(TRForest*)forest;
- (id)initWithForest:(TRForest*)forest;
- (ODClassType*)type;
- (void)prepare;
- (void)draw;
+ (ODClassType*)type;
@end


