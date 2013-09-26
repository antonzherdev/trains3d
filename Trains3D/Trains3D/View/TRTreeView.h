#import "objd.h"
#import "GEVec.h"
#import "EGMaterial.h"
@class EGGlobal;
@class EGTexture;
@class TRForest;
@class TRTree;
@class TRTreeType;
@class EGBillboard;

@class TRTreeView;

@interface TRTreeView : NSObject
@property (nonatomic, readonly) id<CNSeq> textures;
@property (nonatomic, readonly) id<CNSeq> materials;
@property (nonatomic, readonly) id<CNSeq> rects;

+ (id)treeView;
- (id)init;
- (ODClassType*)type;
- (void)drawForest:(TRForest*)forest;
+ (ODClassType*)type;
@end


