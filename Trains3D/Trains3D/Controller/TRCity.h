#import "objd.h"
#import "GEVec.h"
#import "EGScene.h"
#import "TRRailPoint.h"
#import "EGMapIso.h"
@class TRStr;
@class TRStrings;
@class TRTrain;
@class EGCollisionBox;
@class TRLevel;
@class EGCounter;
@class EGRigidBody;
@class GEMat4;
@class ATSlot;
@class ATVar;
@class EGEmptyCounter;
@class TRLevelRules;
@class ATReact;
@class ATSignal;

@class TRCityState;
@class TRCity;
@class TRCityColor;
@class TRCityAngle;

@interface TRCityColor : ODEnum
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) NSString*(^localNameFunc)();
@property (nonatomic, readonly) GEVec4 trainColor;

- (NSString*)localName;
+ (TRCityColor*)orange;
+ (TRCityColor*)green;
+ (TRCityColor*)pink;
+ (TRCityColor*)beige;
+ (TRCityColor*)purple;
+ (TRCityColor*)blue;
+ (TRCityColor*)red;
+ (TRCityColor*)mint;
+ (TRCityColor*)yellow;
+ (TRCityColor*)grey;
+ (NSArray*)values;
@end


@interface TRCityAngle : ODEnum
@property (nonatomic, readonly) NSInteger angle;
@property (nonatomic, readonly) TRRailForm* form;
@property (nonatomic, readonly) BOOL back;

- (TRRailConnector*)in;
- (TRRailConnector*)out;
+ (TRCityAngle*)angle0;
+ (TRCityAngle*)angle90;
+ (TRCityAngle*)angle180;
+ (TRCityAngle*)angle270;
+ (NSArray*)values;
@end


@interface TRCityState : NSObject {
@protected
    TRCity* _city;
    CGFloat _expectedTrainCounterTime;
    TRTrain* _expectedTrain;
    BOOL _isWaiting;
}
@property (nonatomic, readonly) TRCity* city;
@property (nonatomic, readonly) CGFloat expectedTrainCounterTime;
@property (nonatomic, readonly) TRTrain* expectedTrain;
@property (nonatomic, readonly) BOOL isWaiting;

+ (instancetype)cityStateWithCity:(TRCity*)city expectedTrainCounterTime:(CGFloat)expectedTrainCounterTime expectedTrain:(TRTrain*)expectedTrain isWaiting:(BOOL)isWaiting;
- (instancetype)initWithCity:(TRCity*)city expectedTrainCounterTime:(CGFloat)expectedTrainCounterTime expectedTrain:(TRTrain*)expectedTrain isWaiting:(BOOL)isWaiting;
- (ODClassType*)type;
- (BOOL)canRunNewTrain;
+ (ODClassType*)type;
@end


@interface TRCity : NSObject<EGUpdatable> {
@protected
    __weak TRLevel* _level;
    TRCityColor* _color;
    GEVec2i _tile;
    TRCityAngle* _angle;
    BOOL _left;
    BOOL _right;
    BOOL _bottom;
    BOOL _top;
    TRTrain* __expectedTrain;
    EGCounter* __expectedTrainCounter;
    BOOL __wasSentIsAboutToRun;
    BOOL __isWaiting;
    NSArray* _bodies;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRCityColor* color;
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRCityAngle* angle;
@property (nonatomic, readonly) BOOL left;
@property (nonatomic, readonly) BOOL right;
@property (nonatomic, readonly) BOOL bottom;
@property (nonatomic, readonly) BOOL top;
@property (nonatomic, readonly) NSArray* bodies;

+ (instancetype)cityWithLevel:(TRLevel*)level color:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle;
- (instancetype)initWithLevel:(TRLevel*)level color:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle;
- (ODClassType*)type;
- (NSString*)description;
- (TRRailPoint)startPoint;
- (CGFloat)startPointX;
- (TRCityState*)state;
- (TRCity*)restoreState:(TRCityState*)state;
- (TRTrain*)expectedTrain;
- (void)expectTrain:(TRTrain*)train;
- (EGCounter*)expectedTrainCounter;
- (void)updateWithDelta:(CGFloat)delta;
- (void)waitToRunTrain;
- (BOOL)isWaitingToRunTrain;
- (void)resumeTrainRunning;
- (BOOL)canRunNewTrain;
+ (EGCollisionBox*)box;
+ (ODClassType*)type;
@end


