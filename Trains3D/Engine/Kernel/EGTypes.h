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
EGPoint egPointApply(EGPointI point);
EGPoint egPointAdd(EGPoint self, EGPoint point);
EGPoint egPointSub(EGPoint self, EGPoint point);
EGPoint egPointNegate(EGPoint self);
double egPointAngle(EGPoint self);
double egPointDot(EGPoint self, EGPoint point);
double egPointLengthSquare(EGPoint self);
double egPointLength(EGPoint self);
EGPoint egPointMul(EGPoint self, double value);
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

struct EGRect {
    double left;
    double right;
    double top;
    double bottom;
};
static inline EGRect EGRectMake(double left, double right, double top, double bottom) {
    EGRect ret;
    ret.left = left;
    ret.right = right;
    ret.top = top;
    ret.bottom = bottom;
    return ret;
}
static inline BOOL EGRectEq(EGRect s1, EGRect s2) {
    return eqf(s1.left, s2.left) && eqf(s1.right, s2.right) && eqf(s1.top, s2.top) && eqf(s1.bottom, s2.bottom);
}
BOOL egRectContains(EGRect self, EGPoint point);

struct EGRectI {
    NSInteger left;
    NSInteger right;
    NSInteger top;
    NSInteger bottom;
};
static inline EGRectI EGRectIMake(NSInteger left, NSInteger right, NSInteger top, NSInteger bottom) {
    EGRectI ret;
    ret.left = left;
    ret.right = right;
    ret.top = top;
    ret.bottom = bottom;
    return ret;
}
static inline BOOL EGRectIEq(EGRectI s1, EGRectI s2) {
    return s1.left == s2.left && s1.right == s2.right && s1.top == s2.top && s1.bottom == s2.bottom;
}

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
void egColorSet(EGColor self);

@protocol EGController<NSObject>
- (void)updateWithDelta:(double)delta;
@end


@protocol EGCamera<NSObject>
- (void)focusForViewSize:(EGSize)viewSize;
- (EGPoint)translateViewPoint:(EGPoint)viewPoint withViewSize:(EGSize)withViewSize;
@end


@protocol EGView<NSObject>
- (id<EGCamera>)camera;
- (void)drawView;
@end


