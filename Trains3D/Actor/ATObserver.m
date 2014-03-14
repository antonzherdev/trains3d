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


