#import "objd.h"
#import "PGInApp.h"
#import "TRTrain.h"
#import "PGVec.h"
#import "TRCity.h"
#import "TRRailPoint.h"
#import "PGShare.h"
@class PGPlatform;
@class DTLocalKeyValueStorage;
@class DTConflict;
@class DTCloudKeyValueStorage;
@class CNSignal;
@class CNObserver;
@class TRLevel;
@class TRScore;
@class CNVar;
@class PGGameCenter;
@class TRStr;
@class TRStrings;
@class TRLevelRules;
@class PGDirector;
@class CNReact;
@class PGAlert;
@class PGSoundDirector;
@class CNChain;
@class PGOS;
@class PGDevice;
@class PGRate;
@class PGProduct;
@class PGLocalPlayerScore;
@class TRDemo;
@class TRLevelChooseMenu;
@class TRLevels;
@class TRSceneFactory;
@class TRLevelState;
@class TRRailroadState;
@class TRRail;
@class TRSwitchState;
@class TRSwitch;
@class TRRailLightState;
@class TRRailLight;
@class PGEMail;
@class CNFuture;
@class TRHistory;
@class PGCounter;
@class NSDate;
@class PGLengthCounter;
@class PGShareDialog;
@class PGScene;
@protocol PGController;
@class CNSortBuilder;
@class PGInApp;

@class TRGameDirector;

@interface TRGameDirector : NSObject {
@public
    NSString* _gameCenterPrefix;
    NSString* _gameCenterAchievementPrefix;
    NSString* _inAppPrefix;
    NSString* _cloudPrefix;
    NSArray* _rewindsInApp;
    NSInteger _maxDayRewinds;
    NSInteger _rewindRestorePeriod;
    DTLocalKeyValueStorage* _local;
    id(^_resolveMaxLevel)(id, id);
    DTCloudKeyValueStorage* _cloud;
    CNSignal* _playerScoreRetrieved;
    CNObserver* _obs;
    CNObserver* _sporadicDamageHelpObs;
    CNObserver* _damageHelpObs;
    CNObserver* _repairerHelpObs;
    CNMArray* __purchasing;
    CNObserver* _inAppObs;
    CNObserver* _crashObs;
    CNObserver* _knockDownObs;
    BOOL _demo;
    CNVar* _soundEnabled;
    CNObserver* _soundEnabledObserves;
    CNVar* __slowMotionsCount;
    CNVar* __dayRewinds;
    CNVar* __boughtRewinds;
    CNReact* _rewindsCount;
    CNSignal* _shared;
    NSArray* __rewindPrices;
}
@property (nonatomic, readonly) NSString* gameCenterPrefix;
@property (nonatomic, readonly) NSString* gameCenterAchievementPrefix;
@property (nonatomic, readonly) NSString* inAppPrefix;
@property (nonatomic, readonly) NSString* cloudPrefix;
@property (nonatomic, readonly) NSArray* rewindsInApp;
@property (nonatomic, readonly) NSInteger maxDayRewinds;
@property (nonatomic, readonly) NSInteger rewindRestorePeriod;
@property (nonatomic, readonly) DTLocalKeyValueStorage* local;
@property (nonatomic, readonly) id(^resolveMaxLevel)(id, id);
@property (nonatomic, readonly) DTCloudKeyValueStorage* cloud;
@property (nonatomic, readonly) CNSignal* playerScoreRetrieved;
@property (nonatomic, retain) CNMArray* _purchasing;
@property (nonatomic) BOOL demo;
@property (nonatomic, readonly) CNVar* soundEnabled;
@property (nonatomic, readonly) CNReact* rewindsCount;
@property (nonatomic, readonly) CNSignal* shared;

+ (instancetype)gameDirector;
- (instancetype)init;
- (CNClassType*)type;
- (BOOL)showShadows;
- (BOOL)precipitations;
- (BOOL)railroadAA;
- (void)showHelpKey:(NSString*)key text:(NSString*)text after:(CGFloat)after;
- (void)showHelpKey:(NSString*)key text:(NSString*)text;
- (id<CNSeq>)purchasing;
- (void)closeRewindShop;
- (void)clearTutorial;
- (NSInteger)bestScoreLevelNumber:(NSUInteger)levelNumber;
- (void)destroyTrainsTrains:(id<CNIterable>)trains;
- (void)_init;
- (BOOL)needFPS;
- (void)localPlayerScoreLevel:(NSUInteger)level callback:(void(^)(PGLocalPlayerScore*))callback;
- (NSInteger)currentLevel;
- (NSInteger)maxAvailableLevel;
- (NSInteger)firstBuild;
- (void)restoreLastScene;
- (void)startDemo;
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
- (CNReact*)slowMotionsCount;
- (NSArray*)lastRewinds;
- (void)runRewindLevel:(TRLevel*)level;
- (void)runSlowMotionLevel:(TRLevel*)level;
- (void)checkLastRewinds;
- (PGShareDialog*)shareDialog;
- (void)buyRewindsProduct:(PGInAppProduct*)product;
- (void)boughtRewindsCount:(NSUInteger)count;
- (void)shareRect:(PGRect)rect;
- (BOOL)isShareToFacebookAvailable;
- (void)shareToFacebook;
- (BOOL)isShareToTwitterAvailable;
- (void)shareToTwitter;
- (NSArray*)rewindPrices;
- (void)forLevelF:(void(^)(TRLevel*))f;
- (void)closeShop;
- (void)loadProducts;
- (void)openShop;
- (NSString*)description;
+ (TRGameDirector*)instance;
+ (NSInteger)facebookShareRate;
+ (NSInteger)twitterShareRate;
+ (CNClassType*)type;
@end


