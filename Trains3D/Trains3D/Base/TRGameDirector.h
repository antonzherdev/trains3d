#import "objd.h"
@class DTKeyValueStorage;
@class EGScene;
@class TRSceneFactory;
@class EGDirector;
@protocol EGController;
@class TRLevel;
@class TRLevelFactory;

@class TRGameDirector;

@interface TRGameDirector : NSObject
+ (id)gameDirector;
- (id)init;
- (ODClassType*)type;
- (void)_init;
- (NSInteger)maxAvailableLevel;
- (EGScene*)restoreLastScene;
- (void)restartLevel;
- (void)chooseLevel;
- (void)nextLevel;
+ (TRGameDirector*)instance;
+ (ODClassType*)type;
@end


