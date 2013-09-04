#import "EGTypes.h"

EGVec2 egVec2Apply(EGVec2I point) {
    return EGVec2Make(((CGFloat)(point.x)), ((CGFloat)(point.y)));
}
EGVec2 egVec2Add(EGVec2 self, EGVec2 point) {
    return EGVec2Make(self.x + point.x, self.y + point.y);
}
EGVec2 egVec2Sub(EGVec2 self, EGVec2 point) {
    return EGVec2Make(self.x - point.x, self.y - point.y);
}
EGVec2 egVec2Negate(EGVec2 self) {
    return EGVec2Make(-self.x, -self.y);
}
CGFloat egVec2Angle(EGVec2 self) {
    return atan2(self.y, self.x);
}
CGFloat egVec2Dot(EGVec2 self, EGVec2 point) {
    return self.x * point.x + self.y * point.y;
}
CGFloat egVec2LengthSquare(EGVec2 self) {
    return egVec2Dot(self, self);
}
CGFloat egVec2Length(EGVec2 self) {
    return sqrt(egVec2LengthSquare(self));
}
EGVec2 egVec2Mul(EGVec2 self, CGFloat value) {
    return EGVec2Make(self.x * value, self.y * value);
}
EGVec2 egVec2Div(EGVec2 self, CGFloat value) {
    return EGVec2Make(self.x / value, self.y / value);
}
EGVec2 egVec2Mid(EGVec2 self, EGVec2 point) {
    return egVec2Mul(egVec2Add(self, point), 0.5);
}
CGFloat egVec2DistanceTo(EGVec2 self, EGVec2 point) {
    return egVec2Length(egVec2Sub(self, point));
}
EGVec2 egVec2Set(EGVec2 self, CGFloat length) {
    return egVec2Mul(self, length / egVec2Length(self));
}
EGVec2 egVec2Normalize(EGVec2 self) {
    return egVec2Set(self, 1.0);
}
NSInteger egVec2Compare(EGVec2 self, EGVec2 to) {
    NSInteger dX = floatCompare(self.x, to.x);
    if(dX != 0) return dX;
    else return floatCompare(self.y, to.y);
}
ODPType* egVec2Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGVec2Wrap class] name:@"EGVec2" size:sizeof(EGVec2) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGVec2, ((EGVec2*)(data))[i]);
    }];
    return _ret;
}
@implementation EGVec2Wrap{
    EGVec2 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGVec2)value {
    return [[EGVec2Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGVec2)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGVec2Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVec2Wrap* o = ((EGVec2Wrap*)(other));
    return EGVec2Eq(_value, o.value);
}

- (NSUInteger)hash {
    return EGVec2Hash(_value);
}

- (NSInteger)compareTo:(EGVec2Wrap*)to {
    return egVec2Compare(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



EGVec2I egVec2IApply(EGVec2 point) {
    return EGVec2IMake(lround(point.x), lround(point.y));
}
EGVec2I egVec2IAdd(EGVec2I self, EGVec2I point) {
    return EGVec2IMake(self.x + point.x, self.y + point.y);
}
EGVec2I egVec2ISub(EGVec2I self, EGVec2I point) {
    return EGVec2IMake(self.x - point.x, self.y - point.y);
}
EGVec2I egVec2INegate(EGVec2I self) {
    return EGVec2IMake(-self.x, -self.y);
}
NSInteger egVec2ICompare(EGVec2I self, EGVec2I to) {
    NSInteger dX = intCompare(self.x, to.x);
    if(dX != 0) return dX;
    else return intCompare(self.y, to.y);
}
ODPType* egVec2IType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGVec2IWrap class] name:@"EGVec2I" size:sizeof(EGVec2I) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGVec2I, ((EGVec2I*)(data))[i]);
    }];
    return _ret;
}
@implementation EGVec2IWrap{
    EGVec2I _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGVec2I)value {
    return [[EGVec2IWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGVec2I)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGVec2IDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVec2IWrap* o = ((EGVec2IWrap*)(other));
    return EGVec2IEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGVec2IHash(_value);
}

- (NSInteger)compareTo:(EGVec2IWrap*)to {
    return egVec2ICompare(_value, to.value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



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



EGVec3 egVec3Apply(EGVec2 vec2, float z) {
    return EGVec3Make(((float)(vec2.x)), ((float)(vec2.y)), z);
}
EGVec3 egVec3Add(EGVec3 self, EGVec3 v) {
    return EGVec3Make(self.x + v.x, self.y + v.y, self.z + v.z);
}
EGVec3 egVec3Sqr(EGVec3 self) {
    return egVec3Mul(self, ((float)(egVec3Length(self))));
}
EGVec3 egVec3Mul(EGVec3 self, float k) {
    return EGVec3Make(k * self.x, k * self.y, k * self.z);
}
CGFloat egVec3Dot(EGVec3 self, EGVec3 vec3) {
    return ((CGFloat)(self.x * vec3.x + self.y * vec3.y + self.z * vec3.z));
}
CGFloat egVec3LengthSquare(EGVec3 self) {
    return ((CGFloat)(self.x * self.x + self.y * self.y + self.z * self.z));
}
CGFloat egVec3Length(EGVec3 self) {
    return sqrt(egVec3LengthSquare(self));
}
ODPType* egVec3Type() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGVec3Wrap class] name:@"EGVec3" size:sizeof(EGVec3) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGVec3, ((EGVec3*)(data))[i]);
    }];
    return _ret;
}
@implementation EGVec3Wrap{
    EGVec3 _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGVec3)value {
    return [[EGVec3Wrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGVec3)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGVec3Description(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVec3Wrap* o = ((EGVec3Wrap*)(other));
    return EGVec3Eq(_value, o.value);
}

- (NSUInteger)hash {
    return EGVec3Hash(_value);
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


