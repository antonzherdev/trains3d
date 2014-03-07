#import "objd.h"
#import "EGScene.h"
@class SDSound;

@class EGBackgroundSoundPlayer;
@class EGSoundPlayersCollection;
@class EGSporadicSoundPlayer;
@class EGNotificationSoundPlayer;
@class EGSoundParallel;
@protocol EGSoundPlayer;

@protocol EGSoundPlayer<EGUpdatable>
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
@end


@interface EGBackgroundSoundPlayer : NSObject<EGSoundPlayer>
@property (nonatomic, readonly) SDSound* sound;

+ (instancetype)backgroundSoundPlayerWithSound:(SDSound*)sound;
- (instancetype)initWithSound:(SDSound*)sound;
- (ODClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
+ (ODClassType*)type;
@end


@interface EGSoundPlayersCollection : NSObject<EGSoundPlayer>
@property (nonatomic, readonly) id<CNImSeq> players;

+ (instancetype)soundPlayersCollectionWithPlayers:(id<CNImSeq>)players;
- (instancetype)initWithPlayers:(id<CNImSeq>)players;
- (ODClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGSporadicSoundPlayer : NSObject<EGSoundPlayer>
@property (nonatomic, readonly) SDSound* sound;
@property (nonatomic, readonly) CGFloat secondsBetween;

+ (instancetype)sporadicSoundPlayerWithSound:(SDSound*)sound secondsBetween:(CGFloat)secondsBetween;
- (instancetype)initWithSound:(SDSound*)sound secondsBetween:(CGFloat)secondsBetween;
- (ODClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface EGNotificationSoundPlayer : NSObject<EGSoundPlayer>
@property (nonatomic, readonly) SDSound* sound;
@property (nonatomic, readonly) CNNotificationHandle* notificationHandle;
@property (nonatomic, readonly) BOOL(^condition)(id, id);

+ (instancetype)notificationSoundPlayerWithSound:(SDSound*)sound notificationHandle:(CNNotificationHandle*)notificationHandle condition:(BOOL(^)(id, id))condition;
- (instancetype)initWithSound:(SDSound*)sound notificationHandle:(CNNotificationHandle*)notificationHandle condition:(BOOL(^)(id, id))condition;
- (ODClassType*)type;
+ (EGNotificationSoundPlayer*)applySound:(SDSound*)sound notificationHandle:(CNNotificationHandle*)notificationHandle;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
+ (ODClassType*)type;
@end


@interface EGSoundParallel : NSObject
@property (nonatomic, readonly) NSInteger limit;
@property (nonatomic, readonly) SDSound*(^create)();

+ (instancetype)soundParallelWithLimit:(NSInteger)limit create:(SDSound*(^)())create;
- (instancetype)initWithLimit:(NSInteger)limit create:(SDSound*(^)())create;
- (ODClassType*)type;
- (void)play;
- (void)pause;
- (void)resume;
- (void)playWithVolume:(float)volume;
- (id)sound;
+ (ODClassType*)type;
@end


