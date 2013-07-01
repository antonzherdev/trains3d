#import "objd.h"
#import "EGGL.h"
#import "TRCity.h"

@interface TRCityView : NSObject
+ (id)cityView;
- (id)init;
- (void)drawCity:(TRCity*)city;
@end


