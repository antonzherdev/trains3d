#import "objd.h"
@class TRCity;
@class TRColor;

@class TRCityView;

@interface TRCityView : NSObject
+ (id)cityView;
- (id)init;
- (void)drawCity:(TRCity*)city;
@end


