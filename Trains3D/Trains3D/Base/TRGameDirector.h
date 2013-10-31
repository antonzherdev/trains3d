#import "objd.h"
@class DTLocalKeyValueStorage;
@class DTConflict;
@class DTCloudKeyValueStorage;
@class EGDirector;
@class TRSceneFactory;
@class EGScene;
@protocol EGController;
@class TRLevel;
@class TRLevelFactory;

@class TRGameDirector;

@interface TRGameDirector : NSObject
@property (nonatomic, readonly) DTLocalKeyValueStorage* local;

+ (id)gameDirector;
- (id)init;
- (ODClassType*)type;
- (void)_init;
- (NSInteger)currentLevel;
- (NSInteger)maxAvailableLevel;
- (void)restoreLastScene;
- (void)restartLevel;
- (void)chooseLevel;
- (void)nextLevel;
- (void)synchronize;
+ (TRGameDirector*)instance;
+ (ODClassType*)type;
@end


