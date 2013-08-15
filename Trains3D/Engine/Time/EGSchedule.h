#import "objd.h"
#import "CNTreeMap.h"
#import "EGTypes.h"

@class EGSchedule;
@class EGAnimation;

@interface EGSchedule : NSObject<EGController>
+ (id)schedule;
- (id)init;
- (void)scheduleEvent:(void(^)())event after:(double)after;
- (void)updateWithDelta:(double)delta;
- (double)time;
@end


@interface EGAnimation : NSObject<EGController>
@property (nonatomic, readonly) double length;
@property (nonatomic, readonly) void(^finish)();

+ (id)animationWithLength:(double)length finish:(void(^)())finish;
- (id)initWithLength:(double)length finish:(void(^)())finish;
- (double)time;
- (BOOL)isRun;
- (BOOL)isStopped;
- (void)updateWithDelta:(double)delta;
@end


