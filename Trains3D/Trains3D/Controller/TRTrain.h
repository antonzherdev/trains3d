#import "objd.h"
#import "CNList.h"
#import "EGTypes.h"
@class EGMapSso;
@class EGLine;
@class EGSlopeLine;
@class EGVerticalLine;
@protocol EGFigure;
@class EGLineSegment;
@class EGPolygon;
@class EGThickLineSegment;
@class TRColor;
@class TRCityAngle;
@class TRCity;
@class TRLevelRules;
@class TRLevel;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacleType;
@class TRObstacle;
@class TRRailroad;
@class TRRailroadBuilder;

@class TRTrain;
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


@interface TRTrain : NSObject
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) id<CNList> cars;
@property (nonatomic, readonly) NSUInteger speed;

+ (id)trainWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRColor*)color cars:(id<CNList>)cars speed:(NSUInteger)speed;
- (id)initWithLevel:(TRLevel*)level trainType:(TRTrainType*)trainType color:(TRColor*)color cars:(id<CNList>)cars speed:(NSUInteger)speed;
- (void)startFromCity:(TRCity*)city;
- (void)setHead:(TRRailPoint*)head;
- (void)updateWithDelta:(double)delta;
- (BOOL)isLockedTheSwitch:(TRSwitch*)theSwitch;
@end


@interface TRCarType : ODEnum
@property (nonatomic, readonly) double length;
@property (nonatomic, readonly) double width;
@property (nonatomic, readonly) double frontConnectorLength;
@property (nonatomic, readonly) double backConnectorLength;
@property (nonatomic, readonly) BOOL isEngine;

- (double)fullLength;
+ (TRCarType*)car;
+ (TRCarType*)engine;
+ (NSArray*)values;
@end


@interface TRCar : NSObject
@property (nonatomic, readonly) TRCarType* carType;
@property (nonatomic, retain) TRRailPoint* frontConnector;
@property (nonatomic, retain) TRRailPoint* backConnector;
@property (nonatomic, retain) TRRailPoint* head;
@property (nonatomic, retain) TRRailPoint* tail;

+ (id)carWithCarType:(TRCarType*)carType;
- (id)initWithCarType:(TRCarType*)carType;
- (double)frontConnectorLength;
- (double)backConnectorLength;
- (double)length;
- (double)width;
- (double)fullLength;
- (EGThickLineSegment*)figure;
@end


@interface TRTrainGenerator : NSObject
@property (nonatomic, readonly) TRTrainType* trainType;
@property (nonatomic, readonly) id<CNList> carsCount;
@property (nonatomic, readonly) id<CNList> speed;
@property (nonatomic, readonly) id<CNList> carTypes;

+ (id)trainGeneratorWithTrainType:(TRTrainType*)trainType carsCount:(id<CNList>)carsCount speed:(id<CNList>)speed carTypes:(id<CNList>)carTypes;
- (id)initWithTrainType:(TRTrainType*)trainType carsCount:(id<CNList>)carsCount speed:(id<CNList>)speed carTypes:(id<CNList>)carTypes;
- (id<CNList>)generateCars;
- (NSUInteger)generateSpeed;
@end


