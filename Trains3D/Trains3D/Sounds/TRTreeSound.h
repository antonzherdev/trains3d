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

@class TRTreeSound;
@class TRWindSound;
@class TRRainSound;

@interface TRTreeSound : EGSoundPlayersCollection
@property (nonatomic, readonly) TRLevel* level;

+ (id)treeSoundWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
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


@interface TRRainSound : EGBackgroundSoundPlayer
@property (nonatomic, readonly) TRWeather* weather;

+ (id)rainSoundWithWeather:(TRWeather*)weather;
- (id)initWithWeather:(TRWeather*)weather;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


