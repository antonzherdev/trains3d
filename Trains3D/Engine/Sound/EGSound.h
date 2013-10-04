#import "objd.h"
#import "EGScene.h"
@class SDSound;

@class EGBackgroundSoundPlayer;
@class EGSoundPlayersCollection;
@class EGSporadicSoundPlayer;
@protocol EGSoundPlayer;

@protocol EGSoundPlayer<EGController>
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
@end


@interface EGBackgroundSoundPlayer : NSObject<EGSoundPlayer>
@property (nonatomic, readonly) SDSound* sound;

+ (id)backgroundSoundPlayerWithSound:(SDSound*)sound;
- (id)initWithSound:(SDSound*)sound;
- (ODClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
+ (ODClassType*)type;
@end


@interface EGSoundPlayersCollection : NSObject<EGSoundPlayer>
@property (nonatomic, readonly) id<CNSeq> players;

+ (id)soundPlayersCollectionWithPlayers:(id<CNSeq>)players;
- (id)initWithPlayers:(id<CNSeq>)players;
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

+ (id)sporadicSoundPlayerWithSound:(SDSound*)sound secondsBetween:(CGFloat)secondsBetween;
- (id)initWithSound:(SDSound*)sound secondsBetween:(CGFloat)secondsBetween;
- (ODClassType*)type;
- (void)start;
- (void)stop;
- (void)pause;
- (void)resume;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


