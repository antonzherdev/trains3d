#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
@class TRSmokeView;
@class EGStandardMaterial;
@class EGColorSource;
@class EGMaterial;
@class TRTrain;
@class TRSmoke;
@class TRColor;
@class EG;
@class TRCar;
@class TRCarPosition;
@class GELineSegment;
@class GEMatrix;
@class EGMatrixModel;
@class EGMatrixStack;
@class TRCarType;
@class TR3D;
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
+ (ODClassType*)type;
@end


