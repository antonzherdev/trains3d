#import "objd.h"
@class EG;
#import "EGTypes.h"
@class EGMapSso;
@class EGContext;
@class EGMutableMatrix;

@class EGCameraIso;

@interface EGCameraIso : NSObject<EGCamera>
@property (nonatomic, readonly) EGSizeI tilesOnScreen;
@property (nonatomic, readonly) EGPoint center;

+ (id)cameraIsoWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGPoint)center;
- (id)initWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGPoint)center;
- (EGRect)calculateViewportSizeWithViewSize:(EGSize)viewSize;
- (void)focusForViewSize:(EGSize)viewSize;
- (EGPoint)translateWithViewSize:(EGSize)viewSize viewPoint:(EGPoint)viewPoint;
@end


