#import "objd.h"

@class EGGameCenter;
@class EGAchievement;
@class GKAchievement;

@interface EGGameCenter : NSObject
+ (id)gameCenter;
- (id)init;
- (ODClassType*)type;
- (void)authenticate;
- (id)achievementName:(NSString*)name;
+ (EGGameCenter*)instance;

- (void)completeAchievementName:(NSString *)name;

+ (ODClassType*)type;

- (void)reportScoreLeaderboard:(NSString *)leaderboard value:(long)value;
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
