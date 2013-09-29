#import "objd.h"
#import "GEVec.h"
@class TRLevel;
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
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) TRSmokeView* smokeView;
@property (nonatomic, readonly) EGStandardMaterial* blackMaterial;

+ (id)trainViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (EGMaterial*)trainMaterialForColor:(GEVec4)color;
- (void)draw;
- (void)drawSmoke;
- (void)drawTrains:(id<CNSeq>)trains;
- (void)drawSmokeTrains:(id<CNSeq>)trains;
- (void)drawDyingTrains:(id<CNSeq>)dyingTrains;
- (void)updateWithDelta:(CGFloat)delta train:(TRTrain*)train;
+ (ODClassType*)type;
@end


