#import "objd.h"
@class EGSchedule;
@class EGAnimation;
@class TRCityAngle;
@class TRCity;
@class TRColor;

@class TRCityView;

@interface TRCityView : NSObject
+ (id)cityView;
- (id)init;
- (void)drawCity:(TRCity*)city;
@end


