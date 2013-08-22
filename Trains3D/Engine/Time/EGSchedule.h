#import "objd.h"
#import "CNTreeMap.h"
#import "EGTypes.h"

@class EGSchedule;
@class EGAnimation;

@interface EGSchedule : NSObject<EGController>
+ (id)schedule;
- (id)init;
- (void)scheduleEvent:(void(^)())event after:(float)after;
- (void)updateWithDelta:(float)delta;
- (float)time;
@end


@interface EGAnimation : NSObject<EGController>
@property (nonatomic, readonly) float length;
@property (nonatomic, readonly) void(^finish)();

+ (id)animationWithLength:(float)length finish:(void(^)())finish;
- (id)initWithLength:(float)length finish:(void(^)())finish;
- (float)time;
- (BOOL)isRun;
- (BOOL)isStopped;
- (void)updateWithDelta:(float)delta;
@end


