#import "objd.h"

typedef struct EGVec2 EGVec2;
typedef struct EGVec2I EGVec2I;
typedef struct EGVec3 EGVec3;
typedef struct EGVec4 EGVec4;

struct EGVec2 {
    float x;
    float y;
};
static inline EGVec2 EGVec2Make(float x, float y) {
    EGVec2 ret;
    ret.x = x;
    ret.y = y;
    return ret;
}
static inline BOOL EGVec2Eq(EGVec2 s1, EGVec2 s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y);
}
static inline NSUInteger EGVec2Hash(EGVec2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
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
float egVec2Angle(EGVec2 self);
float egVec2Dot(EGVec2 self, EGVec2 point);
float egVec2LengthSquare(EGVec2 self);
CGFloat egVec2Length(EGVec2 self);
EGVec2 egVec2Mul(EGVec2 self, float value);
EGVec2 egVec2Div(EGVec2 self, float value);
EGVec2 egVec2Mid(EGVec2 self, EGVec2 point);
CGFloat egVec2DistanceTo(EGVec2 self, EGVec2 point);
EGVec2 egVec2Set(EGVec2 self, float length);
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
EGVec3 egVec3Set(EGVec3 self, CGFloat length);
EGVec3 egVec3Normalize(EGVec3 self);
ODPType* egVec3Type();
@interface EGVec3Wrap : NSObject
@property (readonly, nonatomic) EGVec3 value;

+ (id)wrapWithValue:(EGVec3)value;
- (id)initWithValue:(EGVec3)value;
@end



struct EGVec4 {
    float x;
    float y;
    float z;
    float w;
};
static inline EGVec4 EGVec4Make(float x, float y, float z, float w) {
    EGVec4 ret;
    ret.x = x;
    ret.y = y;
    ret.z = z;
    ret.w = w;
    return ret;
}
static inline BOOL EGVec4Eq(EGVec4 s1, EGVec4 s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y) && eqf4(s1.z, s2.z) && eqf4(s1.w, s2.w);
}
static inline NSUInteger EGVec4Hash(EGVec4 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    hash = hash * 31 + float4Hash(self.w);
    return hash;
}
static inline NSString* EGVec4Description(EGVec4 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGVec4: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", z=%f", self.z];
    [description appendFormat:@", w=%f", self.w];
    [description appendString:@">"];
    return description;
}
EGVec4 egVec4Apply(EGVec3 vec3, float w);
EGVec3 egVec4Xyz(EGVec4 self);
EGVec4 egVec4Mul(EGVec4 self, float k);
CGFloat egVec4LengthSquare(EGVec4 self);
CGFloat egVec4Length(EGVec4 self);
EGVec4 egVec4Set(EGVec4 self, CGFloat length);
EGVec4 egVec4Normalize(EGVec4 self);
ODPType* egVec4Type();
@interface EGVec4Wrap : NSObject
@property (readonly, nonatomic) EGVec4 value;

+ (id)wrapWithValue:(EGVec4)value;
- (id)initWithValue:(EGVec4)value;
@end



