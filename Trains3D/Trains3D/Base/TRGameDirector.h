#import "objd.h"
@class DTKeyValueStorage;
@class EGScene;
@class TRSceneFactory;

@class TRGameDirector;

@interface TRGameDirector : NSObject
+ (id)gameDirector;
- (id)init;
- (ODClassType*)type;
- (void)_init;
- (NSInteger)maxAvailableLevel;
- (EGScene*)restoreLastScene;
+ (TRGameDirector*)instance;
+ (ODClassType*)type;
@end


