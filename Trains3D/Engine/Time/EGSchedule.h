#import "objd.h"
#import "EGScene.h"

@class EGSchedule;
@class EGCounter;
@class EGEmptyCounter;
@class EGLengthCounter;
@class EGFinisher;
@class EGEventCounter;

@interface EGSchedule : NSObject<EGController>
+ (id)schedule;
- (id)init;
- (ODClassType*)type;
- (void)scheduleAfter:(CGFloat)after event:(void(^)())event;
- (void)updateWithDelta:(CGFloat)delta;
- (CGFloat)time;
- (BOOL)isEmpty;
+ (ODClassType*)type;
@end


@interface EGCounter : NSObject<EGController>
+ (id)counter;
- (id)init;
- (ODClassType*)type;
- (BOOL)isRunning;
- (CGFloat)time;
- (BOOL)isStopped;
- (void)forF:(void(^)(CGFloat))f;
- (void)updateWithDelta:(CGFloat)delta;
+ (EGCounter*)applyLength:(CGFloat)length;
+ (EGCounter*)applyLength:(CGFloat)length finish:(void(^)())finish;
+ (EGCounter*)apply;
- (EGCounter*)onTime:(CGFloat)time event:(void(^)())event;
+ (ODClassType*)type;
@end


@interface EGEmptyCounter : EGCounter
+ (id)emptyCounter;
- (id)init;
- (ODClassType*)type;
- (BOOL)isRunning;
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
- (BOOL)isRunning;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGFinisher : EGCounter
@property (nonatomic, readonly) EGCounter* counter;
@property (nonatomic, readonly) void(^finish)();

+ (id)finisherWithCounter:(EGCounter*)counter finish:(void(^)())finish;
- (id)initWithCounter:(EGCounter*)counter finish:(void(^)())finish;
- (ODClassType*)type;
- (BOOL)isRunning;
- (CGFloat)time;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGEventCounter : EGCounter
@property (nonatomic, readonly) EGCounter* counter;
@property (nonatomic, readonly) CGFloat eventTime;
@property (nonatomic, readonly) void(^event)();

+ (id)eventCounterWithCounter:(EGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event;
- (id)initWithCounter:(EGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event;
- (ODClassType*)type;
- (BOOL)isRunning;
- (CGFloat)time;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


