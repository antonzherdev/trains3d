#import "EGSchedule.h"

@implementation EGSchedule{
    CNTreeMap* __map;
    double __current;
    double __next;
}

+ (id)schedule {
    return [[EGSchedule alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        __map = [CNTreeMap new];
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

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


