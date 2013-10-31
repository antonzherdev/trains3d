#import "objd.h"

@class DTKeyValueStorage;

@interface DTKeyValueStorage : NSObject
@property (nonatomic, readonly) id<CNMap> defaults;

+ (id)keyValueStorageWithDefaults:(id<CNMap>)defaults;
- (id)initWithDefaults:(id<CNMap>)defaults;
- (ODClassType*)type;
- (void)setKey:(NSString*)key i:(NSInteger)i;
- (NSInteger)intForKey:(NSString*)key;
- (void)synchronize;
+ (ODClassType*)type;

- (void)keepMaxKey:(NSString *)key i:(NSInteger)i;
@end


