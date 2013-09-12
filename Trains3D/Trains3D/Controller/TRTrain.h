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
@class EGCollisionBody;
@class EGLineSegment;
@class EGMatrix;

@class TRTrain;
@class TREngineType;
@class TRCar;
@class TRCarPosition;
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
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat startToFront;
@property (nonatomic, readonly) CGFloat frontToWheel;
@property (nonatomic, readonly) CGFloat betweenWheels;
@property (nonatomic, readonly) CGFloat wheelToBack;
@property (nonatomic, readonly) CGFloat backToEnd;
@property (nonatomic, readonly) id engineType;
@property (nonatomic, readonly) CGFloat startToWheel;
@property (nonatomic, readonly) CGFloat wheelToEnd;
@property (nonatomic, readonly) CGFloat fullLength;
@property (nonatomic, readonly) id<EGCollisionShape> shape;

- (BOOL)isEngine;
+ (TRCarType*)car;
+ (TRCarType*)engine;
+ (NSArray*)values;
@end


@interface TRCar : NSObject
@property (nonatomic, readonly, weak) TRTrain* train;
@property (nonatomic, readonly) TRCarType* carType;
@property (nonatomic, readonly) EGCollisionBody* collisionBody;

+ (id)carWithTrain:(TRTrain*)train carType:(TRCarType*)carType;
- (id)initWithTrain:(TRTrain*)train carType:(TRCarType*)carType;
- (ODClassType*)type;
- (TRCarPosition*)position;
- (void)setPosition:(TRCarPosition*)position;
+ (ODClassType*)type;
@end


@interface TRCarPosition : NSObject
@property (nonatomic, readonly) TRRailPoint* frontConnector;
@property (nonatomic, readonly) TRRailPoint* head;
@property (nonatomic, readonly) TRRailPoint* tail;
@property (nonatomic, readonly) TRRailPoint* backConnector;
@property (nonatomic, readonly) EGLineSegment* line;

+ (id)carPositionWithFrontConnector:(TRRailPoint*)frontConnector head:(TRRailPoint*)head tail:(TRRailPoint*)tail backConnector:(TRRailPoint*)backConnector;
- (id)initWithFrontConnector:(TRRailPoint*)frontConnector head:(TRRailPoint*)head tail:(TRRailPoint*)tail backConnector:(TRRailPoint*)backConnector;
- (ODClassType*)type;
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


