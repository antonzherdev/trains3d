#import "TRGameDirector.h"

#import "GL.h"
#import "EGPlatform.h"
#import "DTKeyValueStorage.h"
#import "DTConflictResolve.h"
#import "TRLevel.h"
#import "TestFlight.h"
#import "TRScore.h"
#import "EGGameCenterPlat.h"
#import "TRStrings.h"
#import "EGSchedule.h"
#import "TRTrain.h"
#import "TRLevelFactory.h"
#import "EGCameraIso.h"
#import "EGDirector.h"
#import "EGScene.h"
#import "EGInApp.h"
#import "EGAlert.h"
#import "SDSoundDirector.h"
#import "EGRate.h"
#import "EGGameCenter.h"
#import "TRSceneFactory.h"
#import "TRLevelChooseMenu.h"
#import "EGEMail.h"
#import "EGInAppPlat.h"
#import "EGSharePlat.h"
#import "EGShare.h"
@implementation TRGameDirector{
    NSString* _gameCenterPrefix;
    NSString* _gameCenterAchievementPrefix;
    NSString* _inAppPrefix;
    NSString* _cloudPrefix;
    id<CNSeq> _slowMotionsInApp;
    NSInteger _maxDaySlowMotions;
    NSInteger _slowMotionRestorePeriod;
    DTLocalKeyValueStorage* _local;
    id(^_resolveMaxLevel)(id, id);
    DTCloudKeyValueStorage* _cloud;
    CNNotificationObserver* _obs;
    CNNotificationObserver* _sporadicDamageHelpObs;
    CNNotificationObserver* _damageHelpObs;
    CNNotificationObserver* _repairerHelpObs;
    CNNotificationObserver* _crazyHelpObs;
    CNNotificationObserver* _lineAdviceObs;
    CNNotificationObserver* _slowMotionHelpObs;
    CNNotificationObserver* _zoomHelpObs;
    CNNotificationObserver* _inAppObs;
    CNNotificationObserver* _crashObs;
    CNNotificationObserver* _knockDownObs;
    NSInteger __slowMotionsCount;
    id<CNSeq> __slowMotionPrices;
}
static TRGameDirector* _TRGameDirector_instance;
static CNNotificationHandle* _TRGameDirector_playerScoreRetrieveNotification;
static NSInteger _TRGameDirector_facebookShareRate = 10;
static NSInteger _TRGameDirector_twitterShareRate = 10;
static ODClassType* _TRGameDirector_type;
@synthesize gameCenterPrefix = _gameCenterPrefix;
@synthesize gameCenterAchievementPrefix = _gameCenterAchievementPrefix;
@synthesize inAppPrefix = _inAppPrefix;
@synthesize cloudPrefix = _cloudPrefix;
@synthesize slowMotionsInApp = _slowMotionsInApp;
@synthesize maxDaySlowMotions = _maxDaySlowMotions;
@synthesize slowMotionRestorePeriod = _slowMotionRestorePeriod;
@synthesize local = _local;
@synthesize resolveMaxLevel = _resolveMaxLevel;
@synthesize cloud = _cloud;

+ (id)gameDirector {
    return [[TRGameDirector alloc] init];
}

- (id)init {
    self = [super init];
    __weak TRGameDirector* _weakSelf = self;
    if(self) {
        _gameCenterPrefix = @"grp.com.antonzherdev.Trains3D";
        _gameCenterAchievementPrefix = @"grp.com.antonzherdev.Train3D";
        _inAppPrefix = ((egPlatform().isComputer) ? @"com.antonzherdev.Trains3D" : @"com.antonzherdev.Trains3Di");
        _cloudPrefix = @"";
        _slowMotionsInApp = (@[tuple([NSString stringWithFormat:@"%@.Slow1", _inAppPrefix], @20), tuple([NSString stringWithFormat:@"%@.Slow2", _inAppPrefix], @50), tuple([NSString stringWithFormat:@"%@.Slow3", _inAppPrefix], @200)]);
        _maxDaySlowMotions = 5;
        _slowMotionRestorePeriod = 60 * 60 * 24;
        _local = [DTLocalKeyValueStorage localKeyValueStorageWithDefaults:(@{@"currentLevel" : @1, @"soundEnabled" : @1, @"lastSlowMotions" : (@[]), @"daySlowMotions" : numi(_maxDaySlowMotions), @"boughtSlowMotions" : @0})];
        _resolveMaxLevel = ^id(id a, id b) {
            id v = DTConflict.resolveMax(a, b);
            [CNLog applyText:[NSString stringWithFormat:@"Max level from cloud %@ = max(%@, %@)", v, a, b]];
            if([_weakSelf currentLevel] == unumi(a)) {
                [CNLog applyText:[NSString stringWithFormat:@"Update current level with %@ from cloud", v]];
                [_weakSelf.local setKey:@"currentLevel" value:v];
            }
            return v;
        };
        _cloud = [DTCloudKeyValueStorage cloudKeyValueStorageWithDefaults:(@{@"maxLevel" : @1, @"pocket.maxLevel" : @1}) resolveConflict:^id(NSString* name) {
            if([name isEqual:[NSString stringWithFormat:@"%@maxLevel", _weakSelf.cloudPrefix]]) return _weakSelf.resolveMaxLevel;
            else return DTConflict.resolveMax;
        }];
        _obs = [TRLevel.winNotification observeBy:^void(TRLevel* level, id _) {
            NSUInteger n = ((TRLevel*)(level)).number;
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"Win level %lu", (unsigned long)n]];
            [_weakSelf.cloud keepMaxKey:[NSString stringWithFormat:@"%@maxLevel", _weakSelf.cloudPrefix] i:((NSInteger)(n + 1))];
            [_weakSelf.local setKey:@"currentLevel" i:((NSInteger)(n + 1))];
            NSString* leaderboard = [NSString stringWithFormat:@"%@.Level%lu", _weakSelf.gameCenterPrefix, (unsigned long)n];
            NSInteger s = [((TRLevel*)(level)).score score];
            [_weakSelf.cloud keepMaxKey:[NSString stringWithFormat:@"%@level%lu.score", _weakSelf.cloudPrefix, (unsigned long)n] i:[((TRLevel*)(level)).score score]];
            [EGGameCenter.instance reportScoreLeaderboard:leaderboard value:((long)(s)) completed:^void(EGLocalPlayerScore* score) {
                [[TRGameDirector playerScoreRetrieveNotification] postSender:_weakSelf data:score];
            }];
        }];
        _sporadicDamageHelpObs = [TRLevel.sporadicDamageNotification observeBy:^void(TRLevel* level, id _) {
            if([_weakSelf.cloud intForKey:@"help.sporadicDamage"] == 0) [((TRLevel*)(level)).schedule scheduleAfter:1.0 event:^void() {
                [((TRLevel*)(level)) showHelpText:[TRStr.Loc helpSporadicDamage]];
                [_weakSelf.cloud setKey:@"help.sporadicDamage" i:1];
            }];
        }];
        _damageHelpObs = [TRLevel.damageNotification observeBy:^void(TRLevel* level, id _) {
            if([_weakSelf.cloud intForKey:@"help.damage"] == 0) [((TRLevel*)(level)).schedule scheduleAfter:1.0 event:^void() {
                [((TRLevel*)(level)) showHelpText:[TRStr.Loc helpDamage]];
                [_weakSelf.cloud setKey:@"help.damage" i:1];
            }];
        }];
        _repairerHelpObs = [TRLevel.runRepairerNotification observeBy:^void(TRLevel* level, id _) {
            if([_weakSelf.cloud intForKey:@"help.repairer"] == 0) [((TRLevel*)(level)).schedule scheduleAfter:((CGFloat)(TRLevel.trainComingPeriod + 7)) event:^void() {
                [((TRLevel*)(level)) showHelpText:[TRStr.Loc helpRepairer]];
                [_weakSelf.cloud setKey:@"help.repairer" i:1];
            }];
        }];
        _crazyHelpObs = [TRLevel.runTrainNotification observeBy:^void(TRLevel* level, TRTrain* train) {
            if(((TRTrain*)(train)).trainType == TRTrainType.crazy && [_weakSelf.cloud intForKey:@"help.crazy"] == 0) [((TRLevel*)(level)).schedule scheduleAfter:2.0 event:^void() {
                [((TRLevel*)(level)) showHelpText:[TRStr.Loc helpCrazy]];
                [_weakSelf.cloud setKey:@"help.crazy" i:1];
            }];
        }];
        _lineAdviceObs = [TRLevelFactory.lineAdviceTimeNotification observeBy:^void(id _, TRLevel* level) {
            if([_weakSelf.cloud intForKey:@"help.linesAdvice"] == 0) {
                [((TRLevel*)(level)) showHelpText:[TRStr.Loc linesAdvice]];
                [_weakSelf.cloud setKey:@"help.linesAdvice" i:1];
            }
        }];
        _slowMotionHelpObs = [TRLevelFactory.slowMotionHelpNotification observeBy:^void(id _, TRLevel* level) {
            if([_weakSelf.cloud intForKey:@"help.slowMotion"] == 0) {
                [((TRLevel*)(level)) showHelpText:[TRStr.Loc helpSlowMotion]];
                [_weakSelf.cloud setKey:@"help.slowMotion" i:1];
            }
        }];
        _zoomHelpObs = [EGCameraIsoMove.cameraChangedNotification observeBy:^void(EGCameraIsoMove* move, id _) {
            if([_weakSelf.cloud intForKey:@"help.zoom"] == 0 && [((EGCameraIsoMove*)(move)) scale] > 1) {
                [((TRLevel*)(((EGScene*)([[[EGDirector current] scene] get])).controller)) showHelpText:[TRStr.Loc helpInZoom]];
                [_weakSelf.cloud setKey:@"help.zoom" i:1];
            }
        }];
        _inAppObs = [EGInAppTransaction.changeNotification observeBy:^void(EGInAppTransaction* transaction, id __) {
            if(((EGInAppTransaction*)(transaction)).state == EGInAppTransactionState.purchased) {
                [[_weakSelf.slowMotionsInApp findWhere:^BOOL(CNTuple* _) {
                    return [((CNTuple*)(_)).a isEqual:((EGInAppTransaction*)(transaction)).productId];
                }] forEach:^void(CNTuple* item) {
                    [_weakSelf boughtSlowMotionsCount:unumui(((CNTuple*)(item)).b)];
                    [((EGInAppTransaction*)(transaction)) finish];
                    if([[EGDirector current] isPaused]) [_weakSelf forLevelF:^void(TRLevel* level) {
                        if(level.slowMotionShop) {
                            level.slowMotionShop = NO;
                            [[EGDirector current] resume];
                            [_weakSelf runSlowMotionLevel:level];
                        }
                    }];
                }];
            } else {
                if(((EGInAppTransaction*)(transaction)).state == EGInAppTransactionState.failed) {
                    BOOL paused = [[EGDirector current] isPaused];
                    if(!(paused)) [[EGDirector current] pause];
                    [EGAlert showErrorTitle:[TRStr.Loc error] message:[((EGInAppTransaction*)(transaction)).error get] callback:^void() {
                        [((EGInAppTransaction*)(transaction)) finish];
                        if(!(paused)) [[EGDirector current] resume];
                    }];
                }
            }
        }];
        _crashObs = [TRLevel.crashNotification observeBy:^void(TRLevel* level, id<CNSeq> trains) {
            [TRGameDirector.instance destroyTrainsTrains:trains];
        }];
        _knockDownObs = [TRLevel.knockDownNotification observeBy:^void(TRLevel* level, CNTuple* p) {
            [TRGameDirector.instance destroyTrainsTrains:(@[((CNTuple*)(p)).a])];
            if(unumi(((CNTuple*)(p)).b) == 2) {
                [EGGameCenter.instance completeAchievementName:[NSString stringWithFormat:@"%@.KnockDown", _weakSelf.gameCenterAchievementPrefix]];
            } else {
                if(unumui(((CNTuple*)(p)).b) > 2) [EGGameCenter.instance completeAchievementName:[NSString stringWithFormat:@"%@.Crash%@", _weakSelf.gameCenterAchievementPrefix, ((CNTuple*)(p)).b]];
            }
        }];
        __slowMotionsCount = 0;
        __slowMotionPrices = [[[_slowMotionsInApp chain] map:^CNTuple*(CNTuple* _) {
            return tuple(((CNTuple*)(_)).b, [CNOption none]);
        }] toArray];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRGameDirector_type = [ODClassType classTypeWithCls:[TRGameDirector class]];
    _TRGameDirector_instance = [TRGameDirector gameDirector];
    _TRGameDirector_playerScoreRetrieveNotification = [CNNotificationHandle notificationHandleWithName:@"playerScoreRetrieveNotification"];
}

- (void)clearTutorial {
    [_cloud setKey:@"help.sporadicDamage" i:0];
    [_cloud setKey:@"help.damage" i:0];
    [_cloud setKey:@"help.repairer" i:0];
    [_cloud setKey:@"help.crazy" i:0];
    [_cloud setKey:@"help.linesAdvice" i:0];
    [_cloud setKey:@"help.slowMotion" i:0];
    [_cloud setKey:@"help.zoom" i:0];
}

- (NSInteger)bestScoreLevelNumber:(NSUInteger)levelNumber {
    return [_cloud intForKey:[NSString stringWithFormat:@"%@level%lu.score", _cloudPrefix, (unsigned long)levelNumber]];
}

- (void)destroyTrainsTrains:(id<CNSeq>)trains {
    [EGGameCenter.instance completeAchievementName:[NSString stringWithFormat:@"%@.Crash", _gameCenterAchievementPrefix]];
    if([trains existsWhere:^BOOL(TRTrain* _) {
    return ((TRTrain*)(_)).trainType == TRTrainType.fast;
}]) [EGGameCenter.instance completeAchievementName:[NSString stringWithFormat:@"%@.ExpressCrash", _gameCenterAchievementPrefix]];
    if([trains existsWhere:^BOOL(TRTrain* _) {
    return ((TRTrain*)(_)).trainType == TRTrainType.repairer;
}]) [EGGameCenter.instance completeAchievementName:[NSString stringWithFormat:@"%@.RepairCrash", _gameCenterAchievementPrefix]];
    if([trains existsWhere:^BOOL(TRTrain* _) {
    return ((TRTrain*)(_)).trainType == TRTrainType.crazy;
}]) [EGGameCenter.instance completeAchievementName:[NSString stringWithFormat:@"%@.CrazyCrash", _gameCenterAchievementPrefix]];
}

- (void)_init {
    [SDSoundDirector.instance setEnabled:[_local intForKey:@"soundEnabled"] == 1];
    [EGRate.instance setIdsIos:736579117 osx:736545415];
    [EGGameCenter.instance authenticate];
    if([self daySlowMotions] > _maxDaySlowMotions) [_local setKey:@"daySlowMotions" i:_maxDaySlowMotions];
    NSUInteger fullDayCount = [[self lastSlowMotions] count] + [self daySlowMotions];
    if(fullDayCount > _maxDaySlowMotions) {
        [_local setKey:@"lastSlowMotions" array:[[[[self lastSlowMotions] chain] topNumbers:_maxDaySlowMotions - [self daySlowMotions]] toArray]];
    } else {
        if(fullDayCount < _maxDaySlowMotions) [_local setKey:@"daySlowMotions" i:_maxDaySlowMotions - [[self lastSlowMotions] count]];
    }
    [self checkLastSlowMotions];
    __slowMotionsCount = [self daySlowMotions] + [self boughtSlowMotions];
}

- (void)localPlayerScoreLevel:(NSUInteger)level callback:(void(^)(id))callback {
    NSString* leaderboard = [NSString stringWithFormat:@"%@.Level%lu", _gameCenterPrefix, (unsigned long)level];
    [EGGameCenter.instance localPlayerScoreLeaderboard:leaderboard callback:^void(id score) {
        NSInteger bs = [self bestScoreLevelNumber:level];
        if(([score isDefined] && ((EGLocalPlayerScore*)([score get])).value < bs) || (bs > 0 && [score isEmpty])) {
            [CNLog applyText:[NSString stringWithFormat:@"No result in game center for level %lu. We are trying to report.", (unsigned long)level]];
            [EGGameCenter.instance reportScoreLeaderboard:leaderboard value:((long)(bs)) completed:^void(EGLocalPlayerScore* ls) {
                callback([CNOption applyValue:ls]);
            }];
        } else {
            callback(score);
        }
    }];
}

- (NSInteger)currentLevel {
    return [_local intForKey:@"currentLevel"];
}

- (NSInteger)maxAvailableLevel {
    return [_cloud intForKey:[NSString stringWithFormat:@"%@maxLevel", _cloudPrefix]];
}

- (void)restoreLastScene {
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Start with %ld", (long)[self currentLevel]]];
    [[EGDirector current] setScene:^EGScene*() {
        return [TRSceneFactory sceneForLevelWithNumber:((NSUInteger)([self currentLevel]))];
    }];
}

- (void)restartLevel {
    __weak TRGameDirector* _weakSelf = self;
    [self forLevelF:^void(TRLevel* level) {
        if(level.number == 16 && [_weakSelf isNeedRate]) {
            level.rate = YES;
            [[EGDirector current] redraw];
        } else {
            [_weakSelf setLevel:((NSInteger)(level.number))];
            [[EGDirector current] resume];
        }
    }];
}

- (void)chooseLevel {
    [TestFlight passCheckpoint:@"Choose level menu"];
    [[EGDirector current] setScene:^EGScene*() {
        return [TRLevelChooseMenu scene];
    }];
    [[EGDirector current] pause];
}

- (void)nextLevel {
    __weak TRGameDirector* _weakSelf = self;
    [self forLevelF:^void(TRLevel* level) {
        if([_weakSelf isNeedRate]) {
            [TestFlight passCheckpoint:@"Show rate dialog"];
            level.rate = YES;
            [[EGDirector current] redraw];
        } else {
            [_weakSelf setLevel:((NSInteger)(level.number + 1))];
            [[EGDirector current] resume];
        }
    }];
}

- (void)rateLater {
    [EGRate.instance later];
    [self nextLevel];
}

- (void)rateClose {
    [EGRate.instance never];
    [self nextLevel];
}

- (void)setLevel:(NSInteger)level {
    if(level <= [self maxAvailableLevel]) {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"Start level %ld", (long)level]];
        [_local setKey:@"currentLevel" i:level];
        [[EGDirector current] setTimeSpeed:1.0];
        [[EGDirector current] setScene:^EGScene*() {
            return [TRSceneFactory sceneForLevel:[TRLevelFactory levelWithNumber:((NSUInteger)(level))]];
        }];
    }
}

- (void)showLeaderboardLevel:(TRLevel*)level {
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Show leaderboard for level %lu", (unsigned long)level.number]];
    [EGGameCenter.instance showLeaderboardName:[NSString stringWithFormat:@"%@.Level%lu", _gameCenterPrefix, (unsigned long)level.number]];
}

- (void)synchronize {
    [_local synchronize];
    [_cloud synchronize];
}

- (void)showSupportChangeLevel:(BOOL)changeLevel {
    __weak TRGameDirector* _weakSelf = self;
    [TestFlight passCheckpoint:@"Show support"];
    NSString* text = [@"\n"
        "\n"
        "> " stringByAppendingString:[[TRStr.Loc supportEmailText] replaceOccurrences:@"\n" withString:@"\n"
        "> "]];
    NSString* htmlText = [[text replaceOccurrences:@">" withString:@"&gt;"] replaceOccurrences:@"\n" withString:@"<br/>\n"];
    [self forLevelF:^void(TRLevel* level) {
        [EGEMail.instance showInterfaceTo:@"support@raildale.com" subject:[NSString stringWithFormat:@"Raildale - %lu", (unsigned long)oduIntRnd()] text:text htmlText:[NSString stringWithFormat:@"<small><i>%@</i></small>", htmlText]];
        if(changeLevel) [_weakSelf setLevel:((NSInteger)(level.number + 1))];
    }];
}

- (BOOL)isNeedRate {
    return [self maxAvailableLevel] > 6 && [EGRate.instance shouldShowEveryVersion:YES];
}

- (void)showRate {
    __weak TRGameDirector* _weakSelf = self;
    [TestFlight passCheckpoint:@"Rate"];
    [self forLevelF:^void(TRLevel* level) {
        [EGRate.instance showRate];
        [_weakSelf setLevel:((NSInteger)(level.number + 1))];
    }];
}

- (BOOL)soundEnabled {
    return [SDSoundDirector.instance enabled];
}

- (void)setSoundEnabled:(BOOL)soundEnabled {
    if([SDSoundDirector.instance enabled] != soundEnabled) {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"SoundEnabled = %d", soundEnabled]];
        [_local setKey:@"soundEnabled" i:((soundEnabled) ? 1 : 0)];
        [SDSoundDirector.instance setEnabled:soundEnabled];
    }
}

- (id<CNSeq>)lastSlowMotions {
    return [_local arrayForKey:@"lastSlowMotions"];
}

- (NSInteger)daySlowMotions {
    return [_local intForKey:@"daySlowMotions"];
}

- (NSInteger)boughtSlowMotions {
    return [_local intForKey:@"boughtSlowMotions"];
}

- (NSInteger)slowMotionsCount {
    return __slowMotionsCount;
}

- (void)runSlowMotionLevel:(TRLevel*)level {
    if([level.slowMotionCounter isStopped]) {
        if(__slowMotionsCount <= 0) {
            [TestFlight passCheckpoint:@"Shop"];
            [EGInApp loadProductsIds:[[[_slowMotionsInApp chain] map:^NSString*(CNTuple* _) {
                return ((CNTuple*)(_)).a;
            }] toArray] callback:^void(id<CNSeq> products) {
                __slowMotionPrices = [[[[[[products chain] sortBy] ascBy:^NSString*(EGInAppProduct* _) {
                    return ((EGInAppProduct*)(_)).id;
                }] endSort] map:^CNTuple*(EGInAppProduct* product) {
                    return tuple(((CNTuple*)([[_slowMotionsInApp findWhere:^BOOL(CNTuple* _) {
                        return [((CNTuple*)(_)).a isEqual:((EGInAppProduct*)(product)).id];
                    }] get])).b, [CNOption someValue:product]);
                }] toArray];
                [[EGDirector current] redraw];
            }];
            level.slowMotionShop = YES;
            [[EGDirector current] pause];
            return ;
        }
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"slow motion : %ld", (long)__slowMotionsCount]];
        [[EGDirector current] setTimeSpeed:0.1];
        level.slowMotionCounter = [[EGLengthCounter lengthCounterWithLength:1.0] onEndEvent:^void() {
            [[EGDirector current] setTimeSpeed:1.0];
        }];
        NSInteger dsm = [self daySlowMotions];
        if(dsm > 0) {
            [_local decrementKey:@"daySlowMotions"];
            if([[_local appendToArrayKey:@"lastSlowMotions" value:[NSDate date]] count] == 1) [self checkLastSlowMotions];
            __slowMotionsCount--;
        } else {
            NSInteger bsm = [self boughtSlowMotions];
            if(bsm > 0) {
                [_local decrementKey:@"boughtSlowMotions"];
                __slowMotionsCount--;
            } else {
                return ;
            }
        }
    }
}

- (void)checkLastSlowMotions {
    id<CNSeq> lsm = [self lastSlowMotions];
    if(!([lsm isEmpty])) {
        NSDate* first = [lsm head];
        if([first beforeNow] > _slowMotionRestorePeriod) {
            [_local setKey:@"lastSlowMotions" array:[[self lastSlowMotions] tail]];
            [_local incrementKey:@"daySlowMotions"];
            __slowMotionsCount++;
            [self checkLastSlowMotions];
        } else {
            __weak TRGameDirector* ws = self;
            delay([first beforeNow] + 1, ^void() {
                [ws checkLastSlowMotions];
            });
        }
    }
}

- (EGShareDialog*)shareDialog {
    __weak TRGameDirector* _weakSelf = self;
    NSString* url = @"http://get.raildale.com/?x=a";
    return [[[[EGShareContent applyText:[TRStr.Loc shareTextUrl:url] image:[CNOption applyValue:@"Share.jpg"]] twitterText:[TRStr.Loc twitterTextUrl:url]] emailText:[TRStr.Loc shareTextUrl:url] subject:[TRStr.Loc shareSubject]] dialogShareHandler:^void(EGShareChannel* shareChannel) {
        if(shareChannel == EGShareChannel.facebook && [_cloud intForKey:@"share.facebook"] == 0) {
            [_cloud setKey:@"share.facebook" i:1];
            [self boughtSlowMotionsCount:((NSUInteger)(_TRGameDirector_facebookShareRate))];
        } else {
            if(shareChannel == EGShareChannel.twitter && [_cloud intForKey:@"share.twitter"] == 0) {
                [_cloud setKey:@"share.twitter" i:1];
                [self boughtSlowMotionsCount:((NSUInteger)(_TRGameDirector_twitterShareRate))];
            }
        }
        [self forLevelF:^void(TRLevel* level) {
            if(level.slowMotionShop) {
                level.slowMotionShop = NO;
                [[EGDirector current] resume];
                [_weakSelf runSlowMotionLevel:level];
            }
        }];
    } cancelHandler:^void() {
    }];
}

- (void)buySlowMotionsProduct:(EGInAppProduct*)product {
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"buySlowMotions %@", product.id]];
    [product buy];
}

- (void)boughtSlowMotionsCount:(NSUInteger)count {
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"boughtSlowMotions %lu", (unsigned long)count]];
    [_local setKey:@"boughtSlowMotions" i:[_local intForKey:@"boughtSlowMotions"] + count];
    __slowMotionsCount += ((NSInteger)(count));
}

- (void)share {
    if(!([EGShareDialog isSupported])) return ;
    [TestFlight passCheckpoint:@"Share"];
    [[self shareDialog] display];
}

- (BOOL)isShareToFacebookAvailable {
    return [EGShareDialog isSupported] && [_cloud intForKey:@"share.facebook"] == 0;
}

- (void)shareToFacebook {
    [[self shareDialog] displayFacebook];
}

- (BOOL)isShareToTwitterAvailable {
    return [EGShareDialog isSupported] && [_cloud intForKey:@"share.twitter"] == 0;
}

- (void)shareToTwitter {
    [[self shareDialog] displayTwitter];
}

- (id<CNSeq>)slowMotionPrices {
    return __slowMotionPrices;
}

- (void)forLevelF:(void(^)(TRLevel*))f {
    [[ODObject asKindOfClass:[TRLevel class] object:((EGScene*)([[[EGDirector current] scene] get])).controller] forEach:f];
}

- (void)closeShop {
    [self forLevelF:^void(TRLevel* level) {
        if(level.slowMotionShop) {
            level.slowMotionShop = NO;
            [[EGDirector current] resume];
        }
    }];
}

- (ODClassType*)type {
    return [TRGameDirector type];
}

+ (TRGameDirector*)instance {
    return _TRGameDirector_instance;
}

+ (CNNotificationHandle*)playerScoreRetrieveNotification {
    return _TRGameDirector_playerScoreRetrieveNotification;
}

+ (NSInteger)facebookShareRate {
    return _TRGameDirector_facebookShareRate;
}

+ (NSInteger)twitterShareRate {
    return _TRGameDirector_twitterShareRate;
}

+ (ODClassType*)type {
    return _TRGameDirector_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


