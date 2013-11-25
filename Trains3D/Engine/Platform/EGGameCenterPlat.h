#import "objd.h"

@class EGGameCenter;
@class EGAchievement;
@class GKAchievement;
@class EGLocalPlayerScore;

@interface EGGameCenter : NSObject
+ (id)gameCenter;
- (id)init;
- (ODClassType*)type;
- (void)authenticate;
- (id)achievementName:(NSString*)name;
+ (EGGameCenter *)instance;

- (void)completeAchievementName:(NSString *)name;

+ (ODClassType*)type;

- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value;
- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value completed :(void (^)(void))completed;

- (void)localPlayerScoreLeaderboard:(NSString *)leaderboard callback:(void (^)(EGLocalPlayerScore*))callback;
@end



@interface EGAchievement : NSObject
@property (nonatomic, readonly) NSString* name;

- (instancetype)initWithAchievement:(GKAchievement *)achievement;
+ (instancetype)achievementWithAchievement:(GKAchievement *)achievement;

- (void)complete;
- (ODClassType*)type;
- (CGFloat)progress;
- (void)setProgress:(CGFloat)progress;
+ (ODClassType*)type;
@end
