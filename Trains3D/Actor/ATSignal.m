#import "ATSignal.h"

@implementation ATSignal
static ODClassType* _ATSignal_type;

+ (instancetype)signal {
    return [[ATSignal alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATSignal class]) _ATSignal_type = [ODClassType classTypeWithCls:[ATSignal class]];
}

- (void)postData:(id)data {
    [self notifyValue:data];
}

- (void)post {
    [self notifyValue:nil];
}

- (void)attachObserver:(ATObserver*)observer {
    while(YES) {
        id<CNImSeq> v = [__observers value];
        if([__observers compareAndSetOldValue:v newValue:[v addItem:observer]]) return ;
    }
}

- (void)detachObserver:(ATObserver*)observer {
    while(YES) {
        id<CNImSeq> v = [__observers value];
        if([__observers compareAndSetOldValue:v newValue:[v subItem:observer]]) return ;
    }
}

- (void)notifyValue:(id)value {
    [((id<CNImSeq>)([__observers value])) forEach:^void(void(^f)(id)) {
        f(value);
    }];
}

- (BOOL)hasObservers {
    return !([((id<CNImSeq>)([__observers value])) isEmpty]);
}

- (ATObserver*)observeF:(void(^)(id))f {
    ATObserver* obs = [ATObserver observerWithObservable:self f:f];
    [self attachObserver:obs];
    return obs;
}

- (ODClassType*)type {
    return [ATSignal type];
}

+ (ODClassType*)type {
    return _ATSignal_type;
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


