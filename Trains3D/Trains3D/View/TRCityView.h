#import "objd.h"
#import "EGGL.h"
#import "TRCity.h"

@class TRCityView;

@interface TRCityView : NSObject
+ (id)cityView;
- (id)init;
- (void)drawCity:(TRCity*)city;
@end


