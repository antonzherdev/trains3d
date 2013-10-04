#import "objd.h"
#import "EGSound.h"
#import "GEVec.h"
@class SDSound;
@class TRForest;
@class TRWeather;

@class TRTreeSound;
@class TRWindSound;

@interface TRTreeSound : EGSoundPlayersCollection
@property (nonatomic, readonly) TRForest* forest;

+ (id)treeSoundWithForest:(TRForest*)forest;
- (id)initWithForest:(TRForest*)forest;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRWindSound : EGBackgroundSoundPlayer
@property (nonatomic, readonly) TRForest* forest;

+ (id)windSoundWithForest:(TRForest*)forest;
- (id)initWithForest:(TRForest*)forest;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


