#import <GameKit/GameKit.h>
#import "EGGameCenterPlat.h"
#import "EGDirector.h"
#import "EGGameCenter.h"

@implementation EGGameCenter {
    BOOL _paused;
    BOOL _active;
    NSMutableDictionary* _achievements;
}
static EGGameCenter * _EGGameCenter_instance;
static ODClassType* _EGGameCenter_type;

+ (id)gameCenter {
    return [[EGGameCenter alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _paused = NO;
        _active = NO;
    }
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGGameCenter_type = [ODClassType classTypeWithCls:[EGGameCenter class]];
    _EGGameCenter_instance = [EGGameCenter gameCenter];
}

- (void)authenticate {
    __weak typeof(self) weakSelf = self; // removes retain cycle error

    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer]; // localPlayer is the public GKLocalPlayer
    __weak GKLocalPlayer *weakPlayer = localPlayer; // removes retain cycle error


    weakPlayer.authenticateHandler =
#if TARGET_OS_IPHONE
    ^(UIViewController *viewController, NSError *error)
#else
    ^(NSViewController *viewController, NSError *error)
#endif
     {
        if (viewController != nil) {
            if(![[EGDirector current] isPaused]) {
                _paused = YES;
                [[EGDirector current] pause];
            }
            [weakSelf showAuthenticationDialogWhenReasonable:viewController];
        } else {
            if (weakPlayer.isAuthenticated) {
                [weakSelf authenticatedPlayer:weakPlayer];
            }
            else {
                [weakSelf disableGameCenter];
                _active = NO;
            }
            if(_paused) {
                _paused = NO;
                [[EGDirector current] resume];
            }
        }
    };
}


#if TARGET_OS_IPHONE
-(void)showAuthenticationDialogWhenReasonable:(UIViewController *)controller {
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:controller animated:YES completion:nil];
}
#else
-(void)showAuthenticationDialogWhenReasonable:(NSViewController *)controller {
    [[GKDialogController sharedDialogController] presentViewController:(NSViewController <GKViewController> *) controller];

}
#endif

-(void)authenticatedPlayer:(GKLocalPlayer *)player{
    [GKAchievement loadAchievementsWithCompletionHandler:^(NSArray *achievements, NSError *error) {
        if (error != nil) {
            NSLog(@"Error while loading achievements: %@", error);
            return;
        }
        if (achievements != nil) {
            _active = YES;
            NSMutableDictionary * dic = [NSMutableDictionary dictionary];
            for(GKAchievement* a in achievements) {
                a.showsCompletionBanner = YES;
                [dic setObject:[EGAchievement achievementWithAchievement:a] forKey:a.identifier];
            }
            _achievements = dic;
        }
    }];
}

-(void)disableGameCenter {

}

- (id)achievementName:(NSString*)name {
    if(!_active) return [CNOption none];

    return [CNOption someValue:[_achievements objectForKey:name orUpdateWith:^id {
        GKAchievement *a = [[GKAchievement alloc] initWithIdentifier:name];
        a.showsCompletionBanner = YES;
        return [EGAchievement achievementWithAchievement:a];
    }]];
}


- (ODClassType*)type {
    return [EGGameCenter type];
}

+ (EGGameCenter *)instance {
    return _EGGameCenter_instance;
}

+ (ODClassType*)type {
    return _EGGameCenter_type;
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

- (void)completeAchievementName:(NSString *)name {
    [((CNOption *) [self achievementName:name]) forEach:^(EGAchievement * a) {
        [a complete];
    }];
}

- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value {
    [self reportScoreLeaderboard:leaderboard value:value completed:nil];
}

- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value completed :(void (^)(EGLocalPlayerScore*))completed {
    if(!_active) return;
#if TARGET_OS_IPHONE
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboard];
    scoreReporter.value = value;
    scoreReporter.context = 0;
    NSArray *scores = @[scoreReporter];
    [GKScore reportScores:scores withCompletionHandler:^(NSError *error) {
        if(error != nil) NSLog(@"Error while writing leaderboard %@", error);
        if(completed != nil) [self retrieveLocalPlayerScoreLeaderboard: leaderboard minValue : [NSNumber numberWithLong:value] callback:^(id o) {
                if([o isEmpty]) {
                    NSLog(@"Error while retrurning written value to leaderboard");
                    return;
                }
                completed([o get]);
            } attems:0];
    }];
#else
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:leaderboard];

    scoreReporter.value = value;
    scoreReporter.context = 0;

    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if(error != nil) NSLog(@"Error while writing leaderboard %@", error);
        if(completed != nil) [self retrieveLocalPlayerScoreLeaderboard: leaderboard minValue : [NSNumber numberWithLong:value] callback:^(id o) {
                if([o isEmpty]) {
                    NSLog(@"Error while retrurning written value to leaderboard");
                    return;
                }
                completed([o get]);
            } attems:0];
    }];
#endif
}

- (void)retrieveLocalPlayerScoreLeaderboard:(NSString *)leaderboard minValue:(NSNumber *)value callback:(void (^)(id))callback attems:(int)attems {
    GKLeaderboard *leaderboardRequest = [[GKLeaderboard alloc] init];
    leaderboardRequest.timeScope = GKLeaderboardTimeScopeAllTime;
    leaderboardRequest.playerScope = GKLeaderboardPlayerScopeGlobal;
#if TARGET_OS_IPHONE
    leaderboardRequest.identifier = leaderboard;
#else
    leaderboardRequest.category = leaderboard;
#endif
    leaderboardRequest.range = NSMakeRange(1, 1);
    [leaderboardRequest loadScoresWithCompletionHandler:^(NSArray *scores, NSError *error) {
        if(error != nil) {
            NSLog(@"Error while loading scores %@", error);
            return;
        }
        GKScore *s = leaderboardRequest.localPlayerScore;
        if(s.rank == 0 && value == nil) {
            callback([CNOption none]);

        } else if(s.rank != 0 && (value == nil || s.value >= value.longValue)) {
            EGLocalPlayerScore *lps = [EGLocalPlayerScore localPlayerScoreWithValue:(long) s.value
                                                                               rank:(NSUInteger) s.rank
                                                                            maxRank:leaderboardRequest.maxRange];
            callback([CNOption someValue:lps]);
        } else {
            if(attems > 10) {
                NSLog(@"Could not write retrieve new information from Game Center during a timeout.");
            } else {
                delay(0.5, ^{
                    [self retrieveLocalPlayerScoreLeaderboard:leaderboard minValue:value callback:callback attems:attems + 1];
                });
            }
        }
    }];
}

- (void)localPlayerScoreLeaderboard:(NSString *)leaderboard callback:(void (^)(id))callback {
    [self retrieveLocalPlayerScoreLeaderboard:leaderboard minValue:nil callback:callback attems:0];
}

- (void)showLeaderboardName:(NSString *)name {
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
#if TARGET_OS_IPHONE
        gameCenterController.leaderboardIdentifier = name;
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController]
            presentViewController:gameCenterController animated:YES completion:nil];
#else
        gameCenterController.leaderboardCategory = name;
        GKDialogController *controller = [GKDialogController sharedDialogController];
        controller.parentWindow = [[NSApplication sharedApplication] mainWindow];
        [controller performSelectorOnMainThread:@selector(presentViewController:) withObject:gameCenterController waitUntilDone:NO];
#endif

    }

}

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
#if TARGET_OS_IPHONE
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];
#else
    GKDialogController *controller = [GKDialogController sharedDialogController];
    [controller performSelectorOnMainThread:@selector(dismiss:) withObject:self waitUntilDone:NO];
#endif
}

@end



@implementation EGAchievement{
    GKAchievement* _achievement;
}
static ODClassType* _EGAchievement_type;

- (instancetype)initWithAchievement:(GKAchievement *)achievement {
    self = [super init];
    if (self) {
        _achievement = achievement;
    }

    return self;
}

+ (instancetype)achievementWithAchievement:(GKAchievement *)achievement {
    return [[self alloc] initWithAchievement:achievement];
}


+ (void)initialize {
    [super initialize];
    _EGAchievement_type = [ODClassType classTypeWithCls:[EGAchievement class]];
}

- (NSString*) name {
    return _achievement.identifier;
}
- (CGFloat)progress {
    return (CGFloat) (_achievement.percentComplete/100.0);
}

- (void)setProgress:(CGFloat)progress {
    CGFloat d = progress*100.0;
    if(!eqf((CGFloat) _achievement.percentComplete, d)) {
        _achievement.percentComplete = d;
        [GKAchievement reportAchievements:@[_achievement] withCompletionHandler:^(NSError *error) {
            if(error != nil) {
                NSLog(@"Error in achievenment %@ reporting: %@", _achievement.identifier, error);
            } else {
                NSLog(@"The achievenment %@ has been reported", _achievement.identifier);
            }
        }];
    }
}

- (void)complete {
    [self setProgress:1.0];
}

- (ODClassType*)type {
    return [EGAchievement type];
}

+ (ODClassType*)type {
    return _EGAchievement_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGAchievement* o = ((EGAchievement*)(other));
    return [self.name isEqual:o.name];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.name hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"name=%@", self.name];
    [description appendString:@">"];
    return description;
}

@end
