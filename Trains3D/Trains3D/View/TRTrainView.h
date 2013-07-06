#import "objd.h"
#import "TR3DCar.h"
#import "EGTypes.h"
@class TRTrain;
@class TRCar;
#import "TRTypes.h"

@class TRTrainView;

@interface TRTrainView : NSObject
+ (id)trainView;
- (id)init;
- (void)drawTrain:(TRTrain*)train;
@end


