#import "objd.h"
#import "EGVec.h"
#import "EGTypes.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGGL.h"
@class EGMatrix;

@class EGCamera2D;

@interface EGCamera2D : NSObject<EGCamera>
@property (nonatomic, readonly) EGVec2 size;

+ (id)camera2DWithSize:(EGVec2)size;
- (id)initWithSize:(EGVec2)size;
- (ODClassType*)type;
- (void)focusForViewSize:(EGVec2)viewSize;
- (EGVec2)translateWithViewSize:(EGVec2)viewSize viewPoint:(EGVec2)viewPoint;
+ (ODClassType*)type;
@end


