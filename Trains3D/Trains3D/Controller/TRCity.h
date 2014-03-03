#import "objd.h"
#import "GEVec.h"
#import "EGScene.h"
#import "TRRailPoint.h"
@class TRStr;
@class TRStrings;
@class EGCollisionBox;
@class EGCounter;
@class TRTrain;
@class EGRigidBody;
@class GEMat4;

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


@interface TRCity : NSObject<EGUpdatable>
@property (nonatomic, readonly) TRCityColor* color;
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRCityAngle* angle;
@property (nonatomic, retain) EGCounter* expectedTrainCounter;
@property (nonatomic, retain) TRTrain* expectedTrain;
@property (nonatomic, readonly) id<CNSeq> bodies;

+ (instancetype)cityWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle;
- (instancetype)initWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle;
- (ODClassType*)type;
- (TRRailPoint)startPoint;
- (void)updateWithDelta:(CGFloat)delta;
- (void)waitToRunTrain;
- (BOOL)isWaitingToRunTrain;
- (void)resumeTrainRunning;
- (BOOL)canRunNewTrain;
+ (EGCollisionBox*)box;
+ (ODClassType*)type;
@end


