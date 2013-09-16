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



@implementation EGEGEnvironment{
    EGColor _ambientColor;
    id<CNSeq> _lights;
}
static EGEGEnvironment* _EGEGEnvironment_default;
static ODClassType* _EGEGEnvironment_type;
@synthesize ambientColor = _ambientColor;
@synthesize lights = _lights;

+ (id)environmentWithAmbientColor:(EGColor)ambientColor lights:(id<CNSeq>)lights {
    return [[EGEGEnvironment alloc] initWithAmbientColor:ambientColor lights:lights];
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
    _EGEGEnvironment_type = [ODClassType classTypeWithCls:[EGEGEnvironment class]];
    _EGEGEnvironment_default = [EGEGEnvironment environmentWithAmbientColor:EGColorMake(1.0, 1.0, 1.0, 1.0) lights:(@[])];
}

+ (EGEGEnvironment*)applyLights:(id<CNSeq>)lights {
    return [EGEGEnvironment environmentWithAmbientColor:EGColorMake(1.0, 1.0, 1.0, 1.0) lights:lights];
}

+ (EGEGEnvironment*)applyLight:(EGEGLight*)light {
    return [EGEGEnvironment environmentWithAmbientColor:EGColorMake(1.0, 1.0, 1.0, 1.0) lights:(@[light])];
}

- (ODClassType*)type {
    return [EGEGEnvironment type];
}

+ (EGEGEnvironment*)aDefault {
    return _EGEGEnvironment_default;
}

+ (ODClassType*)type {
    return _EGEGEnvironment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEGEnvironment* o = ((EGEGEnvironment*)(other));
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


@implementation EGEGLight{
    EGColor _color;
}
static ODClassType* _EGEGLight_type;
@synthesize color = _color;

+ (id)lightWithColor:(EGColor)color {
    return [[EGEGLight alloc] initWithColor:color];
}

- (id)initWithColor:(EGColor)color {
    self = [super init];
    if(self) _color = color;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEGLight_type = [ODClassType classTypeWithCls:[EGEGLight class]];
}

- (ODClassType*)type {
    return [EGEGLight type];
}

+ (ODClassType*)type {
    return _EGEGLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEGLight* o = ((EGEGLight*)(other));
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


@implementation EGEGDirectLight{
    GEVec3 _direction;
}
static ODClassType* _EGEGDirectLight_type;
@synthesize direction = _direction;

+ (id)directLightWithColor:(EGColor)color direction:(GEVec3)direction {
    return [[EGEGDirectLight alloc] initWithColor:color direction:direction];
}

- (id)initWithColor:(EGColor)color direction:(GEVec3)direction {
    self = [super initWithColor:color];
    if(self) _direction = direction;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEGDirectLight_type = [ODClassType classTypeWithCls:[EGEGDirectLight class]];
}

- (ODClassType*)type {
    return [EGEGDirectLight type];
}

+ (ODClassType*)type {
    return _EGEGDirectLight_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEGDirectLight* o = ((EGEGDirectLight*)(other));
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


