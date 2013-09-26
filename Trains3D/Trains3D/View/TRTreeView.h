#import "objd.h"
#import "GEVec.h"
#import "EGMaterial.h"
@class EGTexture;
@class EGGlobal;
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
- (void)drawTree:(TRTree*)tree;
+ (ODClassType*)type;
@end


