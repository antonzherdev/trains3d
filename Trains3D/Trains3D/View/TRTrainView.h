#import "objd.h"
@class EG;
#import "EGGL.h"
#import "EGTypes.h"
@class EGMesh;
@class EGMeshModel;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGContext;
@class EGMutableMatrix;
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

@class TRTrainView;

@interface TRTrainView : NSObject
@property (nonatomic, readonly) EGStandardMaterial* blackMaterial;

+ (id)trainView;
- (id)init;
- (ODClassType*)type;
- (EGMaterial*)trainMaterialForColor:(EGColor)color;
- (void)drawTrain:(TRTrain*)train;
+ (ODClassType*)type;
@end


