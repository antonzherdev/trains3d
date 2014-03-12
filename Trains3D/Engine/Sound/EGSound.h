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


@interface EGBackgroundSoundPlayer : NSObject<EGSoundPlayer> {
@private
    SDSound* _sound;
}
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


@interface EGSoundPlayersCollection : NSObject<EGSoundPlayer> {
@private
    id<CNImSeq> _players;
}
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


@interface EGSporadicSoundPlayer : NSObject<EGSoundPlayer> {
@private
    SDSound* _sound;
    CGFloat _secondsBetween;
    CGFloat __timeToNextPlaying;
    BOOL _wasPlaying;
}
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


@interface EGNotificationSoundPlayer : NSObject<EGSoundPlayer> {
@private
    SDSound* _sound;
    CNNotificationHandle* _notificationHandle;
    BOOL(^_condition)(id, id);
    id _obs;
    BOOL _wasPlaying;
}
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


@interface EGSoundParallel : NSObject {
@private
    NSInteger _limit;
    SDSound*(^_create)();
    NSMutableArray* _sounds;
    id<CNImSeq> _paused;
}
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


