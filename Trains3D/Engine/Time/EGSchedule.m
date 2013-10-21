#import "EGSchedule.h"

@implementation EGSchedule{
    CNMutableTreeMap* __map;
    CGFloat __current;
    CGFloat __next;
}
static ODClassType* _EGSchedule_type;

+ (id)schedule {
    return [[EGSchedule alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __map = [CNMutableTreeMap apply];
        __current = 0.0;
        __next = -1.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSchedule_type = [ODClassType classTypeWithCls:[EGSchedule class]];
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
    while(__next > 0 && __current > __next) {
        [((id<CNSeq>)(((CNTuple*)([[__map pollFirst] get])).b)) forEach:^void(void(^event)()) {
            ((void(^)())(event))();
        }];
        __next = unumf([[__map firstKey] getOrValue:@-1.0]);
    }
}

- (CGFloat)time {
    return __current;
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

+ (id)counter {
    return [[EGCounter alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCounter_type = [ODClassType classTypeWithCls:[EGCounter class]];
}

- (BOOL)isRun {
    @throw @"Method isRun is abstract";
}

- (CGFloat)time {
    @throw @"Method time is abstract";
}

- (BOOL)isStopped {
    return !([self isRun]);
}

- (void)forF:(void(^)(CGFloat))f {
    if([self isRun]) f([self time]);
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

+ (id)emptyCounter {
    return [[EGEmptyCounter alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEmptyCounter_type = [ODClassType classTypeWithCls:[EGEmptyCounter class]];
}

- (BOOL)isRun {
    return NO;
}

- (CGFloat)time {
    return 0.0;
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

+ (id)lengthCounterWithLength:(CGFloat)length {
    return [[EGLengthCounter alloc] initWithLength:length];
}

- (id)initWithLength:(CGFloat)length {
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
    _EGLengthCounter_type = [ODClassType classTypeWithCls:[EGLengthCounter class]];
}

- (CGFloat)time {
    return __time;
}

- (BOOL)isRun {
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

+ (id)finisherWithCounter:(EGCounter*)counter finish:(void(^)())finish {
    return [[EGFinisher alloc] initWithCounter:counter finish:finish];
}

- (id)initWithCounter:(EGCounter*)counter finish:(void(^)())finish {
    self = [super init];
    if(self) {
        _counter = counter;
        _finish = finish;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGFinisher_type = [ODClassType classTypeWithCls:[EGFinisher class]];
}

- (BOOL)isRun {
    return [_counter isRun];
}

- (CGFloat)time {
    return [_counter time];
}

- (void)updateWithDelta:(CGFloat)delta {
    if([_counter isRun]) {
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


