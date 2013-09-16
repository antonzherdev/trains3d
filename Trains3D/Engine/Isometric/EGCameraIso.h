#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
#import "GERect.h"
@class EGMapSso;
@class EGMatrixModel;
@class GEMat4;
@class EG;
@class EGMatrixStack;

@class EGCameraIso;

@interface EGCameraIso : NSObject<EGCamera>
@property (nonatomic, readonly) GEVec2i tilesOnScreen;
@property (nonatomic, readonly) GEVec2 center;

+ (id)cameraIsoWithTilesOnScreen:(GEVec2i)tilesOnScreen center:(GEVec2)center;
- (id)initWithTilesOnScreen:(GEVec2i)tilesOnScreen center:(GEVec2)center;
- (ODClassType*)type;
- (GERect)calculateViewportSizeWithViewSize:(GEVec2)viewSize;
- (void)focusForViewSize:(GEVec2)viewSize;
- (GEVec2)translateWithViewSize:(GEVec2)viewSize viewPoint:(GEVec2)viewPoint;
+ (ODType*)type;
@end


