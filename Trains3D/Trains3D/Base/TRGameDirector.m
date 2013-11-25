#import "TRGameDirector.h"

#import "DTKeyValueStorage.h"
#import "DTConflictResolve.h"
#import "TRLevel.h"
#import "EGGameCenterPlat.h"
#import "TRScore.h"
#import "EGDirector.h"
#import "TRSceneFactory.h"
#import "EGScene.h"
#import "TRLevelChooseMenu.h"
#import "TRLevelFactory.h"
@implementation TRGameDirector{
    DTLocalKeyValueStorage* _local;
    id(^_resolveMaxLevel)(id, id);
    DTCloudKeyValueStorage* _cloud;
    CNNotificationObserver* _obs;
    CNNotificationObserver* _crashObs;
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
        _obs = [TRLevel.winNotification observeBy:^void(TRLevel* level) {
            NSUInteger n = ((TRLevel*)(level)).number;
            [_weakSelf.cloud keepMaxKey:@"maxLevel" i:((NSInteger)(n + 1))];
            [_weakSelf.local setKey:@"currentLevel" i:((NSInteger)(n + 1))];
            NSString* leaderboard = [NSString stringWithFormat:@"grp.com.antonzherdev.Trains3D.Level%lu", (unsigned long)n];
            [EGGameCenter.instance reportScoreLeaderboard:leaderboard value:((long)([((TRLevel*)(level)).score score])) completed:^void() {
                [EGGameCenter.instance localPlayerScoreLeaderboard:leaderboard callback:^void(EGLocalPlayerScore* _) {
                    [[TRGameDirector playerScoreRetrieveNotification] postData:_];
                }];
            }];
            [_weakSelf.cloud keepMaxKey:[NSString stringWithFormat:@"level%lu.score", (unsigned long)n] i:[((TRLevel*)(level)).score score]];
        }];
        _crashObs = [TRLevel.crashNotification observeBy:^void(id _) {
            [EGGameCenter.instance completeAchievementName:@"grp.Crash"];
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

- (void)_init {
    [EGGameCenter.instance authenticate];
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
        [self setLevel:((NSInteger)(((TRLevel*)(level)).number))];
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
        [self setLevel:((NSInteger)(((TRLevel*)(level)).number + 1))];
    }];
}

- (void)setLevel:(NSInteger)level {
    if(level <= [self maxAvailableLevel]) {
        [_local setKey:@"currentLevel" i:level];
        [[EGDirector current] setScene:^EGScene*() {
            return [TRSceneFactory sceneForLevel:[TRLevelFactory levelWithNumber:((NSUInteger)(level))]];
        }];
        [[EGDirector current] resume];
    }
}

- (void)synchronize {
    [_local synchronize];
    [_cloud synchronize];
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


