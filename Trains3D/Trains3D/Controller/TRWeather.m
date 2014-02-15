#import "TRWeather.h"

#import "EGProgress.h"
@implementation TRWeatherRules{
    CGFloat _sunny;
    CGFloat _windStrength;
    CGFloat _blastness;
    CGFloat _blastMinLength;
    CGFloat _blastMaxLength;
    CGFloat _blastStrength;
    id _precipitation;
}
static ODClassType* _TRWeatherRules_type;
@synthesize sunny = _sunny;
@synthesize windStrength = _windStrength;
@synthesize blastness = _blastness;
@synthesize blastMinLength = _blastMinLength;
@synthesize blastMaxLength = _blastMaxLength;
@synthesize blastStrength = _blastStrength;
@synthesize precipitation = _precipitation;

+ (id)weatherRulesWithSunny:(CGFloat)sunny windStrength:(CGFloat)windStrength blastness:(CGFloat)blastness blastMinLength:(CGFloat)blastMinLength blastMaxLength:(CGFloat)blastMaxLength blastStrength:(CGFloat)blastStrength precipitation:(id)precipitation {
    return [[TRWeatherRules alloc] initWithSunny:sunny windStrength:windStrength blastness:blastness blastMinLength:blastMinLength blastMaxLength:blastMaxLength blastStrength:blastStrength precipitation:precipitation];
}

- (id)initWithSunny:(CGFloat)sunny windStrength:(CGFloat)windStrength blastness:(CGFloat)blastness blastMinLength:(CGFloat)blastMinLength blastMaxLength:(CGFloat)blastMaxLength blastStrength:(CGFloat)blastStrength precipitation:(id)precipitation {
    self = [super init];
    if(self) {
        _sunny = sunny;
        _windStrength = windStrength;
        _blastness = blastness;
        _blastMinLength = blastMinLength;
        _blastMaxLength = blastMaxLength;
        _blastStrength = blastStrength;
        _precipitation = precipitation;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRWeatherRules class]) _TRWeatherRules_type = [ODClassType classTypeWithCls:[TRWeatherRules class]];
}

- (BOOL)isRain {
    return [_precipitation isDefined] && ((TRPrecipitation*)([_precipitation get])).tp == TRPrecipitationType.rain;
}

- (BOOL)isSnow {
    return [_precipitation isDefined] && ((TRPrecipitation*)([_precipitation get])).tp == TRPrecipitationType.snow;
}

- (ODClassType*)type {
    return [TRWeatherRules type];
}

+ (ODClassType*)type {
    return _TRWeatherRules_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRWeatherRules* o = ((TRWeatherRules*)(other));
    return eqf(self.sunny, o.sunny) && eqf(self.windStrength, o.windStrength) && eqf(self.blastness, o.blastness) && eqf(self.blastMinLength, o.blastMinLength) && eqf(self.blastMaxLength, o.blastMaxLength) && eqf(self.blastStrength, o.blastStrength) && [self.precipitation isEqual:o.precipitation];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.sunny);
    hash = hash * 31 + floatHash(self.windStrength);
    hash = hash * 31 + floatHash(self.blastness);
    hash = hash * 31 + floatHash(self.blastMinLength);
    hash = hash * 31 + floatHash(self.blastMaxLength);
    hash = hash * 31 + floatHash(self.blastStrength);
    hash = hash * 31 + [self.precipitation hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"sunny=%f", self.sunny];
    [description appendFormat:@", windStrength=%f", self.windStrength];
    [description appendFormat:@", blastness=%f", self.blastness];
    [description appendFormat:@", blastMinLength=%f", self.blastMinLength];
    [description appendFormat:@", blastMaxLength=%f", self.blastMaxLength];
    [description appendFormat:@", blastStrength=%f", self.blastStrength];
    [description appendFormat:@", precipitation=%@", self.precipitation];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRPrecipitation{
    TRPrecipitationType* _tp;
    CGFloat _strength;
}
static ODClassType* _TRPrecipitation_type;
@synthesize tp = _tp;
@synthesize strength = _strength;

+ (id)precipitationWithTp:(TRPrecipitationType*)tp strength:(CGFloat)strength {
    return [[TRPrecipitation alloc] initWithTp:tp strength:strength];
}

- (id)initWithTp:(TRPrecipitationType*)tp strength:(CGFloat)strength {
    self = [super init];
    if(self) {
        _tp = tp;
        _strength = strength;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRPrecipitation class]) _TRPrecipitation_type = [ODClassType classTypeWithCls:[TRPrecipitation class]];
}

- (ODClassType*)type {
    return [TRPrecipitation type];
}

+ (ODClassType*)type {
    return _TRPrecipitation_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRPrecipitation* o = ((TRPrecipitation*)(other));
    return self.tp == o.tp && eqf(self.strength, o.strength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.tp ordinal];
    hash = hash * 31 + floatHash(self.strength);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tp=%@", self.tp];
    [description appendFormat:@", strength=%f", self.strength];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRPrecipitationType
static TRPrecipitationType* _TRPrecipitationType_rain;
static TRPrecipitationType* _TRPrecipitationType_snow;
static NSArray* _TRPrecipitationType_values;

+ (id)precipitationTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRPrecipitationType alloc] initWithOrdinal:ordinal name:name];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRPrecipitationType_rain = [TRPrecipitationType precipitationTypeWithOrdinal:0 name:@"rain"];
    _TRPrecipitationType_snow = [TRPrecipitationType precipitationTypeWithOrdinal:1 name:@"snow"];
    _TRPrecipitationType_values = (@[_TRPrecipitationType_rain, _TRPrecipitationType_snow]);
}

+ (TRPrecipitationType*)rain {
    return _TRPrecipitationType_rain;
}

+ (TRPrecipitationType*)snow {
    return _TRPrecipitationType_snow;
}

+ (NSArray*)values {
    return _TRPrecipitationType_values;
}

@end


@implementation TRWeather{
    TRWeatherRules* _rules;
    GEVec2 __constantWind;
    GEVec2 __blast;
    TRBlast __nextBlast;
    TRBlast __currentBlast;
    CGFloat __blastWaitCounter;
    CGFloat __blastCounter;
    BOOL __hasBlast;
}
static ODClassType* _TRWeather_type;
@synthesize rules = _rules;

+ (id)weatherWithRules:(TRWeatherRules*)rules {
    return [[TRWeather alloc] initWithRules:rules];
}

- (id)initWithRules:(TRWeatherRules*)rules {
    self = [super init];
    if(self) {
        _rules = rules;
        __constantWind = geVec2MulF(geVec2Rnd(), _rules.windStrength);
        __blast = GEVec2Make(0.0, 0.0);
        __nextBlast = [self rndBlast];
        __blastWaitCounter = 0.0;
        __blastCounter = 0.0;
        __hasBlast = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRWeather class]) _TRWeather_type = [ODClassType classTypeWithCls:[TRWeather class]];
}

- (GEVec2)wind {
    return geVec2AddVec2(__constantWind, __blast);
}

- (void)updateWithDelta:(CGFloat)delta {
    __blastWaitCounter += delta;
    if(__blastWaitCounter > __nextBlast.start) {
        __blastWaitCounter = 0.0;
        if(!(__hasBlast)) {
            __hasBlast = YES;
            __currentBlast = __nextBlast;
        }
        __nextBlast = [self rndBlast];
    }
    if(__hasBlast) {
        __blastCounter += delta;
        if(__blastCounter > __currentBlast.length) {
            __blastCounter = 0.0;
            __hasBlast = NO;
            __blast = GEVec2Make(0.0, 0.0);
        } else {
            __blast = [self blastAnimationT:__blastCounter];
        }
    }
}

- (GEVec2)blastAnimationT:(CGFloat)t {
    if(t < 1) {
        GEVec2(^f)(float) = [EGProgress progressVec2:GEVec2Make(0.0, 0.0) vec22:__currentBlast.dir];
        return f(((float)(t)));
    } else {
        if(t > __currentBlast.length - 1) {
            GEVec2(^f)(float) = [EGProgress progressVec2:__currentBlast.dir vec22:GEVec2Make(0.0, 0.0)];
            return f(((float)(t - __currentBlast.length + 1)));
        } else {
            return __currentBlast.dir;
        }
    }
}

- (TRBlast)rndBlast {
    return TRBlastMake((odFloatRnd() * 2) / _rules.blastness, odFloatRndMinMax(_rules.blastMinLength, _rules.blastMaxLength), geVec2MulF(geVec2Rnd(), _rules.blastStrength));
}

- (ODClassType*)type {
    return [TRWeather type];
}

+ (ODClassType*)type {
    return _TRWeather_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRWeather* o = ((TRWeather*)(other));
    return [self.rules isEqual:o.rules];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.rules hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"rules=%@", self.rules];
    [description appendString:@">"];
    return description;
}

@end


NSString* TRBlastDescription(TRBlast self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRBlast: "];
    [description appendFormat:@"start=%f", self.start];
    [description appendFormat:@", length=%f", self.length];
    [description appendFormat:@", dir=%@", GEVec2Description(self.dir)];
    [description appendString:@">"];
    return description;
}
ODPType* trBlastType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRBlastWrap class] name:@"TRBlast" size:sizeof(TRBlast) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRBlast, ((TRBlast*)(data))[i]);
    }];
    return _ret;
}
@implementation TRBlastWrap{
    TRBlast _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRBlast)value {
    return [[TRBlastWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRBlast)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRBlastDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRBlastWrap* o = ((TRBlastWrap*)(other));
    return TRBlastEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRBlastHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



