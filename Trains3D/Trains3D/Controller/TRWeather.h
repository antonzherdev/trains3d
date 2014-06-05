#import "objd.h"
#import "PGVec.h"
#import "CNActor.h"
@class CNFuture;
@class PGProgress;

@class TRWeatherRules;
@class TRPrecipitation;
@class TRWeather;
@class TRPrecipitationType;
typedef struct TRBlast TRBlast;

typedef enum TRPrecipitationTypeR {
    TRPrecipitationType_Nil = 0,
    TRPrecipitationType_rain = 1,
    TRPrecipitationType_snow = 2
} TRPrecipitationTypeR;
@interface TRPrecipitationType : CNEnum
+ (NSArray*)values;
+ (TRPrecipitationType*)value:(TRPrecipitationTypeR)r;
@end


@interface TRWeatherRules : NSObject {
@public
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
- (CNClassType*)type;
- (BOOL)isRain;
- (BOOL)isSnow;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (TRWeatherRules*)aDefault;
+ (CNClassType*)type;
@end


@interface TRPrecipitation : NSObject {
@public
    TRPrecipitationTypeR _tp;
    CGFloat _strength;
}
@property (nonatomic, readonly) TRPrecipitationTypeR tp;
@property (nonatomic, readonly) CGFloat strength;

+ (instancetype)precipitationWithTp:(TRPrecipitationTypeR)tp strength:(CGFloat)strength;
- (instancetype)initWithTp:(TRPrecipitationTypeR)tp strength:(CGFloat)strength;
- (CNClassType*)type;
- (NSString*)description;
- (BOOL)isEqual:(id)to;
- (NSUInteger)hash;
+ (CNClassType*)type;
@end


struct TRBlast {
    CGFloat start;
    CGFloat length;
    PGVec2 dir;
};
static inline TRBlast TRBlastMake(CGFloat start, CGFloat length, PGVec2 dir) {
    return (TRBlast){start, length, dir};
}
NSString* trBlastDescription(TRBlast self);
BOOL trBlastIsEqualTo(TRBlast self, TRBlast to);
NSUInteger trBlastHash(TRBlast self);
CNPType* trBlastType();
@interface TRBlastWrap : NSObject
@property (readonly, nonatomic) TRBlast value;

+ (id)wrapWithValue:(TRBlast)value;
- (id)initWithValue:(TRBlast)value;
@end



@interface TRWeather : CNActor {
@public
    TRWeatherRules* _rules;
    PGVec2 __constantWind;
    PGVec2 __blast;
    volatile PGVec2 __wind;
    TRBlast __nextBlast;
    TRBlast __currentBlast;
    CGFloat __blastWaitCounter;
    CGFloat __blastCounter;
    BOOL __hasBlast;
}
@property (nonatomic, readonly) TRWeatherRules* rules;

+ (instancetype)weatherWithRules:(TRWeatherRules*)rules;
- (instancetype)initWithRules:(TRWeatherRules*)rules;
- (CNClassType*)type;
- (PGVec2)wind;
- (CNFuture*)updateWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


