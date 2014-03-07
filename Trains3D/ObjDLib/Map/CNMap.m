#import "objd.h"
#import "CNMap.h"

#import "ODType.h"
#import "CNChain.h"
#import "CNDispatchQueue.h"
@implementation CNMapDefault{
    id(^_defaultFunc)(id);
    id<CNMMap> _map;
}
static ODClassType* _CNMapDefault_type;
@synthesize defaultFunc = _defaultFunc;
@synthesize map = _map;

+ (instancetype)mapDefaultWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMMap>)map {
    return [[CNMapDefault alloc] initWithDefaultFunc:defaultFunc map:map];
}

- (instancetype)initWithDefaultFunc:(id(^)(id))defaultFunc map:(id<CNMMap>)map {
    self = [super init];
    if(self) {
        _defaultFunc = [defaultFunc copy];
        _map = map;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNMapDefault class]) _CNMapDefault_type = [ODClassType classTypeWithCls:[CNMapDefault class]];
}

- (NSUInteger)count {
    return [_map count];
}

- (id<CNIterator>)iterator {
    return [_map iterator];
}

- (id<CNMIterator>)mutableIterator {
    return [_map mutableIterator];
}

- (id)applyKey:(id)key {
    return [_map objectForKey:key orUpdateWith:^id() {
        return _defaultFunc(key);
    }];
}

- (id<CNIterable>)keys {
    return [_map keys];
}

- (id<CNIterable>)values {
    return [_map values];
}

- (BOOL)containsKey:(id)key {
    return [_map containsKey:key];
}

- (void)setKey:(id)key value:(id)value {
    [_map setKey:key value:value];
}

- (id)modifyKey:(id)key by:(id(^)(id))by {
    id value = by([self applyKey:key]);
    [_map setKey:key value:value];
    return value;
}

- (void)appendItem:(CNTuple*)item {
    [_map appendItem:item];
}

- (BOOL)removeItem:(CNTuple*)item {
    return [_map removeItem:item];
}

- (void)clear {
    [_map clear];
}

- (void)mutableFilterBy:(BOOL(^)(id))by {
    id<CNMIterator> i = [self mutableIterator];
    while([i hasNext]) {
        if(by([i next])) [i remove];
    }
}

- (id<CNImIterable>)im {
    return [self imCopy];
}

- (id<CNImIterable>)imCopy {
    NSMutableArray* arr = [NSMutableArray mutableArray];
    [self forEach:^void(id item) {
        [arr appendItem:item];
    }];
    return [arr im];
}

- (id)head {
    return [[self iterator] next];
}

- (id)headOpt {
    if([self isEmpty]) return [CNOption none];
    else return [CNOption applyValue:[self head]];
}

- (BOOL)isEmpty {
    return !([[self iterator] hasNext]);
}

- (CNChain*)chain {
    return [CNChain chainWithCollection:self];
}

- (void)forEach:(void(^)(id))each {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        each([i next]);
    }
}

- (void)parForEach:(void(^)(id))each {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        id v = [i next];
        [CNDispatchQueue.aDefault asyncF:^void() {
            each(v);
        }];
    }
}

- (BOOL)goOn:(BOOL(^)(id))on {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if(!(on([i next]))) return NO;
    }
    return YES;
}

- (BOOL)containsItem:(id)item {
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        if([[i next] isEqual:i]) return YES;
    }
    return NO;
}

- (NSString*)description {
    return [[self chain] toStringWithStart:@"[" delimiter:@", " end:@"]"];
}

- (NSUInteger)hash {
    NSUInteger ret = 13;
    id<CNIterator> i = [self iterator];
    while([i hasNext]) {
        ret = ret * 31 + [[i next] hash];
    }
    return ret;
}

- (id)findWhere:(BOOL(^)(id))where {
    __block id ret = [CNOption none];
    [self goOn:^BOOL(id x) {
        if(where(x)) {
            ret = [CNOption applyValue:x];
            return NO;
        } else {
            return YES;
        }
    }];
    return ret;
}

- (BOOL)existsWhere:(BOOL(^)(id))where {
    __block BOOL ret = NO;
    [self goOn:^BOOL(id x) {
        if(where(x)) {
            ret = YES;
            return NO;
        } else {
            return YES;
        }
    }];
    return ret;
}

- (BOOL)allConfirm:(BOOL(^)(id))confirm {
    __block BOOL ret = YES;
    [self goOn:^BOOL(id x) {
        if(!(confirm(x))) {
            ret = NO;
            return NO;
        } else {
            return YES;
        }
    }];
    return ret;
}

- (id)convertWithBuilder:(id<CNBuilder>)builder {
    [self forEach:^void(id x) {
        [builder appendItem:x];
    }];
    return [builder build];
}

- (ODClassType*)type {
    return [CNMapDefault type];
}

+ (ODClassType*)type {
    return _CNMapDefault_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    CNMapDefault* o = ((CNMapDefault*)(other));
    return [self.defaultFunc isEqual:o.defaultFunc] && [self.map isEqual:o.map];
}

@end


@implementation CNHashMapBuilder{
    NSMutableDictionary* _map;
}
static ODClassType* _CNHashMapBuilder_type;
@synthesize map = _map;

+ (instancetype)hashMapBuilder {
    return [[CNHashMapBuilder alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _map = [NSMutableDictionary mutableDictionary];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [CNHashMapBuilder class]) _CNHashMapBuilder_type = [ODClassType classTypeWithCls:[CNHashMapBuilder class]];
}

- (void)appendItem:(CNTuple*)item {
    [_map setKey:item.a value:item.b];
}

- (NSDictionary*)build {
    return [_map im];
}

- (void)appendAllItems:(id<CNTraversable>)items {
    [items forEach:^void(id _) {
        [self appendItem:_];
    }];
}

- (ODClassType*)type {
    return [CNHashMapBuilder type];
}

+ (ODClassType*)type {
    return _CNHashMapBuilder_type;
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


