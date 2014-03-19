#import "objd.h"
@class SDSimpleSound;

@class SDSound;
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


