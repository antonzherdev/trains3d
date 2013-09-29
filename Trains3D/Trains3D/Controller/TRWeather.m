#import "TRWeather.h"

#import "EGProgress.h"
@implementation TRWeatherRules{
    CGFloat _windStrength;
    CGFloat _blastness;
    CGFloat _blastMinLength;
    CGFloat _blastMaxLength;
    CGFloat _blastStrength;
}
static ODClassType* _TRWeatherRules_type;
@synthesize windStrength = _windStrength;
@synthesize blastness = _blastness;
@synthesize blastMinLength = _blastMinLength;
@synthesize blastMaxLength = _blastMaxLength;
@synthesize blastStrength = _blastStrength;

+ (id)weatherRulesWithWindStrength:(CGFloat)windStrength blastness:(CGFloat)blastness blastMinLength:(CGFloat)blastMinLength blastMaxLength:(CGFloat)blastMaxLength blastStrength:(CGFloat)blastStrength {
    return [[TRWeatherRules alloc] initWithWindStrength:windStrength blastness:blastness blastMinLength:blastMinLength blastMaxLength:blastMaxLength blastStrength:blastStrength];
}

- (id)initWithWindStrength:(CGFloat)windStrength blastness:(CGFloat)blastness blastMinLength:(CGFloat)blastMinLength blastMaxLength:(CGFloat)blastMaxLength blastStrength:(CGFloat)blastStrength {
    self = [super init];
    if(self) {
        _windStrength = windStrength;
        _blastness = blastness;
        _blastMinLength = blastMinLength;
        _blastMaxLength = blastMaxLength;
        _blastStrength = blastStrength;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRWeatherRules_type = [ODClassType classTypeWithCls:[TRWeatherRules class]];
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
    return eqf(self.windStrength, o.windStrength) && eqf(self.blastness, o.blastness) && eqf(self.blastMinLength, o.blastMinLength) && eqf(self.blastMaxLength, o.blastMaxLength) && eqf(self.blastStrength, o.blastStrength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.windStrength);
    hash = hash * 31 + floatHash(self.blastness);
    hash = hash * 31 + floatHash(self.blastMinLength);
    hash = hash * 31 + floatHash(self.blastMaxLength);
    hash = hash * 31 + floatHash(self.blastStrength);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"windStrength=%f", self.windStrength];
    [description appendFormat:@", blastness=%f", self.blastness];
    [description appendFormat:@", blastMinLength=%f", self.blastMinLength];
    [description appendFormat:@", blastMaxLength=%f", self.blastMaxLength];
    [description appendFormat:@", blastStrength=%f", self.blastStrength];
    [description appendString:@">"];
    return description;
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
    _TRWeather_type = [ODClassType classTypeWithCls:[TRWeather class]];
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
    if(t < 0.01) {
        GEVec2(^f)(float) = [EGProgress progressVec2:GEVec2Make(0.0, 0.0) vec22:__currentBlast.dir];
        return f(((float)(t / 0.01)));
    } else {
        if(t > __currentBlast.length - 0.01) {
            GEVec2(^f)(float) = [EGProgress progressVec2:__currentBlast.dir vec22:GEVec2Make(0.0, 0.0)];
            return f(((float)((t - __currentBlast.length + 0.01) / 0.01)));
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



