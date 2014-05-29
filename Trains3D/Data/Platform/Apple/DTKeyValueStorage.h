#import "objd.h"

@class DTKeyValueStorage;
@class CNVar;

@interface DTKeyValueStorage : NSObject
@property (nonatomic, readonly) id<CNMap> defaults;

+ (id)keyValueStorageWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)userDefaults;

- (id)initWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)d;
+ (CNClassType*)type;
- (CNClassType*)type;

- (NSArray*)arrayForKey:(NSString *)string;
- (id)valueForKey:(NSString *)key;
- (NSInteger)intForKey:(NSString*)key;
- (NSString *)stringForKey:(NSString *)key;
- (BOOL)boolForKey:(NSString *)string;

- (CNVar *)stringVarKey:(NSString *)string;
- (CNVar *)intVarKey:(NSString *)string;
- (CNVar *)boolVarKey:(NSString *)string;
- (CNVar *)varForKey:(NSString *)string;

- (void)setKey:(NSString*)key i:(NSInteger)i;
- (void)setKey:(NSString *)key value:(id)value;
- (void)setKey:(NSString *)string array:(id <CNImSeq>)array;
- (void)setKey:(NSString *)string b:(BOOL)array;
- (void)synchronize;

- (void)keepMaxKey:(NSString *)key i:(NSInteger)i;
- (NSInteger)incrementKey:(NSString *)string;
- (NSInteger)decrementKey:(NSString *)string;
- (NSArray*)appendToArrayKey:(NSString *)key value:(id)value;

@end


@interface DTLocalKeyValueStorage : DTKeyValueStorage
+ (id)localKeyValueStorageWithDefaults:(id<CNMap>)defaults;

- (id)initWithDefaults:(id <CNMap>)defaults userDefaults:(NSUserDefaults *)d;
- (CNClassType*)type;

@end

@interface DTCloudKeyValueStorage : DTKeyValueStorage
@property (nonatomic, readonly) id (^resolveConflict)(NSString*);
+ (id)cloudKeyValueStorageWithDefaults:(id<CNMap>)defaults resolveConflict:(id (^)(NSString*))resolveConflict;
- (id)initWithDefaults:(id<CNMap>)defaults resolveConflict:(id (^)(NSString*))resolveConflict;
- (CNClassType*)type;
@end
