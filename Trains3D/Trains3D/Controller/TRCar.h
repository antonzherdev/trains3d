#import "objd.h"
#import "PGVec.h"
#import "TRRailPoint.h"
@protocol PGCollisionShape;
@class PGCollisionBox2d;
@class PGCollisionBox;
@class TRTrain;
@class PGMat4;
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
@property (nonatomic, readonly) id<PGCollisionShape> collision2dShape;
@property (nonatomic, readonly) id<PGCollisionShape> rigidShape;

- (BOOL)isEngine;
+ (NSArray*)values;
+ (TRCarType*)value:(TRCarTypeR)r;
@end


@interface TREngineType : NSObject {
@public
    PGVec3 _tubePos;
    CGFloat _tubeSize;
}
@property (nonatomic, readonly) PGVec3 tubePos;
@property (nonatomic, readonly) CGFloat tubeSize;

+ (instancetype)engineTypeWithTubePos:(PGVec3)tubePos tubeSize:(CGFloat)tubeSize;
- (instancetype)initWithTubePos:(PGVec3)tubePos tubeSize:(CGFloat)tubeSize;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRCar : NSObject {
@public
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
@public
    TRCar* _car;
    TRCarTypeR _carType;
}
@property (nonatomic, readonly) TRCar* car;
@property (nonatomic, readonly) TRCarTypeR carType;

+ (instancetype)carStateWithCar:(TRCar*)car;
- (instancetype)initWithCar:(TRCar*)car;
- (CNClassType*)type;
- (PGMat4*)matrix;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRDieCarState : TRCarState {
@public
    PGMat4* _matrix;
    PGVec3 _velocity;
    PGVec3 _angularVelocity;
}
@property (nonatomic, readonly) PGMat4* matrix;
@property (nonatomic, readonly) PGVec3 velocity;
@property (nonatomic, readonly) PGVec3 angularVelocity;

+ (instancetype)dieCarStateWithCar:(TRCar*)car matrix:(PGMat4*)matrix velocity:(PGVec3)velocity angularVelocity:(PGVec3)angularVelocity;
- (instancetype)initWithCar:(TRCar*)car matrix:(PGMat4*)matrix velocity:(PGVec3)velocity angularVelocity:(PGVec3)angularVelocity;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRLiveCarState : TRCarState {
@public
    TRRailPoint _frontConnector;
    TRRailPoint _head;
    TRRailPoint _tail;
    TRRailPoint _backConnector;
    PGLine2 _line;
    PGVec2 _midPoint;
    PGMat4* _matrix;
}
@property (nonatomic, readonly) TRRailPoint frontConnector;
@property (nonatomic, readonly) TRRailPoint head;
@property (nonatomic, readonly) TRRailPoint tail;
@property (nonatomic, readonly) TRRailPoint backConnector;
@property (nonatomic, readonly) PGLine2 line;
@property (nonatomic, readonly) PGVec2 midPoint;
@property (nonatomic, readonly) PGMat4* matrix;

+ (instancetype)liveCarStateWithCar:(TRCar*)car frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector line:(PGLine2)line;
- (instancetype)initWithCar:(TRCar*)car frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector line:(PGLine2)line;
- (CNClassType*)type;
+ (TRLiveCarState*)applyCar:(TRCar*)car frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector;
- (BOOL)isOnRail:(TRRail*)rail;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


