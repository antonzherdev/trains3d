#import "objd.h"
#import "EGScene.h"
@class SDSimpleSound;
@class SDSound;
@class ATSignal;
@class ATObserver;

@class EGBackgroundSoundPlayer;
@class EGSoundPlayersCollection;
@class EGSporadicSoundPlayer;
@class EGNotificationSoundPlayer;
@class EGSignalSoundPlayer;
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
    NSArray* _players;
}
@property (nonatomic, readonly) NSArray* players;

+ (instancetype)soundPlayersCollectionWithPlayers:(NSArray*)players;
- (instancetype)initWithPlayers:(NSArray*)players;
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
    CNNotificationObserver* _obs;
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


@interface EGSignalSoundPlayer : NSObject<EGSoundPlayer> {
@private
    SDSound* _sound;
    ATSignal* _signal;
    BOOL(^_condition)(id);
    ATObserver* _obs;
}
@property (nonatomic, readonly) SDSound* sound;
@property (nonatomic, readonly) ATSignal* signal;
@property (nonatomic, readonly) BOOL(^condition)(id);

+ (instancetype)signalSoundPlayerWithSound:(SDSound*)sound signal:(ATSignal*)signal condition:(BOOL(^)(id))condition;
- (instancetype)initWithSound:(SDSound*)sound signal:(ATSignal*)signal condition:(BOOL(^)(id))condition;
- (ODClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
+ (EGSignalSoundPlayer*)applySound:(SDSound*)sound signal:(ATSignal*)signal;
+ (ODClassType*)type;
@end


