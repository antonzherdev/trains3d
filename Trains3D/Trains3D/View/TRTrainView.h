#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
@class TRSmokeView;
@class EGStandardMaterial;
@class EGColorSource;
@class EGMaterial;
@class TRTrain;
@class TRSmoke;
@class TRCityColor;
@class EGGlobal;
@class TRCar;
@class TRCarPosition;
@class GELineSegment;
@class GEMat4;
@class EGMatrixModel;
@class EGMatrixStack;
@class TRCarType;
@class TRModels;
@class EGRigidBody;

@class TRTrainView;

@interface TRTrainView : NSObject
@property (nonatomic, readonly) TRSmokeView* smokeView;
@property (nonatomic, readonly) EGStandardMaterial* blackMaterial;

+ (id)trainView;
- (id)init;
- (ODClassType*)type;
- (EGMaterial*)trainMaterialForColor:(EGColor)color;
- (void)drawTrains:(id<CNSeq>)trains;
- (void)drawDyingTrains:(id<CNSeq>)dyingTrains;
- (void)updateWithDelta:(CGFloat)delta train:(TRTrain*)train;
+ (ODType*)type;
@end


