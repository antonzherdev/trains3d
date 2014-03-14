#import "objd.h"
#import "EGScene.h"
@class ATReact;
@class ATVal;
@class ATVar;
@class ATObserver;

@class EGSchedule;
@class EGCounter;
@class EGEmptyCounter;
@class EGLengthCounter;
@class EGFinisher;
@class EGEventCounter;
@class EGCounterData;
@class EGMutableCounterArray;

@interface EGSchedule : NSObject<EGUpdatable> {
@private
    CNMTreeMap* __map;
    CGFloat __current;
    CGFloat __next;
}
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
- (ATReact*)isRunning;
- (ATReact*)time;
- (void)restart;
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
- (ATReact*)isRunning;
- (ATReact*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
+ (ODClassType*)type;
@end


@interface EGLengthCounter : EGCounter {
@private
    CGFloat _length;
    ATVar* __time;
    ATVar* __run;
}
@property (nonatomic, readonly) CGFloat length;

+ (instancetype)lengthCounterWithLength:(CGFloat)length;
- (instancetype)initWithLength:(CGFloat)length;
- (ODClassType*)type;
- (ATReact*)time;
- (ATReact*)isRunning;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
+ (ODClassType*)type;
@end


@interface EGFinisher : EGCounter {
@private
    EGCounter* _counter;
    void(^_finish)();
    ATObserver* _obs;
}
@property (nonatomic, readonly) EGCounter* counter;
@property (nonatomic, readonly) void(^finish)();

+ (instancetype)finisherWithCounter:(EGCounter*)counter finish:(void(^)())finish;
- (instancetype)initWithCounter:(EGCounter*)counter finish:(void(^)())finish;
- (ODClassType*)type;
- (ATReact*)isRunning;
- (ATReact*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
+ (ODClassType*)type;
@end


@interface EGEventCounter : EGCounter {
@private
    EGCounter* _counter;
    CGFloat _eventTime;
    void(^_event)();
    BOOL _executed;
    ATObserver* _obs;
}
@property (nonatomic, readonly) EGCounter* counter;
@property (nonatomic, readonly) CGFloat eventTime;
@property (nonatomic, readonly) void(^event)();

+ (instancetype)eventCounterWithCounter:(EGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event;
- (instancetype)initWithCounter:(EGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event;
- (ODClassType*)type;
- (ATReact*)isRunning;
- (ATReact*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
+ (ODClassType*)type;
@end


@interface EGCounterData : EGCounter {
@private
    EGCounter* _counter;
    id _data;
}
@property (nonatomic, readonly) EGCounter* counter;
@property (nonatomic, readonly) id data;

+ (instancetype)counterDataWithCounter:(EGCounter*)counter data:(id)data;
- (instancetype)initWithCounter:(EGCounter*)counter data:(id)data;
- (ODClassType*)type;
- (ATReact*)isRunning;
- (ATReact*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
+ (ODClassType*)type;
@end


@interface EGMutableCounterArray : NSObject<EGUpdatable> {
@private
    id<CNImSeq> __counters;
}
+ (instancetype)mutableCounterArray;
- (instancetype)init;
- (ODClassType*)type;
- (id<CNImSeq>)counters;
- (void)appendCounter:(EGCounterData*)counter;
- (void)appendCounter:(EGCounter*)counter data:(id)data;
- (void)updateWithDelta:(CGFloat)delta;
- (void)forEach:(void(^)(EGCounterData*))each;
+ (ODClassType*)type;
@end


