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

struct EGTilePoint {
    NSInteger x;
    NSInteger y;
};
typedef struct EGTilePoint EGTilePoint;
static inline EGTilePoint EGTilePointMake(NSInteger x, NSInteger y) {
    EGTilePoint ret;
    ret.x = x;
    ret.y = y;
    return ret;
}

