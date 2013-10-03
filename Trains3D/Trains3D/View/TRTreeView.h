#import "objd.h"
#import "GEVec.h"
#import "EGMaterial.h"
#import "GELine.h"
@class TRForest;
@class EGGlobal;
@class EGTexture;
@class TRTree;
@class TRTreeType;
@class EGD2D;

@class TRTreeView;

@interface TRTreeView : NSObject
@property (nonatomic, readonly) TRForest* forest;
@property (nonatomic, readonly) id<CNSeq> textures;
@property (nonatomic, readonly) id<CNSeq> materials;
@property (nonatomic, readonly) id<CNSeq> rects;

+ (id)treeViewWithForest:(TRForest*)forest;
- (id)initWithForest:(TRForest*)forest;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


