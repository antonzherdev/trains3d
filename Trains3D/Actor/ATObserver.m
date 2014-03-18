#import "ATObserver.h"

@implementation ATObserver
static ODClassType* _ATObserver_type;
@synthesize observable = _observable;
@synthesize f = _f;

+ (instancetype)observerWithObservable:(id<ATObservable>)observable f:(void(^)(id))f {
    return [[ATObserver alloc] initWithObservable:observable f:f];
}

- (instancetype)initWithObservable:(id<ATObservable>)observable f:(void(^)(id))f {
    self = [super init];
    if(self) {
        _observable = observable;
        _f = [f copy];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATObserver class]) _ATObserver_type = [ODClassType classTypeWithCls:[ATObserver class]];
}

- (void)detach {
    [_observable detachObserver:self];
}

- (void)dealloc {
    [self detach];
}

- (ODClassType*)type {
    return [ATObserver type];
}

+ (ODClassType*)type {
    return _ATObserver_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATObserver* o = ((ATObserver*)(other));
    return [self.observable isEqual:o.observable] && [self.f isEqual:o.f];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.observable hash];
    hash = hash * 31 + [self.f hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"observable=%@", self.observable];
    [description appendString:@">"];
    return description;
}

@end


@implementation ATSignal
static ODClassType* _ATSignal_type;

+ (instancetype)signal {
    return [[ATSignal alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __observers = [CNAtomicObject applyValue:(@[])];
    
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
        if([__observers compareAndSetOldValue:v newValue:[v addItem:[CNWeak weakWithGet:observer]]]) return ;
    }
}

- (void)detachObserver:(ATObserver*)observer {
    while(YES) {
        id<CNImSeq> v = [__observers value];
        id<CNImSeq> nv = [[[v chain] filter:^BOOL(CNWeak* l) {
            ATObserver* lv = ((CNWeak*)(l)).get;
            return lv != observer && lv != nil;
        }] toArray];
        if([__observers compareAndSetOldValue:v newValue:nv]) return ;
    }
}

- (void)notifyValue:(id)value {
    [((id<CNImSeq>)([__observers value])) forEach:^void(CNWeak* o) {
        ((ATObserver*)(o.get)).f(value);
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


