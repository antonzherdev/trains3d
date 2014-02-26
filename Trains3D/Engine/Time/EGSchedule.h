#import "objd.h"
#import "EGScene.h"

@class EGSchedule;
@class EGCounter;
@class EGEmptyCounter;
@class EGLengthCounter;
@class EGFinisher;
@class EGEventCounter;
@class EGCounterData;
@class EGMutableCounterArray;

@interface EGSchedule : NSObject<EGUpdatable>
+ (instancetype)schedule;
- (instancetype)init;
- (ODClassType*)type;
- (void)scheduleAfter:(CGFloat)after event:(void(^)())event;
- (void)updateWithDelta:(CGFloat)delta;
- (CGFloat)time;
- (BOOL)isEmpty;
+ (ODClassType*)type;
@end


@interface EGCounter : NSObject<EGUpdatable>
+ (instancetype)counter;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)isRunning;
- (CGFloat)time;
- (CGFloat)invTime;
- (BOOL)isStopped;
- (void)forF:(void(^)(CGFloat))f;
- (void)updateWithDelta:(CGFloat)delta;
+ (EGCounter*)applyLength:(CGFloat)length;
+ (EGCounter*)applyLength:(CGFloat)length finish:(void(^)())finish;
+ (EGCounter*)apply;
- (EGCounter*)onTime:(CGFloat)time event:(void(^)())event;
- (EGCounter*)onEndEvent:(void(^)())event;
+ (ODClassType*)type;
@end


@interface EGEmptyCounter : EGCounter
+ (instancetype)emptyCounter;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)isRunning;
- (CGFloat)time;
- (CGFloat)invTime;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGLengthCounter : EGCounter
@property (nonatomic, readonly) CGFloat length;

+ (instancetype)lengthCounterWithLength:(CGFloat)length;
- (instancetype)initWithLength:(CGFloat)length;
- (ODClassType*)type;
- (CGFloat)time;
- (CGFloat)invTime;
- (BOOL)isRunning;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGFinisher : EGCounter
@property (nonatomic, readonly) EGCounter* counter;
@property (nonatomic, readonly) void(^finish)();

+ (instancetype)finisherWithCounter:(EGCounter*)counter finish:(void(^)())finish;
- (instancetype)initWithCounter:(EGCounter*)counter finish:(void(^)())finish;
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

+ (instancetype)eventCounterWithCounter:(EGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event;
- (instancetype)initWithCounter:(EGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event;
- (ODClassType*)type;
- (BOOL)isRunning;
- (CGFloat)time;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGCounterData : EGCounter
@property (nonatomic, readonly) EGCounter* counter;
@property (nonatomic, readonly) id data;

+ (instancetype)counterDataWithCounter:(EGCounter*)counter data:(id)data;
- (instancetype)initWithCounter:(EGCounter*)counter data:(id)data;
- (ODClassType*)type;
- (BOOL)isRunning;
- (CGFloat)time;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGMutableCounterArray : NSObject<EGUpdatable>
+ (instancetype)mutableCounterArray;
- (instancetype)init;
- (ODClassType*)type;
- (id<CNSeq>)counters;
- (void)appendCounter:(EGCounterData*)counter;
- (void)appendCounter:(EGCounter*)counter data:(id)data;
- (void)updateWithDelta:(CGFloat)delta;
- (void)forEach:(void(^)(EGCounterData*))each;
+ (ODClassType*)type;
@end


