#import "objd.h"

@protocol EGController;
@protocol EGCamera;
@protocol EGView;
typedef struct EGPoint EGPoint;
typedef struct EGPointI EGPointI;
typedef struct EGSize EGSize;
typedef struct EGSizeI EGSizeI;
typedef struct EGRect EGRect;
typedef struct EGRectI EGRectI;
typedef struct EGColor EGColor;

struct EGPoint {
    CGFloat x;
    CGFloat y;
};
static inline EGPoint EGPointMake(CGFloat x, CGFloat y) {
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
    hash = hash * 31 + floatHash(self.x);
    hash = hash * 31 + floatHash(self.y);
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
CGFloat egPointAngle(EGPoint self);
CGFloat egPointDot(EGPoint self, EGPoint point);
CGFloat egPointLengthSquare(EGPoint self);
CGFloat egPointLength(EGPoint self);
EGPoint egPointMul(EGPoint self, CGFloat value);
EGPoint egPointDiv(EGPoint self, CGFloat value);
EGPoint egPointMid(EGPoint self, EGPoint point);
CGFloat egPointDistanceTo(EGPoint self, EGPoint point);
EGPoint egPointSet(EGPoint self, CGFloat length);
EGPoint egPointNormalize(EGPoint self);
NSInteger egPointCompare(EGPoint self, EGPoint to);
@interface EGPointWrap : NSObject
@property (readonly, nonatomic) EGPoint value;

+ (id)wrapWithValue:(EGPoint)value;
- (id)initWithValue:(EGPoint)value;
@end



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
NSInteger egPointICompare(EGPointI self, EGPointI to);
@interface EGPointIWrap : NSObject
@property (readonly, nonatomic) EGPointI value;

+ (id)wrapWithValue:(EGPointI)value;
- (id)initWithValue:(EGPointI)value;
@end



struct EGSize {
    CGFloat width;
    CGFloat height;
};
static inline EGSize EGSizeMake(CGFloat width, CGFloat height) {
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
    hash = hash * 31 + floatHash(self.width);
    hash = hash * 31 + floatHash(self.height);
    return hash;
}
static inline NSString* EGSizeDescription(EGSize self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGSize: "];
    [description appendFormat:@"width=%f", self.width];
    [description appendFormat:@", height=%f", self.height];
    [description appendString:@">"];
    return description;
}
@interface EGSizeWrap : NSObject
@property (readonly, nonatomic) EGSize value;

+ (id)wrapWithValue:(EGSize)value;
- (id)initWithValue:(EGSize)value;
@end



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
@interface EGSizeIWrap : NSObject
@property (readonly, nonatomic) EGSizeI value;

+ (id)wrapWithValue:(EGSizeI)value;
- (id)initWithValue:(EGSizeI)value;
@end



struct EGRect {
    CGFloat x;
    CGFloat width;
    CGFloat y;
    CGFloat height;
};
static inline EGRect EGRectMake(CGFloat x, CGFloat width, CGFloat y, CGFloat height) {
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
    hash = hash * 31 + floatHash(self.x);
    hash = hash * 31 + floatHash(self.width);
    hash = hash * 31 + floatHash(self.y);
    hash = hash * 31 + floatHash(self.height);
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
CGFloat egRectX2(EGRect self);
CGFloat egRectY2(EGRect self);
EGRect egRectNewXY(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2);
EGRect egRectMove(EGRect self, CGFloat x, CGFloat y);
EGRect egRectMoveToCenterFor(EGRect self, EGSize size);
EGPoint egRectPoint(EGRect self);
EGSize egRectSize(EGRect self);
BOOL egRectIntersects(EGRect self, EGRect rect);
EGRect egRectThicken(EGRect self, CGFloat x, CGFloat y);
@interface EGRectWrap : NSObject
@property (readonly, nonatomic) EGRect value;

+ (id)wrapWithValue:(EGRect)value;
- (id)initWithValue:(EGRect)value;
@end



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
EGRectI egRectINewXY(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2);
NSInteger egRectIX2(EGRectI self);
NSInteger egRectIY2(EGRectI self);
@interface EGRectIWrap : NSObject
@property (readonly, nonatomic) EGRectI value;

+ (id)wrapWithValue:(EGRectI)value;
- (id)initWithValue:(EGRectI)value;
@end



struct EGColor {
    CGFloat r;
    CGFloat g;
    CGFloat b;
    CGFloat a;
};
static inline EGColor EGColorMake(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
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
    hash = hash * 31 + floatHash(self.r);
    hash = hash * 31 + floatHash(self.g);
    hash = hash * 31 + floatHash(self.b);
    hash = hash * 31 + floatHash(self.a);
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
void egColorSetMaterial(EGColor self);
@interface EGColorWrap : NSObject
@property (readonly, nonatomic) EGColor value;

+ (id)wrapWithValue:(EGColor)value;
- (id)initWithValue:(EGColor)value;
@end



@protocol EGController<NSObject>
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGCamera<NSObject>
- (void)focusForViewSize:(EGSize)viewSize;
- (EGPoint)translateWithViewSize:(EGSize)viewSize viewPoint:(EGPoint)viewPoint;
@end


@protocol EGView<NSObject>
- (id<EGCamera>)camera;
- (void)drawView;
@end


