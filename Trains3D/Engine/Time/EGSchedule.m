#import "EGSchedule.h"

#import "CNReact.h"
#import "CNObserver.h"
#import "CNChain.h"
@implementation EGScheduleEvent
static CNClassType* _EGScheduleEvent_type;
@synthesize time = _time;
@synthesize f = _f;

+ (instancetype)scheduleEventWithTime:(CGFloat)time f:(void(^)())f {
    return [[EGScheduleEvent alloc] initWithTime:time f:f];
}

- (instancetype)initWithTime:(CGFloat)time f:(void(^)())f {
    self = [super init];
    if(self) {
        _time = time;
        _f = [f copy];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGScheduleEvent class]) _EGScheduleEvent_type = [CNClassType classTypeWithCls:[EGScheduleEvent class]];
}

- (NSInteger)compareTo:(EGScheduleEvent*)to {
    return floatCompareTo(_time, ((EGScheduleEvent*)(to)).time);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ScheduleEvent(%f)", _time];
}

- (CNClassType*)type {
    return [EGScheduleEvent type];
}

+ (CNClassType*)type {
    return _EGScheduleEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGImSchedule
static CNClassType* _EGImSchedule_type;
@synthesize events = _events;
@synthesize time = _time;

+ (instancetype)imScheduleWithEvents:(CNImList*)events time:(NSUInteger)time {
    return [[EGImSchedule alloc] initWithEvents:events time:time];
}

- (instancetype)initWithEvents:(CNImList*)events time:(NSUInteger)time {
    self = [super init];
    if(self) {
        _events = events;
        _time = time;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGImSchedule class]) _EGImSchedule_type = [CNClassType classTypeWithCls:[EGImSchedule class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ImSchedule(%@, %lu)", _events, (unsigned long)_time];
}

- (CNClassType*)type {
    return [EGImSchedule type];
}

+ (CNClassType*)type {
    return _EGImSchedule_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMSchedule
static CNClassType* _EGMSchedule_type;

+ (instancetype)schedule {
    return [[EGMSchedule alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __events = [CNImList apply];
        __current = 0.0;
        __next = -1.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMSchedule class]) _EGMSchedule_type = [CNClassType classTypeWithCls:[EGMSchedule class]];
}

- (void)scheduleAfter:(CGFloat)after event:(void(^)())event {
    __events = [__events insertItem:[EGScheduleEvent scheduleEventWithTime:__current + after f:event]];
    __next = ((EGScheduleEvent*)(nonnil([__events head]))).time;
}

- (void)updateWithDelta:(CGFloat)delta {
    __current += delta;
    while(__next >= 0 && __current > __next) {
        EGScheduleEvent* e = [__events head];
        __events = [__events tail];
        ((EGScheduleEvent*)(e)).f();
        [self updateNext];
    }
}

- (CGFloat)time {
    return __current;
}

- (BOOL)isEmpty {
    return __next < 0.0;
}

- (EGImSchedule*)imCopy {
    return [EGImSchedule imScheduleWithEvents:__events time:((NSUInteger)(__current))];
}

- (void)assignImSchedule:(EGImSchedule*)imSchedule {
    __events = imSchedule.events;
    __current = ((CGFloat)(imSchedule.time));
    [self updateNext];
}

- (void)updateNext {
    EGScheduleEvent* __tmp_0 = [__events head];
    if(__tmp_0 != nil) __next = ((EGScheduleEvent*)([__events head])).time;
    else __next = -1.0;
}

- (NSString*)description {
    return @"MSchedule";
}

- (CNClassType*)type {
    return [EGMSchedule type];
}

+ (CNClassType*)type {
    return _EGMSchedule_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGCounter
static CNClassType* _EGCounter_type;

+ (instancetype)counter {
    return [[EGCounter alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCounter class]) _EGCounter_type = [CNClassType classTypeWithCls:[EGCounter class]];
}

- (CNReact*)isRunning {
    @throw @"Method isRunning is abstract";
}

- (CNVar*)time {
    @throw @"Method time is abstract";
}

- (void)restart {
    @throw @"Method restart is abstract";
}

- (void)finish {
    @throw @"Method finish is abstract";
}

- (id)finished {
    [self finish];
    return self;
}

- (void)forF:(void(^)(CGFloat))f {
    if(unumb([[self isRunning] value])) f(unumf([[self time] value]));
}

- (void)updateWithDelta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

+ (EGCounter*)stoppedLength:(CGFloat)length {
    return [EGLengthCounter lengthCounterWithLength:length];
}

+ (EGCounter*)applyLength:(CGFloat)length {
    return [EGLengthCounter lengthCounterWithLength:length];
}

+ (EGCounter*)applyLength:(CGFloat)length finish:(void(^)())finish {
    return [EGFinisher finisherWithCounter:[EGLengthCounter lengthCounterWithLength:length] onFinish:finish];
}

+ (EGCounter*)apply {
    return [EGEmptyCounter emptyCounter];
}

- (EGCounter*)onTime:(CGFloat)time event:(void(^)())event {
    return [EGEventCounter eventCounterWithCounter:self eventTime:time event:event];
}

- (EGCounter*)onEndEvent:(void(^)())event {
    return [EGFinisher finisherWithCounter:self onFinish:event];
}

- (NSString*)description {
    return @"Counter";
}

- (CNClassType*)type {
    return [EGCounter type];
}

+ (CNClassType*)type {
    return _EGCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGEmptyCounter
static EGEmptyCounter* _EGEmptyCounter_instance;
static CNClassType* _EGEmptyCounter_type;

+ (instancetype)emptyCounter {
    return [[EGEmptyCounter alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEmptyCounter class]) {
        _EGEmptyCounter_type = [CNClassType classTypeWithCls:[EGEmptyCounter class]];
        _EGEmptyCounter_instance = [EGEmptyCounter emptyCounter];
    }
}

- (CNReact*)isRunning {
    return [CNVal valWithValue:@NO];
}

- (CNVar*)time {
    return [CNVar applyInitial:@1.0];
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (void)restart {
}

- (void)finish {
}

- (NSString*)description {
    return @"EmptyCounter";
}

- (CNClassType*)type {
    return [EGEmptyCounter type];
}

+ (EGEmptyCounter*)instance {
    return _EGEmptyCounter_instance;
}

+ (CNClassType*)type {
    return _EGEmptyCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGLengthCounter
static CNClassType* _EGLengthCounter_type;
@synthesize length = _length;
@synthesize time = _time;
@synthesize isRunning = _isRunning;

+ (instancetype)lengthCounterWithLength:(CGFloat)length {
    return [[EGLengthCounter alloc] initWithLength:length];
}

- (instancetype)initWithLength:(CGFloat)length {
    self = [super init];
    if(self) {
        _length = length;
        _time = [CNVar applyInitial:@0.0];
        _isRunning = [_time mapF:^id(id _) {
            return numb(unumf(_) < 1.0);
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGLengthCounter class]) _EGLengthCounter_type = [CNClassType classTypeWithCls:[EGLengthCounter class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    if(unumb([_isRunning value])) {
        CGFloat t = unumf([_time value]);
        t += delta / _length;
        if(t >= 1.0) [_time setValue:@1.0];
        else [_time setValue:numf(t)];
    }
}

- (void)restart {
    [_time setValue:@0.0];
}

- (void)finish {
    [_time setValue:@1.0];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LengthCounter(%f)", _length];
}

- (CNClassType*)type {
    return [EGLengthCounter type];
}

+ (CNClassType*)type {
    return _EGLengthCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGFinisher
static CNClassType* _EGFinisher_type;
@synthesize counter = _counter;
@synthesize onFinish = _onFinish;

+ (instancetype)finisherWithCounter:(EGCounter*)counter onFinish:(void(^)())onFinish {
    return [[EGFinisher alloc] initWithCounter:counter onFinish:onFinish];
}

- (instancetype)initWithCounter:(EGCounter*)counter onFinish:(void(^)())onFinish {
    self = [super init];
    if(self) {
        _counter = counter;
        _onFinish = [onFinish copy];
        _obs = [[counter isRunning] observeF:^void(id r) {
            if(!(unumb(r))) onFinish();
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFinisher class]) _EGFinisher_type = [CNClassType classTypeWithCls:[EGFinisher class]];
}

- (CNReact*)isRunning {
    return [_counter isRunning];
}

- (CNVar*)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_counter updateWithDelta:delta];
}

- (void)restart {
    [_counter restart];
}

- (void)finish {
    [_counter finish];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Finisher(%@)", _counter];
}

- (CNClassType*)type {
    return [EGFinisher type];
}

+ (CNClassType*)type {
    return _EGFinisher_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGEventCounter
static CNClassType* _EGEventCounter_type;
@synthesize counter = _counter;
@synthesize eventTime = _eventTime;
@synthesize event = _event;

+ (instancetype)eventCounterWithCounter:(EGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event {
    return [[EGEventCounter alloc] initWithCounter:counter eventTime:eventTime event:event];
}

- (instancetype)initWithCounter:(EGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event {
    self = [super init];
    __weak EGEventCounter* _weakSelf = self;
    if(self) {
        _counter = counter;
        _eventTime = eventTime;
        _event = [event copy];
        _executed = NO;
        _obs = [[counter time] observeF:^void(id time) {
            EGEventCounter* _self = _weakSelf;
            if(_self != nil) {
                if(!(_self->_executed)) {
                    if(unumf([[counter time] value]) > eventTime) {
                        event();
                        _self->_executed = YES;
                    }
                } else {
                    if(unumf([[counter time] value]) < eventTime) _self->_executed = NO;
                }
            }
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEventCounter class]) _EGEventCounter_type = [CNClassType classTypeWithCls:[EGEventCounter class]];
}

- (CNReact*)isRunning {
    return [_counter isRunning];
}

- (CNVar*)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_counter updateWithDelta:delta];
}

- (void)restart {
    _executed = NO;
    [_counter restart];
}

- (void)finish {
    _executed = YES;
    [_counter finish];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"EventCounter(%@, %f)", _counter, _eventTime];
}

- (CNClassType*)type {
    return [EGEventCounter type];
}

+ (CNClassType*)type {
    return _EGEventCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGCounterData
static CNClassType* _EGCounterData_type;
@synthesize counter = _counter;
@synthesize data = _data;

+ (instancetype)counterDataWithCounter:(EGCounter*)counter data:(id)data {
    return [[EGCounterData alloc] initWithCounter:counter data:data];
}

- (instancetype)initWithCounter:(EGCounter*)counter data:(id)data {
    self = [super init];
    if(self) {
        _counter = counter;
        _data = data;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCounterData class]) _EGCounterData_type = [CNClassType classTypeWithCls:[EGCounterData class]];
}

- (CNReact*)isRunning {
    return [_counter isRunning];
}

- (CNVar*)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_counter updateWithDelta:delta];
}

- (void)restart {
    [_counter restart];
}

- (void)finish {
    [_counter finish];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CounterData(%@, %@)", _counter, _data];
}

- (CNClassType*)type {
    return [EGCounterData type];
}

+ (CNClassType*)type {
    return _EGCounterData_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMutableCounterArray
static CNClassType* _EGMutableCounterArray_type;

+ (instancetype)mutableCounterArray {
    return [[EGMutableCounterArray alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __counters = ((NSArray*)((@[])));
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMutableCounterArray class]) _EGMutableCounterArray_type = [CNClassType classTypeWithCls:[EGMutableCounterArray class]];
}

- (NSArray*)counters {
    return __counters;
}

- (void)appendCounter:(EGCounterData*)counter {
    __counters = [__counters addItem:counter];
}

- (void)appendCounter:(EGCounter*)counter data:(id)data {
    __counters = [__counters addItem:[EGCounterData counterDataWithCounter:counter data:data]];
}

- (void)updateWithDelta:(CGFloat)delta {
    __block BOOL hasDied = NO;
    for(EGCounterData* counter in __counters) {
        [((EGCounterData*)(counter)) updateWithDelta:delta];
        if(!(unumb([[((EGCounterData*)(counter)) isRunning] value]))) hasDied = YES;
    }
    if(hasDied) __counters = [[[__counters chain] filterWhen:^BOOL(EGCounterData* _) {
        return !(unumb([[((EGCounterData*)(_)) isRunning] value]));
    }] toArray];
}

- (void)forEach:(void(^)(EGCounterData*))each {
    [__counters forEach:each];
}

- (NSString*)description {
    return @"MutableCounterArray";
}

- (CNClassType*)type {
    return [EGMutableCounterArray type];
}

+ (CNClassType*)type {
    return _EGMutableCounterArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

