#import "objd.h"
#import "GEVec.h"
#import "TRRailPoint.h"
@protocol EGCollisionShape;
@class EGCollisionBox2d;
@class EGCollisionBox;
@class TRTrain;
@class GEMat4;
@class TRRail;

@class TREngineType;
@class TRCar;
@class TRCarState;
@class TRDieCarState;
@class TRLiveCarState;
@class TRCarType;

@interface TREngineType : NSObject {
@private
    GEVec3 _tubePos;
    CGFloat _tubeSize;
}
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


@interface TRCar : NSObject {
@private
    __weak TRTrain* _train;
    TRCarType* _carType;
    NSUInteger _number;
}
@property (nonatomic, readonly, weak) TRTrain* train;
@property (nonatomic, readonly) TRCarType* carType;
@property (nonatomic, readonly) NSUInteger number;

+ (instancetype)carWithTrain:(TRTrain*)train carType:(TRCarType*)carType number:(NSUInteger)number;
- (instancetype)initWithTrain:(TRTrain*)train carType:(TRCarType*)carType number:(NSUInteger)number;
- (ODClassType*)type;
- (BOOL)isEqualCar:(TRCar*)car;
- (NSUInteger)hash;
+ (ODClassType*)type;
@end


@interface TRCarState : NSObject {
@private
    TRCar* _car;
    TRCarType* _carType;
}
@property (nonatomic, readonly) TRCar* car;
@property (nonatomic, readonly) TRCarType* carType;

+ (instancetype)carStateWithCar:(TRCar*)car;
- (instancetype)initWithCar:(TRCar*)car;
- (ODClassType*)type;
- (GEMat4*)matrix;
+ (ODClassType*)type;
@end


@interface TRDieCarState : TRCarState {
@private
    GEMat4* _matrix;
    GEVec3 _velocity;
    GEVec3 _angularVelocity;
}
@property (nonatomic, readonly) GEMat4* matrix;
@property (nonatomic, readonly) GEVec3 velocity;
@property (nonatomic, readonly) GEVec3 angularVelocity;

+ (instancetype)dieCarStateWithCar:(TRCar*)car matrix:(GEMat4*)matrix velocity:(GEVec3)velocity angularVelocity:(GEVec3)angularVelocity;
- (instancetype)initWithCar:(TRCar*)car matrix:(GEMat4*)matrix velocity:(GEVec3)velocity angularVelocity:(GEVec3)angularVelocity;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRLiveCarState : TRCarState {
@private
    TRRailPoint _frontConnector;
    TRRailPoint _head;
    TRRailPoint _tail;
    TRRailPoint _backConnector;
    GELine2 _line;
    GEVec2 _midPoint;
    GEMat4* _matrix;
}
@property (nonatomic, readonly) TRRailPoint frontConnector;
@property (nonatomic, readonly) TRRailPoint head;
@property (nonatomic, readonly) TRRailPoint tail;
@property (nonatomic, readonly) TRRailPoint backConnector;
@property (nonatomic, readonly) GELine2 line;
@property (nonatomic, readonly) GEVec2 midPoint;
@property (nonatomic, readonly) GEMat4* matrix;

+ (instancetype)liveCarStateWithCar:(TRCar*)car frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector line:(GELine2)line;
- (instancetype)initWithCar:(TRCar*)car frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector line:(GELine2)line;
- (ODClassType*)type;
+ (TRLiveCarState*)applyCar:(TRCar*)car frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector;
- (BOOL)isOnRail:(TRRail*)rail;
+ (ODClassType*)type;
@end


