#import "EGSchedule.h"

@implementation EGSchedule{
    CNMutableTreeMap* __map;
    CGFloat __current;
    CGFloat __next;
}
static ODType* _EGSchedule_type;

+ (id)schedule {
    return [[EGSchedule alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __map = [CNMutableTreeMap new];
        __current = 0.0;
        __next = -1.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSchedule_type = [ODType typeWithCls:[EGSchedule class]];
}

- (void)scheduleEvent:(void(^)())event after:(CGFloat)after {
    [__map setObject:event forKey:numf(after)];
    __next = unumf([[__map firstKey] get]);
}

- (void)updateWithDelta:(CGFloat)delta {
    __current += delta;
    while(__next > 0 && __current > __next) {
        ((void(^)())(((CNTuple*)([[__map pollFirst] get])).b))();
        __next = unumf([[__map firstKey] getOr:@-1.0]);
    }
}

- (CGFloat)time {
    return __current;
}

- (ODType*)type {
    return _EGSchedule_type;
}

+ (ODType*)type {
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


@implementation EGAnimation{
    CGFloat _length;
    void(^_finish)();
    CGFloat __time;
    BOOL __run;
}
static ODType* _EGAnimation_type;
@synthesize length = _length;
@synthesize finish = _finish;

+ (id)animationWithLength:(CGFloat)length finish:(void(^)())finish {
    return [[EGAnimation alloc] initWithLength:length finish:finish];
}

- (id)initWithLength:(CGFloat)length finish:(void(^)())finish {
    self = [super init];
    if(self) {
        _length = length;
        _finish = finish;
        __time = 0.0;
        __run = YES;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGAnimation_type = [ODType typeWithCls:[EGAnimation class]];
}

- (CGFloat)time {
    return __time;
}

- (BOOL)isRun {
    return __run;
}

- (BOOL)isStopped {
    return !(__run);
}

- (void)updateWithDelta:(CGFloat)delta {
    if(__run) {
        __time += delta / _length;
        if(__time >= 1.0) {
            __time = 1.0;
            __run = NO;
            ((void(^)())(_finish))();
        }
    }
}

- (ODType*)type {
    return _EGAnimation_type;
}

+ (ODType*)type {
    return _EGAnimation_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGAnimation* o = ((EGAnimation*)(other));
    return eqf(self.length, o.length) && [self.finish isEqual:o.finish];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.length);
    hash = hash * 31 + [self.finish hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"length=%f", self.length];
    [description appendString:@">"];
    return description;
}

@end


