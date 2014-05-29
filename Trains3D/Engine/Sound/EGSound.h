#import "objd.h"
#import "EGController.h"
@class SDSimpleSound;
@class SDSound;
@protocol CNObservableBase;
@class CNObserver;

@class EGSoundPlayer_impl;
@class EGBackgroundSoundPlayer;
@class EGSoundPlayersCollection;
@class EGSporadicSoundPlayer;
@class EGSignalSoundPlayer;
@protocol EGSoundPlayer;

@protocol EGSoundPlayer<EGUpdatable>
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
@end


@interface EGSoundPlayer_impl : EGUpdatable_impl<EGSoundPlayer>
+ (instancetype)soundPlayer_impl;
- (instancetype)init;
- (void)updateWithDelta:(CGFloat)delta;
@end


@interface EGBackgroundSoundPlayer : EGSoundPlayer_impl {
@protected
    SDSimpleSound* _sound;
}
@property (nonatomic, readonly) SDSimpleSound* sound;

+ (instancetype)backgroundSoundPlayerWithSound:(SDSimpleSound*)sound;
- (instancetype)initWithSound:(SDSimpleSound*)sound;
- (CNClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGSoundPlayersCollection : EGSoundPlayer_impl {
@protected
    NSArray* _players;
}
@property (nonatomic, readonly) NSArray* players;

+ (instancetype)soundPlayersCollectionWithPlayers:(NSArray*)players;
- (instancetype)initWithPlayers:(NSArray*)players;
- (CNClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGSporadicSoundPlayer : EGSoundPlayer_impl {
@protected
    SDSound* _sound;
    CGFloat _secondsBetween;
    CGFloat __timeToNextPlaying;
    BOOL _wasPlaying;
}
@property (nonatomic, readonly) SDSound* sound;
@property (nonatomic, readonly) CGFloat secondsBetween;

+ (instancetype)sporadicSoundPlayerWithSound:(SDSound*)sound secondsBetween:(CGFloat)secondsBetween;
- (instancetype)initWithSound:(SDSound*)sound secondsBetween:(CGFloat)secondsBetween;
- (CNClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGSignalSoundPlayer : EGSoundPlayer_impl {
@protected
    SDSound* _sound;
    id<CNObservableBase> _signal;
    BOOL(^_condition)(id);
    CNObserver* _obs;
}
@property (nonatomic, readonly) SDSound* sound;
@property (nonatomic, readonly) id<CNObservableBase> signal;
@property (nonatomic, readonly) BOOL(^condition)(id);

+ (instancetype)signalSoundPlayerWithSound:(SDSound*)sound signal:(id<CNObservableBase>)signal condition:(BOOL(^)(id))condition;
- (instancetype)initWithSound:(SDSound*)sound signal:(id<CNObservableBase>)signal condition:(BOOL(^)(id))condition;
- (CNClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
+ (EGSignalSoundPlayer*)applySound:(SDSound*)sound signal:(id<CNObservableBase>)signal;
- (NSString*)description;
+ (CNClassType*)type;
@end


