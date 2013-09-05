#import "objd.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
@class EGMutableMatrix;
#import "EGVec.h"
@class EGMatrix;

@class EGBillboard;

@interface EGBillboard : NSObject
+ (id)billboard;
- (id)init;
- (ODClassType*)type;
+ (void)drawWithSize:(EGVec2)size;
+ (ODClassType*)type;
@end


