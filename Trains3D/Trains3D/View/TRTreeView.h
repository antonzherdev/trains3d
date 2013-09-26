#import "objd.h"
#import "GEVec.h"
#import "EGMaterial.h"
@class EGTexture;
@class EGGlobal;
@class TRTrees;
@class TRTree;
@class EGBillboard;

@class TRTreeView;

@interface TRTreeView : NSObject
@property (nonatomic, readonly) EGTexture* pineTexture;
@property (nonatomic, readonly) EGColorSource* pine;
@property (nonatomic, readonly) GERect pineRect;

+ (id)treeView;
- (id)init;
- (ODClassType*)type;
- (void)drawTrees:(TRTrees*)trees;
+ (ODClassType*)type;
@end


