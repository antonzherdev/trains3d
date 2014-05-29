#import <GameKit/GameKit.h>
#import "objd.h"

@class EGGameCenter;
@class EGAchievement;
@class GKAchievement;
@class EGLocalPlayerScore;

@interface EGGameCenter : NSObject <GKGameCenterControllerDelegate>
+ (id)gameCenter;
- (id)init;
- (CNClassType*)type;
- (void)authenticate;
- (id)achievementName:(NSString*)name;
+ (EGGameCenter *)instance;

- (void)completeAchievementName:(NSString *)name;
- (void)clearAchievements;

+ (CNClassType*)type;

- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value;

+ (BOOL)isSupported;

- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value completed :(void (^)(EGLocalPlayerScore*))completed;

- (void)localPlayerScoreLeaderboard:(NSString *)leaderboard callback:(void (^)(id))callback;

- (void)showLeaderboardName:(NSString *)name;
@end



@interface EGAchievement : NSObject
@property (nonatomic, readonly) NSString* name;

- (instancetype)initWithAchievementDescription:(GKAchievementDescription *)description chievement:(GKAchievement *)achievement;

+ (instancetype)initWithAchievementDescription:(GKAchievementDescription *)description achievementWithAchievement:(GKAchievement *)achievement;

- (void)complete;
- (CNClassType*)type;
- (CGFloat)progress;
- (void)setProgress:(CGFloat)progress;
+ (CNClassType*)type;
@end
