#import "objd.h"
#import "EGTypesAdd.h"


struct EGColor {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
};
typedef struct EGColor EGColor;
static inline EGColor EGColorMake(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    EGColor ret;
    ret.r = r;
    ret.g = g;
    ret.b = b;
    ret.a = a;
    return ret;
}
static inline BOOL EGColorEq(EGColor s1, EGColor s2) {
    return s1.r == s2.r && s1.g == s2.g && s1.b == s2.b && s1.a == s2.a;
}

struct EGMapPoint {
    NSInteger x;
    NSInteger y;
};
typedef struct EGMapPoint EGMapPoint;
static inline EGMapPoint EGMapPointMake(NSInteger x, NSInteger y) {
    EGMapPoint ret;
    ret.x = x;
    ret.y = y;
    return ret;
}
static inline BOOL EGMapPointEq(EGMapPoint s1, EGMapPoint s2) {
    return s1.x == s2.x && s1.y == s2.y;
}

struct EGMapSize {
    NSInteger width;
    NSInteger height;
};
typedef struct EGMapSize EGMapSize;
static inline EGMapSize EGMapSizeMake(NSInteger width, NSInteger height) {
    EGMapSize ret;
    ret.width = width;
    ret.height = height;
    return ret;
}
static inline BOOL EGMapSizeEq(EGMapSize s1, EGMapSize s2) {
    return s1.width == s2.width && s1.height == s2.height;
}

struct EGMapRect {
    NSInteger left;
    NSInteger top;
    NSInteger right;
    NSInteger bottom;
};
typedef struct EGMapRect EGMapRect;
static inline EGMapRect EGMapRectMake(NSInteger left, NSInteger top, NSInteger right, NSInteger bottom) {
    EGMapRect ret;
    ret.left = left;
    ret.top = top;
    ret.right = right;
    ret.bottom = bottom;
    return ret;
}
static inline BOOL EGMapRectEq(EGMapRect s1, EGMapRect s2) {
    return s1.left == s2.left && s1.top == s2.top && s1.right == s2.right && s1.bottom == s2.bottom;
}

@protocol EGController
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGCamera
- (void)focusForViewSize:(CGSize)viewSize;
- (CGPoint)translateViewPoint:(CGPoint)viewPoint withViewSize:(CGSize)withViewSize;
@end


@protocol EGView
- (id)camera;
- (void)drawView;
@end


