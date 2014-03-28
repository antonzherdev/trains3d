#import "objd.h"

@class DTKeyValueStorage;
@class ATVar;

@interface DTKeyValueStorage : NSObject
@property (nonatomic, readonly) id<CNMap> defaults;

+ (id)keyValueStorageWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)userDefaults;

- (id)initWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)d;
+ (ODClassType*)type;
- (ODClassType*)type;

- (id <CNImSeq>)arrayForKey:(NSString *)string;
- (id)valueForKey:(NSString *)key;
- (NSInteger)intForKey:(NSString*)key;
- (NSString *)stringForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)string;

- (ATVar *)stringVarKey:(NSString *)string;
- (ATVar *)intVarKey:(NSString *)string;
- (ATVar *)boolVarKey:(NSString *)string;
- (ATVar *)varForKey:(NSString *)string;

- (void)setKey:(NSString*)key i:(NSInteger)i;
- (void)setKey:(NSString *)key value:(id)value;
- (void)setKey:(NSString *)string array:(id <CNImSeq>)array;
- (void)setKey:(NSString *)string b:(BOOL)array;
- (void)synchronize;

- (void)keepMaxKey:(NSString *)key i:(NSInteger)i;
- (NSInteger)incrementKey:(NSString *)string;
- (NSInteger)decrementKey:(NSString *)string;
- (id <CNImSeq>)appendToArrayKey:(NSString *)key value:(id)value;

@end


@interface DTLocalKeyValueStorage : DTKeyValueStorage
+ (id)localKeyValueStorageWithDefaults:(id<CNMap>)defaults;

- (id)initWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)d;
- (ODClassType*)type;

@end

@interface DTCloudKeyValueStorage : DTKeyValueStorage
@property (nonatomic, readonly) id (^resolveConflict)(NSString*);
+ (id)cloudKeyValueStorageWithDefaults:(id<CNMap>)defaults resolveConflict:(id (^)(NSString*))resolveConflict;
- (id)initWithDefaults:(id<CNMap>)defaults resolveConflict:(id (^)(NSString*))resolveConflict;
- (ODClassType*)type;
@end
