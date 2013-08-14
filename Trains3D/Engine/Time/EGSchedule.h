#import "objd.h"
#import "CNTreeMap.h"
#import "EGTypes.h"

@class EGSchedule;

@interface EGSchedule : NSObject<EGController>
+ (id)schedule;
- (id)init;
- (void)scheduleEvent:(void(^)())event after:(double)after;
- (void)updateWithDelta:(double)delta;
@end


