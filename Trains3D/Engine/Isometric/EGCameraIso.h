#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"
@class EGMapSso;
@class EGMatrixModel;
@class EGMatrix;
@class EG;
@class EGMatrixStack;

@class EGCameraIso;

@interface EGCameraIso : NSObject<EGCamera>
@property (nonatomic, readonly) EGVec2I tilesOnScreen;
@property (nonatomic, readonly) EGVec2 center;

+ (id)cameraIsoWithTilesOnScreen:(EGVec2I)tilesOnScreen center:(EGVec2)center;
- (id)initWithTilesOnScreen:(EGVec2I)tilesOnScreen center:(EGVec2)center;
- (ODClassType*)type;
- (EGRect)calculateViewportSizeWithViewSize:(EGVec2)viewSize;
- (void)focusForViewSize:(EGVec2)viewSize;
- (EGVec2)translateWithViewSize:(EGVec2)viewSize viewPoint:(EGVec2)viewPoint;
+ (ODClassType*)type;
@end


