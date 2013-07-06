#import "objd.h"
@class TRCity;
#import "TRTypes.h"

@class TRCityView;

@interface TRCityView : NSObject
+ (id)cityView;
- (id)init;
- (void)drawCity:(TRCity*)city;
@end


