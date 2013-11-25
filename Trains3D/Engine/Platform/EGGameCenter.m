#import <GameKit/GameKit.h>
#import "EGGameCenter.h"
#import "EGDirector.h"

@implementation EGGameCenter {
    BOOL _paused;
    BOOL _active;
}
static EGGameCenter* _EGGameCenter_instance;
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
                _active = YES;
            }
            else {
                [weakSelf disableGameCenter];
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
}

-(void)disableGameCenter {

}

- (id)achievementName:(NSString*)name {
    if(!_active) return [CNOption none];
    GKAchievement *ach = [[GKAchievement alloc] initWithIdentifier:name];
    if(ach == nil) {
        NSLog(@"Could not find achievement with name %@", name);
        return [CNOption none];
    }
    ach.showsCompletionBanner = YES;
    return [CNOption someValue:[EGAchievement achievementWithAchievement:ach]];
}


- (ODClassType*)type {
    return [EGGameCenter type];
}

+ (EGGameCenter*)instance {
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
    if(!_active) return;
    GKScore *scoreReporter = [[GKScore alloc] initWithCategory:leaderboard];
    scoreReporter.value = value;
    scoreReporter.context = 0;

    [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
        if(error != nil) NSLog(@"Error while writing leaderboard %@", error);
    }];
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
    _achievement.percentComplete = progress*100.0;
    [GKAchievement reportAchievements:@[_achievement] withCompletionHandler:^(NSError *error) {
        if(error != nil) {
            NSLog(@"Error in achievenment reporting: %@", error);
        }
    }];
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
