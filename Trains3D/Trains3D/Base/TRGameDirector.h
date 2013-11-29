#import "objd.h"
@class DTLocalKeyValueStorage;
@class DTConflict;
@class DTCloudKeyValueStorage;
@class TRLevel;
@class TRScore;
@class EGGameCenter;
@class TRStr;
@protocol TRStrings;
@class EGSchedule;
@class EGLocalPlayerScore;
@class EGDirector;
@class TRSceneFactory;
@class EGScene;
@protocol EGController;
@class TRLevelChooseMenu;
@class TRLevelFactory;
@class EGEMail;
@class EGRate;

@class TRGameDirector;

@interface TRGameDirector : NSObject
@property (nonatomic, readonly) DTLocalKeyValueStorage* local;
@property (nonatomic, readonly) id(^resolveMaxLevel)(id, id);
@property (nonatomic, readonly) DTCloudKeyValueStorage* cloud;

+ (id)gameDirector;
- (id)init;
- (ODClassType*)type;
- (NSInteger)bestScoreLevelNumber:(NSUInteger)levelNumber;
- (void)_init;
- (void)localPlayerScoreLevel:(NSUInteger)level callback:(void(^)(id))callback;
- (NSInteger)currentLevel;
- (NSInteger)maxAvailableLevel;
- (void)restoreLastScene;
- (void)restartLevel;
- (void)chooseLevel;
- (void)nextLevel;
- (void)setLevel:(NSInteger)level;
- (void)showLeaderboardLevel:(TRLevel*)level;
- (void)synchronize;
- (void)showSupport;
- (BOOL)isNeedRate;
- (void)showRate;
+ (TRGameDirector*)instance;
+ (CNNotificationHandle*)playerScoreRetrieveNotification;
+ (ODClassType*)type;
@end


