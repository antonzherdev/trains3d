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
@class TRTrain;
@class TRTrainType;
@class EGCameraIsoMove;
@class EGDirector;
@class EGScene;
@protocol EGController;
@class EGRate;
@class EGLocalPlayerScore;
@class TRSceneFactory;
@class TRLevelChooseMenu;
@class TRLevelFactory;
@class EGEMail;

@class TRGameDirector;

@interface TRGameDirector : NSObject
@property (nonatomic, readonly) DTLocalKeyValueStorage* local;
@property (nonatomic, readonly) id(^resolveMaxLevel)(id, id);
@property (nonatomic, readonly) DTCloudKeyValueStorage* cloud;

+ (id)gameDirector;
- (id)init;
- (ODClassType*)type;
- (void)clearTutorial;
- (NSInteger)bestScoreLevelNumber:(NSUInteger)levelNumber;
- (void)destroyTrainsTrains:(id<CNSeq>)trains;
- (void)_init;
- (void)localPlayerScoreLevel:(NSUInteger)level callback:(void(^)(id))callback;
- (NSInteger)currentLevel;
- (NSInteger)maxAvailableLevel;
- (void)restoreLastScene;
- (void)restartLevel;
- (void)chooseLevel;
- (void)nextLevel;
- (void)rateLater;
- (void)rateClose;
- (void)setLevel:(NSInteger)level;
- (void)showLeaderboardLevel:(TRLevel*)level;
- (void)synchronize;
- (void)showSupportChangeLevel:(BOOL)changeLevel;
- (BOOL)isNeedRate;
- (void)showRate;
+ (TRGameDirector*)instance;
+ (CNNotificationHandle*)playerScoreRetrieveNotification;
+ (ODClassType*)type;
@end


