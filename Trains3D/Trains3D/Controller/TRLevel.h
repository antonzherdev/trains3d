#import "objd.h"
#import "EGTypes.h"
@class EGMapSso;
@class TRCityAngle;
@class TRCity;
@class TRColor;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRRailroad;
@class TRRailroadBuilder;
#import "TRRailPoint.h"
@class TRTrain;
@class TRCar;

@class TRLevel;

@interface TRLevel : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) TRRailroad* railroad;

+ (id)levelWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (NSArray*)cities;
- (NSArray*)trains;
- (void)createNewCity;
- (void)runSample;
- (void)updateWithDelta:(double)delta;
- (void)tryTurnTheSwitch:(TRSwitch*)theSwitch;
@end


