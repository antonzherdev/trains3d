#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class EGMapSso;
@class GEMat4;
@class EGMatrixModel;

@class EGCameraIso;

@interface EGCameraIso : NSObject<EGCamera>
@property (nonatomic, readonly) GEVec2i tilesOnScreen;
@property (nonatomic, readonly) GEVec2 center;
@property (nonatomic, readonly) EGMatrixModel* matrixModel;

+ (id)cameraIsoWithTilesOnScreen:(GEVec2i)tilesOnScreen center:(GEVec2)center;
- (id)initWithTilesOnScreen:(GEVec2i)tilesOnScreen center:(GEVec2)center;
- (ODClassType*)type;
- (GERecti)viewportWithViewSize:(GEVec2)viewSize;
- (void)focusForViewSize:(GEVec2)viewSize;
- (GEVec2)translateWithViewSize:(GEVec2)viewSize viewPoint:(GEVec2)viewPoint;
+ (GEMat4*)m;
+ (GEMat4*)w;
+ (ODClassType*)type;
@end


