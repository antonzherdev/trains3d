#import "objd.h"
#import <AVFoundation/AVFoundation.h>

@class SDSound;

@interface SDSound : NSObject
@property (nonatomic) float pan;
@property (nonatomic) float volume;
@property (nonatomic) CGFloat time;

+ (id)sound;
- (id)init;

- (id)initWithPlayer:(AVAudioPlayer *)player;

+ (id)soundWithPlayer:(AVAudioPlayer *)player;

- (ODClassType*)type;
+ (SDSound*)applyFile:(NSString*)file;
- (BOOL)isPlaying;
- (CGFloat)duration;
- (void)play;
- (void)playLoops:(NSUInteger)loops;
- (void)playAlways;
- (void)pause;
- (void)stop;
+ (ODClassType*)type;
@end


