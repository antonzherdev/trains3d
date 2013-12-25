#import "DTKeyValueStorage.h"

@implementation DTKeyValueStorage{
    id<CNMap> _defaults;
}
static ODClassType* _DTKeyValueStorage_type;
@synthesize defaults = _defaults;

+ (id)keyValueStorageWithDefaults:(id<CNMap>)defaults {
    return [[DTKeyValueStorage alloc] initWithDefaults:defaults];
}

- (id)initWithDefaults:(id<CNMap>)defaults {
    self = [super init];
    if(self) _defaults = defaults;

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

- (id)valueForKey:(NSString *)key {
    @throw @"Method set is abstract";
}


- (void)keepMaxKey:(NSString*)key i:(NSInteger)i {
    @throw @"Method keepMax is abstract";
}

- (NSInteger)intForKey:(NSString*)key {
    @throw @"Method intFor is abstract";
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
@end


@implementation DTLocalKeyValueStorage{
    NSUserDefaults* _d;
}
static ODClassType* _DTKeyValueStorage_type;

+ (id)localKeyValueStorageWithDefaults:(id<CNMap>)defaults {
    return [[DTLocalKeyValueStorage alloc] initWithDefaults:defaults];
}

- (id)initWithDefaults:(id<CNMap>)defaults {
    self = [super initWithDefaults:defaults];
    if(self) {
        _d = [NSUserDefaults standardUserDefaults];
        NSDictionary * dic = [defaults convertWithBuilder:[CNHashMapBuilder hashMapBuilder]];
        [_d registerDefaults:dic];
        [_d synchronize];
    }
    return self;
}


+ (id)keyValueStorageWithDefaults:(id<CNMap>)defaults {
    return [[DTKeyValueStorage alloc] initWithDefaults:defaults];
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

- (void)setKey:(NSString *)key value:(id)value {
    [_d setObject:value forKey:key];
}

- (id)valueForKey:(NSString *)key {
    return [_d objectForKey:key];
}
@end


@implementation DTCloudKeyValueStorage{
    id (^_resolveConflict)(NSString*);
    NSUserDefaults* _d;
}
static ODClassType* _DTCloudKeyValueStorage_type;
static CNNotificationHandle* _DTCloudKeyValueStorage_valueChangedNotification;
@synthesize resolveConflict = _resolveConflict;

+ (id)cloudKeyValueStorageWithDefaults:(id<CNMap>)defaults resolveConflict:(id (^)(NSString*))resolveConflict {
    return [[DTCloudKeyValueStorage alloc] initWithDefaults:defaults resolveConflict:resolveConflict];
}

- (id)initWithDefaults:(id<CNMap>)defaults resolveConflict:(id (^)(NSString*))resolveConflict {
    self = [super initWithDefaults:defaults];
    if(self) {
        _d = [NSUserDefaults standardUserDefaults];
        NSDictionary * dic = [defaults convertWithBuilder:[CNHashMapBuilder hashMapBuilder]];
        [_d registerDefaults:dic];
        [_d synchronize];
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

- (NSInteger)intForKey:(NSString*)key {
    return [_d integerForKey:key];
}

- (void)keepMaxKey:(NSString *)key i:(NSInteger)i {
    if([_d integerForKey:key] < i) {
        [self setKey:key i:i];
    }
}


- (void)synchronize {
    [_d synchronize];
    [[NSUbiquitousKeyValueStore defaultStore] synchronize];
}

- (void)setKey:(NSString *)key value:(id)value {
    [_d setObject:value forKey:key];
    [[NSUbiquitousKeyValueStore defaultStore] setObject:value forKey:key];
}

- (id)valueForKey:(NSString *)key {
    return [_d objectForKey:key];
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
