#import "objd.h"

typedef struct EGVec2 EGVec2;
typedef struct EGVec2I EGVec2I;
typedef struct EGVec3 EGVec3;
typedef struct EGVec4 EGVec4;
typedef struct EGQuad EGQuad;
typedef struct EGQuadrant EGQuadrant;

struct EGVec2 {
    float x;
    float y;
};
static inline EGVec2 EGVec2Make(float x, float y) {
    return (EGVec2){x, y};
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
EGVec2 egVec2ApplyVec2i(EGVec2I vec2i);
EGVec2 egVec2AddVec2(EGVec2 self, EGVec2 vec2);
EGVec2 egVec2SubVec2(EGVec2 self, EGVec2 vec2);
EGVec2 egVec2Negate(EGVec2 self);
float egVec2Angle(EGVec2 self);
float egVec2DotVec2(EGVec2 self, EGVec2 vec2);
float egVec2LengthSquare(EGVec2 self);
CGFloat egVec2Length(EGVec2 self);
EGVec2 egVec2MulValue(EGVec2 self, float value);
EGVec2 egVec2DivValue(EGVec2 self, float value);
EGVec2 egVec2MidVec2(EGVec2 self, EGVec2 vec2);
CGFloat egVec2DistanceToVec2(EGVec2 self, EGVec2 vec2);
EGVec2 egVec2SetLength(EGVec2 self, float length);
EGVec2 egVec2Normalize(EGVec2 self);
NSInteger egVec2CompareTo(EGVec2 self, EGVec2 to);
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
    return (EGVec2I){x, y};
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
EGVec2I egVec2IApplyVec2(EGVec2 vec2);
EGVec2I egVec2IAddVec2i(EGVec2I self, EGVec2I vec2i);
EGVec2I egVec2ISubVec2i(EGVec2I self, EGVec2I vec2i);
EGVec2I egVec2INegate(EGVec2I self);
NSInteger egVec2ICompareTo(EGVec2I self, EGVec2I to);
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
    return (EGVec3){x, y, z};
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
EGVec3 egVec3ApplyVec2Z(EGVec2 vec2, float z);
EGVec3 egVec3AddV(EGVec3 self, EGVec3 v);
EGVec3 egVec3Sqr(EGVec3 self);
EGVec3 egVec3MulK(EGVec3 self, float k);
CGFloat egVec3DotVec3(EGVec3 self, EGVec3 vec3);
CGFloat egVec3LengthSquare(EGVec3 self);
CGFloat egVec3Length(EGVec3 self);
EGVec3 egVec3SetLength(EGVec3 self, CGFloat length);
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
    return (EGVec4){x, y, z, w};
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
EGVec4 egVec4ApplyVec3W(EGVec3 vec3, float w);
EGVec3 egVec4Xyz(EGVec4 self);
EGVec4 egVec4MulK(EGVec4 self, float k);
CGFloat egVec4LengthSquare(EGVec4 self);
CGFloat egVec4Length(EGVec4 self);
EGVec4 egVec4SetLength(EGVec4 self, CGFloat length);
EGVec4 egVec4Normalize(EGVec4 self);
ODPType* egVec4Type();
@interface EGVec4Wrap : NSObject
@property (readonly, nonatomic) EGVec4 value;

+ (id)wrapWithValue:(EGVec4)value;
- (id)initWithValue:(EGVec4)value;
@end



struct EGQuad {
    EGVec2 p1;
    EGVec2 p2;
    EGVec2 p3;
    EGVec2 p4;
};
static inline EGQuad EGQuadMake(EGVec2 p1, EGVec2 p2, EGVec2 p3, EGVec2 p4) {
    return (EGQuad){p1, p2, p3, p4};
}
static inline BOOL EGQuadEq(EGQuad s1, EGQuad s2) {
    return EGVec2Eq(s1.p1, s2.p1) && EGVec2Eq(s1.p2, s2.p2) && EGVec2Eq(s1.p3, s2.p3) && EGVec2Eq(s1.p4, s2.p4);
}
static inline NSUInteger EGQuadHash(EGQuad self) {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec2Hash(self.p1);
    hash = hash * 31 + EGVec2Hash(self.p2);
    hash = hash * 31 + EGVec2Hash(self.p3);
    hash = hash * 31 + EGVec2Hash(self.p4);
    return hash;
}
static inline NSString* EGQuadDescription(EGQuad self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGQuad: "];
    [description appendFormat:@"p1=%@", EGVec2Description(self.p1)];
    [description appendFormat:@", p2=%@", EGVec2Description(self.p2)];
    [description appendFormat:@", p3=%@", EGVec2Description(self.p3)];
    [description appendFormat:@", p4=%@", EGVec2Description(self.p4)];
    [description appendString:@">"];
    return description;
}
EGQuad egQuadApplySize(float size);
EGQuad egQuadMulValue(EGQuad self, float value);
EGQuad egQuadAddVec2(EGQuad self, EGVec2 vec2);
EGQuad egQuadAddXY(EGQuad self, float x, float y);
EGQuadrant egQuadQuadrant(EGQuad self);
EGQuad egQuadIdentity();
ODPType* egQuadType();
@interface EGQuadWrap : NSObject
@property (readonly, nonatomic) EGQuad value;

+ (id)wrapWithValue:(EGQuad)value;
- (id)initWithValue:(EGQuad)value;
@end



struct EGQuadrant {
    EGQuad quads[4];
};
static inline EGQuadrant EGQuadrantMake(EGQuad quads[4]) {
    return (EGQuadrant){{quads[0], quads[1], quads[2], quads[3]}};
}
static inline BOOL EGQuadrantEq(EGQuadrant s1, EGQuadrant s2) {
    return s1.quads == s2.quads;
}
static inline NSUInteger EGQuadrantHash(EGQuadrant self) {
    NSUInteger hash = 0;
    hash = hash * 31 + 13 * (13 * (13 * EGQuadHash(self.quads[0]) + EGQuadHash(self.quads[1])) + EGQuadHash(self.quads[2])) + EGQuadHash(self.quads[3]);
    return hash;
}
static inline NSString* EGQuadrantDescription(EGQuadrant self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGQuadrant: "];
    [description appendFormat:@"quads=[%@, %@, %@, %@]", EGQuadDescription(self.quads[0]), EGQuadDescription(self.quads[1]), EGQuadDescription(self.quads[2]), EGQuadDescription(self.quads[3])];
    [description appendString:@">"];
    return description;
}
EGQuad egQuadrantRandomQuad(EGQuadrant self);
ODPType* egQuadrantType();
@interface EGQuadrantWrap : NSObject
@property (readonly, nonatomic) EGQuadrant value;

+ (id)wrapWithValue:(EGQuadrant)value;
- (id)initWithValue:(EGQuadrant)value;
@end



