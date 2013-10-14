#import "objd.h"
#import "GEVec.h"
@class TRLevel;
@class EGStandardMaterial;
@class EGColorSource;
@class EGVertexArray;
@class TRModels;
@class EGMesh;
@class TRTrain;
@class TRSmoke;
@class TRSmokeView;
@class TRCityColor;
@class EGGlobal;
@class TRCar;
@class TRCarPosition;
@class GELineSegment;
@class GEMat4;
@class EGMatrixModel;
@class EGMatrixStack;
@class TRCarType;
@class EGMaterial;
@class EGRigidBody;

@class TRTrainView;

@interface TRTrainView : NSObject
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGStandardMaterial* blackMaterial;

+ (id)trainViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (EGStandardMaterial*)trainMaterialForColor:(GEVec4)color;
- (void)draw;
- (void)drawSmoke;
- (void)drawTrains:(id<CNSeq>)trains;
- (void)drawSmokeTrains:(id<CNSeq>)trains;
- (void)drawDyingTrains:(id<CNSeq>)dyingTrains;
- (void)updateWithDelta:(CGFloat)delta train:(TRTrain*)train;
+ (ODClassType*)type;
@end


