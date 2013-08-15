#import "EGTypes.h"

#import "EGGL.h"
EGPoint egPointApply(EGPointI point) {
    return EGPointMake(point.x, point.y);
}
EGPoint egPointAdd(EGPoint self, EGPoint point) {
    return EGPointMake(self.x + point.x, self.y + point.y);
}
EGPoint egPointSub(EGPoint self, EGPoint point) {
    return EGPointMake(self.x - point.x, self.y - point.y);
}
EGPoint egPointNegate(EGPoint self) {
    return EGPointMake(-self.x, -self.y);
}
double egPointAngle(EGPoint self) {
    return atan2(self.y, self.x);
}
double egPointDot(EGPoint self, EGPoint point) {
    return self.x * point.x + self.y * point.y;
}
double egPointLengthSquare(EGPoint self) {
    return egPointDot(self, self);
}
double egPointLength(EGPoint self) {
    return sqrt(egPointLengthSquare(self));
}
EGPoint egPointMul(EGPoint self, double value) {
    return EGPointMake(self.x * value, self.y * value);
}
EGPoint egPointDiv(EGPoint self, double value) {
    return EGPointMake(self.x / value, self.y / value);
}
EGPoint egPointMid(EGPoint self, EGPoint point) {
    return egPointMul(egPointAdd(self, point), 0.5);
}
double egPointDistanceTo(EGPoint self, EGPoint point) {
    return egPointLength(egPointSub(self, point));
}
EGPoint egPointSet(EGPoint self, double length) {
    return egPointMul(self, length / egPointLength(self));
}
EGPoint egPointNormalize(EGPoint self) {
    return egPointSet(self, 1.0);
}
NSInteger egPointCompare(EGPoint self, EGPoint to) {
    NSInteger dX = floatCompare(self.x, to.x);
    if(dX != 0) return dX;
    else return floatCompare(self.y, to.y);
}
@implementation EGPointWrap{
    EGPoint _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGPoint)value {
    return [[EGPointWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGPoint)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGPointDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGPointWrap* o = ((EGPointWrap*)other);
    return EGPointEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGPointHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



EGPointI egPointIApply(EGPoint point) {
    return EGPointIMake(lround(point.x), lround(point.y));
}
EGPointI egPointIAdd(EGPointI self, EGPointI point) {
    return EGPointIMake(self.x + point.x, self.y + point.y);
}
EGPointI egPointISub(EGPointI self, EGPointI point) {
    return EGPointIMake(self.x - point.x, self.y - point.y);
}
EGPointI egPointINegate(EGPointI self) {
    return EGPointIMake(-self.x, -self.y);
}
@implementation EGPointIWrap{
    EGPointI _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGPointI)value {
    return [[EGPointIWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGPointI)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGPointIDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGPointIWrap* o = ((EGPointIWrap*)other);
    return EGPointIEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGPointIHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



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
    EGSizeWrap* o = ((EGSizeWrap*)other);
    return EGSizeEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGSizeHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



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
    EGSizeIWrap* o = ((EGSizeIWrap*)other);
    return EGSizeIEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGSizeIHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



BOOL egRectContains(EGRect self, EGPoint point) {
    return self.x <= point.x && point.x <= self.x + self.width && self.y <= point.y && point.y <= self.y + self.height;
}
double egRectX2(EGRect self) {
    return self.x + self.width;
}
double egRectY2(EGRect self) {
    return self.y + self.height;
}
EGRect egRectNewXY(double x, double x2, double y, double y2) {
    return EGRectMake(x, x2 - x, y, y2 - y);
}
EGRect egRectMove(EGRect self, double x, double y) {
    return EGRectMake(self.x + x, self.width, self.y + y, self.height);
}
EGRect egRectMoveToCenterFor(EGRect self, EGSize size) {
    return EGRectMake((size.width - self.width) / 2, self.width, (size.height - self.height) / 2, self.height);
}
EGPoint egRectPoint(EGRect self) {
    return EGPointMake(self.x, self.y);
}
EGSize egRectSize(EGRect self) {
    return EGSizeMake(self.width, self.height);
}
BOOL egRectIntersects(EGRect self, EGRect rect) {
    return self.x <= egRectX2(rect) && egRectX2(self) >= rect.x && self.y <= egRectY2(rect) && egRectY2(self) >= rect.y;
}
EGRect egRectThicken(EGRect self, double x, double y) {
    return EGRectMake(self.x - x, self.width + 2 * x, self.y - y, self.height + 2 * y);
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
    EGRectWrap* o = ((EGRectWrap*)other);
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
EGRectI egRectINewXY(double x, double x2, double y, double y2) {
    return EGRectIMake(((NSInteger)x), ((NSInteger)x2 - x), ((NSInteger)y), ((NSInteger)y2 - y));
}
NSInteger egRectIX2(EGRectI self) {
    return self.x + self.width;
}
NSInteger egRectIY2(EGRectI self) {
    return self.y + self.height;
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
    EGRectIWrap* o = ((EGRectIWrap*)other);
    return EGRectIEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGRectIHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



void egColorSet(EGColor self) {
    egColor4(self.r, self.g, self.b, self.a);
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
    EGColorWrap* o = ((EGColorWrap*)other);
    return EGColorEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGColorHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



