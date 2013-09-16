#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
@class TRObstacle;
@class TRObstacleType;
@class TRLevel;
@class TRRailroad;
@class TRColor;
@class TRRailPoint;
@class TRCar;
@class TRCarType;
@class TRCity;
@class TRRailPointCorrection;
@class TRCarPosition;
@class EGMapSso;
@class TRSwitch;
@class TRRailConnector;

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


@interface TRTrain : NSObject<EGController>
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) id<CNSeq>(^_cars)(TRTrain*);
@property (nonatomic, readonly) NSUInteger speed;
@property (nonatomic) id viewData;
@property (nonatomic, readonly) CGFloat speedFloat;
@property (nonatomic) BOOL isDying;

+ (id)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRColor*)color _cars:(id<CNSeq>(^)(TRTrain*))_cars speed:(NSUInteger)speed;
- (id)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRColor*)color _cars:(id<CNSeq>(^)(TRTrain*))_cars speed:(NSUInteger)speed;
- (ODClassType*)type;
- (id<CNSeq>)cars;
- (BOOL)isBack;
- (void)startFromCity:(TRCity*)city;
- (void)setHead:(TRRailPoint*)head;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch;
+ (ODType*)type;
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
+ (ODType*)type;
@end


