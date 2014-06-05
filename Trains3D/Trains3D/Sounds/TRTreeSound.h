#import "objd.h"
#import "PGSoundPlayer.h"
#import "TRLevel.h"
#import "PGVec.h"
@class TRWeatherRules;
@class PGSound;
@class TRForest;
@class TRWeather;
@class PGSimpleSound;

@class TRTreeSound;
@class TRWindSound;
@class TRRainSound;

@interface TRTreeSound : PGSoundPlayersCollection {
@public
    TRLevel* _level;
}
@property (nonatomic, readonly) TRLevel* level;

+ (instancetype)treeSoundWithLevel:(TRLevel*)level;
- (instancetype)initWithLevel:(TRLevel*)level;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRWindSound : PGBackgroundSoundPlayer {
@public
    TRForest* _forest;
}
@property (nonatomic, readonly) TRForest* forest;

+ (instancetype)windSoundWithForest:(TRForest*)forest;
- (instancetype)initWithForest:(TRForest*)forest;
- (CNClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRRainSound : PGBackgroundSoundPlayer {
@public
    TRWeather* _weather;
}
@property (nonatomic, readonly) TRWeather* weather;

+ (instancetype)rainSoundWithWeather:(TRWeather*)weather;
- (instancetype)initWithWeather:(TRWeather*)weather;
- (CNClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


