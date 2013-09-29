#import "TRWeather.h"

@implementation TRWeatherRules{
    CGFloat _windStrength;
}
static ODClassType* _TRWeatherRules_type;
@synthesize windStrength = _windStrength;

+ (id)weatherRulesWithWindStrength:(CGFloat)windStrength {
    return [[TRWeatherRules alloc] initWithWindStrength:windStrength];
}

- (id)initWithWindStrength:(CGFloat)windStrength {
    self = [super init];
    if(self) _windStrength = windStrength;
    
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
    return eqf(self.windStrength, o.windStrength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.windStrength);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"windStrength=%f", self.windStrength];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRWeather{
    TRWeatherRules* _rules;
    GEVec2 __wind;
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
        __wind = GEVec2Make(0.0, 0.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRWeather_type = [ODClassType classTypeWithCls:[TRWeather class]];
}

- (GEVec2)wind {
    return __wind;
}

- (void)updateWithDelta:(CGFloat)delta {
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


