#import "objd.h"
#import "TRRailPoint.h"
#import "EGScene.h"
#import "TRCar.h"
#import "GEVec.h"
@class TRObstacle;
@class TRObstacleType;
@class TRLevel;
@class EGMapSso;
@class TRRailroad;
@class TRCityColor;
@class TRCity;
@class TRSwitch;
@class TRRail;

@class TRTrain;
@class TRTrainGenerator;
@class TRTrainType;

@interface TRTrainType : ODEnum
@property (nonatomic, readonly) BOOL(^obstacleProcessor)(TRLevel*, TRTrain*, TRObstacle*);

+ (TRTrainType*)simple;
+ (TRTrainType*)crazy;
+ (TRTrainType*)fast;
+ (TRTrainType*)repairer;
+ (NSArray*)values;
@end


@interface TRTrain : NSObject<EGUpdatable>
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) TRCityColor* color;
@property (nonatomic, readonly) id<CNSeq>(^__cars)(TRTrain*);
@property (nonatomic, readonly) NSUInteger speed;
@property (nonatomic) id viewData;
@property (nonatomic) id soundData;
@property (nonatomic, readonly) id<CNSeq> cars;
@property (nonatomic, readonly) CGFloat speedFloat;
@property (nonatomic) BOOL isDying;

+ (id)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color __cars:(id<CNSeq>(^)(TRTrain*))__cars speed:(NSUInteger)speed;
- (id)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRCityColor*)color __cars:(id<CNSeq>(^)(TRTrain*))__cars speed:(NSUInteger)speed;
- (ODClassType*)type;
- (BOOL)isBack;
- (void)startFromCity:(TRCity*)city;
- (NSString*)description;
- (TRRailPoint)head;
- (void)setHead:(TRRailPoint)head;
- (CGFloat)time;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isInTile:(GEVec2i)tile;
- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch;
- (BOOL)isLockedRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


@interface TRTrainGenerator : NSObject
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) id<CNSeq> carsCount;
@property (nonatomic, readonly) id<CNSeq> speed;
@property (nonatomic, readonly) id<CNSeq> carTypes;

+ (id)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes;
- (id)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNSeq>)carsCount speed:(id<CNSeq>)speed carTypes:(id<CNSeq>)carTypes;
- (ODClassType*)type;
- (id<CNSeq>)generateCarsForTrain:(TRTrain*)train;
- (NSUInteger)generateSpeed;
+ (ODClassType*)type;
@end


