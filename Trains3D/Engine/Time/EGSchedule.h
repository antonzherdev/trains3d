#import "objd.h"
#import "EGScene.h"
@class ATReact;
@class ATVar;
@class ATVal;
@class ATObserver;

@class EGScheduleEvent;
@class EGImSchedule;
@class EGMSchedule;
@class EGCounter;
@class EGEmptyCounter;
@class EGLengthCounter;
@class EGFinisher;
@class EGEventCounter;
@class EGCounterData;
@class EGMutableCounterArray;

@interface EGScheduleEvent : NSObject<ODComparable> {
@protected
    CGFloat _time;
    void(^_f)();
}
@property (nonatomic, readonly) CGFloat time;
@property (nonatomic, readonly) void(^f)();

+ (instancetype)scheduleEventWithTime:(CGFloat)time f:(void(^)())f;
- (instancetype)initWithTime:(CGFloat)time f:(void(^)())f;
- (ODClassType*)type;
- (NSInteger)compareTo:(EGScheduleEvent*)to;
+ (ODClassType*)type;
@end


@interface EGImSchedule : NSObject {
@protected
    CNImList* _events;
    NSUInteger _time;
}
@property (nonatomic, readonly) CNImList* events;
@property (nonatomic, readonly) NSUInteger time;

+ (instancetype)imScheduleWithEvents:(CNImList*)events time:(NSUInteger)time;
- (instancetype)initWithEvents:(CNImList*)events time:(NSUInteger)time;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGMSchedule : NSObject {
@protected
    CNImList* __events;
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
- (EGImSchedule*)imCopy;
- (void)assignImSchedule:(EGImSchedule*)imSchedule;
+ (ODClassType*)type;
@end


@interface EGCounter : NSObject<EGUpdatable>
+ (instancetype)counter;
- (instancetype)init;
- (ODClassType*)type;
- (ATReact*)isRunning;
- (ATVar*)time;
- (void)restart;
- (void)finish;
- (id)finished;
- (void)updateWithDelta:(CGFloat)delta;
+ (EGCounter*)stoppedLength:(CGFloat)length;
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
- (ATVar*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
- (void)finish;
+ (EGEmptyCounter*)instance;
+ (ODClassType*)type;
@end


@interface EGLengthCounter : EGCounter {
@protected
    CGFloat _length;
    ATVar* _time;
    ATReact* _isRunning;
}
@property (nonatomic, readonly) CGFloat length;
@property (nonatomic, readonly) ATVar* time;
@property (nonatomic, readonly) ATReact* isRunning;

+ (instancetype)lengthCounterWithLength:(CGFloat)length;
- (instancetype)initWithLength:(CGFloat)length;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
- (void)finish;
+ (ODClassType*)type;
@end


@interface EGFinisher : EGCounter {
@protected
    EGCounter* _counter;
    void(^_onFinish)();
    ATObserver* _obs;
}
@property (nonatomic, readonly) EGCounter* counter;
@property (nonatomic, readonly) void(^onFinish)();

+ (instancetype)finisherWithCounter:(EGCounter*)counter onFinish:(void(^)())onFinish;
- (instancetype)initWithCounter:(EGCounter*)counter onFinish:(void(^)())onFinish;
- (ODClassType*)type;
- (ATReact*)isRunning;
- (ATVar*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
- (void)finish;
+ (ODClassType*)type;
@end


@interface EGEventCounter : EGCounter {
@protected
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
- (ATVar*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
- (void)finish;
+ (ODClassType*)type;
@end


@interface EGCounterData : EGCounter {
@protected
    EGCounter* _counter;
    id _data;
}
@property (nonatomic, readonly) EGCounter* counter;
@property (nonatomic, readonly) id data;

+ (instancetype)counterDataWithCounter:(EGCounter*)counter data:(id)data;
- (instancetype)initWithCounter:(EGCounter*)counter data:(id)data;
- (ODClassType*)type;
- (ATReact*)isRunning;
- (ATVar*)time;
- (void)updateWithDelta:(CGFloat)delta;
- (void)restart;
- (void)finish;
+ (ODClassType*)type;
@end


@interface EGMutableCounterArray : NSObject<EGUpdatable> {
@protected
    NSArray* __counters;
}
+ (instancetype)mutableCounterArray;
- (instancetype)init;
- (ODClassType*)type;
- (NSArray*)counters;
- (void)appendCounter:(EGCounterData*)counter;
- (void)appendCounter:(EGCounter*)counter data:(id)data;
- (void)updateWithDelta:(CGFloat)delta;
- (void)forEach:(void(^)(EGCounterData*))each;
+ (ODClassType*)type;
@end


