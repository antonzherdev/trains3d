#import "objd.h"
@class DTLocalKeyValueStorage;
@class DTConflict;
@class DTCloudKeyValueStorage;
@class TRLevel;
@class EGGameCenter;
@class EGDirector;
@class TRSceneFactory;
@class EGScene;
@protocol EGController;
@class TRLevelChooseMenu;
@class TRLevelFactory;

@class TRGameDirector;

@interface TRGameDirector : NSObject
@property (nonatomic, readonly) DTLocalKeyValueStorage* local;
@property (nonatomic, readonly) DTCloudKeyValueStorage* cloud;

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
- (void)setLevel:(NSInteger)level;
- (void)synchronize;
+ (TRGameDirector*)instance;
+ (ODClassType*)type;
@end


