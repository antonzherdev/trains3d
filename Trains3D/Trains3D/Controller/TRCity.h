#import "objd.h"
#import "PGVec.h"
#import "TRRailPoint.h"
#import "PGController.h"
#import "PGMapIso.h"
@class TRStr;
@class TRStrings;
@class TRTrain;
@class PGCollisionBox;
@class TRLevel;
@class PGCounter;
@class PGRigidBody;
@class PGMat4;
@class CNSlot;
@class CNVar;
@class PGEmptyCounter;
@class TRLevelRules;
@class CNReact;
@class CNSignal;

@class TRCityState;
@class TRCity;
@class TRCityColor;
@class TRCityAngle;

typedef enum TRCityColorR {
    TRCityColor_Nil = 0,
    TRCityColor_orange = 1,
    TRCityColor_green = 2,
    TRCityColor_pink = 3,
    TRCityColor_beige = 4,
    TRCityColor_purple = 5,
    TRCityColor_blue = 6,
    TRCityColor_red = 7,
    TRCityColor_mint = 8,
    TRCityColor_yellow = 9,
    TRCityColor_grey = 10
} TRCityColorR;
@interface TRCityColor : CNEnum
@property (nonatomic, readonly) PGVec4 color;
@property (nonatomic, readonly) NSString*(^localNameFunc)();
@property (nonatomic, readonly) PGVec4 trainColor;

- (NSString*)localName;
+ (NSArray*)values;
+ (TRCityColor*)value:(TRCityColorR)r;
@end


typedef enum TRCityAngleR {
    TRCityAngle_Nil = 0,
    TRCityAngle_angle0 = 1,
    TRCityAngle_angle90 = 2,
    TRCityAngle_angle180 = 3,
    TRCityAngle_angle270 = 4
} TRCityAngleR;
@interface TRCityAngle : CNEnum
@property (nonatomic, readonly) NSInteger angle;
@property (nonatomic, readonly) TRRailFormR form;
@property (nonatomic, readonly) BOOL back;

- (TRRailConnectorR)in;
- (TRRailConnectorR)out;
+ (NSArray*)values;
+ (TRCityAngle*)value:(TRCityAngleR)r;
@end


@interface TRCityState : NSObject {
@public
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
- (CNClassType*)type;
- (BOOL)canRunNewTrain;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRCity : PGUpdatable_impl {
@public
    __weak TRLevel* _level;
    TRCityColorR _color;
    PGVec2i _tile;
    TRCityAngleR _angle;
    BOOL _left;
    BOOL _right;
    BOOL _bottom;
    BOOL _top;
    TRTrain* __expectedTrain;
    PGCounter* __expectedTrainCounter;
    BOOL __wasSentIsAboutToRun;
    BOOL __isWaiting;
    NSArray* _bodies;
}
@property (nonatomic, readonly, weak) TRLevel* level;
@property (nonatomic, readonly) TRCityColorR color;
@property (nonatomic, readonly) PGVec2i tile;
@property (nonatomic, readonly) TRCityAngleR angle;
@property (nonatomic, readonly) BOOL left;
@property (nonatomic, readonly) BOOL right;
@property (nonatomic, readonly) BOOL bottom;
@property (nonatomic, readonly) BOOL top;
@property (nonatomic, readonly) NSArray* bodies;

+ (instancetype)cityWithLevel:(TRLevel*)level color:(TRCityColorR)color tile:(PGVec2i)tile angle:(TRCityAngleR)angle;
- (instancetype)initWithLevel:(TRLevel*)level color:(TRCityColorR)color tile:(PGVec2i)tile angle:(TRCityAngleR)angle;
- (CNClassType*)type;
- (NSString*)description;
- (TRRailPoint)startPoint;
- (CGFloat)startPointX;
- (TRCityState*)state;
- (TRCity*)restoreState:(TRCityState*)state;
- (TRTrain*)expectedTrain;
- (void)expectTrain:(TRTrain*)train;
- (PGCounter*)expectedTrainCounter;
- (void)updateWithDelta:(CGFloat)delta;
- (void)waitToRunTrain;
- (BOOL)isWaitingToRunTrain;
- (void)resumeTrainRunning;
- (BOOL)canRunNewTrain;
+ (PGCollisionBox*)box;
+ (CNClassType*)type;
@end


