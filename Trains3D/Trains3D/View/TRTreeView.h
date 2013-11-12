#import "objd.h"
#import "GEVec.h"
#import "EGBillboard.h"
#import "GELine.h"
@class TRForest;
@class EGTexture;
@class TRForestRules;
@class TRTreeType;
@class EGGlobal;
@class EGColorSource;
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGMutableIndexBuffer;
@class EGIBO;
@class EGVertexArray;
@class EGMesh;
@class EGShadowRenderTarget;
@class EGD2D;
@class EGBlendFunction;
@class EGContext;
@class EGRenderTarget;
@class EGEnablingState;
@class TRTree;

@class TRTreeView;

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


