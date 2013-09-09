#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"
@class TRSmokeView;
@class EGStandardMaterial;
@class EGColorSource;
@class EGMaterial;
@class TRTrain;
@class TRSmoke;
@class TRCar;
@class TRRailPoint;
@class EG;
@class EGMatrix;
@class EGMatrixModel;
@class TRColor;
@class TRCarType;
@class TR3D;
@class EGMatrixStack;

@class TRTrainView;

@interface TRTrainView : NSObject
@property (nonatomic, readonly) TRSmokeView* smokeView;
@property (nonatomic, readonly) EGStandardMaterial* blackMaterial;

+ (id)trainView;
- (id)init;
- (ODClassType*)type;
- (EGMaterial*)trainMaterialForColor:(EGColor)color;
- (void)drawTrains:(id<CNSeq>)trains;
- (void)drawTrain:(TRTrain*)train;
- (void)updateWithDelta:(CGFloat)delta train:(TRTrain*)train;
+ (ODClassType*)type;
@end


