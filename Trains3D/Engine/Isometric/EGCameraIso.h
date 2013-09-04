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
@property (nonatomic, readonly) EGVec2 center;
@property (nonatomic, readonly) EGVec3 eyeDirection;

+ (id)cameraIsoWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGVec2)center;
- (id)initWithTilesOnScreen:(EGSizeI)tilesOnScreen center:(EGVec2)center;
- (ODClassType*)type;
- (EGRect)calculateViewportSizeWithViewSize:(EGSize)viewSize;
- (void)focusForViewSize:(EGSize)viewSize;
- (EGVec2)translateWithViewSize:(EGSize)viewSize viewPoint:(EGVec2)viewPoint;
+ (ODClassType*)type;
@end


