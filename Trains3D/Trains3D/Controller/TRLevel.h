#import "objd.h"
#import "EGTypes.h"
@class TRCityAngle;
@class TRCity;
@class TRColor;
@class TRRail;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRTrain;
@class TRCar;

@class TRLevel;

@interface TRLevel : NSObject
@property (nonatomic, readonly) EGISize mapSize;
@property (nonatomic, readonly) NSArray* cities;
@property (nonatomic, readonly) TRRailroad* railroad;
@property (nonatomic, readonly) NSArray* trains;

+ (id)levelWithMapSize:(EGISize)mapSize;
- (id)initWithMapSize:(EGISize)mapSize;
- (void)createNewCity;
- (void)runSample;
@end


