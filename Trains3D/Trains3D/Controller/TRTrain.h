#import "objd.h"
#import "EGTypes.h"
@class EGMapSso;
@class TRColor;
@class TRCityAngle;
@class TRCity;
@class TRLevel;
#import "TRRailPoint.h"
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRTrain;
@class TRCar;

@interface TRTrain : NSObject
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) NSArray* cars;
@property (nonatomic, readonly) double speed;

+ (id)trainWithLevel:(TRLevel*)level color:(TRColor*)color cars:(NSArray*)cars speed:(double)speed;
- (id)initWithLevel:(TRLevel*)level color:(TRColor*)color cars:(NSArray*)cars speed:(double)speed;
- (void)startFromCity:(TRCity*)city;
- (void)updateWithDelta:(double)delta;
- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch;
@end


@interface TRCar : NSObject
@property (nonatomic) TRRailPoint head;
@property (nonatomic) TRRailPoint tail;
@property (nonatomic) TRRailPoint nextHead;

+ (id)car;
- (id)init;
- (double)length;
@end


