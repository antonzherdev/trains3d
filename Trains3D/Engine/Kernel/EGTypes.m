#import "EGTypes.h"

EGColor egColorWhite() {
    static EGColor _ret = {1.0, 1.0, 1.0, 1.0};
    return _ret;
}
ODPType* egColorType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGColorWrap class] name:@"EGColor" size:sizeof(EGColor) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGColor, ((EGColor*)(data))[i]);
    }];
    return _ret;
}
@implementation EGColorWrap{
    EGColor _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGColor)value {
    return [[EGColorWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGColor)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGColorDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGColorWrap* o = ((EGColorWrap*)(other));
    return EGColorEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGColorHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation EGEnvironment{
    EGColor _ambientColor;
    id<CNSeq> _lights;
}
static EGEnvironment* _EGEnvironment_default;
static ODClassType* _EGEnvironment_type;
@synthesize ambientColor = _ambientColor;
@synthesize lights = _lights;

+ (id)environmentWithAmbientColor:(EGColor)ambientColor lights:(id<CNSeq>)lights {
    return [[EGEnvironment alloc] initWithAmbientColor:ambientColor lights:lights];
}

- (id)initWithAmbientColor:(EGColor)ambientColor lights:(id<CNSeq>)lights {
    self = [super init];
    if(self) {
        _ambientColor = ambientColor;
        _lights = lights;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEnvironment_type = [ODClassType classTypeWithCls:[EGEnvironment class]];
    _EGEnvironment_default = [EGEnvironment environmentWithAmbientColor:EGColorMake(1.0, 1.0, 1.0, 1.0) lights:(@[])];
}

+ (EGEnvironment*)applyLights:(id<CNSeq>)lights {
    return [EGEnvironment environmentWithAmbientColor:EGColorMake(1.0, 1.0, 1.0, 1.0) lights:lights];
}

+ (EGEnvironment*)applyLight:(EGLight*)light {
    return [EGEnvironment environmentWithAmbientColor:EGColorMake(1.0, 1.0, 1.0, 1.0) lights:(@[light])];
}

- (ODClassType*)type {
    return [EGEnvironment type];
}

+ (EGEnvironment*)aDefault {
    return _EGEnvironment_default;
}

+ (ODClassType*)type {
    return _EGEnvironment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEnvironment* o = ((EGEnvironment*)(other));
    return EGColorEq(self.ambientColor, o.ambientColor) && [self.lights isEqual:o.lights];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGColorHash(self.ambientColor);
    hash = hash * 31 + [self.lights hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"ambientColor=%@", EGColorDescription(self.ambientColor)];
    [description appendFormat:@", lights=%@", self.lights];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGLight{
    EGColor _color;
}
static ODClassType* _EGLight_type;
@synthesize color = _color;

+ (id)lightWithColor:(EGColor)color {
    return [[EGLight alloc] initWithColor:color];
}

- (id)initWithColor:(EGColor)color {
    self = [super init];
    if(self) _color = color;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGLight_type = [ODClassType classTypeWithCls:[EGLight class]];
}

- (ODClassType*)type {
    return [EGLight type];
}

+ (ODClassType*)type {
    return _EGLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGLight* o = ((EGLight*)(other));
    return EGColorEq(self.color, o.color);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGColorHash(self.color);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", EGColorDescription(self.color)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGDirectLight{
    GEVec3 _direction;
}
static ODClassType* _EGDirectLight_type;
@synthesize direction = _direction;

+ (id)directLightWithColor:(EGColor)color direction:(GEVec3)direction {
    return [[EGDirectLight alloc] initWithColor:color direction:direction];
}

- (id)initWithColor:(EGColor)color direction:(GEVec3)direction {
    self = [super initWithColor:color];
    if(self) _direction = direction;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGDirectLight_type = [ODClassType classTypeWithCls:[EGDirectLight class]];
}

- (ODClassType*)type {
    return [EGDirectLight type];
}

+ (ODClassType*)type {
    return _EGDirectLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGDirectLight* o = ((EGDirectLight*)(other));
    return EGColorEq(self.color, o.color) && GEVec3Eq(self.direction, o.direction);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGColorHash(self.color);
    hash = hash * 31 + GEVec3Hash(self.direction);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", EGColorDescription(self.color)];
    [description appendFormat:@", direction=%@", GEVec3Description(self.direction)];
    [description appendString:@">"];
    return description;
}

@end


