#import "objd.h"
#import "GEVec.h"
#import "EGBillboard.h"
#import "EGMaterial.h"
#import "GELine.h"
@class TRForest;
@class EGGlobal;
@class EGTexture;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGD2D;
@class EGMesh;
@class TRTree;
@class TRTreeType;

@class TRTreeView;

@interface TRTreeView : NSObject
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) id<CNSeq> textures;
@property (nonatomic, readonly) EGColorSource* material;
@property (nonatomic, readonly) id<CNSeq> materials;
@property (nonatomic, readonly) id<CNSeq> rects;

+ (id)treeViewWithForest:(TRForest*)forest;
- (id)initWithForest:(TRForest*)forest;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


