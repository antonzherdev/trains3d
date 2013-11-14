#import "TRPrecipitationView.h"

#import "TRWeather.h"
@implementation TRPrecipitationView
static ODClassType* _TRPrecipitationView_type;

+ (id)precipitationView {
    return [[TRPrecipitationView alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRPrecipitationView_type = [ODClassType classTypeWithCls:[TRPrecipitationView class]];
}

+ (TRPrecipitationView*)applyPrecipitation:(TRPrecipitation*)precipitation {
    if(precipitation.tp == TRPrecipitationType.rain) return [TRRainView rainViewWithStrength:precipitation.strength];
    else @throw @"Unknown precipitation type";
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (ODClassType*)type {
    return [TRPrecipitationView type];
}

+ (ODClassType*)type {
    return _TRPrecipitationView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRRainView{
    CGFloat _strength;
}
static ODClassType* _TRRainView_type;
@synthesize strength = _strength;

+ (id)rainViewWithStrength:(CGFloat)strength {
    return [[TRRainView alloc] initWithStrength:strength];
}

- (id)initWithStrength:(CGFloat)strength {
    self = [super init];
    if(self) _strength = strength;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRRainView_type = [ODClassType classTypeWithCls:[TRRainView class]];
}

- (void)draw {
}

- (ODClassType*)type {
    return [TRRainView type];
}

+ (ODClassType*)type {
    return _TRRainView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRRainView* o = ((TRRainView*)(other));
    return eqf(self.strength, o.strength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.strength);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"strength=%f", self.strength];
    [description appendString:@">"];
    return description;
}

@end


