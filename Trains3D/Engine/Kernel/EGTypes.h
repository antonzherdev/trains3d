#import <Foundation/Foundation.h>

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

@protocol EGController
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGView
- (void)drawController:(id)controller viewSize:(CGSize)viewSize;
@end


