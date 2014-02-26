#import "objd.h"
#import "EGSound.h"
@class TRTreeSound;
@class SDSound;
@class TRLevel;
@class TRTrainsDynamicWorld;
@class TRRailroadBuilderProcessor;
@class TRSwitchProcessor;
@class TRSwitch;
@class TRRailLight;
@class TRRailroadBuilder;
@class TRTrain;

@class TRLevelSound;
@class TRCollisionSound;

@interface TRLevelSound : EGSoundPlayersCollection
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)levelSoundWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRCollisionSound : NSObject<EGSoundPlayer>
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) CNNotificationHandle* notificationHandle;
@property (nonatomic, readonly) float impulseK;
@property (nonatomic, readonly) float volume;
@property (nonatomic, readonly) EGSoundParallel* sound;

+ (instancetype)collisionSoundWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle impulseK:(float)impulseK volume:(float)volume;
- (instancetype)initWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle impulseK:(float)impulseK volume:(float)volume;
- (ODClassType*)type;
- (void)start;
- (void)stop;
+ (ODClassType*)type;
@end


