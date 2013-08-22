#import "objd.h"
#import "EGTypes.h"
@class EGSchedule;
@class EGAnimation;
@class TRColor;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;

@class TRCity;
@class TRCityAngle;

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
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) EGPointI tile;
@property (nonatomic, readonly) TRCityAngle* angle;
@property (nonatomic) id expectedTrainAnimation;

+ (id)cityWithColor:(TRColor*)color tile:(EGPointI)tile angle:(TRCityAngle*)angle;
- (id)initWithColor:(TRColor*)color tile:(EGPointI)tile angle:(TRCityAngle*)angle;
- (TRRailPoint*)startPoint;
- (void)updateWithDelta:(CGFloat)delta;
@end


