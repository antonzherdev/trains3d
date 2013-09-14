#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
#import "GERect.h"
@class EGMatrixModel;
@class GEMatrix;
@class EG;
@class EGMatrixStack;

@class EGCamera2D;

@interface EGCamera2D : NSObject<EGCamera>
@property (nonatomic, readonly) GEVec2 size;

+ (id)camera2DWithSize:(GEVec2)size;
- (id)initWithSize:(GEVec2)size;
- (ODClassType*)type;
- (void)focusForViewSize:(GEVec2)viewSize;
- (GEVec2)translateWithViewSize:(GEVec2)viewSize viewPoint:(GEVec2)viewPoint;
+ (ODClassType*)type;
@end


