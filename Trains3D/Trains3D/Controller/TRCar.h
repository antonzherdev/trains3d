#import "objd.h"
#import "EGVec.h"
@protocol EGCollisionShape;
@class EGCollisionBox2d;
@class EGCollisionBox;
@class TRTrain;
@class EGCollisionBody;
@class EGRigidBody;
@class EGLineSegment;
@class EGMatrix;
@class TRRailPoint;

@class TREngineType;
@class TRCar;
@class TRCarPosition;
@class TRCarType;

@interface TREngineType : NSObject
@property (nonatomic, readonly) EGVec3 tubePos;

+ (id)engineTypeWithTubePos:(EGVec3)tubePos;
- (id)initWithTubePos:(EGVec3)tubePos;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRCarType : ODEnum
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGFloat weight;
@property (nonatomic, readonly) CGFloat startToFront;
@property (nonatomic, readonly) CGFloat frontToWheel;
@property (nonatomic, readonly) CGFloat betweenWheels;
@property (nonatomic, readonly) CGFloat wheelToBack;
@property (nonatomic, readonly) CGFloat backToEnd;
@property (nonatomic, readonly) id engineType;
@property (nonatomic, readonly) CGFloat startToWheel;
@property (nonatomic, readonly) CGFloat wheelToEnd;
@property (nonatomic, readonly) CGFloat fullLength;
@property (nonatomic, readonly) id<EGCollisionShape> collision2dShape;
@property (nonatomic, readonly) id<EGCollisionShape> rigidShape;

- (BOOL)isEngine;
+ (TRCarType*)car;
+ (TRCarType*)engine;
+ (NSArray*)values;
@end


@interface TRCar : NSObject
@property (nonatomic, readonly, weak) TRTrain* train;
@property (nonatomic, readonly) TRCarType* carType;
@property (nonatomic, readonly) EGCollisionBody* collisionBody;
@property (nonatomic, readonly) EGRigidBody* rigidBody;

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


