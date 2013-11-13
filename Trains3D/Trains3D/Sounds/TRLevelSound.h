#import "objd.h"
#import "EGSound.h"
@class TRTreeSound;
@class TRTrainSound;
@class SDSound;
@class TRLevel;
@class TRRailroadBuilder;
@class TRSwitch;
@class TRRailLight;

@class TRLevelSound;

@interface TRLevelSound : EGSoundPlayersCollection
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelSoundWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


