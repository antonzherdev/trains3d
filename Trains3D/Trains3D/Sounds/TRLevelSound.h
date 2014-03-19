#import "objd.h"
#import "EGSound.h"
@class TRTreeSound;
@class SDSound;
@class TRLevel;
@class TRTrainsDynamicWorld;
@class TRRailroadBuilder;
@class TRSwitchProcessor;
@class TRRailroad;
@class TRTrain;
@class SDParSound;

@class TRLevelSound;
@class TRCollisionSound;

@interface TRLevelSound : EGSoundPlayersCollection {
@private
    TRLevel* _level;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)levelSoundWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRCollisionSound : NSObject<EGSoundPlayer> {
@private
    NSString* _name;
    CNNotificationHandle* _notificationHandle;
    float _impulseK;
    float _volume;
    SDParSound* _sound;
    id _obs;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) CNNotificationHandle* notificationHandle;
@property (nonatomic, readonly) float impulseK;
@property (nonatomic, readonly) float volume;
@property (nonatomic, readonly) SDParSound* sound;

+ (instancetype)collisionSoundWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle impulseK:(float)impulseK volume:(float)volume;
- (instancetype)initWithName:(NSString*)name notificationHandle:(CNNotificationHandle*)notificationHandle impulseK:(float)impulseK volume:(float)volume;
- (ODClassType*)type;
- (void)start;
- (void)stop;
+ (ODClassType*)type;
@end


