#import "objd.h"
#import "EGTypes.h"
@class TRColor;
@class TRCityAngle;
@class TRCity;
@class TRLevel;
#import "TRRailPoint.h"
@class TRRail;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRTrain;
@class TRCar;

@interface TRTrain : NSObject
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) NSArray* cars;
@property (nonatomic, readonly) CGFloat speed;

+ (id)trainWithLevel:(TRLevel*)level color:(TRColor*)color cars:(NSArray*)cars speed:(CGFloat)speed;
- (id)initWithLevel:(TRLevel*)level color:(TRColor*)color cars:(NSArray*)cars speed:(CGFloat)speed;
- (void)startFromCity:(TRCity*)city;
- (void)updateWithDelta:(CGFloat)delta;
@end


@interface TRCar : NSObject
@property (nonatomic) TRRailPoint head;
@property (nonatomic) TRRailPoint tail;

+ (id)car;
- (id)init;
- (CGFloat)length;
@end


