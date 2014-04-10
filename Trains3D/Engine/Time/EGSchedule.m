#import "EGSchedule.h"

#import "ATReact.h"
#import "ATObserver.h"
@implementation EGScheduleEvent
static ODClassType* _EGScheduleEvent_type;
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
    if(self == [EGScheduleEvent class]) _EGScheduleEvent_type = [ODClassType classTypeWithCls:[EGScheduleEvent class]];
}

- (NSInteger)compareTo:(EGScheduleEvent*)to {
    return floatCompareTo(_time, ((EGScheduleEvent*)(to)).time);
}

- (ODClassType*)type {
    return [EGScheduleEvent type];
}

+ (ODClassType*)type {
    return _EGScheduleEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"time=%f", self.time];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGImSchedule
static ODClassType* _EGImSchedule_type;
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
    if(self == [EGImSchedule class]) _EGImSchedule_type = [ODClassType classTypeWithCls:[EGImSchedule class]];
}

- (ODClassType*)type {
    return [EGImSchedule type];
}

+ (ODClassType*)type {
    return _EGImSchedule_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"events=%@", self.events];
    [description appendFormat:@", time=%lu", (unsigned long)self.time];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMSchedule
static ODClassType* _EGMSchedule_type;

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
    if(self == [EGMSchedule class]) _EGMSchedule_type = [ODClassType classTypeWithCls:[EGMSchedule class]];
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

- (ODClassType*)type {
    return [EGMSchedule type];
}

+ (ODClassType*)type {
    return _EGMSchedule_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCounter
static ODClassType* _EGCounter_type;

+ (instancetype)counter {
    return [[EGCounter alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCounter class]) _EGCounter_type = [ODClassType classTypeWithCls:[EGCounter class]];
}

- (ATReact*)isRunning {
    @throw @"Method isRunning is abstract";
}

- (ATVar*)time {
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

- (ODClassType*)type {
    return [EGCounter type];
}

+ (ODClassType*)type {
    return _EGCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEmptyCounter
static EGEmptyCounter* _EGEmptyCounter_instance;
static ODClassType* _EGEmptyCounter_type;

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
        _EGEmptyCounter_type = [ODClassType classTypeWithCls:[EGEmptyCounter class]];
        _EGEmptyCounter_instance = [EGEmptyCounter emptyCounter];
    }
}

- (ATReact*)isRunning {
    return [ATVal valWithValue:@NO];
}

- (ATVar*)time {
    return [ATVar applyInitial:@1.0];
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (void)restart {
}

- (void)finish {
}

- (ODClassType*)type {
    return [EGEmptyCounter type];
}

+ (EGEmptyCounter*)instance {
    return _EGEmptyCounter_instance;
}

+ (ODClassType*)type {
    return _EGEmptyCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGLengthCounter
static ODClassType* _EGLengthCounter_type;
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
        _time = [ATVar applyInitial:@0.0];
        _isRunning = [_time mapF:^id(id _) {
            return numb(unumf(_) < 1.0);
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGLengthCounter class]) _EGLengthCounter_type = [ODClassType classTypeWithCls:[EGLengthCounter class]];
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

- (ODClassType*)type {
    return [EGLengthCounter type];
}

+ (ODClassType*)type {
    return _EGLengthCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"length=%f", self.length];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFinisher
static ODClassType* _EGFinisher_type;
@synthesize counter = _counter;
@synthesize onFinish = _onFinish;

+ (instancetype)finisherWithCounter:(EGCounter*)counter onFinish:(void(^)())onFinish {
    return [[EGFinisher alloc] initWithCounter:counter onFinish:onFinish];
}

- (instancetype)initWithCounter:(EGCounter*)counter onFinish:(void(^)())onFinish {
    self = [super init];
    __weak EGFinisher* _weakSelf = self;
    if(self) {
        _counter = counter;
        _onFinish = [onFinish copy];
        _obs = [[_counter isRunning] observeF:^void(id r) {
            EGFinisher* _self = _weakSelf;
            if(_self != nil) {
                if(!(unumb(r))) _self->_onFinish();
            }
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFinisher class]) _EGFinisher_type = [ODClassType classTypeWithCls:[EGFinisher class]];
}

- (ATReact*)isRunning {
    return [_counter isRunning];
}

- (ATVar*)time {
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

- (ODClassType*)type {
    return [EGFinisher type];
}

+ (ODClassType*)type {
    return _EGFinisher_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"counter=%@", self.counter];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEventCounter
static ODClassType* _EGEventCounter_type;
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
        _obs = [[_counter time] observeF:^void(id time) {
            EGEventCounter* _self = _weakSelf;
            if(_self != nil) {
                if(!(_self->_executed)) {
                    if(unumf([[_self->_counter time] value]) > _self->_eventTime) {
                        _self->_event();
                        _self->_executed = YES;
                    }
                } else {
                    if(unumf([[_self->_counter time] value]) < _self->_eventTime) _self->_executed = NO;
                }
            }
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEventCounter class]) _EGEventCounter_type = [ODClassType classTypeWithCls:[EGEventCounter class]];
}

- (ATReact*)isRunning {
    return [_counter isRunning];
}

- (ATVar*)time {
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

- (ODClassType*)type {
    return [EGEventCounter type];
}

+ (ODClassType*)type {
    return _EGEventCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"counter=%@", self.counter];
    [description appendFormat:@", eventTime=%f", self.eventTime];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCounterData
static ODClassType* _EGCounterData_type;
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
    if(self == [EGCounterData class]) _EGCounterData_type = [ODClassType classTypeWithCls:[EGCounterData class]];
}

- (ATReact*)isRunning {
    return [_counter isRunning];
}

- (ATVar*)time {
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

- (ODClassType*)type {
    return [EGCounterData type];
}

+ (ODClassType*)type {
    return _EGCounterData_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"counter=%@", self.counter];
    [description appendFormat:@", data=%@", self.data];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableCounterArray
static ODClassType* _EGMutableCounterArray_type;

+ (instancetype)mutableCounterArray {
    return [[EGMutableCounterArray alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __counters = (@[]);
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMutableCounterArray class]) _EGMutableCounterArray_type = [ODClassType classTypeWithCls:[EGMutableCounterArray class]];
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
    if(hasDied) __counters = [[[__counters chain] filter:^BOOL(EGCounterData* _) {
        return !(unumb([[((EGCounterData*)(_)) isRunning] value]));
    }] toArray];
}

- (void)forEach:(void(^)(EGCounterData*))each {
    [__counters forEach:each];
}

- (ODClassType*)type {
    return [EGMutableCounterArray type];
}

+ (ODClassType*)type {
    return _EGMutableCounterArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


