#import "objd.h"
@class SDSimpleSoundPlat;

@class SDSound;
@class SDSimpleSound;
@class SDParSound;

@interface SDSound : NSObject
+ (instancetype)sound;
- (instancetype)init;
- (ODClassType*)type;
+ (SDSimpleSound*)applyFile:(NSString*)file;
+ (SDSimpleSound*)applyFile:(NSString*)file volume:(float)volume;
+ (SDParSound*)parLimit:(NSInteger)limit file:(NSString*)file volume:(float)volume;
+ (SDParSound*)parLimit:(NSInteger)limit file:(NSString*)file;
- (void)play;
- (void)playLoops:(NSUInteger)loops;
- (void)playAlways;
- (void)stop;
- (BOOL)isPlaying;
- (void)pause;
- (void)resume;
+ (ODClassType*)type;
@end


@interface SDSimpleSound : SDSound {
@private
    NSString* _file;
}
@property (nonatomic, readonly) NSString* file;

+ (instancetype)simpleSoundWithFile:(NSString*)file;
- (instancetype)initWithFile:(NSString*)file;
- (ODClassType*)type;
- (float)pan;
- (void)setPan:(float)pan;
- (float)volume;
- (void)setVolume:(float)volume;
- (CGFloat)time;
- (void)setTime:(CGFloat)time;
- (CGFloat)duration;
+ (ODClassType*)type;
@end


@interface SDParSound : SDSound {
@private
    NSInteger _limit;
    SDSimpleSound*(^_create)();
    NSMutableArray* _sounds;
    NSMutableSet* _paused;
}
@property (nonatomic, readonly) NSInteger limit;
@property (nonatomic, readonly) SDSimpleSound*(^create)();

+ (instancetype)parSoundWithLimit:(NSInteger)limit create:(SDSimpleSound*(^)())create;
- (instancetype)initWithLimit:(NSInteger)limit create:(SDSimpleSound*(^)())create;
- (ODClassType*)type;
- (void)play;
- (void)playLoops:(NSUInteger)loops;
- (void)playAlways;
- (void)pause;
- (void)resume;
- (BOOL)isPlaying;
- (void)stop;
- (void)playWithVolume:(float)volume;
+ (ODClassType*)type;
@end


