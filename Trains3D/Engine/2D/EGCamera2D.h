#import "objd.h"
#import "EGTypes.h"

@class EGCamera2D;

@interface EGCamera2D : NSObject<EGCamera>
@property (nonatomic, readonly) EGSize size;

+ (id)camera2DWithSize:(EGSize)size;
- (id)initWithSize:(EGSize)size;
- (void)focusForViewSize:(EGSize)viewSize;
- (EGPoint)translateWithViewSize:(EGSize)viewSize viewPoint:(EGPoint)viewPoint;
@end


