#import "objd.h"

@class EGEnvironment;
@class EGLight;
@class EGDirectLight;
@protocol EGController;
@protocol EGCamera;
@protocol EGView;
typedef struct EGVec2 EGVec2;
typedef struct EGVec2I EGVec2I;
typedef struct EGSize EGSize;
typedef struct EGSizeI EGSizeI;
typedef struct EGRect EGRect;
typedef struct EGRectI EGRectI;
typedef struct EGColor EGColor;
typedef struct EGVec3 EGVec3;

struct EGVec2 {
    CGFloat x;
    CGFloat y;
};
static inline EGVec2 EGVec2Make(CGFloat x, CGFloat y) {
    EGVec2 ret;
    ret.x = x;
    ret.y = y;
    return ret;
}
static inline BOOL EGVec2Eq(EGVec2 s1, EGVec2 s2) {
    return eqf(s1.x, s2.x) && eqf(s1.y, s2.y);
}
static inline NSUInteger EGVec2Hash(EGVec2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.x);
    hash = hash * 31 + floatHash(self.y);
    return hash;
}
static inline NSString* EGVec2Description(EGVec2 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGVec2: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendString:@">"];
    return description;
}
EGVec2 egVec2Apply(EGVec2I point);
EGVec2 egVec2Add(EGVec2 self, EGVec2 point);
EGVec2 egVec2Sub(EGVec2 self, EGVec2 point);
EGVec2 egVec2Negate(EGVec2 self);
CGFloat egVec2Angle(EGVec2 self);
CGFloat egVec2Dot(EGVec2 self, EGVec2 point);
CGFloat egVec2LengthSquare(EGVec2 self);
CGFloat egVec2Length(EGVec2 self);
EGVec2 egVec2Mul(EGVec2 self, CGFloat value);
EGVec2 egVec2Div(EGVec2 self, CGFloat value);
EGVec2 egVec2Mid(EGVec2 self, EGVec2 point);
CGFloat egVec2DistanceTo(EGVec2 self, EGVec2 point);
EGVec2 egVec2Set(EGVec2 self, CGFloat length);
EGVec2 egVec2Normalize(EGVec2 self);
NSInteger egVec2Compare(EGVec2 self, EGVec2 to);
ODPType* egVec2Type();
@interface EGVec2Wrap : NSObject
@property (readonly, nonatomic) EGVec2 value;

+ (id)wrapWithValue:(EGVec2)value;
- (id)initWithValue:(EGVec2)value;
@end



struct EGVec2I {
    NSInteger x;
    NSInteger y;
};
static inline EGVec2I EGVec2IMake(NSInteger x, NSInteger y) {
    EGVec2I ret;
    ret.x = x;
    ret.y = y;
    return ret;
}
static inline BOOL EGVec2IEq(EGVec2I s1, EGVec2I s2) {
    return s1.x == s2.x && s1.y == s2.y;
}
static inline NSUInteger EGVec2IHash(EGVec2I self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.y;
    return hash;
}
static inline NSString* EGVec2IDescription(EGVec2I self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGVec2I: "];
    [description appendFormat:@"x=%li", self.x];
    [description appendFormat:@", y=%li", self.y];
    [description appendString:@">"];
    return description;
}
EGVec2I egVec2IApply(EGVec2 point);
EGVec2I egVec2IAdd(EGVec2I self, EGVec2I point);
EGVec2I egVec2ISub(EGVec2I self, EGVec2I point);
EGVec2I egVec2INegate(EGVec2I self);
NSInteger egVec2ICompare(EGVec2I self, EGVec2I to);
ODPType* egVec2IType();
@interface EGVec2IWrap : NSObject
@property (readonly, nonatomic) EGVec2I value;

+ (id)wrapWithValue:(EGVec2I)value;
- (id)initWithValue:(EGVec2I)value;
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
ODPType* egSizeType();
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
ODPType* egSizeIType();
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
BOOL egRectContains(EGRect self, EGVec2 point);
CGFloat egRectX2(EGRect self);
CGFloat egRectY2(EGRect self);
EGRect egRectNewXY(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2);
EGRect egRectMove(EGRect self, CGFloat x, CGFloat y);
EGRect egRectMoveToCenterFor(EGRect self, EGSize size);
EGVec2 egRectPoint(EGRect self);
EGSize egRectSize(EGRect self);
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
- (void)focusForViewSize:(EGSize)viewSize;
- (EGVec2)translateWithViewSize:(EGSize)viewSize viewPoint:(EGVec2)viewPoint;
- (EGVec3)eyeDirection;
@end


@protocol EGView<EGController>
- (id<EGCamera>)camera;
- (void)drawView;
- (EGEnvironment*)environment;
- (void)updateWithDelta:(CGFloat)delta;
@end


struct EGVec3 {
    float x;
    float y;
    float z;
};
static inline EGVec3 EGVec3Make(float x, float y, float z) {
    EGVec3 ret;
    ret.x = x;
    ret.y = y;
    ret.z = z;
    return ret;
}
static inline BOOL EGVec3Eq(EGVec3 s1, EGVec3 s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y) && eqf4(s1.z, s2.z);
}
static inline NSUInteger EGVec3Hash(EGVec3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    return hash;
}
static inline NSString* EGVec3Description(EGVec3 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGVec3: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", z=%f", self.z];
    [description appendString:@">"];
    return description;
}
EGVec3 egVec3Apply(EGVec2 vec2, float z);
EGVec3 egVec3Add(EGVec3 self, EGVec3 v);
EGVec3 egVec3Sqr(EGVec3 self);
EGVec3 egVec3Mul(EGVec3 self, float k);
CGFloat egVec3Dot(EGVec3 self, EGVec3 vec3);
CGFloat egVec3LengthSquare(EGVec3 self);
CGFloat egVec3Length(EGVec3 self);
ODPType* egVec3Type();
@interface EGVec3Wrap : NSObject
@property (readonly, nonatomic) EGVec3 value;

+ (id)wrapWithValue:(EGVec3)value;
- (id)initWithValue:(EGVec3)value;
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


