#import "objd.h"
#import "EGTypes.h"

@class EGCameraIso;

@interface EGCameraIso : NSObject<EGCamera>
@property (nonatomic, readonly) EGSizeI tilesOnScreen;
@property (nonatomic, readonly) EGPoint center;

+ (id)cameraIsoWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGPoint)center;
- (id)initWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGPoint)center;
- (void)focusForViewSize:(EGSize)viewSize;

- (EGPoint)translateWithViewSize:(EGSize)viewSize viewPoint:(EGPoint)viewPoint;
@end


