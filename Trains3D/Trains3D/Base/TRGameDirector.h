#import "objd.h"
@class DTLocalKeyValueStorage;
@class DTConflict;
@class DTCloudKeyValueStorage;
@class TRLevel;
@class TestFlight;
@class TRScore;
@class EGGameCenter;
@class TRStr;
@protocol TRStrings;
@class EGSchedule;
@class TRTrain;
@class TRTrainType;
@class TRLevelFactory;
@class EGCameraIsoMove;
@class EGDirector;
@class EGScene;
@protocol EGController;
@class SDSoundDirector;
@class EGRate;
@class EGLocalPlayerScore;
@class TRSceneFactory;
@class TRLevelChooseMenu;
@class EGEMail;
@class EGCounter;
@class EGLengthCounter;
@class EGShareDialog;
@class EGShareContent;

@class TRGameDirector;

@interface TRGameDirector : NSObject
@property (nonatomic, readonly) NSString* gameCenterPrefix;
@property (nonatomic, readonly) NSString* gameCenterAchievmentPrefix;
@property (nonatomic, readonly) NSString* cloudPrefix;
@property (nonatomic, readonly) NSInteger maxDaySlowMotions;
@property (nonatomic, readonly) NSInteger slowMotionRestorePeriod;
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
- (BOOL)soundEnabled;
- (void)setSoundEnabled:(BOOL)soundEnabled;
- (id<CNSeq>)lastSlowMotions;
- (NSInteger)daySlowMotions;
- (NSInteger)boughtSlowMotions;
- (NSInteger)slowMotionsCount;
- (void)runSlowMotionLevel:(TRLevel*)level;
- (void)checkLastSlowMotions;
- (void)share;
+ (TRGameDirector*)instance;
+ (CNNotificationHandle*)playerScoreRetrieveNotification;
+ (ODClassType*)type;
@end


