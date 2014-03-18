#import "ATReact.h"

@implementation ATReact
static ODClassType* _ATReact_type;

+ (instancetype)react {
    return [[ATReact alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATReact class]) _ATReact_type = [ODClassType classTypeWithCls:[ATReact class]];
}

+ (ATReact*)applyValue:(id)value {
    return [ATVal valWithValue:value];
}

+ (ATReact*)applyA:(ATReact*)a f:(id(^)(id))f {
    return [ATMappedReact mappedReactWithA:a f:f];
}

+ (ATReact*)applyA:(ATReact*)a b:(ATReact*)b f:(id(^)(id, id))f {
    return [ATMappedReact2 mappedReact2WithA:a b:b f:f];
}

+ (ATReact*)applyA:(ATReact*)a b:(ATReact*)b c:(ATReact*)c f:(id(^)(id, id, id))f {
    return [ATMappedReact3 mappedReact3WithA:a b:b c:c f:f];
}

- (void)attachObserver:(ATObserver*)observer {
    @throw @"Method attach is abstract";
}

- (void)detachObserver:(ATObserver*)observer {
    @throw @"Method detach is abstract";
}

- (id)value {
    @throw @"Method value is abstract";
}

- (ATReact*)mapF:(id(^)(id))f {
    return [ATMappedReact mappedReactWithA:self f:f];
}

- (ATObserver*)observeF:(void(^)(id))f {
    ATObserver* obs = [ATObserver observerWithObservable:self f:f];
    [self attachObserver:obs];
    return obs;
}

- (ODClassType*)type {
    return [ATReact type];
}

+ (ODClassType*)type {
    return _ATReact_type;
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


@implementation ATImReact
static ODClassType* _ATImReact_type;

+ (instancetype)imReact {
    return [[ATImReact alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATImReact class]) _ATImReact_type = [ODClassType classTypeWithCls:[ATImReact class]];
}

- (void)attachObserver:(ATObserver*)observer {
}

- (void)detachObserver:(ATObserver*)observer {
}

- (ODClassType*)type {
    return [ATImReact type];
}

+ (ODClassType*)type {
    return _ATImReact_type;
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


@implementation ATMReact
static ODClassType* _ATMReact_type;

+ (instancetype)react {
    return [[ATMReact alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __observers = [CNAtomicObject applyValue:(@[])];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATMReact class]) _ATMReact_type = [ODClassType classTypeWithCls:[ATMReact class]];
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
    [((id<CNImSeq>)([__observers value])) forEach:^void(ATObserver* o) {
        o.f(value);
    }];
}

- (BOOL)hasObservers {
    return !([((id<CNImSeq>)([__observers value])) isEmpty]);
}

- (ODClassType*)type {
    return [ATMReact type];
}

+ (ODClassType*)type {
    return _ATMReact_type;
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


@implementation ATVal
static ODClassType* _ATVal_type;
@synthesize value = _value;

+ (instancetype)valWithValue:(id)value {
    return [[ATVal alloc] initWithValue:value];
}

- (instancetype)initWithValue:(id)value {
    self = [super init];
    if(self) _value = value;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATVal class]) _ATVal_type = [ODClassType classTypeWithCls:[ATVal class]];
}

- (ODClassType*)type {
    return [ATVal type];
}

+ (ODClassType*)type {
    return _ATVal_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATVal* o = ((ATVal*)(other));
    return [self.value isEqual:o.value];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.value hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"value=%@", self.value];
    [description appendString:@">"];
    return description;
}

@end


@implementation ATVar
static ODClassType* _ATVar_type;

+ (instancetype)var {
    return [[ATVar alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __value = [CNAtomicObject atomicObject];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATVar class]) _ATVar_type = [ODClassType classTypeWithCls:[ATVar class]];
}

+ (ATVar*)applyInitial:(id)initial {
    ATVar* v = [ATVar var];
    [v setValue:initial];
    return v;
}

- (id)value {
    return [__value value];
}

- (void)setValue:(id)value {
    while(YES) {
        id v = [__value value];
        if([v isEqual:value]) return ;
        if([__value compareAndSetOldValue:v newValue:value]) {
            [self notifyValue:value];
            return ;
        }
    }
}

- (void)updateF:(id(^)(id))f {
    while(YES) {
        id v = [__value value];
        id value = f(v);
        if([v isEqual:value]) return ;
        if([__value compareAndSetOldValue:v newValue:value]) {
            [self notifyValue:value];
            return ;
        }
    }
}

- (ODClassType*)type {
    return [ATVar type];
}

+ (ODClassType*)type {
    return _ATVar_type;
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


@implementation ATReactExpression
static ODClassType* _ATReactExpression_type;

+ (instancetype)reactExpression {
    return [[ATReactExpression alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __value = [CNAtomicObject atomicObject];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATReactExpression class]) _ATReactExpression_type = [ODClassType classTypeWithCls:[ATReactExpression class]];
}

- (id)value {
    return [__value value];
}

- (void)setValue:(id)value {
    while(YES) {
        id v = [__value value];
        if([v isEqual:value]) return ;
        if([__value compareAndSetOldValue:v newValue:value]) {
            [self notifyValue:value];
            return ;
        }
    }
}

- (void)_init {
    [self setValue:[self calc]];
}

- (id)calc {
    @throw @"Method calc is abstract";
}

- (ODClassType*)type {
    return [ATReactExpression type];
}

+ (ODClassType*)type {
    return _ATReactExpression_type;
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


@implementation ATMappedReact
static ODClassType* _ATMappedReact_type;
@synthesize a = _a;
@synthesize f = _f;

+ (instancetype)mappedReactWithA:(ATReact*)a f:(id(^)(id))f {
    return [[ATMappedReact alloc] initWithA:a f:f];
}

- (instancetype)initWithA:(ATReact*)a f:(id(^)(id))f {
    self = [super init];
    __weak ATMappedReact* _weakSelf = self;
    if(self) {
        _a = a;
        _f = [f copy];
        _obsA = [_a observeF:^void(id newValue) {
            ATMappedReact* _self = _weakSelf;
            if(_self != nil) [_self setValue:_self->_f(newValue)];
        }];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATMappedReact class]) _ATMappedReact_type = [ODClassType classTypeWithCls:[ATMappedReact class]];
}

- (id)calc {
    return _f([_a value]);
}

- (ODClassType*)type {
    return [ATMappedReact type];
}

+ (ODClassType*)type {
    return _ATMappedReact_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATMappedReact* o = ((ATMappedReact*)(other));
    return [self.a isEqual:o.a] && [self.f isEqual:o.f];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.a hash];
    hash = hash * 31 + [self.f hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"a=%@", self.a];
    [description appendString:@">"];
    return description;
}

@end


@implementation ATMappedReact2
static ODClassType* _ATMappedReact2_type;
@synthesize a = _a;
@synthesize b = _b;
@synthesize f = _f;

+ (instancetype)mappedReact2WithA:(ATReact*)a b:(ATReact*)b f:(id(^)(id, id))f {
    return [[ATMappedReact2 alloc] initWithA:a b:b f:f];
}

- (instancetype)initWithA:(ATReact*)a b:(ATReact*)b f:(id(^)(id, id))f {
    self = [super init];
    __weak ATMappedReact2* _weakSelf = self;
    if(self) {
        _a = a;
        _b = b;
        _f = [f copy];
        _obsA = [_a observeF:^void(id newValue) {
            ATMappedReact2* _self = _weakSelf;
            if(_self != nil) [_self setValue:_self->_f(newValue, [_self->_b value])];
        }];
        _obsB = [_b observeF:^void(id newValue) {
            ATMappedReact2* _self = _weakSelf;
            if(_self != nil) [_self setValue:_self->_f([_self->_a value], newValue)];
        }];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATMappedReact2 class]) _ATMappedReact2_type = [ODClassType classTypeWithCls:[ATMappedReact2 class]];
}

- (id)calc {
    return _f([_a value], [_b value]);
}

- (ODClassType*)type {
    return [ATMappedReact2 type];
}

+ (ODClassType*)type {
    return _ATMappedReact2_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATMappedReact2* o = ((ATMappedReact2*)(other));
    return [self.a isEqual:o.a] && [self.b isEqual:o.b] && [self.f isEqual:o.f];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.a hash];
    hash = hash * 31 + [self.b hash];
    hash = hash * 31 + [self.f hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"a=%@", self.a];
    [description appendFormat:@", b=%@", self.b];
    [description appendString:@">"];
    return description;
}

@end


@implementation ATMappedReact3
static ODClassType* _ATMappedReact3_type;
@synthesize a = _a;
@synthesize b = _b;
@synthesize c = _c;
@synthesize f = _f;

+ (instancetype)mappedReact3WithA:(ATReact*)a b:(ATReact*)b c:(ATReact*)c f:(id(^)(id, id, id))f {
    return [[ATMappedReact3 alloc] initWithA:a b:b c:c f:f];
}

- (instancetype)initWithA:(ATReact*)a b:(ATReact*)b c:(ATReact*)c f:(id(^)(id, id, id))f {
    self = [super init];
    __weak ATMappedReact3* _weakSelf = self;
    if(self) {
        _a = a;
        _b = b;
        _c = c;
        _f = [f copy];
        _obsA = [_a observeF:^void(id newValue) {
            ATMappedReact3* _self = _weakSelf;
            if(_self != nil) [_self setValue:_self->_f(newValue, [_self->_b value], [_self->_c value])];
        }];
        _obsB = [_b observeF:^void(id newValue) {
            ATMappedReact3* _self = _weakSelf;
            if(_self != nil) [_self setValue:_self->_f([_self->_a value], newValue, [_self->_c value])];
        }];
        _obsC = [_c observeF:^void(id newValue) {
            ATMappedReact3* _self = _weakSelf;
            if(_self != nil) [_self setValue:_self->_f([_self->_a value], [_self->_b value], newValue)];
        }];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATMappedReact3 class]) _ATMappedReact3_type = [ODClassType classTypeWithCls:[ATMappedReact3 class]];
}

- (id)calc {
    return _f([_a value], [_b value], [_c value]);
}

- (ODClassType*)type {
    return [ATMappedReact3 type];
}

+ (ODClassType*)type {
    return _ATMappedReact3_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATMappedReact3* o = ((ATMappedReact3*)(other));
    return [self.a isEqual:o.a] && [self.b isEqual:o.b] && [self.c isEqual:o.c] && [self.f isEqual:o.f];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.a hash];
    hash = hash * 31 + [self.b hash];
    hash = hash * 31 + [self.c hash];
    hash = hash * 31 + [self.f hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"a=%@", self.a];
    [description appendFormat:@", b=%@", self.b];
    [description appendFormat:@", c=%@", self.c];
    [description appendString:@">"];
    return description;
}

@end


@implementation ATReactFlag
static ODClassType* _ATReactFlag_type;
@synthesize initial = _initial;
@synthesize reacts = _reacts;

+ (instancetype)reactFlagWithInitial:(BOOL)initial reacts:(id<CNImSeq>)reacts {
    return [[ATReactFlag alloc] initWithInitial:initial reacts:reacts];
}

- (instancetype)initWithInitial:(BOOL)initial reacts:(id<CNImSeq>)reacts {
    self = [super init];
    __weak ATReactFlag* _weakSelf = self;
    if(self) {
        _initial = initial;
        _reacts = reacts;
        _observers = [[[_reacts chain] map:^ATObserver*(ATReact* r) {
            return [((ATReact*)(r)) observeF:^void(id _) {
                ATReactFlag* _self = _weakSelf;
                [_self setValue:@YES];
            }];
        }] toArray];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [ATReactFlag class]) _ATReactFlag_type = [ODClassType classTypeWithCls:[ATReactFlag class]];
}

- (void)_init {
    [self setValue:numb(_initial)];
}

- (void)set {
    [self setValue:@YES];
}

- (void)clear {
    [self setValue:@NO];
}

- (void)processF:(void(^)())f {
    if(unumb([self value])) {
        ((void(^)())(f))();
        [self clear];
    }
}

- (ODClassType*)type {
    return [ATReactFlag type];
}

+ (ODClassType*)type {
    return _ATReactFlag_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    ATReactFlag* o = ((ATReactFlag*)(other));
    return self.initial == o.initial && [self.reacts isEqual:o.reacts];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.initial;
    hash = hash * 31 + [self.reacts hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"initial=%d", self.initial];
    [description appendFormat:@", reacts=%@", self.reacts];
    [description appendString:@">"];
    return description;
}

@end


