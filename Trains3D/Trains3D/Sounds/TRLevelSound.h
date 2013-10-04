#import "objd.h"
#import "EGSound.h"
@class TRLevel;
@class TRTreeSound;

@class TRLevelSound;

@interface TRLevelSound : EGSoundPlayersCollection
@property (nonatomic, readonly) TRLevel* level;

+ (id)levelSoundWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


