#import "objd.h"
#import "EGScene.h"

@class EGSchedule;
@class EGCounter;
@class EGEmptyCounter;
@class EGLengthCounter;
@class EGFinisher;

@interface EGSchedule : NSObject<EGController>
+ (id)schedule;
- (id)init;
- (ODClassType*)type;
- (void)scheduleAfter:(CGFloat)after event:(void(^)())event;
- (void)updateWithDelta:(CGFloat)delta;
- (CGFloat)time;
+ (ODClassType*)type;
@end


@interface EGCounter : NSObject<EGController>
+ (id)counter;
- (id)init;
- (ODClassType*)type;
- (BOOL)isRun;
- (CGFloat)time;
- (BOOL)isStopped;
- (void)forF:(void(^)(CGFloat))f;
- (void)updateWithDelta:(CGFloat)delta;
+ (EGCounter*)applyLength:(CGFloat)length;
+ (EGCounter*)applyLength:(CGFloat)length finish:(void(^)())finish;
+ (EGCounter*)apply;
+ (ODClassType*)type;
@end


@interface EGEmptyCounter : EGCounter
+ (id)emptyCounter;
- (id)init;
- (ODClassType*)type;
- (BOOL)isRun;
- (CGFloat)time;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGLengthCounter : EGCounter
@property (nonatomic, readonly) CGFloat length;

+ (id)lengthCounterWithLength:(CGFloat)length;
- (id)initWithLength:(CGFloat)length;
- (ODClassType*)type;
- (CGFloat)time;
- (BOOL)isRun;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGFinisher : EGCounter
@property (nonatomic, readonly) EGCounter* counter;
@property (nonatomic, readonly) void(^finish)();

+ (id)finisherWithCounter:(EGCounter*)counter finish:(void(^)())finish;
- (id)initWithCounter:(EGCounter*)counter finish:(void(^)())finish;
- (ODClassType*)type;
- (BOOL)isRun;
- (CGFloat)time;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


