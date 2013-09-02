#import "objd.h"
#import "EGTypes.h"
@class EG;
#import "EGGL.h"
@class EGContext;
@class EGMutableMatrix;

@class EGCamera2D;

@interface EGCamera2D : NSObject<EGCamera>
@property (nonatomic, readonly) EGSize size;
@property (nonatomic, readonly) EGVec3 eyeDirection;

+ (id)camera2DWithSize:(EGSize)size;
- (id)initWithSize:(EGSize)size;
- (ODClassType*)type;
- (void)focusForViewSize:(EGSize)viewSize;
- (EGPoint)translateWithViewSize:(EGSize)viewSize viewPoint:(EGPoint)viewPoint;
+ (ODClassType*)type;
@end


