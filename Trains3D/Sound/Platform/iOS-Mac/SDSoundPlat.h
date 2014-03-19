#import "objd.h"
#import <AVFoundation/AVFoundation.h>
#import "SDSound.h"
@class SDSimpleSoundPlat;

@interface SDSimpleSoundPlat : SDSimpleSound
@property (nonatomic) float pan;
@property (nonatomic) float volume;
@property (nonatomic) CGFloat time;

+ (id)sound;
- (id)init;

- (id)initWithPlayer:(AVAudioPlayer *)player;

+ (id)soundWithPlayer:(AVAudioPlayer *)player;

- (ODClassType*)type;
+ (SDSimpleSoundPlat *)simpleSoundPlatWithFile:(NSString*)file;
- (BOOL)isPlaying;
- (CGFloat)duration;
- (void)play;
- (void)playLoops:(NSUInteger)loops;
- (void)playAlways;
- (void)pause;
- (void)stop;
+ (ODClassType*)type;

- (void)setRate:(float)rate;
@end


