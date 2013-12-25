#import "TRGameDirector.h"

#import "DTKeyValueStorage.h"
#import "DTConflictResolve.h"
#import "TRLevel.h"
#import "TRScore.h"
#import "EGGameCenterPlat.h"
#import "TRStrings.h"
#import "EGSchedule.h"
#import "TRTrain.h"
#import "EGCameraIso.h"
#import "EGDirector.h"
#import "EGScene.h"
#import "EGRate.h"
#import "EGGameCenter.h"
#import "TRSceneFactory.h"
#import "TRLevelChooseMenu.h"
#import "TRLevelFactory.h"
#import "EGEMail.h"
@implementation TRGameDirector{
    DTLocalKeyValueStorage* _local;
    id(^_resolveMaxLevel)(id, id);
    DTCloudKeyValueStorage* _cloud;
    CNNotificationObserver* _obs;
    CNNotificationObserver* _sporadicDamageHelpObs;
    CNNotificationObserver* _damageHelpObs;
    CNNotificationObserver* _repairerHelpObs;
    CNNotificationObserver* _crazyHelpObs;
    CNNotificationObserver* _zoomHelpObs;
    CNNotificationObserver* _crashObs;
    CNNotificationObserver* _knockDownObs;
}
static TRGameDirector* _TRGameDirector_instance;
static CNNotificationHandle* _TRGameDirector_playerScoreRetrieveNotification;
static ODClassType* _TRGameDirector_type;
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
        _local = [DTLocalKeyValueStorage localKeyValueStorageWithDefaults:(@{@"currentLevel" : @1})];
        _resolveMaxLevel = ^id(id a, id b) {
            id v = DTConflict.resolveMax(a, b);
            [CNLog applyText:[NSString stringWithFormat:@"Max level from cloud %@ = max(%@, %@)", v, a, b]];
            if([_weakSelf currentLevel] == unumi(a)) {
                [CNLog applyText:[NSString stringWithFormat:@"Update current level with %@ from cloud", v]];
                [_weakSelf.local setKey:@"currentLevel" value:v];
            }
            return v;
        };
        _cloud = [DTCloudKeyValueStorage cloudKeyValueStorageWithDefaults:(@{@"maxLevel" : @1}) resolveConflict:^id(NSString* name) {
            if([name isEqual:@"maxLevel"]) return _weakSelf.resolveMaxLevel;
            else return DTConflict.resolveMax;
        }];
        _obs = [TRLevel.winNotification observeBy:^void(TRLevel* level, id _) {
            NSUInteger n = ((TRLevel*)(level)).number;
            [_weakSelf.cloud keepMaxKey:@"maxLevel" i:((NSInteger)(n + 1))];
            [_weakSelf.local setKey:@"currentLevel" i:((NSInteger)(n + 1))];
            NSString* leaderboard = [NSString stringWithFormat:@"grp.com.antonzherdev.Trains3D.Level%lu", (unsigned long)n];
            NSInteger s = [((TRLevel*)(level)).score score];
            [_weakSelf.cloud keepMaxKey:[NSString stringWithFormat:@"level%lu.score", (unsigned long)n] i:[((TRLevel*)(level)).score score]];
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
        _crazyHelpObs = [TRLevelFactory.lineAdviceTimeNotification observeBy:^void(id _, TRLevel* level) {
            if([_weakSelf.cloud intForKey:@"help.linesAdvice"] == 0) {
                [((TRLevel*)(level)) showHelpText:[TRStr.Loc linesAdvice]];
                [_weakSelf.cloud setKey:@"help.linesAdvice" i:1];
            }
        }];
        _zoomHelpObs = [EGCameraIsoMove.cameraChangedNotification observeBy:^void(EGCameraIsoMove* move, id _) {
            if([_weakSelf.cloud intForKey:@"help.zoom"] == 0 && [((EGCameraIsoMove*)(move)) scale] > 1) {
                [((TRLevel*)(((EGScene*)([[[EGDirector current] scene] get])).controller)) showHelpText:[TRStr.Loc helpInZoom]];
                [_weakSelf.cloud setKey:@"help.zoom" i:1];
            }
        }];
        _crashObs = [TRLevel.crashNotification observeBy:^void(TRLevel* level, id<CNSeq> trains) {
            [TRGameDirector.instance destroyTrainsTrains:trains];
        }];
        _knockDownObs = [TRLevel.knockDownNotification observeBy:^void(TRLevel* level, CNTuple* p) {
            [TRGameDirector.instance destroyTrainsTrains:(@[((CNTuple*)(p)).a])];
            if(unumi(((CNTuple*)(p)).b) == 2) {
                [EGGameCenter.instance completeAchievementName:@"grp.KnockDown"];
            } else {
                if(unumi(((CNTuple*)(p)).b) == 3) {
                    [EGGameCenter.instance completeAchievementName:@"grp.TripleCrash"];
                } else {
                    if(unumi(((CNTuple*)(p)).b) == 4) {
                        [EGGameCenter.instance completeAchievementName:@"grp.QuadrupleCrash"];
                    } else {
                        if(unumi(((CNTuple*)(p)).b) == 5) {
                            [EGGameCenter.instance completeAchievementName:@"grp.QuinaryCrash"];
                        } else {
                            if(unumi(((CNTuple*)(p)).b) == 6) [EGGameCenter.instance completeAchievementName:@"grp.SenaryCrash"];
                        }
                    }
                }
            }
        }];
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
}

- (NSInteger)bestScoreLevelNumber:(NSUInteger)levelNumber {
    return [_cloud intForKey:[NSString stringWithFormat:@"level%lu.score", (unsigned long)levelNumber]];
}

- (void)destroyTrainsTrains:(id<CNSeq>)trains {
    [EGGameCenter.instance completeAchievementName:@"grp.Crash"];
    if([trains existsWhere:^BOOL(TRTrain* _) {
    return ((TRTrain*)(_)).trainType == TRTrainType.fast;
}]) [EGGameCenter.instance completeAchievementName:@"grp.ExpressCrash"];
    if([trains existsWhere:^BOOL(TRTrain* _) {
    return ((TRTrain*)(_)).trainType == TRTrainType.repairer;
}]) [EGGameCenter.instance completeAchievementName:@"grp.RepairCrash"];
    if([trains existsWhere:^BOOL(TRTrain* _) {
    return ((TRTrain*)(_)).trainType == TRTrainType.crazy;
}]) [EGGameCenter.instance completeAchievementName:@"grp.CrazyCrash"];
}

- (void)_init {
    [EGRate.instance setIdsIos:736579117 osx:736545415];
    [EGGameCenter.instance authenticate];
}

- (void)localPlayerScoreLevel:(NSUInteger)level callback:(void(^)(id))callback {
    NSString* leaderboard = [NSString stringWithFormat:@"grp.com.antonzherdev.Trains3D.Level%lu", (unsigned long)level];
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
    return [_cloud intForKey:@"maxLevel"];
}

- (void)restoreLastScene {
    [[EGDirector current] setScene:^EGScene*() {
        return [TRSceneFactory sceneForLevelWithNumber:((NSUInteger)([self currentLevel]))];
    }];
}

- (void)restartLevel {
    [[ODObject asKindOfClass:[TRLevel class] object:((EGScene*)([[[EGDirector current] scene] get])).controller] forEach:^void(TRLevel* level) {
        if(((TRLevel*)(level)).number == 16 && [self isNeedRate]) {
            ((TRLevel*)(level)).rate = YES;
            [[EGDirector current] redraw];
        } else {
            [self setLevel:((NSInteger)(((TRLevel*)(level)).number))];
            [[EGDirector current] resume];
        }
    }];
}

- (void)chooseLevel {
    [[EGDirector current] setScene:^EGScene*() {
        return [TRLevelChooseMenu scene];
    }];
    [[EGDirector current] pause];
}

- (void)nextLevel {
    [[ODObject asKindOfClass:[TRLevel class] object:((EGScene*)([[[EGDirector current] scene] get])).controller] forEach:^void(TRLevel* level) {
        if([self isNeedRate]) {
            ((TRLevel*)(level)).rate = YES;
            [[EGDirector current] redraw];
        } else {
            [self setLevel:((NSInteger)(((TRLevel*)(level)).number + 1))];
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
        [_local setKey:@"currentLevel" i:level];
        [[EGDirector current] setScene:^EGScene*() {
            return [TRSceneFactory sceneForLevel:[TRLevelFactory levelWithNumber:((NSUInteger)(level))]];
        }];
    }
}

- (void)showLeaderboardLevel:(TRLevel*)level {
    [EGGameCenter.instance showLeaderboardName:[NSString stringWithFormat:@"grp.com.antonzherdev.Trains3D.Level%lu", (unsigned long)level.number]];
}

- (void)synchronize {
    [_local synchronize];
    [_cloud synchronize];
}

- (void)showSupportChangeLevel:(BOOL)changeLevel {
    NSString* text = [@"\n"
        "\n"
        "> " stringByAppendingString:[[TRStr.Loc supportEmailText] replaceOccurrences:@"\n" withString:@"\n"
        "> "]];
    NSString* htmlText = [[text replaceOccurrences:@">" withString:@"&gt;"] replaceOccurrences:@"\n" withString:@"<br/>\n"];
    [[ODObject asKindOfClass:[TRLevel class] object:((EGScene*)([[[EGDirector current] scene] get])).controller] forEach:^void(TRLevel* level) {
        [EGEMail.instance showInterfaceTo:@"support@raildale.com" subject:[NSString stringWithFormat:@"Raildale - %lu", (unsigned long)oduIntRnd()] text:text htmlText:[NSString stringWithFormat:@"<small><i>%@</i></small>", htmlText]];
        if(changeLevel) [self setLevel:((NSInteger)(((TRLevel*)(level)).number + 1))];
    }];
}

- (BOOL)isNeedRate {
    return [self maxAvailableLevel] > 6 && [EGRate.instance shouldShowEveryVersion:YES];
}

- (void)showRate {
    [[ODObject asKindOfClass:[TRLevel class] object:((EGScene*)([[[EGDirector current] scene] get])).controller] forEach:^void(TRLevel* level) {
        [EGRate.instance showRate];
        [self setLevel:((NSInteger)(((TRLevel*)(level)).number + 1))];
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


