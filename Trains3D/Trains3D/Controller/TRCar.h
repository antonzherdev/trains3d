#import "objd.h"
#import "GEVec.h"
#import "TRRailPoint.h"
@protocol EGCollisionShape;
@class EGCollisionBox2d;
@class EGCollisionBox;
@class TRTrain;
@class EGRigidBody;
@class GEMat4;
@class TRRail;

@class TREngineType;
@class TRCar;
@class TRCarPosition;
@class TRCarType;

@interface TREngineType : NSObject
@property (nonatomic, readonly) GEVec3 tubePos;
@property (nonatomic, readonly) CGFloat tubeSize;

+ (instancetype)engineTypeWithTubePos:(GEVec3)tubePos tubeSize:(CGFloat)tubeSize;
- (instancetype)initWithTubePos:(GEVec3)tubePos tubeSize:(CGFloat)tubeSize;
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
+ (TRCarType*)expressCar;
+ (TRCarType*)expressEngine;
+ (NSArray*)values;
@end


@interface TRCar : NSObject
@property (nonatomic, readonly, weak) TRTrain* train;
@property (nonatomic, readonly) TRCarType* carType;
@property (nonatomic, readonly) EGRigidBody* kinematicBody;
@property (nonatomic, retain) TRCarPosition* _position;

+ (instancetype)carWithTrain:(TRTrain*)train carType:(TRCarType*)carType;
- (instancetype)initWithTrain:(TRTrain*)train carType:(TRCarType*)carType;
- (ODClassType*)type;
- (EGRigidBody*)dynamicBody;
- (TRCarPosition*)position;
- (void)setPosition:(TRCarPosition*)position;
- (void)writeKinematicMatrix;
+ (ODClassType*)type;
@end


@interface TRCarPosition : NSObject
@property (nonatomic, readonly) TRCarType* carType;
@property (nonatomic, readonly) TRRailPoint frontConnector;
@property (nonatomic, readonly) TRRailPoint head;
@property (nonatomic, readonly) TRRailPoint tail;
@property (nonatomic, readonly) TRRailPoint backConnector;
@property (nonatomic, readonly) GELine2 line;
@property (nonatomic, readonly) GEVec2 midPoint;
@property (nonatomic, readonly) GEMat4* matrix;

+ (instancetype)carPositionWithCarType:(TRCarType*)carType frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector line:(GELine2)line;
- (instancetype)initWithCarType:(TRCarType*)carType frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector line:(GELine2)line;
- (ODClassType*)type;
+ (TRCarPosition*)applyCarType:(TRCarType*)carType frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector;
- (BOOL)isOnRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


