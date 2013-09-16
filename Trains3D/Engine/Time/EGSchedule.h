#import "objd.h"
#import "EGTypes.h"

@class EGSchedule;
@class EGAnimation;

@interface EGSchedule : NSObject<EGController>
+ (id)schedule;
- (id)init;
- (ODClassType*)type;
- (void)scheduleAfter:(CGFloat)after event:(void(^)())event;
- (void)updateWithDelta:(CGFloat)delta;
- (CGFloat)time;
+ (ODType*)type;
@end


@interface EGAnimation : NSObject<EGController>
@property (nonatomic, readonly) CGFloat length;
@property (nonatomic, readonly) void(^finish)();

+ (id)animationWithLength:(CGFloat)length finish:(void(^)())finish;
- (id)initWithLength:(CGFloat)length finish:(void(^)())finish;
- (ODClassType*)type;
- (CGFloat)time;
- (BOOL)isRun;
- (BOOL)isStopped;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODType*)type;
@end


