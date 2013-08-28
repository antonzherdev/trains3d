#import "objd.h"
#import "EGGL.h"
#import "EGTypes.h"
@class EGMesh;
@class EGMeshModel;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial2;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMaterial;
@class TRTrainType;
@class TRTrain;
@class TRCarType;
@class TRCar;
@class TRTrainGenerator;
@class TRColor;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;

@class TRTrainView;

@interface TRTrainView : NSObject
+ (id)trainView;
- (id)init;
- (void)drawTrain:(TRTrain*)train;
- (ODType*)type;
+ (ODType*)type;
@end


