#import "objd.h"
#import "EGSound.h"
@class SDSound;
@class TRForest;

@class TRTreeSound;

@interface TRTreeSound : EGBackgroundSoundPlayer
@property (nonatomic, readonly) TRForest* forest;

+ (id)treeSoundWithForest:(TRForest*)forest;
- (id)initWithForest:(TRForest*)forest;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


