#import "DTKeyValueStorage.h"

@implementation DTKeyValueStorage{
    id<CNMap> _defaults;
    NSUserDefaults* _d;
}
static ODClassType* _DTKeyValueStorage_type;
@synthesize defaults = _defaults;

+ (id)keyValueStorageWithDefaults:(id<CNMap>)defaults {
    return [[DTKeyValueStorage alloc] initWithDefaults:defaults];
}

- (id)initWithDefaults:(id<CNMap>)defaults {
    self = [super init];
    if(self) {
        _defaults = defaults;
        _d = [NSUserDefaults standardUserDefaults];
        NSDictionary * dic = [defaults convertWithBuilder:[CNHashMapBuilder hashMapBuilder]];
        [_d registerDefaults:dic];
        [_d synchronize];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _DTKeyValueStorage_type = [ODClassType classTypeWithCls:[DTKeyValueStorage class]];
}

- (void)setKey:(NSString*)key i:(NSInteger)i {
    [_d setInteger:i forKey:key];
}

- (NSInteger)intForKey:(NSString*)key {
    return [_d integerForKey:key];
}

- (void)synchronize {
    [_d synchronize];
}

- (ODClassType*)type {
    return [DTKeyValueStorage type];
}

+ (ODClassType*)type {
    return _DTKeyValueStorage_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    DTKeyValueStorage* o = ((DTKeyValueStorage*)(other));
    return [self.defaults isEqual:o.defaults];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.defaults hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"defaults=%@", self.defaults];
    [description appendString:@">"];
    return description;
}

- (void)keepMaxKey:(NSString *)key i:(NSInteger)i {
    if([_d integerForKey:key] < i) {
        [_d setInteger:i forKey:key];
    }
}
@end


