#import "objd.h"
#import "EGTypes.h"

@class EGCameraIso;

@interface EGCameraIso : NSObject
@property (nonatomic, readonly) EGISize tilesOnScreen;
@property (nonatomic, readonly) CGPoint center;

+ (id)cameraIsoWithTilesOnScreen:(EGISize)tilesOnScreen center:(CGPoint)center;
- (id)initWithTilesOnScreen:(EGISize)tilesOnScreen center:(CGPoint)center;
- (void)focusForViewSize:(CGSize)viewSize;
- (CGPoint)translateViewPoint:(CGPoint)viewPoint withViewSize:(CGSize)withViewSize;
@end


