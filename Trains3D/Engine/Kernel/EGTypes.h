#import "objd.h"
#import "EGTypesAdd.h"


struct EGISize {
    NSInteger width;
    NSInteger height;
};
typedef struct EGISize EGISize;
static inline EGISize EGISizeMake(NSInteger width, NSInteger height) {
    EGISize ret;
    ret.width = width;
    ret.height = height;
    return ret;
}
static inline BOOL EGISizeEq(EGISize s1, EGISize s2) {
    return s1.width == s2.width && s1.height == s2.height;
}

struct EGIRect {
    NSInteger left;
    NSInteger top;
    NSInteger right;
    NSInteger bottom;
};
typedef struct EGIRect EGIRect;
static inline EGIRect EGIRectMake(NSInteger left, NSInteger top, NSInteger right, NSInteger bottom) {
    EGIRect ret;
    ret.left = left;
    ret.top = top;
    ret.right = right;
    ret.bottom = bottom;
    return ret;
}
static inline BOOL EGIRectEq(EGIRect s1, EGIRect s2) {
    return s1.left == s2.left && s1.top == s2.top && s1.right == s2.right && s1.bottom == s2.bottom;
}

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


