#import "objd.h"
#import "EGTypes.h"
@class TRColor;
#import "TRRailPoint.h"

@class TRCity;
@class TRCityAngle;

@interface TRCityAngle : ODEnum
@property (nonatomic, readonly) NSInteger angle;
@property (nonatomic, readonly) TRRailForm* form;
@property (nonatomic, readonly) BOOL back;

+ (NSArray*)values;
+ (TRCityAngle*)angle0;
+ (TRCityAngle*)angle90;
+ (TRCityAngle*)angle180;
+ (TRCityAngle*)angle270;
@end


@interface TRCity : NSObject
@property (nonatomic, readonly) TRColor* color;
@property (nonatomic, readonly) EGIPoint tile;
@property (nonatomic, readonly) TRCityAngle* angle;

+ (id)cityWithColor:(TRColor*)color tile:(EGIPoint)tile angle:(TRCityAngle*)angle;
- (id)initWithColor:(TRColor*)color tile:(EGIPoint)tile angle:(TRCityAngle*)angle;
- (TRRailPoint)startPoint;
@end


