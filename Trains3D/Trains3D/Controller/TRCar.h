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

typedef enum TRCarTypeR {
    TRCarType_Nil = 0,
    TRCarType_car = 1,
    TRCarType_engine = 2,
    TRCarType_expressCar = 3,
    TRCarType_expressEngine = 4
} TRCarTypeR;
@interface TRCarType : CNEnum
@property (nonatomic, readonly) CGFloat width;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGFloat weight;
@property (nonatomic, readonly) CGFloat startToFront;
@property (nonatomic, readonly) CGFloat frontToWheel;
@property (nonatomic, readonly) CGFloat betweenWheels;
@property (nonatomic, readonly) CGFloat wheelToBack;
@property (nonatomic, readonly) CGFloat backToEnd;
@property (nonatomic, readonly) TREngineType* engineType;
@property (nonatomic, readonly) CGFloat startToWheel;
@property (nonatomic, readonly) CGFloat wheelToEnd;
@property (nonatomic, readonly) CGFloat fullLength;
@property (nonatomic, readonly) id<EGCollisionShape> collision2dShape;
@property (nonatomic, readonly) id<EGCollisionShape> rigidShape;

- (BOOL)isEngine;
+ (NSArray*)values;
+ (TRCarType*)value:(TRCarTypeR)r;
@end


@interface TREngineType : NSObject {
@protected
    GEVec3 _tubePos;
    CGFloat _tubeSize;
}
@property (nonatomic, readonly) GEVec3 tubePos;
@property (nonatomic, readonly) CGFloat tubeSize;

+ (instancetype)engineTypeWithTubePos:(GEVec3)tubePos tubeSize:(CGFloat)tubeSize;
- (instancetype)initWithTubePos:(GEVec3)tubePos tubeSize:(CGFloat)tubeSize;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRCar : NSObject {
@protected
    __weak TRTrain* _train;
    TRCarTypeR _carType;
    NSUInteger _number;
}
@property (nonatomic, readonly, weak) TRTrain* train;
@property (nonatomic, readonly) TRCarTypeR carType;
@property (nonatomic, readonly) NSUInteger number;

+ (instancetype)carWithTrain:(TRTrain*)train carType:(TRCarTypeR)carType number:(NSUInteger)number;
- (instancetype)initWithTrain:(TRTrain*)train carType:(TRCarTypeR)carType number:(NSUInteger)number;
- (CNClassType*)type;
- (BOOL)isEqualCar:(TRCar*)car;
- (NSUInteger)hash;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
+ (CNClassType*)type;
@end


@interface TRCarState : NSObject {
@protected
    TRCar* _car;
    TRCarTypeR _carType;
}
@property (nonatomic, readonly) TRCar* car;
@property (nonatomic, readonly) TRCarTypeR carType;

+ (instancetype)carStateWithCar:(TRCar*)car;
- (instancetype)initWithCar:(TRCar*)car;
- (CNClassType*)type;
- (GEMat4*)matrix;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRDieCarState : TRCarState {
@protected
    GEMat4* _matrix;
    GEVec3 _velocity;
    GEVec3 _angularVelocity;
}
@property (nonatomic, readonly) GEMat4* matrix;
@property (nonatomic, readonly) GEVec3 velocity;
@property (nonatomic, readonly) GEVec3 angularVelocity;

+ (instancetype)dieCarStateWithCar:(TRCar*)car matrix:(GEMat4*)matrix velocity:(GEVec3)velocity angularVelocity:(GEVec3)angularVelocity;
- (instancetype)initWithCar:(TRCar*)car matrix:(GEMat4*)matrix velocity:(GEVec3)velocity angularVelocity:(GEVec3)angularVelocity;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRLiveCarState : TRCarState {
@protected
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
- (CNClassType*)type;
+ (TRLiveCarState*)applyCar:(TRCar*)car frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector;
- (BOOL)isOnRail:(TRRail*)rail;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


