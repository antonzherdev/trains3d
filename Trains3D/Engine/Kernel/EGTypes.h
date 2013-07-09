#import "objd.h"
#import "EGTypesAdd.h"

typedef struct EGISize EGISize;
typedef struct EGIRect EGIRect;

struct EGISize {
    NSInteger width;
    NSInteger height;
};
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


