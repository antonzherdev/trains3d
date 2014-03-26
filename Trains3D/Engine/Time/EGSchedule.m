#import "EGSchedule.h"

#import "ATReact.h"
#import "ATObserver.h"
@implementation EGSchedule
static ODClassType* _EGSchedule_type;

+ (instancetype)schedule {
    return [[EGSchedule alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __map = [CNMTreeMap apply];
        __current = 0.0;
        __next = -1.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSchedule class]) _EGSchedule_type = [ODClassType classTypeWithCls:[EGSchedule class]];
}

- (void)scheduleAfter:(CGFloat)after event:(void(^)())event {
    [__map modifyKey:numf(__current + after) by:^id(id _) {
        return [CNOption applyValue:[((id<CNImSeq>)([_ getOrElseF:^id<CNImSeq>() {
            return (@[]);
        }])) addItem:event]];
    }];
    __next = unumf([[__map firstKey] get]);
}

- (void)updateWithDelta:(CGFloat)delta {
    __current += delta;
    while(__next >= 0 && __current > __next) {
        [((id<CNImSeq>)(((CNTuple*)([[__map pollFirst] get])).b)) forEach:^void(void(^event)()) {
            ((void(^)())(event))();
        }];
        __next = unumf([[__map firstKey] getOrValue:@-1.0]);
    }
}

- (CGFloat)time {
    return __current;
}

- (BOOL)isEmpty {
    return __next < 0.0;
}

- (ODClassType*)type {
    return [EGSchedule type];
}

+ (ODClassType*)type {
    return _EGSchedule_type;
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

- (ATReact*)time {
    @throw @"Method time is abstract";
}

- (void)restart {
    @throw @"Method restart is abstract";
}

- (void)forF:(void(^)(CGFloat))f {
    if(unumb([[self isRunning] value])) f(unumf([[self time] value]));
}

- (void)updateWithDelta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

+ (EGCounter*)applyLength:(CGFloat)length {
    return [EGLengthCounter lengthCounterWithLength:length];
}

+ (EGCounter*)applyLength:(CGFloat)length finish:(void(^)())finish {
    return [EGFinisher finisherWithCounter:[EGLengthCounter lengthCounterWithLength:length] finish:finish];
}

+ (EGCounter*)apply {
    return [EGEmptyCounter emptyCounter];
}

- (EGCounter*)onTime:(CGFloat)time event:(void(^)())event {
    return [EGEventCounter eventCounterWithCounter:self eventTime:time event:event];
}

- (EGCounter*)onEndEvent:(void(^)())event {
    return [EGFinisher finisherWithCounter:self finish:event];
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

- (ATReact*)time {
    return [ATVal valWithValue:@0.0];
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (void)restart {
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

+ (instancetype)lengthCounterWithLength:(CGFloat)length {
    return [[EGLengthCounter alloc] initWithLength:length];
}

- (instancetype)initWithLength:(CGFloat)length {
    self = [super init];
    if(self) {
        _length = length;
        __time = [ATVar applyInitial:@0.0];
        __run = [ATVar applyInitial:@YES];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGLengthCounter class]) _EGLengthCounter_type = [ODClassType classTypeWithCls:[EGLengthCounter class]];
}

- (ATReact*)time {
    return __time;
}

- (ATReact*)isRunning {
    return __run;
}

- (void)updateWithDelta:(CGFloat)delta {
    if(unumb([__run value])) {
        CGFloat t = unumf([__time value]);
        t += delta / _length;
        if(t >= 1.0) {
            [__time setValue:@1.0];
            [__run setValue:@NO];
        } else {
            [__time setValue:numf(t)];
        }
    }
}

- (void)restart {
    [__time setValue:@0.0];
    [__run setValue:@YES];
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
@synthesize finish = _finish;

+ (instancetype)finisherWithCounter:(EGCounter*)counter finish:(void(^)())finish {
    return [[EGFinisher alloc] initWithCounter:counter finish:finish];
}

- (instancetype)initWithCounter:(EGCounter*)counter finish:(void(^)())finish {
    self = [super init];
    __weak EGFinisher* _weakSelf = self;
    if(self) {
        _counter = counter;
        _finish = [finish copy];
        _obs = [[_counter isRunning] observeF:^void(id r) {
            EGFinisher* _self = _weakSelf;
            if(!(unumb(r))) _self->_finish();
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

- (ATReact*)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_counter updateWithDelta:delta];
}

- (void)restart {
    [_counter restart];
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
            if(!(_self->_executed) && unumf([[_self->_counter time] value]) > _self->_eventTime) {
                _self->_event();
                _self->_executed = YES;
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

- (ATReact*)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_counter updateWithDelta:delta];
}

- (void)restart {
    _executed = NO;
    [_counter restart];
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

- (ATReact*)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_counter updateWithDelta:delta];
}

- (void)restart {
    [_counter restart];
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

- (id<CNImSeq>)counters {
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
    [__counters forEach:^void(EGCounterData* counter) {
        [((EGCounterData*)(counter)) updateWithDelta:delta];
        if(!(unumb([[((EGCounterData*)(counter)) isRunning] value]))) hasDied = YES;
    }];
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


