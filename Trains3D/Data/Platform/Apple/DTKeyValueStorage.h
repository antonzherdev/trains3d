#import "objd.h"

@class DTKeyValueStorage;

@interface DTKeyValueStorage : NSObject
@property (nonatomic, readonly) id<CNMap> defaults;

+ (id)keyValueStorageWithDefaults:(id<CNMap>)defaults;
- (id)initWithDefaults:(id<CNMap>)defaults;
- (ODClassType*)type;
- (void)setKey:(NSString*)key i:(NSInteger)i;
- (void)setKey:(NSString *)key value:(id)value;
- (id)valueForKey:(NSString *)key;
- (NSInteger)intForKey:(NSString*)key;

- (void)synchronize;
+ (ODClassType*)type;
- (void)keepMaxKey:(NSString *)key i:(NSInteger)i;
@end


@interface DTLocalKeyValueStorage : DTKeyValueStorage
+ (id)localKeyValueStorageWithDefaults:(id<CNMap>)defaults;
- (id)initWithDefaults:(id<CNMap>)defaults;
- (ODClassType*)type;
+ (ODClassType*)type;

@end


@interface DTCloudKeyValueStorage : DTKeyValueStorage
@property (nonatomic, readonly) id<CNMap> resolveConflict;

+ (id)cloudKeyValueStorageWithDefaults:(id<CNMap>)defaults resolveConflict:(id<CNMap>)resolveConflict;
- (id)initWithDefaults:(id<CNMap>)defaults resolveConflict:(id<CNMap>)resolveConflict;
- (ODClassType*)type;
+ (ODClassType*)type;
@end
