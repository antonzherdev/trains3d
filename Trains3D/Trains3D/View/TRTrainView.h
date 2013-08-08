#import "objd.h"
#import "TR3DCar.h"
#import "EGTypes.h"
@class TRTrain;
@class TRCar;
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


