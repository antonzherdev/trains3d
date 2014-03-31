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
    [_observable detachObserver:nil];
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
        NSArray* v = [__observers value];
        if([__observers compareAndSetOldValue:v newValue:[v addItem:[CNWeak weakWithGet:observer]]]) return ;
    }
}

- (void)detachObserver:(ATObserver*)observer {
    BOOL(^p)(CNWeak*) = ((observer == nil) ? ^BOOL(CNWeak* l) {
        return !([l isEmpty]);
    } : ^BOOL(CNWeak* l) {
        ATObserver* lv = l.get;
        return lv != observer && lv != nil;
    });
    while(YES) {
        NSArray* v = [__observers value];
        NSArray* nv = [[[v chain] filter:p] toArray];
        if([__observers compareAndSetOldValue:v newValue:nv]) return ;
    }
}

- (void)notifyValue:(id)value {
    __block BOOL old = NO;
    [((NSArray*)([__observers value])) forEach:^void(CNWeak* o) {
        ATObserver* oo = o.get;
        if(oo != nil) oo.f(value);
        else old = YES;
    }];
}

- (BOOL)hasObservers {
    return !([((NSArray*)([__observers value])) isEmpty]);
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


