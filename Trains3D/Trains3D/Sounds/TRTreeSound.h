#import "objd.h"
#import "EGSound.h"
#import "GEVec.h"
@class TRLevel;
@class TRLevelRules;
@class TRWeatherRules;
@class TRLevelTheme;
@class SDSound;
@class TRForest;
@class TRWeather;
@class SDSimpleSound;

@class TRTreeSound;
@class TRWindSound;
@class TRRainSound;

@interface TRTreeSound : EGSoundPlayersCollection {
@protected
    TRLevel* _level;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)treeSoundWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRWindSound : EGBackgroundSoundPlayer {
@protected
    TRForest* _forest;
}
@property (nonatomic, readonly) TRForest* forest;

+ (instancetype)windSoundWithForest:(TRForest*)forest;
- (instancetype)initWithForest:(TRForest*)forest;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@interface TRRainSound : EGBackgroundSoundPlayer {
@protected
    TRWeather* _weather;
}
@property (nonatomic, readonly) TRWeather* weather;

+ (instancetype)rainSoundWithWeather:(TRWeather*)weather;
- (instancetype)initWithWeather:(TRWeather*)weather;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


