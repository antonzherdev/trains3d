#import "objd.h"
#import "EGScene.h"
#import "GEVec.h"
@class EGProgress;

@class TRWeatherRules;
@class TRPrecipitation;
@class TRWeather;
@class TRPrecipitationType;
typedef struct TRBlast TRBlast;

@interface TRWeatherRules : NSObject
@property (nonatomic, readonly) CGFloat sunny;
@property (nonatomic, readonly) CGFloat windStrength;
@property (nonatomic, readonly) CGFloat blastness;
@property (nonatomic, readonly) CGFloat blastMinLength;
@property (nonatomic, readonly) CGFloat blastMaxLength;
@property (nonatomic, readonly) CGFloat blastStrength;
@property (nonatomic, readonly) id precipitation;

+ (id)weatherRulesWithSunny:(CGFloat)sunny windStrength:(CGFloat)windStrength blastness:(CGFloat)blastness blastMinLength:(CGFloat)blastMinLength blastMaxLength:(CGFloat)blastMaxLength blastStrength:(CGFloat)blastStrength precipitation:(id)precipitation;
- (id)initWithSunny:(CGFloat)sunny windStrength:(CGFloat)windStrength blastness:(CGFloat)blastness blastMinLength:(CGFloat)blastMinLength blastMaxLength:(CGFloat)blastMaxLength blastStrength:(CGFloat)blastStrength precipitation:(id)precipitation;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRPrecipitation : NSObject
@property (nonatomic, readonly) TRPrecipitationType* tp;
@property (nonatomic, readonly) CGFloat strength;

+ (id)precipitationWithTp:(TRPrecipitationType*)tp strength:(CGFloat)strength;
- (id)initWithTp:(TRPrecipitationType*)tp strength:(CGFloat)strength;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRPrecipitationType : ODEnum
+ (TRPrecipitationType*)rain;
+ (TRPrecipitationType*)snow;
+ (NSArray*)values;
@end


@interface TRWeather : NSObject<EGController>
@property (nonatomic, readonly) TRWeatherRules* rules;

+ (id)weatherWithRules:(TRWeatherRules*)rules;
- (id)initWithRules:(TRWeatherRules*)rules;
- (ODClassType*)type;
- (GEVec2)wind;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
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



