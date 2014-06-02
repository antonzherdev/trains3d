#import "TRWeather.h"

#import "CNFuture.h"
#import "EGProgress.h"
@implementation TRWeatherRules
static TRWeatherRules* _TRWeatherRules_default;
static CNClassType* _TRWeatherRules_type;
@synthesize sunny = _sunny;
@synthesize windStrength = _windStrength;
@synthesize blastness = _blastness;
@synthesize blastMinLength = _blastMinLength;
@synthesize blastMaxLength = _blastMaxLength;
@synthesize blastStrength = _blastStrength;
@synthesize precipitation = _precipitation;

+ (instancetype)weatherRulesWithSunny:(CGFloat)sunny windStrength:(CGFloat)windStrength blastness:(CGFloat)blastness blastMinLength:(CGFloat)blastMinLength blastMaxLength:(CGFloat)blastMaxLength blastStrength:(CGFloat)blastStrength precipitation:(TRPrecipitation*)precipitation {
    return [[TRWeatherRules alloc] initWithSunny:sunny windStrength:windStrength blastness:blastness blastMinLength:blastMinLength blastMaxLength:blastMaxLength blastStrength:blastStrength precipitation:precipitation];
}

- (instancetype)initWithSunny:(CGFloat)sunny windStrength:(CGFloat)windStrength blastness:(CGFloat)blastness blastMinLength:(CGFloat)blastMinLength blastMaxLength:(CGFloat)blastMaxLength blastStrength:(CGFloat)blastStrength precipitation:(TRPrecipitation*)precipitation {
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
    if(self == [TRWeatherRules class]) {
        _TRWeatherRules_type = [CNClassType classTypeWithCls:[TRWeatherRules class]];
        _TRWeatherRules_default = [TRWeatherRules weatherRulesWithSunny:1.0 windStrength:1.0 blastness:0.1 blastMinLength:5.0 blastMaxLength:10.0 blastStrength:10.0 precipitation:nil];
    }
}

- (BOOL)isRain {
    TRPrecipitationTypeR __tmp = ((TRPrecipitation*)(_precipitation)).tp;
    return __tmp != TRPrecipitationType_Nil && __tmp == TRPrecipitationType_rain;
}

- (BOOL)isSnow {
    TRPrecipitationTypeR __tmp = ((TRPrecipitation*)(_precipitation)).tp;
    return __tmp != TRPrecipitationType_Nil && __tmp == TRPrecipitationType_snow;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"WeatherRules(%f, %f, %f, %f, %f, %f, %@)", _sunny, _windStrength, _blastness, _blastMinLength, _blastMaxLength, _blastStrength, _precipitation];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRWeatherRules class]])) return NO;
    TRWeatherRules* o = ((TRWeatherRules*)(to));
    return eqf(_sunny, o.sunny) && eqf(_windStrength, o.windStrength) && eqf(_blastness, o.blastness) && eqf(_blastMinLength, o.blastMinLength) && eqf(_blastMaxLength, o.blastMaxLength) && eqf(_blastStrength, o.blastStrength) && [_precipitation isEqual:o.precipitation];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(_sunny);
    hash = hash * 31 + floatHash(_windStrength);
    hash = hash * 31 + floatHash(_blastness);
    hash = hash * 31 + floatHash(_blastMinLength);
    hash = hash * 31 + floatHash(_blastMaxLength);
    hash = hash * 31 + floatHash(_blastStrength);
    hash = hash * 31 + [((TRPrecipitation*)(_precipitation)) hash];
    return hash;
}

- (CNClassType*)type {
    return [TRWeatherRules type];
}

+ (TRWeatherRules*)aDefault {
    return _TRWeatherRules_default;
}

+ (CNClassType*)type {
    return _TRWeatherRules_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRPrecipitation
static CNClassType* _TRPrecipitation_type;
@synthesize tp = _tp;
@synthesize strength = _strength;

+ (instancetype)precipitationWithTp:(TRPrecipitationTypeR)tp strength:(CGFloat)strength {
    return [[TRPrecipitation alloc] initWithTp:tp strength:strength];
}

- (instancetype)initWithTp:(TRPrecipitationTypeR)tp strength:(CGFloat)strength {
    self = [super init];
    if(self) {
        _tp = tp;
        _strength = strength;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRPrecipitation class]) _TRPrecipitation_type = [CNClassType classTypeWithCls:[TRPrecipitation class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Precipitation(%@, %f)", [TRPrecipitationType value:_tp], _strength];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRPrecipitation class]])) return NO;
    TRPrecipitation* o = ((TRPrecipitation*)(to));
    return _tp == o.tp && eqf(_strength, o.strength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [[TRPrecipitationType value:_tp] hash];
    hash = hash * 31 + floatHash(_strength);
    return hash;
}

- (CNClassType*)type {
    return [TRPrecipitation type];
}

+ (CNClassType*)type {
    return _TRPrecipitation_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

TRPrecipitationType* TRPrecipitationType_Values[3];
TRPrecipitationType* TRPrecipitationType_rain_Desc;
TRPrecipitationType* TRPrecipitationType_snow_Desc;
@implementation TRPrecipitationType

+ (instancetype)precipitationTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    return [[TRPrecipitationType alloc] initWithOrdinal:ordinal name:name];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name {
    self = [super initWithOrdinal:ordinal name:name];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRPrecipitationType_rain_Desc = [TRPrecipitationType precipitationTypeWithOrdinal:0 name:@"rain"];
    TRPrecipitationType_snow_Desc = [TRPrecipitationType precipitationTypeWithOrdinal:1 name:@"snow"];
    TRPrecipitationType_Values[0] = nil;
    TRPrecipitationType_Values[1] = TRPrecipitationType_rain_Desc;
    TRPrecipitationType_Values[2] = TRPrecipitationType_snow_Desc;
}

+ (NSArray*)values {
    return (@[TRPrecipitationType_rain_Desc, TRPrecipitationType_snow_Desc]);
}

+ (TRPrecipitationType*)value:(TRPrecipitationTypeR)r {
    return TRPrecipitationType_Values[r];
}

@end

NSString* trBlastDescription(TRBlast self) {
    return [NSString stringWithFormat:@"Blast(%f, %f, %@)", self.start, self.length, geVec2Description(self.dir)];
}
BOOL trBlastIsEqualTo(TRBlast self, TRBlast to) {
    return eqf(self.start, to.start) && eqf(self.length, to.length) && geVec2IsEqualTo(self.dir, to.dir);
}
NSUInteger trBlastHash(TRBlast self) {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.start);
    hash = hash * 31 + floatHash(self.length);
    hash = hash * 31 + geVec2Hash(self.dir);
    return hash;
}
CNPType* trBlastType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[TRBlastWrap class] name:@"TRBlast" size:sizeof(TRBlast) wrap:^id(void* data, NSUInteger i) {
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
    return trBlastDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRBlastWrap* o = ((TRBlastWrap*)(other));
    return trBlastIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return trBlastHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation TRWeather
static CNClassType* _TRWeather_type;
@synthesize rules = _rules;

+ (instancetype)weatherWithRules:(TRWeatherRules*)rules {
    return [[TRWeather alloc] initWithRules:rules];
}

- (instancetype)initWithRules:(TRWeatherRules*)rules {
    self = [super init];
    if(self) {
        _rules = rules;
        __constantWind = geVec2MulF(geVec2Rnd(), rules.windStrength);
        __blast = GEVec2Make(0.0, 0.0);
        __wind = GEVec2Make(0.0, 0.0);
        __nextBlast = [self rndBlast];
        __currentBlast = TRBlastMake(0.0, 0.0, (GEVec2Make(0.0, 0.0)));
        __blastWaitCounter = 0.0;
        __blastCounter = 0.0;
        __hasBlast = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRWeather class]) _TRWeather_type = [CNClassType classTypeWithCls:[TRWeather class]];
}

- (GEVec2)wind {
    return __wind;
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self futureF:^id() {
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
        GEVec2 wind = geVec2AddVec2(__constantWind, __blast);
        __wind = wind;
        return nil;
    }];
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
    return TRBlastMake((cnFloatRnd() * 2) / _rules.blastness, (cnFloatRndMinMax(_rules.blastMinLength, _rules.blastMaxLength)), (geVec2MulF(geVec2Rnd(), _rules.blastStrength)));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Weather(%@)", _rules];
}

- (CNClassType*)type {
    return [TRWeather type];
}

+ (CNClassType*)type {
    return _TRWeather_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

