#import "objd.h"
#import "GEVec.h"
#import "TRRailPoint.h"
#import "EGController.h"
#import "EGMapIso.h"
@class TRStr;
@class TRStrings;
@class TRTrain;
@class EGCollisionBox;
@class TRLevel;
@class EGCounter;
@class EGRigidBody;
@class GEMat4;
@class CNSlot;
@class CNVar;
@class EGEmptyCounter;
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
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) NSString*(^localNameFunc)();
@property (nonatomic, readonly) GEVec4 trainColor;

- (NSString*)localName;
+ (NSArray*)values;
@end
static TRCityColor* TRCityColor_Values[11];
static TRCityColor* TRCityColor_orange_Desc;
static TRCityColor* TRCityColor_green_Desc;
static TRCityColor* TRCityColor_pink_Desc;
static TRCityColor* TRCityColor_beige_Desc;
static TRCityColor* TRCityColor_purple_Desc;
static TRCityColor* TRCityColor_blue_Desc;
static TRCityColor* TRCityColor_red_Desc;
static TRCityColor* TRCityColor_mint_Desc;
static TRCityColor* TRCityColor_yellow_Desc;
static TRCityColor* TRCityColor_grey_Desc;


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
@end
static TRCityAngle* TRCityAngle_Values[5];
static TRCityAngle* TRCityAngle_angle0_Desc;
static TRCityAngle* TRCityAngle_angle90_Desc;
static TRCityAngle* TRCityAngle_angle180_Desc;
static TRCityAngle* TRCityAngle_angle270_Desc;


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
- (CNClassType*)type;
- (BOOL)canRunNewTrain;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


@interface TRCity : EGUpdatable_impl {
@protected
    __weak TRLevel* _level;
    TRCityColorR _color;
    GEVec2i _tile;
    TRCityAngleR _angle;
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
@property (nonatomic, readonly) TRCityColorR color;
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRCityAngleR angle;
@property (nonatomic, readonly) BOOL left;
@property (nonatomic, readonly) BOOL right;
@property (nonatomic, readonly) BOOL bottom;
@property (nonatomic, readonly) BOOL top;
@property (nonatomic, readonly) NSArray* bodies;

+ (instancetype)cityWithLevel:(TRLevel*)level color:(TRCityColorR)color tile:(GEVec2i)tile angle:(TRCityAngleR)angle;
- (instancetype)initWithLevel:(TRLevel*)level color:(TRCityColorR)color tile:(GEVec2i)tile angle:(TRCityAngleR)angle;
- (CNClassType*)type;
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
+ (CNClassType*)type;
@end


