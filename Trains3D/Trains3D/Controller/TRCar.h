#import "objd.h"
#import "GEVec.h"
#import "TRRailPoint.h"
@protocol EGCollisionShape;
@class EGCollisionBox2d;
@class EGCollisionBox;
@class TRTrain;
@class EGCollisionBody;
@class EGRigidBody;
@class GEMat4;

@class TREngineType;
@class TRCar;
@class TRCarType;
typedef struct TRCarPosition TRCarPosition;

@interface TREngineType : NSObject
@property (nonatomic, readonly) GEVec3 tubePos;

+ (id)engineTypeWithTubePos:(GEVec3)tubePos;
- (id)initWithTubePos:(GEVec3)tubePos;
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
@property (nonatomic, readonly) EGCollisionBody* collisionBody;
@property (nonatomic, readonly) EGRigidBody* kinematicBody;

+ (id)carWithTrain:(TRTrain*)train carType:(TRCarType*)carType;
- (id)initWithTrain:(TRTrain*)train carType:(TRCarType*)carType;
- (ODClassType*)type;
- (EGRigidBody*)dynamicBody;
- (TRCarPosition)position;
- (void)setPosition:(TRCarPosition)position;
- (GEVec2)midPoint;
+ (ODClassType*)type;
@end


struct TRCarPosition {
    TRRailPoint frontConnector;
    TRRailPoint head;
    TRRailPoint tail;
    TRRailPoint backConnector;
    GELine2 line;
};
static inline TRCarPosition TRCarPositionMake(TRRailPoint frontConnector, TRRailPoint head, TRRailPoint tail, TRRailPoint backConnector, GELine2 line) {
    return (TRCarPosition){frontConnector, head, tail, backConnector, line};
}
static inline BOOL TRCarPositionEq(TRCarPosition s1, TRCarPosition s2) {
    return TRRailPointEq(s1.frontConnector, s2.frontConnector) && TRRailPointEq(s1.head, s2.head) && TRRailPointEq(s1.tail, s2.tail) && TRRailPointEq(s1.backConnector, s2.backConnector) && GELine2Eq(s1.line, s2.line);
}
static inline NSUInteger TRCarPositionHash(TRCarPosition self) {
    NSUInteger hash = 0;
    hash = hash * 31 + TRRailPointHash(self.frontConnector);
    hash = hash * 31 + TRRailPointHash(self.head);
    hash = hash * 31 + TRRailPointHash(self.tail);
    hash = hash * 31 + TRRailPointHash(self.backConnector);
    hash = hash * 31 + GELine2Hash(self.line);
    return hash;
}
NSString* TRCarPositionDescription(TRCarPosition self);
TRCarPosition trCarPositionApplyFrontConnectorHeadTailBackConnector(TRRailPoint frontConnector, TRRailPoint head, TRRailPoint tail, TRRailPoint backConnector);
BOOL trCarPositionIsInTile(TRCarPosition self, GEVec2i tile);
ODPType* trCarPositionType();
@interface TRCarPositionWrap : NSObject
@property (readonly, nonatomic) TRCarPosition value;

+ (id)wrapWithValue:(TRCarPosition)value;
- (id)initWithValue:(TRCarPosition)value;
@end



