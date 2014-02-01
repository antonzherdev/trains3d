#import "objd.h"

@class DTKeyValueStorage;

@interface DTKeyValueStorage : NSObject
@property (nonatomic, readonly) id<CNMap> defaults;

+ (id)keyValueStorageWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)userDefaults;

- (id)initWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)d;
- (ODClassType*)type;
- (void)setKey:(NSString*)key i:(NSInteger)i;
- (void)setKey:(NSString *)key value:(id)value;
- (id)valueForKey:(NSString *)key;
- (NSInteger)intForKey:(NSString*)key;
- (NSString *)stringForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)string;

- (void)synchronize;
+ (ODClassType*)type;
- (void)keepMaxKey:(NSString *)key i:(NSInteger)i;

- (void)setKey:(NSString *)string array:(id <CNSeq>)array;

- (id <CNSeq>)arrayForKey:(NSString *)string;

- (id <CNSeq>)appendToArrayKey:(NSString *)key value:(id)value;

- (NSInteger)decrementKey:(NSString *)string;
- (NSInteger)incrementKey:(NSString *)string;
@end


@interface DTLocalKeyValueStorage : DTKeyValueStorage
+ (id)localKeyValueStorageWithDefaults:(id<CNMap>)defaults;

- (id)initWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)d;
- (ODClassType*)type;

@end

@interface DTCloudKeyValueStorage : DTKeyValueStorage
@property (nonatomic, readonly) id (^resolveConflict)(NSString*);
+ (CNNotificationHandle*)valueChangedNotification;
+ (id)cloudKeyValueStorageWithDefaults:(id<CNMap>)defaults resolveConflict:(id (^)(NSString*))resolveConflict;
- (id)initWithDefaults:(id<CNMap>)defaults resolveConflict:(id (^)(NSString*))resolveConflict;
- (ODClassType*)type;
@end
