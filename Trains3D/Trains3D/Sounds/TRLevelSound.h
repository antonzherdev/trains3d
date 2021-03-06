#import "objd.h"
#import "PGSoundPlayer.h"
#import "TRCity.h"
@class TRTreeSound;
@class PGSound;
@class TRLevel;
@class TRTrainsDynamicWorld;
@class TRRailroadBuilder;
@class TRSwitchProcessor;
@class TRRailroad;
@class TRTrain;
@class CNSignal;
@class PGParSound;
@class CNObserver;

@class TRLevelSound;
@class TRCollisionSound;

@interface TRLevelSound : PGSoundPlayersCollection {
@public
    TRLevel* _level;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)levelSoundWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRCollisionSound : PGSoundPlayer_impl {
@public
    NSString* _name;
    CNSignal* _signal;
    float _impulseK;
    float _volume;
    PGParSound* _sound;
    CNObserver* _obs;
}
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) CNSignal* signal;
@property (nonatomic, readonly) float impulseK;
@property (nonatomic, readonly) float volume;
@property (nonatomic, readonly) PGParSound* sound;

+ (instancetype)collisionSoundWithName:(NSString*)name signal:(CNSignal*)signal impulseK:(float)impulseK volume:(float)volume;
- (instancetype)initWithName:(NSString*)name signal:(CNSignal*)signal impulseK:(float)impulseK volume:(float)volume;
- (CNClassType*)type;
- (void)start;
- (void)stop;
- (NSString*)description;
+ (CNClassType*)type;
@end


