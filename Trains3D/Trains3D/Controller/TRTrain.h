#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"
@class TRObstacle;
@class TRObstacleType;
@class TRLevel;
@class TRRailroad;
@class TRColor;
@class TRRailPoint;
@class TRCity;
@class TRRailPointCorrection;
@class EGMapSso;
@class TRSwitch;
@class TRRailConnector;
@protocol EGCollisionShape;
@class EGCollisionBox2d;
@class EGThickLineSegment;
@class EGLineSegment;

@class TRTrain;
@class TREngineType;
@class TRCar;
@class TRTrainGenerator;
@class TRTrainType;
@class TRCarType;

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

+ (id)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRColor*)color _cars:(id<CNSeq>(^)(TRTrain*))_cars speed:(NSUInteger)speed;
- (id)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRColor*)color _cars:(id<CNSeq>(^)(TRTrain*))_cars speed:(NSUInteger)speed;
- (ODClassType*)type;
- (id<CNSeq>)cars;
- (BOOL)isBack;
- (void)startFromCity:(TRCity*)city;
- (void)setHead:(TRRailPoint*)head;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch;
+ (ODClassType*)type;
@end


@interface TREngineType : NSObject
@property (nonatomic, readonly) EGVec3 tubePos;

+ (id)engineTypeWithTubePos:(EGVec3)tubePos;
- (id)initWithTubePos:(EGVec3)tubePos;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRCarType : ODEnum
@property (nonatomic, readonly) CGFloat length;
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat frontConnectorLength;
@property (nonatomic, readonly) CGFloat backConnectorLength;
@property (nonatomic, readonly) id engineType;
@property (nonatomic, readonly) id<EGCollisionShape> shape;

- (CGFloat)fullLength;
- (BOOL)isEngine;
+ (TRCarType*)car;
+ (TRCarType*)engine;
+ (NSArray*)values;
@end


@interface TRCar : NSObject
@property (nonatomic, readonly, weak) TRTrain* train;
@property (nonatomic, readonly) TRCarType* carType;
@property (nonatomic, retain) TRRailPoint* frontConnector;
@property (nonatomic, retain) TRRailPoint* backConnector;
@property (nonatomic, retain) TRRailPoint* head;
@property (nonatomic, retain) TRRailPoint* tail;

+ (id)carWithTrain:(TRTrain*)train carType:(TRCarType*)carType;
- (id)initWithTrain:(TRTrain*)train carType:(TRCarType*)carType;
- (ODClassType*)type;
- (CGFloat)frontConnectorLength;
- (CGFloat)backConnectorLength;
- (CGFloat)length;
- (CGFloat)width;
- (CGFloat)fullLength;
- (EGThickLineSegment*)figure;
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


