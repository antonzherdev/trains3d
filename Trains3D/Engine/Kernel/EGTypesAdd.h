#import <math.h>

static inline BOOL CGPointEq(CGPoint p1, CGPoint p2) {
    return eqf(p1.x, p2.x) && eqf(p1.y, p2.y);
}

static inline CGPoint egp( CGFloat x, CGFloat y ) {
    return CGPointMake(x, y);
}

static inline CGFloat egpDot(const CGPoint v1, const CGPoint v2) {
    return v1.x*v2.x + v1.y*v2.y;
}

static inline CGPoint egpAdd(const CGPoint v1, const CGPoint v2) {
    return egp(v1.x + v2.x, v1.y + v2.y);
}

static inline CGPoint egpSub(const CGPoint v1, const CGPoint v2) {
    return egp(v1.x - v2.x, v1.y - v2.y);
}

static inline CGFloat egpToAngle(const CGPoint v) {
    return atan2f(v.y, v.x);
}

static inline CGFloat egpLengthSQ(const CGPoint v) {
    return egpDot(v, v);
}

static inline CGFloat egpLength(const CGPoint v) {
    return sqrtf(egpLengthSQ(v));
}

static inline CGPoint egpMult(const CGPoint v, const CGFloat s) {
    return egp(v.x*s, v.y*s);
}


static inline CGPoint egpMidpoint(const CGPoint v1, const CGPoint v2) {
    return egpMult(egpAdd(v1, v2), 0.5f);
}



static inline CGFloat egpDistance(const CGPoint v1, const CGPoint v2) {
    return egpLength(egpSub(v1, v2));
}


static inline CGPoint egpSetLength(const CGPoint v, CGFloat l) {
    return egpMult(v, l/egpLength(v));
}


static inline CGPoint egpNormalize(const CGPoint v) {
    return egpSetLength(v, 1.0f);
}

struct EGIPoint {
    NSInteger x;
    NSInteger y;
};
typedef struct EGIPoint EGIPoint;
static inline EGIPoint EGIPointMake(NSInteger x, NSInteger y) {
    EGIPoint ret;
    ret.x = x;
    ret.y = y;
    return ret;
}
static inline BOOL EGIPointEq(EGIPoint s1, EGIPoint s2) {
    return s1.x == s2.x && s1.y == s2.y;
}


static inline EGIPoint egpRound(CGPoint v) {
    return EGIPointMake(lround(v.x), lround(v.y));
}

static inline CGPoint egipFloat(EGIPoint v) {
    return CGPointMake(v.x, v.y);
}

static inline EGIPoint egip(NSInteger x, NSInteger y ) {
    return EGIPointMake(x, y);
}

static inline EGIPoint egipAdd(const EGIPoint v1, const EGIPoint v2) {
    return egip(v1.x + v2.x, v1.y + v2.y);
}

static inline EGIPoint egipSub(const EGIPoint v1, const EGIPoint v2) {
    return egip(v1.x - v2.x, v1.y - v2.y);
}

static inline EGIPoint egipNeg(const EGIPoint v) {
    return egip(-v.x, -v.y);
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

static inline void egColor(EGColor color) {
    glColor4f(color.r, color.g, color.b, color.a);
}