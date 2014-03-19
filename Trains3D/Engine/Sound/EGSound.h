#import "objd.h"
#import "EGScene.h"
@class SDSimpleSound;
@class SDSound;

@class EGBackgroundSoundPlayer;
@class EGSoundPlayersCollection;
@class EGSporadicSoundPlayer;
@class EGNotificationSoundPlayer;
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
    SDSimpleSound* _sound;
}
@property (nonatomic, readonly) SDSimpleSound* sound;

+ (instancetype)backgroundSoundPlayerWithSound:(SDSimpleSound*)sound;
- (instancetype)initWithSound:(SDSimpleSound*)sound;
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


