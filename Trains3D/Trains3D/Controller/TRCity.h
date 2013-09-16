#import "objd.h"
#import "EGTypes.h"
#import "GEVec.h"
@class TRRailForm;
@class TRRailPoint;
@class EGAnimation;

@class TRCity;
@class TRCityColor;
@class TRCityAngle;

@interface TRCityColor : ODEnum
@property (nonatomic, readonly) EGColor color;

- (void)set;
+ (TRCityColor*)orange;
+ (TRCityColor*)green;
+ (TRCityColor*)purple;
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
@property (nonatomic) id expectedTrainAnimation;

+ (id)cityWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle;
- (id)initWithColor:(TRCityColor*)color tile:(GEVec2i)tile angle:(TRCityAngle*)angle;
- (ODClassType*)type;
- (TRRailPoint*)startPoint;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


