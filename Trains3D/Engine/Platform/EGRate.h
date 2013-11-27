#import "objd.h"
#import "iRate.h"

@class EGRate;

@interface EGRate : NSObject<iRateDelegate>
+ (id)rate;
- (id)init;
- (ODClassType*)type;
- (BOOL)isRated;
- (BOOL)isRatedThisVersion;
- (void)showRate;
+ (EGRate*)instance;
+ (ODClassType*)type;
@end


