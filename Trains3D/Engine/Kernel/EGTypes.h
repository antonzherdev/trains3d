#import "objd.h"
#import "EGTypesAdd.h"

typedef struct EGPoint EGPoint;
typedef struct EGPointI EGPointI;
typedef struct EGSize EGSize;
typedef struct EGSizeI EGSizeI;
typedef struct EGRect EGRect;
typedef struct EGRectI EGRectI;
typedef struct EGColor EGColor;

struct EGPoint {
    double x;
    double y;
};
static inline EGPoint EGPointMake(double x, double y) {
    EGPoint ret;
    ret.x = x;
    ret.y = y;
    return ret;
}
static inline BOOL EGPointEq(EGPoint s1, EGPoint s2) {
    return eqf(s1.x, s2.x) && eqf(s1.y, s2.y);
}
static inline NSUInteger EGPointHash(EGPoint self) {
    NSUInteger hash = 0;
    hash = hash * 31 + [[NSNumber numberWithDouble:self.x] hash];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.y] hash];
    return hash;
}
static inline NSString* EGPointDescription(EGPoint self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGPoint: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendString:@">"];
    return description;
}
EGPoint egPointApply(EGPointI point);
EGPoint egPointAdd(EGPoint self, EGPoint point);
EGPoint egPointSub(EGPoint self, EGPoint point);
EGPoint egPointNegate(EGPoint self);
double egPointAngle(EGPoint self);
double egPointDot(EGPoint self, EGPoint point);
double egPointLengthSquare(EGPoint self);
double egPointLength(EGPoint self);
EGPoint egPointMul(EGPoint self, double value);
EGPoint egPointDiv(EGPoint self, double value);
EGPoint egPointMid(EGPoint self, EGPoint point);
double egPointDistanceTo(EGPoint self, EGPoint point);
EGPoint egPointSet(EGPoint self, double length);
EGPoint egPointNormalize(EGPoint self);

struct EGPointI {
    NSInteger x;
    NSInteger y;
};
static inline EGPointI EGPointIMake(NSInteger x, NSInteger y) {
    EGPointI ret;
    ret.x = x;
    ret.y = y;
    return ret;
}
static inline BOOL EGPointIEq(EGPointI s1, EGPointI s2) {
    return s1.x == s2.x && s1.y == s2.y;
}
static inline NSUInteger EGPointIHash(EGPointI self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.y;
    return hash;
}
static inline NSString* EGPointIDescription(EGPointI self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGPointI: "];
    [description appendFormat:@"x=%li", self.x];
    [description appendFormat:@", y=%li", self.y];
    [description appendString:@">"];
    return description;
}
EGPointI egPointIApply(EGPoint point);
EGPointI egPointIAdd(EGPointI self, EGPointI point);
EGPointI egPointISub(EGPointI self, EGPointI point);
EGPointI egPointINegate(EGPointI self);

struct EGSize {
    double width;
    double height;
};
static inline EGSize EGSizeMake(double width, double height) {
    EGSize ret;
    ret.width = width;
    ret.height = height;
    return ret;
}
static inline BOOL EGSizeEq(EGSize s1, EGSize s2) {
    return eqf(s1.width, s2.width) && eqf(s1.height, s2.height);
}
static inline NSUInteger EGSizeHash(EGSize self) {
    NSUInteger hash = 0;
    hash = hash * 31 + [[NSNumber numberWithDouble:self.width] hash];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.height] hash];
    return hash;
}
static inline NSString* EGSizeDescription(EGSize self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGSize: "];
    [description appendFormat:@"width=%f", self.width];
    [description appendFormat:@", height=%f", self.height];
    [description appendString:@">"];
    return description;
}

struct EGSizeI {
    NSInteger width;
    NSInteger height;
};
static inline EGSizeI EGSizeIMake(NSInteger width, NSInteger height) {
    EGSizeI ret;
    ret.width = width;
    ret.height = height;
    return ret;
}
static inline BOOL EGSizeIEq(EGSizeI s1, EGSizeI s2) {
    return s1.width == s2.width && s1.height == s2.height;
}
static inline NSUInteger EGSizeIHash(EGSizeI self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.width;
    hash = hash * 31 + self.height;
    return hash;
}
static inline NSString* EGSizeIDescription(EGSizeI self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGSizeI: "];
    [description appendFormat:@"width=%li", self.width];
    [description appendFormat:@", height=%li", self.height];
    [description appendString:@">"];
    return description;
}

struct EGRect {
    double x;
    double width;
    double y;
    double height;
};
static inline EGRect EGRectMake(double x, double width, double y, double height) {
    EGRect ret;
    ret.x = x;
    ret.width = width;
    ret.y = y;
    ret.height = height;
    return ret;
}
static inline BOOL EGRectEq(EGRect s1, EGRect s2) {
    return eqf(s1.x, s2.x) && eqf(s1.width, s2.width) && eqf(s1.y, s2.y) && eqf(s1.height, s2.height);
}
static inline NSUInteger EGRectHash(EGRect self) {
    NSUInteger hash = 0;
    hash = hash * 31 + [[NSNumber numberWithDouble:self.x] hash];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.width] hash];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.y] hash];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.height] hash];
    return hash;
}
static inline NSString* EGRectDescription(EGRect self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGRect: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", width=%f", self.width];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", height=%f", self.height];
    [description appendString:@">"];
    return description;
}
BOOL egRectContains(EGRect self, EGPoint point);
double egRectX2(EGRect self);
double egRectY2(EGRect self);
EGRect egRectNewXY(double x, double x2, double y, double y2);
EGRect egRectMove(EGRect self, double x, double y);
EGRect egRectMoveToCenterFor(EGRect self, EGSize size);
EGPoint egRectPoint(EGRect self);
EGSize egRectSize(EGRect self);

struct EGRectI {
    NSInteger x;
    NSInteger width;
    NSInteger y;
    NSInteger height;
};
static inline EGRectI EGRectIMake(NSInteger x, NSInteger width, NSInteger y, NSInteger height) {
    EGRectI ret;
    ret.x = x;
    ret.width = width;
    ret.y = y;
    ret.height = height;
    return ret;
}
static inline BOOL EGRectIEq(EGRectI s1, EGRectI s2) {
    return s1.x == s2.x && s1.width == s2.width && s1.y == s2.y && s1.height == s2.height;
}
static inline NSUInteger EGRectIHash(EGRectI self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.width;
    hash = hash * 31 + self.y;
    hash = hash * 31 + self.height;
    return hash;
}
static inline NSString* EGRectIDescription(EGRectI self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGRectI: "];
    [description appendFormat:@"x=%li", self.x];
    [description appendFormat:@", width=%li", self.width];
    [description appendFormat:@", y=%li", self.y];
    [description appendFormat:@", height=%li", self.height];
    [description appendString:@">"];
    return description;
}
EGRectI egRectIApply(EGRect rect);
EGRectI egRectINewXY(double x, double x2, double y, double y2);
NSInteger egRectIX2(EGRectI self);
NSInteger egRectIY2(EGRectI self);

struct EGColor {
    double r;
    double g;
    double b;
    double a;
};
static inline EGColor EGColorMake(double r, double g, double b, double a) {
    EGColor ret;
    ret.r = r;
    ret.g = g;
    ret.b = b;
    ret.a = a;
    return ret;
}
static inline BOOL EGColorEq(EGColor s1, EGColor s2) {
    return eqf(s1.r, s2.r) && eqf(s1.g, s2.g) && eqf(s1.b, s2.b) && eqf(s1.a, s2.a);
}
static inline NSUInteger EGColorHash(EGColor self) {
    NSUInteger hash = 0;
    hash = hash * 31 + [[NSNumber numberWithDouble:self.r] hash];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.g] hash];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.b] hash];
    hash = hash * 31 + [[NSNumber numberWithDouble:self.a] hash];
    return hash;
}
static inline NSString* EGColorDescription(EGColor self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGColor: "];
    [description appendFormat:@"r=%f", self.r];
    [description appendFormat:@", g=%f", self.g];
    [description appendFormat:@", b=%f", self.b];
    [description appendFormat:@", a=%f", self.a];
    [description appendString:@">"];
    return description;
}
void egColorSet(EGColor self);

@protocol EGController<NSObject>
- (void)updateWithDelta:(double)delta;
@end


@protocol EGCamera<NSObject>
- (void)focusForViewSize:(EGSize)viewSize;
- (EGPoint)translateWithViewSize:(EGSize)viewSize viewPoint:(EGPoint)viewPoint;
@end


@protocol EGView<NSObject>
- (id<EGCamera>)camera;
- (void)drawView;
@end


