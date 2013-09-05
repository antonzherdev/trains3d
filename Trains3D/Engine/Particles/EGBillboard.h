#import "objd.h"
@class EG;
@class EGContext;
@class EGMutableMatrix;
#import "EGVec.h"

@class EGBillboard;

@interface EGBillboard : NSObject
+ (id)billboard;
- (id)init;
- (ODClassType*)type;
+ (void)drawWithSize:(EGVec2)size;
+ (ODClassType*)type;
@end


