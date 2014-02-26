#import "EGSchedule.h"

@implementation EGSchedule{
    CNMTreeMap* __map;
    CGFloat __current;
    CGFloat __next;
}
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
    [__map modifyBy:^id(id _) {
        return [CNOption applyValue:[((id<CNSeq>)([_ getOrElseF:^id<CNSeq>() {
            return (@[]);
        }])) addItem:event]];
    } forKey:numf(__current + after)];
    __next = unumf([[__map firstKey] get]);
}

- (void)updateWithDelta:(CGFloat)delta {
    __current += delta;
    while(__next >= 0 && __current > __next) {
        [((id<CNSeq>)(((CNTuple*)([[__map pollFirst] get])).b)) forEach:^void(void(^event)()) {
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

- (BOOL)isRunning {
    @throw @"Method isRunning is abstract";
}

- (CGFloat)time {
    @throw @"Method time is abstract";
}

- (CGFloat)invTime {
    return 1.0 - [self time];
}

- (BOOL)isStopped {
    return !([self isRunning]);
}

- (void)forF:(void(^)(CGFloat))f {
    if([self isRunning]) f([self time]);
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEmptyCounter
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
    if(self == [EGEmptyCounter class]) _EGEmptyCounter_type = [ODClassType classTypeWithCls:[EGEmptyCounter class]];
}

- (BOOL)isRunning {
    return NO;
}

- (CGFloat)time {
    return 0.0;
}

- (CGFloat)invTime {
    return 1.0;
}

- (void)updateWithDelta:(CGFloat)delta {
}

- (ODClassType*)type {
    return [EGEmptyCounter type];
}

+ (ODClassType*)type {
    return _EGEmptyCounter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGLengthCounter{
    CGFloat _length;
    CGFloat __time;
    BOOL __run;
}
static ODClassType* _EGLengthCounter_type;
@synthesize length = _length;

+ (instancetype)lengthCounterWithLength:(CGFloat)length {
    return [[EGLengthCounter alloc] initWithLength:length];
}

- (instancetype)initWithLength:(CGFloat)length {
    self = [super init];
    if(self) {
        _length = length;
        __time = 0.0;
        __run = YES;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGLengthCounter class]) _EGLengthCounter_type = [ODClassType classTypeWithCls:[EGLengthCounter class]];
}

- (CGFloat)time {
    return __time;
}

- (CGFloat)invTime {
    return 1.0 - __time;
}

- (BOOL)isRunning {
    return __run;
}

- (void)updateWithDelta:(CGFloat)delta {
    if(__run) {
        __time += delta / _length;
        if(__time >= 1.0) {
            __time = 1.0;
            __run = NO;
        }
    }
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGLengthCounter* o = ((EGLengthCounter*)(other));
    return eqf(self.length, o.length);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.length);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"length=%f", self.length];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGFinisher{
    EGCounter* _counter;
    void(^_finish)();
}
static ODClassType* _EGFinisher_type;
@synthesize counter = _counter;
@synthesize finish = _finish;

+ (instancetype)finisherWithCounter:(EGCounter*)counter finish:(void(^)())finish {
    return [[EGFinisher alloc] initWithCounter:counter finish:finish];
}

- (instancetype)initWithCounter:(EGCounter*)counter finish:(void(^)())finish {
    self = [super init];
    if(self) {
        _counter = counter;
        _finish = finish;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGFinisher class]) _EGFinisher_type = [ODClassType classTypeWithCls:[EGFinisher class]];
}

- (BOOL)isRunning {
    return [_counter isRunning];
}

- (CGFloat)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    if([_counter isRunning]) {
        [_counter updateWithDelta:delta];
        if([_counter isStopped]) ((void(^)())(_finish))();
    }
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGFinisher* o = ((EGFinisher*)(other));
    return [self.counter isEqual:o.counter] && [self.finish isEqual:o.finish];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.counter hash];
    hash = hash * 31 + [self.finish hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"counter=%@", self.counter];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEventCounter{
    EGCounter* _counter;
    CGFloat _eventTime;
    void(^_event)();
    BOOL _executed;
}
static ODClassType* _EGEventCounter_type;
@synthesize counter = _counter;
@synthesize eventTime = _eventTime;
@synthesize event = _event;

+ (instancetype)eventCounterWithCounter:(EGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event {
    return [[EGEventCounter alloc] initWithCounter:counter eventTime:eventTime event:event];
}

- (instancetype)initWithCounter:(EGCounter*)counter eventTime:(CGFloat)eventTime event:(void(^)())event {
    self = [super init];
    if(self) {
        _counter = counter;
        _eventTime = eventTime;
        _event = event;
        _executed = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEventCounter class]) _EGEventCounter_type = [ODClassType classTypeWithCls:[EGEventCounter class]];
}

- (BOOL)isRunning {
    return [_counter isRunning];
}

- (CGFloat)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    if([_counter isRunning]) {
        [_counter updateWithDelta:delta];
        if(!(_executed) && [_counter time] > _eventTime) {
            ((void(^)())(_event))();
            _executed = YES;
        }
    }
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEventCounter* o = ((EGEventCounter*)(other));
    return [self.counter isEqual:o.counter] && eqf(self.eventTime, o.eventTime) && [self.event isEqual:o.event];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.counter hash];
    hash = hash * 31 + floatHash(self.eventTime);
    hash = hash * 31 + [self.event hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"counter=%@", self.counter];
    [description appendFormat:@", eventTime=%f", self.eventTime];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCounterData{
    EGCounter* _counter;
    id _data;
}
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

- (BOOL)isRunning {
    return [_counter isRunning];
}

- (CGFloat)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_counter updateWithDelta:delta];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCounterData* o = ((EGCounterData*)(other));
    return [self.counter isEqual:o.counter] && [self.data isEqual:o.data];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.counter hash];
    hash = hash * 31 + [self.data hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"counter=%@", self.counter];
    [description appendFormat:@", data=%@", self.data];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableCounterArray{
    id<CNSeq> __counters;
}
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

- (id<CNSeq>)counters {
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
        if([((EGCounterData*)(counter)) isStopped]) hasDied = YES;
    }];
    if(hasDied) __counters = [[[__counters chain] filter:^BOOL(EGCounterData* _) {
        return [((EGCounterData*)(_)) isRunning];
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


