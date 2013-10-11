#import "objd.h"
#import "GEVec.h"
#import "EGBillboard.h"
#import "GELine.h"
@class TRForest;
@class EGTexture;
@class EGGlobal;
@class EGColorSource;
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGMutableIndexBuffer;
@class EGIBO;
@class EGVertexArray;
@class EGMesh;
@class EGD2D;
@class EGBlendFunction;
@class EGContext;
@class EGEnablingState;
@class TRTree;
@class TRTreeType;

@class TRTreeView;

@interface TRTreeView : NSObject
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) EGColorSource* material;

+ (id)treeViewWithForest:(TRForest*)forest;
- (id)initWithForest:(TRForest*)forest;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


