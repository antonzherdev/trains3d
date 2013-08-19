#import "objd.h"
#import "EGTypes.h"
@class TRTrainType;
@class TRTrain;
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
@end


