#import "objd.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGGL.h"
#import "EGTypes.h"
@class EGMesh;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
#import "EGMaterial.h"
@class EGMatrix;
@class TRTrainType;
@class TRTrain;
@class TREngineType;
@class TRCarType;
@class TRCar;
@class TRTrainGenerator;
@class TRColor;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;
@class TR3D;
@class TRSmoke;
@class TRSmokeParticle;
@class TRSmokeView;

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


