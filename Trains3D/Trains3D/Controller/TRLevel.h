#import "objd.h"
#import "EGTypes.h"
@class TRCityAngle;
@class TRCity;
@class TRColor;
@class TRRail;
@class TRSwitch;
@class TRRailroad;
@class TRRailroadBuilder;
#import "TRRailPoint.h"
@class TRTrain;
@class TRCar;

@class TRLevel;

@interface TRLevel : NSObject
@property (nonatomic, readonly) EGISize mapSize;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) NSArray* cities;
@property (nonatomic, readonly) NSArray* trains;

+ (id)levelWithMapSize:(EGISize)mapSize;
- (id)initWithMapSize:(EGISize)mapSize;
- (void)createNewCity;
- (void)runSample;
- (void)updateWithDelta:(CGFloat)delta;
- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch;
@end


