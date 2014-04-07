#import "objd.h"
#import "GEVec.h"
#import "ATActor.h"
@class EGProgress;

@class TRWeatherRules;
@class TRPrecipitation;
@class TRWeather;
@class TRPrecipitationType;
typedef struct TRBlast TRBlast;

@interface TRWeatherRules : NSObject {
@private
    CGFloat _sunny;
    CGFloat _windStrength;
    CGFloat _blastness;
    CGFloat _blastMinLength;
    CGFloat _blastMaxLength;
    CGFloat _blastStrength;
    TRPrecipitation* _precipitation;
}
@property (nonatomic, readonly) CGFloat sunny;
@property (nonatomic, readonly) CGFloat windStrength;
@property (nonatomic, readonly) CGFloat blastness;
@property (nonatomic, readonly) CGFloat blastMinLength;
@property (nonatomic, readonly) CGFloat blastMaxLength;
@property (nonatomic, readonly) CGFloat blastStrength;
@property (nonatomic, readonly) TRPrecipitation* precipitation;

+ (instancetype)weatherRulesWithSunny:(CGFloat)sunny windStrength:(CGFloat)windStrength blastness:(CGFloat)blastness blastMinLength:(CGFloat)blastMinLength blastMaxLength:(CGFloat)blastMaxLength blastStrength:(CGFloat)blastStrength precipitation:(TRPrecipitation*)precipitation;
- (instancetype)initWithSunny:(CGFloat)sunny windStrength:(CGFloat)windStrength blastness:(CGFloat)blastness blastMinLength:(CGFloat)blastMinLength blastMaxLength:(CGFloat)blastMaxLength blastStrength:(CGFloat)blastStrength precipitation:(TRPrecipitation*)precipitation;
- (ODClassType*)type;
- (BOOL)isRain;
- (BOOL)isSnow;
+ (TRWeatherRules*)aDefault;
+ (ODClassType*)type;
@end


@interface TRPrecipitation : NSObject {
@private
    TRPrecipitationType* _tp;
    CGFloat _strength;
}
@property (nonatomic, readonly) TRPrecipitationType* tp;
@property (nonatomic, readonly) CGFloat strength;

+ (instancetype)precipitationWithTp:(TRPrecipitationType*)tp strength:(CGFloat)strength;
- (instancetype)initWithTp:(TRPrecipitationType*)tp strength:(CGFloat)strength;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRPrecipitationType : ODEnum
+ (TRPrecipitationType*)rain;
+ (TRPrecipitationType*)snow;
+ (NSArray*)values;
@end


struct TRBlast {
    CGFloat start;
    CGFloat length;
    GEVec2 dir;
};
static inline TRBlast TRBlastMake(CGFloat start, CGFloat length, GEVec2 dir) {
    return (TRBlast){start, length, dir};
}
static inline BOOL TRBlastEq(TRBlast s1, TRBlast s2) {
    return eqf(s1.start, s2.start) && eqf(s1.length, s2.length) && GEVec2Eq(s1.dir, s2.dir);
}
static inline NSUInteger TRBlastHash(TRBlast self) {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.start);
    hash = hash * 31 + floatHash(self.length);
    hash = hash * 31 + GEVec2Hash(self.dir);
    return hash;
}
NSString* TRBlastDescription(TRBlast self);
ODPType* trBlastType();
@interface TRBlastWrap : NSObject
@property (readonly, nonatomic) TRBlast value;

+ (id)wrapWithValue:(TRBlast)value;
- (id)initWithValue:(TRBlast)value;
@end



@interface TRWeather : ATActor {
@private
    TRWeatherRules* _rules;
    GEVec2 __constantWind;
    GEVec2 __blast;
    GEVec2 __wind;
    TRBlast __nextBlast;
    TRBlast __currentBlast;
    CGFloat __blastWaitCounter;
    CGFloat __blastCounter;
    BOOL __hasBlast;
}
@property (nonatomic, readonly) TRWeatherRules* rules;

+ (instancetype)weatherWithRules:(TRWeatherRules*)rules;
- (instancetype)initWithRules:(TRWeatherRules*)rules;
- (ODClassType*)type;
- (GEVec2)wind;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


