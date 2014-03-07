#import "DTKeyValueStorage.h"

@implementation DTKeyValueStorage{
@public
    id<CNMap> _defaults;
    NSUserDefaults* _d;
}
static ODClassType* _DTKeyValueStorage_type;
@synthesize defaults = _defaults;

+ (id)keyValueStorageWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)userDefaults {
    return [[DTKeyValueStorage alloc] initWithDefaults:defaults userDefaults:userDefaults];
}

- (id)initWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)d {
    self = [super init];
    if(self) {
        _defaults = defaults;
        _d = d;
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
    @throw @"Method set is abstract";
}

- (void)setKey:(NSString *)key value:(id)value {
    @throw @"Method set is abstract";
}

- (void)synchronize {
    @throw @"Method synchronize is abstract";
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

- (NSInteger)intForKey:(NSString*)key {
    return [_d integerForKey:key];
}

- (BOOL)boolForKey:(NSString *)key {
    return [_d boolForKey:key];
}

- (NSString *)stringForKey:(NSString *)key {
    return [_d stringForKey:key];
}


- (void)keepMaxKey:(NSString *)key i:(NSInteger)i {
    if([_d integerForKey:key] < i) {
        [self setKey:key i:i];
    }
}

- (id)valueForKey:(NSString *)key {
    return [_d objectForKey:key];
}

- (void)setKey:(NSString *)key array:(id <CNImSeq>)array {
    @throw @"Abstract";
}

- (id <CNImSeq>)arrayForKey:(NSString *)string {
    return [_d objectForKey:string];
}

- (id <CNImSeq>)appendToArrayKey:(NSString *)key value:(id)value {
    id <CNImSeq> ret = [[self arrayForKey:key] addItem:value];
    [self setKey:key array:ret];
    return ret;
}

- (NSInteger)decrementKey:(NSString *)key {
    NSInteger i = [_d integerForKey:key] - 1;
    [self setKey:key i:i];
    return i;
}

- (NSInteger)incrementKey:(NSString *)key {
    NSInteger i = [_d integerForKey:key] + 1;
    [self setKey:key i:i];
    return i;
}
@end


@implementation DTLocalKeyValueStorage
static ODClassType* _DTKeyValueStorage_type;

+ (id)localKeyValueStorageWithDefaults:(id<CNMap>)defaults {
    return [[DTLocalKeyValueStorage alloc] initWithDefaults:defaults userDefaults:nil ];
}

- (id)initWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)d {
    self = [super initWithDefaults:defaults userDefaults:[NSUserDefaults standardUserDefaults]];
    return self;
}


+ (id)keyValueStorageWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)userDefaults {
    return [[DTKeyValueStorage alloc] initWithDefaults:defaults userDefaults:nil ];
}
+ (void)initialize {
    [super initialize];
    _DTKeyValueStorage_type = [ODClassType classTypeWithCls:[DTKeyValueStorage class]];
}

- (void)setKey:(NSString*)key i:(NSInteger)i {
    [_d setInteger:i forKey:key];
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

- (void)setKey:(NSString *)key value:(id)value {
    [_d setObject:value forKey:key];
}

- (void)setKey:(NSString *)key array:(id <CNSeq>)array {
    [_d setObject:array forKey:key];
}
@end


@implementation DTCloudKeyValueStorage{
    id (^_resolveConflict)(NSString*);
}
static ODClassType* _DTCloudKeyValueStorage_type;
static CNNotificationHandle* _DTCloudKeyValueStorage_valueChangedNotification;
@synthesize resolveConflict = _resolveConflict;

+ (id)cloudKeyValueStorageWithDefaults:(id<CNMap>)defaults resolveConflict:(id (^)(NSString*))resolveConflict {
    return [[DTCloudKeyValueStorage alloc] initWithDefaults:defaults resolveConflict:resolveConflict];
}

- (id)initWithDefaults:(id<CNMap>)defaults resolveConflict:(id (^)(NSString*))resolveConflict {
    self = [super initWithDefaults:defaults userDefaults:[NSUserDefaults standardUserDefaults]];
    if(self) {
        _resolveConflict = resolveConflict;
        [[NSNotificationCenter defaultCenter]
                addObserver: self
                   selector: @selector (storeDidChange:)
                       name: NSUbiquitousKeyValueStoreDidChangeExternallyNotification
                     object: [NSUbiquitousKeyValueStore defaultStore]];

        BOOL ok = [[NSUbiquitousKeyValueStore defaultStore] synchronize];
        if(!ok) NSLog(@"Error with iCloud");
    }

    return self;
}

- (void)storeDidChange:(NSNotification *)note {
    NSDictionary* userInfo = [note userInfo];
    NSNumber* reasonForChange = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangeReasonKey];
    if (!reasonForChange) return;

    // Update only for changes from the server.
    NSInteger reason = [reasonForChange integerValue];
    if ((reason == NSUbiquitousKeyValueStoreServerChange) || (reason == NSUbiquitousKeyValueStoreInitialSyncChange)) {
        // If something is changing externally, get the changes
        // and update the corresponding keys locally.
        NSArray* changedKeys = [userInfo objectForKey:NSUbiquitousKeyValueStoreChangedKeysKey];
        NSUbiquitousKeyValueStore* store = [NSUbiquitousKeyValueStore defaultStore];
        
        // This loop assumes you are using the same key names in both
        // the user defaults database and the iCloud key-value store
        for (NSString* key in changedKeys) {
            id value = [store objectForKey:key];
            id oldValue = [_d objectForKey:key];
            if(oldValue == nil) {
                [_d setObject:value forKey:key];
                [_DTCloudKeyValueStorage_valueChangedNotification postSender:self data:tuple(key, value)];
            } else if(![oldValue isEqual:value]) {
                id (^resolver)(id, id) = _resolveConflict(key);
                id newValue = resolver(oldValue, value);
                if(![oldValue isEqual:newValue]) {
                    [_d setObject:value forKey:key];
                    [_DTCloudKeyValueStorage_valueChangedNotification postSender:self data:tuple(key, value)];
                }
                if(![value isEqual:newValue]) {
                    [[NSUbiquitousKeyValueStore defaultStore] setObject:newValue forKey:key];
                }
            }
        }
    }
}

- (void)setKey:(NSString*)key i:(NSInteger)i {
    [_d setInteger:i forKey:key];
    [[NSUbiquitousKeyValueStore defaultStore] setLongLong:i forKey:key];
}

- (void)setKey:(NSString *)key array:(id <CNSeq>)array {
    [_d setObject:array forKey:key];
    [[NSUbiquitousKeyValueStore defaultStore] setObject:array forKey:key];
}

- (void)synchronize {
    [_d synchronize];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)setKey:(NSString *)key value:(id)value {
    [_d setObject:value forKey:key];
    [[NSUbiquitousKeyValueStore defaultStore] setObject:value forKey:key];
}

+ (CNNotificationHandle*)valueChangedNotification {
    return _DTCloudKeyValueStorage_valueChangedNotification;
}

+ (void)initialize {
    [super initialize];
    _DTCloudKeyValueStorage_type = [ODClassType classTypeWithCls:[DTCloudKeyValueStorage class]];
    _DTCloudKeyValueStorage_valueChangedNotification = [CNNotificationHandle notificationHandleWithName:@"CloudKeyValueStorage.changeNotification"];
}

- (ODClassType*)type {
    return [DTCloudKeyValueStorage type];
}

+ (ODClassType*)type {
    return _DTCloudKeyValueStorage_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    DTCloudKeyValueStorage* o = ((DTCloudKeyValueStorage*)(other));
    return [self.defaults isEqual:o.defaults] && [self.resolveConflict isEqual:o.resolveConflict];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.defaults hash];
    hash = hash * 31 + [self.resolveConflict hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"defaults=%@", self.defaults];
    [description appendFormat:@", resolveConflict=%@", self.resolveConflict];
    [description appendString:@">"];
    return description;
}

@end
