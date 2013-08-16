#import "EGSchedule.h"

@implementation EGSchedule{
    CNMutableTreeMap* __map;
    double __current;
    double __next;
}

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

- (void)scheduleEvent:(void(^)())event after:(double)after {
    [__map setObject:event forKey:numf(after)];
    __next = unumf([[__map firstKey] get]);
}

- (void)updateWithDelta:(double)delta {
    __current += delta;
    while(__next > 0 && __current > __next) {
        ((void(^)())((CNTuple*)[[__map pollFirst] get]).b)();
        __next = unumf([[__map firstKey] getOr:@-1.0]);
    }
}

- (double)time {
    return __current;
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
    double _length;
    void(^_finish)();
    double __time;
    BOOL __run;
}
@synthesize length = _length;
@synthesize finish = _finish;

+ (id)animationWithLength:(double)length finish:(void(^)())finish {
    return [[EGAnimation alloc] initWithLength:length finish:finish];
}

- (id)initWithLength:(double)length finish:(void(^)())finish {
    self = [super init];
    if(self) {
        _length = length;
        _finish = finish;
        __time = 0.0;
        __run = YES;
    }
    
    return self;
}

- (double)time {
    return __time;
}

- (BOOL)isRun {
    return __run;
}

- (BOOL)isStopped {
    return !(__run);
}

- (void)updateWithDelta:(double)delta {
    if(__run) {
        __time += delta / _length;
        if(__time >= 1.0) {
            __time = 1.0;
            __run = NO;
            ((void(^)())_finish)();
        }
    }
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGAnimation* o = ((EGAnimation*)other);
    return eqf(self.length, o.length) && [self.finish isEqual:o.finish];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [[NSNumber numberWithDouble:self.length] hash];
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


