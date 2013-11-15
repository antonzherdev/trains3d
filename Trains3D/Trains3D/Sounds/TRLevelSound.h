#import "objd.h"
#import "EGSound.h"
@class TRTreeSound;
@class TRTrainSound;
@class TRTrainsDynamicWorld;
@class SDSound;
@class TRLevel;
@class TRRailroadBuilder;
@class TRSwitch;
@class TRRailLight;

@class TRLevelSound;
@class TRCollisionSound;

@interface TRLevelSound : EGSoundPlayersCollection
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelSoundWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRCollisionSound : NSObject<EGSoundPlayer>
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) CNNotificationHandle* notificationHandle;
@property (nonatomic, readonly) SDSound* sound;

+ (id)collisionSoundWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle;
- (id)initWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle;
- (ODClassType*)type;
- (void)start;
- (void)stop;
+ (ODClassType*)type;
@end


