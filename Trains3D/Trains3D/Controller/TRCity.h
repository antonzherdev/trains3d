#import "objd.h"
#import "GEVec.h"
#import "EGScene.h"
@class TRStr;
@protocol TRStrings;
@class TRRailForm;
@class EGCounter;
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
+ (TRCityColor*)grey;
+ (NSArray*)values;
@end


@interface TRCityAngle : ODEnum
@property (nonatomic, readonly) NSInteger angle;
@property (nonatomic, readonly) TRRailForm* form;
@property (nonatomic, readonly) BOOL back;

+ (TRCityAngle*)angle0;
+ (TRCityAngle*)angle90;
+ (TRCityAngle*)angle180;
+ (TRCityAngle*)angle270;
+ (NSArray*)values;
@end


@interface TRCity : NSObject<EGController>
@property (nonatomic, readonly) TRCityColor* color;
@property (nonatomic, readonly) GEVec2i tile;
@property (nonatomic, readonly) TRCityAngle* angle;
@property (nonatomic, retain) EGCounter* expectedTrainCounter;
@property (nonatomic, retain) TRCityColor* expectedTrainColor;

+ (id)cityWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle;
- (id)initWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle;
- (ODClassType*)type;
- (TRRailPoint*)startPoint;
- (void)updateWithDelta:(CGFloat)delta;
- (void)waitToRunTrain;
- (BOOL)isWaitingToRunTrain;
- (void)resumeTrainRunning;
- (BOOL)canRunNewTrain;
+ (ODClassType*)type;
@end


