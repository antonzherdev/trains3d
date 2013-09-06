#import "objd.h"
#import "EGVec.h"

@class EGEnvironment;
@class EGLight;
@class EGDirectLight;
@protocol EGController;
@protocol EGCamera;
@protocol EGView;
typedef struct EGRect EGRect;
typedef struct EGRectI EGRectI;
typedef struct EGColor EGColor;

struct EGRect {
    CGFloat x;
    CGFloat width;
    CGFloat y;
    CGFloat height;
};
static inline EGRect EGRectMake(CGFloat x, CGFloat width, CGFloat y, CGFloat height) {
    return (EGRect){x, width, y, height};
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
BOOL egRectContains(EGRect self, EGVec2 point);
CGFloat egRectX2(EGRect self);
CGFloat egRectY2(EGRect self);
EGRect egRectNewXY(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2);
EGRect egRectMove(EGRect self, CGFloat x, CGFloat y);
EGRect egRectMoveToCenterFor(EGRect self, EGVec2 size);
EGVec2 egRectPoint(EGRect self);
EGVec2 egRectSize(EGRect self);
BOOL egRectIntersects(EGRect self, EGRect rect);
EGRect egRectThicken(EGRect self, CGFloat x, CGFloat y);
ODPType* egRectType();
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
    return (EGRectI){x, width, y, height};
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
ODPType* egRectIType();
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
    return (EGColor){r, g, b, a};
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
EGColor egColorWhite();
ODPType* egColorType();
@interface EGColorWrap : NSObject
@property (readonly, nonatomic) EGColor value;

+ (id)wrapWithValue:(EGColor)value;
- (id)initWithValue:(EGColor)value;
@end



@protocol EGController<NSObject>
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGCamera<NSObject>
- (void)focusForViewSize:(EGVec2)viewSize;
- (EGVec2)translateWithViewSize:(EGVec2)viewSize viewPoint:(EGVec2)viewPoint;
@end


@protocol EGView<EGController>
- (id<EGCamera>)camera;
- (void)drawView;
- (EGEnvironment*)environment;
- (void)updateWithDelta:(CGFloat)delta;
@end


@interface EGEnvironment : NSObject
@property (nonatomic, readonly) EGColor ambientColor;
@property (nonatomic, readonly) id<CNSeq> lights;

+ (id)environmentWithAmbientColor:(EGColor)ambientColor lights:(id<CNSeq>)lights;
- (id)initWithAmbientColor:(EGColor)ambientColor lights:(id<CNSeq>)lights;
- (ODClassType*)type;
+ (EGEnvironment*)applyLights:(id<CNSeq>)lights;
+ (EGEnvironment*)applyLight:(EGLight*)light;
+ (EGEnvironment*)aDefault;
+ (ODClassType*)type;
@end


@interface EGLight : NSObject
@property (nonatomic, readonly) EGColor color;

+ (id)lightWithColor:(EGColor)color;
- (id)initWithColor:(EGColor)color;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGDirectLight : EGLight
@property (nonatomic, readonly) EGVec3 direction;

+ (id)directLightWithColor:(EGColor)color direction:(EGVec3)direction;
- (id)initWithColor:(EGColor)color direction:(EGVec3)direction;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


