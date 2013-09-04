#import "EGTypes.h"

#import "EGMath.h"
ODPType* egSizeType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGSizeWrap class] name:@"EGSize" size:sizeof(EGSize) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGSize, ((EGSize*)(data))[i]);
    }];
    return _ret;
}
@implementation EGSizeWrap{
    EGSize _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGSize)value {
    return [[EGSizeWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGSize)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGSizeDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSizeWrap* o = ((EGSizeWrap*)(other));
    return EGSizeEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGSizeHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



ODPType* egSizeIType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGSizeIWrap class] name:@"EGSizeI" size:sizeof(EGSizeI) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGSizeI, ((EGSizeI*)(data))[i]);
    }];
    return _ret;
}
@implementation EGSizeIWrap{
    EGSizeI _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGSizeI)value {
    return [[EGSizeIWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGSizeI)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGSizeIDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSizeIWrap* o = ((EGSizeIWrap*)(other));
    return EGSizeIEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGSizeIHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



BOOL egRectContains(EGRect self, EGVec2 point) {
    return self.x <= point.x && point.x <= self.x + self.width && self.y <= point.y && point.y <= self.y + self.height;
}
CGFloat egRectX2(EGRect self) {
    return self.x + self.width;
}
CGFloat egRectY2(EGRect self) {
    return self.y + self.height;
}
EGRect egRectNewXY(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2) {
    return EGRectMake(x, x2 - x, y, y2 - y);
}
EGRect egRectMove(EGRect self, CGFloat x, CGFloat y) {
    return EGRectMake(self.x + x, self.width, self.y + y, self.height);
}
EGRect egRectMoveToCenterFor(EGRect self, EGSize size) {
    return EGRectMake((size.width - self.width) / 2, self.width, (size.height - self.height) / 2, self.height);
}
EGVec2 egRectPoint(EGRect self) {
    return EGVec2Make(self.x, self.y);
}
EGSize egRectSize(EGRect self) {
    return EGSizeMake(self.width, self.height);
}
BOOL egRectIntersects(EGRect self, EGRect rect) {
    return self.x <= egRectX2(rect) && egRectX2(self) >= rect.x && self.y <= egRectY2(rect) && egRectY2(self) >= rect.y;
}
EGRect egRectThicken(EGRect self, CGFloat x, CGFloat y) {
    return EGRectMake(self.x - x, self.width + 2 * x, self.y - y, self.height + 2 * y);
}
ODPType* egRectType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGRectWrap class] name:@"EGRect" size:sizeof(EGRect) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGRect, ((EGRect*)(data))[i]);
    }];
    return _ret;
}
@implementation EGRectWrap{
    EGRect _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGRect)value {
    return [[EGRectWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGRect)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGRectDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRectWrap* o = ((EGRectWrap*)(other));
    return EGRectEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGRectHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



EGRectI egRectIApply(EGRect rect) {
    return EGRectIMake(lround(rect.x), lround(rect.width), lround(rect.y), lround(rect.height));
}
EGRectI egRectINewXY(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2) {
    return EGRectIMake(((NSInteger)(x)), ((NSInteger)(x2 - x)), ((NSInteger)(y)), ((NSInteger)(y2 - y)));
}
NSInteger egRectIX2(EGRectI self) {
    return self.x + self.width;
}
NSInteger egRectIY2(EGRectI self) {
    return self.y + self.height;
}
ODPType* egRectIType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGRectIWrap class] name:@"EGRectI" size:sizeof(EGRectI) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGRectI, ((EGRectI*)(data))[i]);
    }];
    return _ret;
}
@implementation EGRectIWrap{
    EGRectI _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGRectI)value {
    return [[EGRectIWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGRectI)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGRectIDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRectIWrap* o = ((EGRectIWrap*)(other));
    return EGRectIEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGRectIHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



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
    EGVec3 _direction;
}
static ODClassType* _EGDirectLight_type;
@synthesize direction = _direction;

+ (id)directLightWithColor:(EGColor)color direction:(EGVec3)direction {
    return [[EGDirectLight alloc] initWithColor:color direction:direction];
}

- (id)initWithColor:(EGColor)color direction:(EGVec3)direction {
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
    return EGColorEq(self.color, o.color) && EGVec3Eq(self.direction, o.direction);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + EGColorHash(self.color);
    hash = hash * 31 + EGVec3Hash(self.direction);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", EGColorDescription(self.color)];
    [description appendFormat:@", direction=%@", EGVec3Description(self.direction)];
    [description appendString:@">"];
    return description;
}

@end


