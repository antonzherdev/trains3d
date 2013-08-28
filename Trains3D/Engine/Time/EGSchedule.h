#import "objd.h"
#import "CNTreeMap.h"
#import "EGTypes.h"

@class EGSchedule;
@class EGAnimation;

@interface EGSchedule : NSObject<EGController>
+ (id)schedule;
- (id)init;
- (void)scheduleEvent:(void(^)())event after:(CGFloat)after;
- (void)updateWithDelta:(CGFloat)delta;
- (CGFloat)time;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGAnimation : NSObject<EGController>
@property (nonatomic, readonly) CGFloat length;
@property (nonatomic, readonly) void(^finish)();

+ (id)animationWithLength:(CGFloat)length finish:(void(^)())finish;
- (id)initWithLength:(CGFloat)length finish:(void(^)())finish;
- (CGFloat)time;
- (BOOL)isRun;
- (BOOL)isStopped;
- (void)updateWithDelta:(CGFloat)delta;
- (ODType*)type;
+ (ODType*)type;
@end


