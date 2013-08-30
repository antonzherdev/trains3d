#import "objd.h"
@class EG;
#import "EGGL.h"
#import "EGTypes.h"
@class EGMapSso;
@class EGMapSsoView;
@class EGContext;
@class EGMutableMatrix;

@class EGCameraIso;

@interface EGCameraIso : NSObject<EGCamera>
@property (nonatomic, readonly) EGSizeI tilesOnScreen;
@property (nonatomic, readonly) EGPoint center;
@property (nonatomic, readonly) EGVec3 eyeDirection;

+ (id)cameraIsoWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGPoint)center;
- (id)initWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGPoint)center;
- (EGRect)calculateViewportSizeWithViewSize:(EGSize)viewSize;
- (void)focusForViewSize:(EGSize)viewSize;
- (EGPoint)translateWithViewSize:(EGSize)viewSize viewPoint:(EGPoint)viewPoint;
- (ODType*)type;
+ (ODType*)type;
@end


