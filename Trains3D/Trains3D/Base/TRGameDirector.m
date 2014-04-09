#import "TRGameDirector.h"

#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "DTKeyValueStorage.h"
#import "DTConflictResolve.h"
#import "TRLevel.h"
#import "TestFlight.h"
#import "TRScore.h"
#import "ATReact.h"
#import "EGGameCenterPlat.h"
#import "TRStrings.h"
#import "EGInApp.h"
#import "EGDirector.h"
#import "EGAlert.h"
#import "SDSoundDirector.h"
#import "ATObserver.h"
#import "TRTrain.h"
#import "EGRate.h"
#import "EGGameCenter.h"
#import "TRLevelChooseMenu.h"
#import "TRLevels.h"
#import "TRSceneFactory.h"
#import "EGEMail.h"
#import "TRHistory.h"
#import "EGSchedule.h"
#import "EGSharePlat.h"
#import "EGShare.h"
#import "EGScene.h"
#import "EGInAppPlat.h"
@implementation TRGameDirector
static TRGameDirector* _TRGameDirector_instance;
static CNNotificationHandle* _TRGameDirector_playerScoreRetrieveNotification;
static NSInteger _TRGameDirector_facebookShareRate = 10;
static NSInteger _TRGameDirector_twitterShareRate = 10;
static CNNotificationHandle* _TRGameDirector_shareNotification;
static ODClassType* _TRGameDirector_type;
@synthesize gameCenterPrefix = _gameCenterPrefix;
@synthesize gameCenterAchievementPrefix = _gameCenterAchievementPrefix;
@synthesize inAppPrefix = _inAppPrefix;
@synthesize cloudPrefix = _cloudPrefix;
@synthesize rewindsInApp = _rewindsInApp;
@synthesize maxDayRewinds = _maxDayRewinds;
@synthesize rewindRestorePeriod = _rewindRestorePeriod;
@synthesize local = _local;
@synthesize resolveMaxLevel = _resolveMaxLevel;
@synthesize cloud = _cloud;
@synthesize _purchasing = __purchasing;
@synthesize soundEnabled = _soundEnabled;
@synthesize rewindsCount = _rewindsCount;

+ (instancetype)gameDirector {
    return [[TRGameDirector alloc] init];
}

- (instancetype)init {
    self = [super init];
    __weak TRGameDirector* _weakSelf = self;
    if(self) {
        _gameCenterPrefix = @"grp.com.antonzherdev.Trains3D";
        _gameCenterAchievementPrefix = @"grp.com.antonzherdev.Train3D";
        _inAppPrefix = ((egPlatform().isComputer) ? @"com.antonzherdev.Trains3D" : @"com.antonzherdev.Trains3Di");
        _cloudPrefix = @"";
        _rewindsInApp = (@[tuple(([NSString stringWithFormat:@"%@.Rewind1", _inAppPrefix]), @20), tuple(([NSString stringWithFormat:@"%@.Rewind2", _inAppPrefix]), @50), tuple(([NSString stringWithFormat:@"%@.Rewind3", _inAppPrefix]), @200)]);
        _maxDayRewinds = 2;
        _rewindRestorePeriod = 60 * 60 * 12;
        _local = [DTLocalKeyValueStorage localKeyValueStorageWithDefaults:(@{@"currentLevel" : @1, @"soundEnabled" : @1, @"lastRewinds" : (@[]), @"dayRewinds" : numi(_maxDayRewinds), @"boughtRewinds" : @3, @"boughtSlowMotions" : @0, @"show_fps" : @NO, @"shadow" : @"Default", @"railroad_aa" : @"Default"})];
        _resolveMaxLevel = ^id(id a, id b) {
            TRGameDirector* _self = _weakSelf;
            id v = DTConflict.resolveMax(a, b);
            cnLogApplyText(([NSString stringWithFormat:@"Max level from cloud %@ = max(%@, %@)", v, a, b]));
            if([_self currentLevel] == unumi(a)) {
                cnLogApplyText(([NSString stringWithFormat:@"Update current level with %@ from cloud", v]));
                [_self->_local setKey:@"currentLevel" value:v];
            }
            return v;
        };
        _cloud = [DTCloudKeyValueStorage cloudKeyValueStorageWithDefaults:(@{@"maxLevel" : @1, @"pocket.maxLevel" : @1}) resolveConflict:^id(NSString* name) {
            TRGameDirector* _self = _weakSelf;
            if([name isEqual:[NSString stringWithFormat:@"%@maxLevel", _self->_cloudPrefix]]) return _self->_resolveMaxLevel;
            else return DTConflict.resolveMax;
        }];
        _obs = [TRLevel.winNotification observeBy:^void(TRLevel* level, id _) {
            TRGameDirector* _self = _weakSelf;
            NSUInteger n = ((TRLevel*)(level)).number;
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"Win level %lu", (unsigned long)n]];
            [_self->_cloud keepMaxKey:[NSString stringWithFormat:@"%@maxLevel", _self->_cloudPrefix] i:((NSInteger)(n + 1))];
            [_self->_local setKey:@"currentLevel" i:((NSInteger)(n + 1))];
            NSString* leaderboard = [NSString stringWithFormat:@"%@.Level%lu", _self->_gameCenterPrefix, (unsigned long)n];
            NSInteger s = unumi([((TRLevel*)(level)).score.money value]);
            [_self->_cloud keepMaxKey:[NSString stringWithFormat:@"%@level%lu.score", _self->_cloudPrefix, (unsigned long)n] i:s];
            [_self->_local synchronize];
            [_self->_cloud synchronize];
            [EGGameCenter.instance reportScoreLeaderboard:leaderboard value:((long)(s)) completed:^void(EGLocalPlayerScore* score) {
                TRGameDirector* _self = _weakSelf;
                [_TRGameDirector_playerScoreRetrieveNotification postSender:_self data:score];
            }];
        }];
        _sporadicDamageHelpObs = [TRLevel.sporadicDamageNotification observeBy:^void(TRLevel* level, id _) {
            TRGameDirector* _self = _weakSelf;
            if([_self->_cloud intForKey:@"help.sporadicDamage"] == 0) [((TRLevel*)(level)) scheduleAfter:1.0 event:^void() {
                TRGameDirector* _self = _weakSelf;
                [((TRLevel*)(level)) showHelpText:[TRStr.Loc helpSporadicDamage]];
                [_self->_cloud setKey:@"help.sporadicDamage" i:1];
            }];
        }];
        _damageHelpObs = [TRLevel.damageNotification observeBy:^void(TRLevel* level, id _) {
            TRGameDirector* _self = _weakSelf;
            if([_self->_cloud intForKey:@"help.damage"] == 0) [((TRLevel*)(level)) scheduleAfter:1.0 event:^void() {
                TRGameDirector* _self = _weakSelf;
                [((TRLevel*)(level)) showHelpText:[TRStr.Loc helpDamage]];
                [_self->_cloud setKey:@"help.damage" i:1];
            }];
        }];
        _repairerHelpObs = [TRLevel.runRepairerNotification observeBy:^void(TRLevel* level, id _) {
            TRGameDirector* _self = _weakSelf;
            if([_self->_cloud intForKey:@"help.repairer"] == 0) [((TRLevel*)(level)) scheduleAfter:((CGFloat)(TRLevel.trainComingPeriod + 7)) event:^void() {
                TRGameDirector* _self = _weakSelf;
                [((TRLevel*)(level)) showHelpText:[TRStr.Loc helpRepairer]];
                [_self->_cloud setKey:@"help.repairer" i:1];
            }];
        }];
        __purchasing = [NSMutableArray mutableArray];
        _inAppObs = [EGInAppTransaction.changeNotification observeBy:^void(EGInAppTransaction* transaction, id __) {
            TRGameDirector* _self = _weakSelf;
            if(((EGInAppTransaction*)(transaction)).state == EGInAppTransactionState.purchasing) {
                CNTuple* item = [_self->_rewindsInApp findWhere:^BOOL(CNTuple* _) {
                    return [((CNTuple*)(_)).a isEqual:((EGInAppTransaction*)(transaction)).productId];
                }];
                if(item != nil) {
                    [_self->__purchasing appendItem:item.b];
                    if(unumb([[EGDirector current].isPaused value])) [[EGDirector current] redraw];
                }
            } else {
                if(((EGInAppTransaction*)(transaction)).state == EGInAppTransactionState.purchased) {
                    CNTuple* item = [_self->_rewindsInApp findWhere:^BOOL(CNTuple* _) {
                        return [((CNTuple*)(_)).a isEqual:((EGInAppTransaction*)(transaction)).productId];
                    }];
                    if(item != nil) {
                        [_self boughtRewindsCount:unumui(item.b)];
                        [_self->__purchasing removeItem:item.b];
                        [((EGInAppTransaction*)(transaction)) finish];
                        [_self closeRewindShop];
                    }
                } else {
                    if(((EGInAppTransaction*)(transaction)).state == EGInAppTransactionState.failed) {
                        BOOL paused = unumb([[EGDirector current].isPaused value]);
                        if(!(paused)) [[EGDirector current] pause];
                        {
                            CNTuple* item = [_self->_rewindsInApp findWhere:^BOOL(CNTuple* _) {
                                return [((CNTuple*)(_)).a isEqual:((EGInAppTransaction*)(transaction)).productId];
                            }];
                            if(item != nil) {
                                [_self->__purchasing removeItem:item.b];
                                [[EGDirector current] redraw];
                            }
                        }
                        [EGAlert showErrorTitle:[TRStr.Loc error] message:((NSString*)(nonnil(((EGInAppTransaction*)(transaction)).error))) callback:^void() {
                            [((EGInAppTransaction*)(transaction)) finish];
                            if(!(paused)) [[EGDirector current] resume];
                        }];
                    }
                }
            }
        }];
        _crashObs = [TRLevel.crashNotification observeBy:^void(TRLevel* level, id<CNIterable> trains) {
            [TRGameDirector.instance destroyTrainsTrains:trains];
        }];
        _knockDownObs = [TRLevel.knockDownNotification observeBy:^void(TRLevel* level, CNTuple* p) {
            TRGameDirector* _self = _weakSelf;
            [TRGameDirector.instance destroyTrainsTrains:(@[((CNTuple*)(p)).a])];
            if(unumi(((CNTuple*)(p)).b) == 2) {
                [EGGameCenter.instance completeAchievementName:[NSString stringWithFormat:@"%@.KnockDown", _self->_gameCenterAchievementPrefix]];
            } else {
                if(unumui(((CNTuple*)(p)).b) > 2) [EGGameCenter.instance completeAchievementName:[NSString stringWithFormat:@"%@.Crash%@", _self->_gameCenterAchievementPrefix, ((CNTuple*)(p)).b]];
            }
        }];
        _soundEnabled = [ATVar applyInitial:numb([SDSoundDirector.instance enabled])];
        _soundEnabledObserves = [_soundEnabled observeF:^void(id e) {
            TRGameDirector* _self = _weakSelf;
            [TestFlight passCheckpoint:[NSString stringWithFormat:@"SoundEnabled = %@", e]];
            [_self->_local setKey:@"soundEnabled" i:((unumb(e)) ? 1 : 0)];
            [SDSoundDirector.instance setEnabled:unumb(e)];
        }];
        __slowMotionsCount = [_local intVarKey:@"boughtSlowMotions"];
        __dayRewinds = [_local intVarKey:@"dayRewinds"];
        __boughtRewinds = [_local intVarKey:@"boughtRewinds"];
        _rewindsCount = [ATReact applyA:__dayRewinds b:__boughtRewinds f:^id(id day, id bought) {
            return numi(unumi(day) + unumi(bought));
        }];
        __rewindPrices = [[[_rewindsInApp chain] map:^CNTuple*(CNTuple* _) {
            return tuple(((CNTuple*)(_)).b, nil);
        }] toArray];
        if([self class] == [TRGameDirector class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRGameDirector class]) {
        _TRGameDirector_type = [ODClassType classTypeWithCls:[TRGameDirector class]];
        _TRGameDirector_instance = [TRGameDirector gameDirector];
        _TRGameDirector_playerScoreRetrieveNotification = [CNNotificationHandle notificationHandleWithName:@"playerScoreRetrieveNotification"];
        _TRGameDirector_shareNotification = [CNNotificationHandle notificationHandleWithName:@"GameDirector.shareNotification"];
    }
}

- (BOOL)showShadows {
    NSString* s = [_local stringForKey:@"shadow"];
    return ([s isEqual:@"Default"] || [s isEqual:@"On"]) && !([egPlatform() isIOSLessVersion:@"7"]);
}

- (BOOL)railroadAA {
    NSString* s = [_local stringForKey:@"railroad_aa"];
    return ([s isEqual:@"Default"] && !([egPlatform() isIOSLessVersion:@"7"])) || [s isEqual:@"On"];
}

- (void)showHelpKey:(NSString*)key text:(NSString*)text after:(CGFloat)after {
    if([_cloud intForKey:key] == 0) [self forLevelF:^void(TRLevel* level) {
        if(eqf(after, 0)) {
            [level showHelpText:text];
            [_cloud setKey:key i:1];
        } else {
            [level scheduleAfter:after event:^void() {
                [level showHelpText:text];
                [_cloud setKey:key i:1];
            }];
        }
    }];
}

- (void)showHelpKey:(NSString*)key text:(NSString*)text {
    [self showHelpKey:key text:text after:0.0];
}

- (id<CNSeq>)purchasing {
    return __purchasing;
}

- (void)closeRewindShop {
    if(unumb([[EGDirector current].isPaused value])) [self forLevelF:^void(TRLevel* level) {
        if(level.rewindShop == 1) {
            level.rewindShop = 0;
            [[EGDirector current] resume];
            [self runRewindLevel:level];
        } else {
            if(level.rewindShop == 2) {
                level.rewindShop = 0;
                [[EGDirector current] redraw];
            }
        }
    }];
}

- (void)clearTutorial {
    [_cloud setKey:@"help.sporadicDamage" i:0];
    [_cloud setKey:@"help.damage" i:0];
    [_cloud setKey:@"help.express" i:0];
    [_cloud setKey:@"help.repairer" i:0];
    [_cloud setKey:@"help.crazy" i:0];
    [_cloud setKey:@"help.linesAdvice" i:0];
    [_cloud setKey:@"help.rewind" i:0];
    [_cloud setKey:@"help.zoom" i:0];
    [_cloud setKey:@"help.tozoom" i:0];
    [_cloud setKey:@"help.remove" i:0];
}

- (NSInteger)bestScoreLevelNumber:(NSUInteger)levelNumber {
    return [_cloud intForKey:[NSString stringWithFormat:@"%@level%lu.score", _cloudPrefix, (unsigned long)levelNumber]];
}

- (void)destroyTrainsTrains:(id<CNIterable>)trains {
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
    [_soundEnabled setValue:numb([_local intForKey:@"soundEnabled"] == 1)];
    [EGRate.instance setIdsIos:736579117 osx:736545415];
    [EGGameCenter.instance authenticate];
    if(unumi([__dayRewinds value]) > _maxDayRewinds) [__dayRewinds setValue:numi(_maxDayRewinds)];
    NSUInteger fullDayCount = [[self lastRewinds] count] + unumui([__dayRewinds value]);
    if(fullDayCount > _maxDayRewinds) {
        [_local setKey:@"lastRewinds" array:[[[[self lastRewinds] chain] topNumbers:_maxDayRewinds - unumi([__dayRewinds value])] toArray]];
    } else {
        if(fullDayCount < _maxDayRewinds) [__dayRewinds setValue:numi(_maxDayRewinds - [[self lastRewinds] count])];
    }
    [self checkLastRewinds];
}

- (BOOL)needFPS {
    return [_local boolForKey:@"show_fps"];
}

- (void)localPlayerScoreLevel:(NSUInteger)level callback:(void(^)(EGLocalPlayerScore*))callback {
    NSString* leaderboard = [NSString stringWithFormat:@"%@.Level%lu", _gameCenterPrefix, (unsigned long)level];
    [EGGameCenter.instance localPlayerScoreLeaderboard:leaderboard callback:^void(EGLocalPlayerScore* score) {
        NSInteger bs = [self bestScoreLevelNumber:level];
        if((score != nil && ((EGLocalPlayerScore*)(score)).value < bs) || (bs > 0 && score == nil)) {
            cnLogApplyText(([NSString stringWithFormat:@"No result in game center for level %lu. We are trying to report.", (unsigned long)level]));
            [EGGameCenter.instance reportScoreLeaderboard:leaderboard value:((long)(bs)) completed:^void(EGLocalPlayerScore* ls) {
                callback(ls);
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
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Restore %ld", (long)[self currentLevel]]];
    if(egPlatform().jailbreak) [TestFlight passCheckpoint:@"Jailbreak"];
    [self setLevel:[self currentLevel]];
}

- (void)restartLevel {
    [self forLevelF:^void(TRLevel* level) {
        if(level.number == 16 && [self isNeedRate]) {
            level.rate = YES;
            [[EGDirector current] redraw];
        } else {
            [self setLevel:((NSInteger)(level.number))];
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
    [self forLevelF:^void(TRLevel* level) {
        if([self isNeedRate]) {
            [TestFlight passCheckpoint:@"Show rate dialog"];
            level.rate = YES;
            [[EGDirector current] redraw];
        } else {
            [self setLevel:((NSInteger)(level.number + 1))];
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
    NSInteger l = ((level > [self maxAvailableLevel]) ? [self maxAvailableLevel] : level);
    NSString* sh = (([self showShadows]) ? @"sh" : @"no_sh");
    NSString* raa = (([self railroadAA]) ? @"raa" : @"no_raa");
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Start level %ld %@ %@", (long)l, sh, raa]];
    [_local setKey:@"currentLevel" i:l];
    [[EGDirector current] setTimeSpeed:1.0];
    TRLevel* lvl = [TRLevels levelWithNumber:((NSUInteger)(l))];
    if(l > 2 && [_cloud intForKey:@"help.remove"] == 0) [lvl scheduleAfter:5.0 event:^void() {
        [self showHelpKey:@"help.remove" text:[TRStr.Loc helpToRemove]];
    }];
    [[EGDirector current] setScene:^EGScene*() {
        return [TRSceneFactory sceneForLevel:lvl];
    }];
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
    [TestFlight passCheckpoint:@"Show support"];
    NSString* txt = [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@", [TRStr.Loc supportEmailText], egPlatform().text];
    NSString* text = [@"\n"
        "\n"
        "> " stringByAppendingString:[txt replaceOccurrences:@"\n" withString:@"\n"
        "> "]];
    NSString* htmlText = [[text replaceOccurrences:@">" withString:@"&gt;"] replaceOccurrences:@"\n" withString:@"<br/>\n"];
    [self forLevelF:^void(TRLevel* level) {
        [EGEMail.instance showInterfaceTo:@"support@raildale.com" subject:[NSString stringWithFormat:@"Raildale - %lu", (unsigned long)oduIntRnd()] text:text htmlText:[NSString stringWithFormat:@"<small><i>%@</i></small>", htmlText]];
        if(changeLevel) [self setLevel:((NSInteger)(level.number + 1))];
    }];
}

- (BOOL)isNeedRate {
    return [self maxAvailableLevel] > 4 && [EGRate.instance shouldShowEveryVersion:YES];
}

- (void)showRate {
    [TestFlight passCheckpoint:@"Rate"];
    [self forLevelF:^void(TRLevel* level) {
        [EGRate.instance showRate];
        [self setLevel:((NSInteger)(level.number + 1))];
    }];
}

- (ATReact*)slowMotionsCount {
    return __slowMotionsCount;
}

- (NSArray*)lastRewinds {
    return [_local arrayForKey:@"lastRewinds"];
}

- (void)runRewindLevel:(TRLevel*)level {
    if(!(unumb([[level.history.rewindCounter isRunning] value]))) {
        if(unumi([_rewindsCount value]) <= 0) {
            [TestFlight passCheckpoint:@"Shop"];
            [self loadProducts];
            level.rewindShop = 1;
            [[EGDirector current] pause];
            return ;
        }
        [level rewind];
        if(unumi([__dayRewinds value]) > 0) {
            [__dayRewinds updateF:^id(id _) {
                return numi(unumi(_) - 1);
            }];
            if([[_local appendToArrayKey:@"lastRewinds" value:[NSDate date]] count] == 1) [self checkLastRewinds];
        } else {
            if(unumi([__boughtRewinds value]) > 0) [__boughtRewinds updateF:^id(id _) {
                return numi(unumi(_) - 1);
            }];
        }
        [_local synchronize];
    }
}

- (void)runSlowMotionLevel:(TRLevel*)level {
    if(!(unumb([[level.slowMotionCounter isRunning] value]))) {
        if(unumi([__slowMotionsCount value]) <= 0) return ;
        [[EGDirector current] setTimeSpeed:0.1];
        level.slowMotionCounter = [[EGLengthCounter lengthCounterWithLength:1.0] onEndEvent:^void() {
            [[EGDirector current] setTimeSpeed:1.0];
        }];
        [__slowMotionsCount updateF:^id(id _) {
            return numi(unumi(_) - 1);
        }];
        [_local synchronize];
    }
}

- (void)checkLastRewinds {
    NSArray* lsm = [self lastRewinds];
    if(!([lsm isEmpty])) {
        NSDate* first = [lsm head];
        if([first beforeNow] > _rewindRestorePeriod) {
            [_local setKey:@"lastRewinds" array:[[self lastRewinds] tail]];
            [__dayRewinds updateF:^id(id _) {
                return numi(unumi(_) + 1);
            }];
            [self checkLastRewinds];
        } else {
            __weak TRGameDirector* ws = self;
            delay([first beforeNow] + 1, ^void() {
                [ws checkLastRewinds];
            });
        }
    }
}

- (EGShareDialog*)shareDialog {
    NSString* url = @"http://get.raildale.com/?x=a";
    return [[[[EGShareContent applyText:[TRStr.Loc shareTextUrl:url] image:@"Share.jpg"] twitterText:[TRStr.Loc twitterTextUrl:url]] emailText:[TRStr.Loc shareTextUrl:url] subject:[TRStr.Loc shareSubject]] dialogShareHandler:^void(EGShareChannel* shareChannel) {
        [TestFlight passCheckpoint:[NSString stringWithFormat:@"share.%@", shareChannel.name]];
        if(shareChannel == EGShareChannel.facebook && [_cloud intForKey:@"share.facebook"] == 0) {
            [_cloud setKey:@"share.facebook" i:1];
            [self boughtRewindsCount:((NSUInteger)(_TRGameDirector_facebookShareRate))];
        } else {
            if(shareChannel == EGShareChannel.twitter && [_cloud intForKey:@"share.twitter"] == 0) {
                [_cloud setKey:@"share.twitter" i:1];
                [self boughtRewindsCount:((NSUInteger)(_TRGameDirector_twitterShareRate))];
            }
        }
        [_TRGameDirector_shareNotification postSender:self data:shareChannel];
        [self closeRewindShop];
    } cancelHandler:^void() {
    }];
}

- (void)buyRewindsProduct:(EGInAppProduct*)product {
    [product buy];
}

- (void)boughtRewindsCount:(NSUInteger)count {
    [__boughtRewinds updateF:^id(id _) {
        return numi(unumi(_) + count);
    }];
    [_local synchronize];
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

- (NSArray*)rewindPrices {
    return __rewindPrices;
}

- (void)forLevelF:(void(^)(TRLevel*))f {
    TRLevel* _ = [ODObject asKindOfClass:[TRLevel class] object:((EGScene*)(nonnil([[EGDirector current] scene]))).controller];
    if(_ != nil) f(_);
}

- (void)closeShop {
    [self forLevelF:^void(TRLevel* level) {
        if(level.rewindShop == 1) {
            level.rewindShop = 0;
            [[EGDirector current] resume];
        } else {
            if(level.rewindShop == 2) {
                level.rewindShop = 0;
                [[EGDirector current] redraw];
            }
        }
    }];
}

- (void)loadProducts {
    [EGInApp loadProductsIds:[[[_rewindsInApp chain] map:^NSString*(CNTuple* _) {
        return ((CNTuple*)(_)).a;
    }] toArray] callback:^void(NSArray* products) {
        __rewindPrices = [[[[[[products chain] sortBy] ascBy:^NSString*(EGInAppProduct* _) {
            return ((EGInAppProduct*)(_)).id;
        }] endSort] map:^CNTuple*(EGInAppProduct* product) {
            return tuple(((CNTuple*)(nonnil([_rewindsInApp findWhere:^BOOL(CNTuple* _) {
                return [((CNTuple*)(_)).a isEqual:((EGInAppProduct*)(product)).id];
            }]))).b, product);
        }] toArray];
        [[EGDirector current] redraw];
    } onError:^void(NSString* _) {
        [EGAlert showErrorTitle:[TRStr.Loc error] message:_];
    }];
}

- (void)openShop {
    [self forLevelF:^void(TRLevel* level) {
        [TestFlight passCheckpoint:@"Shop from pause"];
        [self loadProducts];
        level.rewindShop = 2;
        [[EGDirector current] redraw];
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

+ (CNNotificationHandle*)shareNotification {
    return _TRGameDirector_shareNotification;
}

+ (ODClassType*)type {
    return _TRGameDirector_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


