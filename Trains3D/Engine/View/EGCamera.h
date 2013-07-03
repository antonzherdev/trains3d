#import "objd.h"
#import "EGTypes.h"

@class EGCameraIso;

@interface EGCameraIso : NSObject
@property (nonatomic, readonly) EGMapSize tilesOnScreen;
@property (nonatomic, readonly) CGPoint center;

+ (id)cameraIsoWithTilesOnScreen:(EGMapSize)tilesOnScreen center:(CGPoint)center;
- (id)initWithTilesOnScreen:(EGMapSize)tilesOnScreen center:(CGPoint)center;
- (void)focusForViewSize:(CGSize)viewSize;
@end


