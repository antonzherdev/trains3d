#import "objd.h"
#import "CNVar.h"

#import "CNAtomic.h"
#import "CNTypes.h"
#import "ODType.h"
@implementation CNVar{
    CNAtomicObject* __value;
    CNAtomicObject* __observers;
}
static ODClassType* _CNVar_type;

+ (instancetype)var {
    return [[CNVar alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) {
        __value = [CNAtomicObject atomicObject];
        __observers = [CNAtomicObject applyValue:(@[])];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNVar class]) _CNVar_type = [ODClassType classTypeWithCls:[CNVar class]];
}

+ (CNVar*)applyInitial:(id)initial {
    CNVar* v = [CNVar var];
    [v setValue:initial];
    return v;
}

- (void)setValue:(id)value {
    while(YES) {
        id v = [__value value];
        if([v isEqual:value]) return ;
        if([__value compareAndSetOldValue:v newValue:value]) {
            [((id<CNImSeq>)([__observers value])) forEach:^void(void(^f)(id)) {
                f(value);
            }];
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
            [((id<CNImSeq>)([__observers value])) forEach:^void(void(^f)(id<CNImSeq>)) {
                f(value);
            }];
            return ;
        }
    }
}

- (id)value {
    return [__value value];
}

- (void)onChangeF:(void(^)(id))f {
    while(YES) {
        id<CNImSeq> v = [__observers value];
        if([__observers compareAndSetOldValue:v newValue:[v addItem:f]]) return ;
    }
}

- (CNVar*)mapF:(id(^)(id))f {
    CNVar* r = [CNVar var];
    [self onChangeF:^void(id v) {
        [r setValue:f(v)];
    }];
    memoryBarrier();
    [r setValue:f([__value value])];
    return r;
}

- (ODClassType*)type {
    return [CNVar type];
}

+ (ODClassType*)type {
    return _CNVar_type;
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


