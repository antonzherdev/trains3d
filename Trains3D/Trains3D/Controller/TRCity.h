#import "objd.h"
#import "GEVec.h"
#import "EGScene.h"
@class TRStr;
@protocol TRStrings;
@class TRRailForm;
@class TRRailConnector;
@class EGCollisionBox;
@class EGCounter;
@class TRTrain;
@class EGRigidBody;
@class GEMat4;
@class TRRailPoint;

@class TRCity;
@class TRCityColor;
@class TRCityAngle;

@interface TRCityColor : ODEnum
@property (nonatomic, readonly) GEVec4 color;
@property (nonatomic, readonly) NSString* localName;
@property (nonatomic, readonly) GEVec4 trainColor;

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

+ (id)cityWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle;
- (id)initWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle;
- (ODClassType*)type;
- (TRRailPoint*)startPoint;
- (void)updateWithDelta:(CGFloat)delta;
- (void)waitToRunTrain;
- (BOOL)isWaitingToRunTrain;
- (void)resumeTrainRunning;
- (BOOL)canRunNewTrain;
+ (EGCollisionBox*)box;
+ (ODClassType*)type;
@end


