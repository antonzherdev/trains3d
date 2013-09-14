#import "objd.h"

typedef struct GEVec2 GEVec2;
typedef struct GEVec2I GEVec2I;
typedef struct GEVec3 GEVec3;
typedef struct GEVec4 GEVec4;
typedef struct GEQuad GEQuad;
typedef struct GEQuadrant GEQuadrant;

struct GEVec2 {
    float x;
    float y;
};
static inline GEVec2 GEVec2Make(float x, float y) {
    return (GEVec2){x, y};
}
static inline BOOL GEVec2Eq(GEVec2 s1, GEVec2 s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y);
}
static inline NSUInteger GEVec2Hash(GEVec2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    return hash;
}
static inline NSString* GEVec2Description(GEVec2 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEVec2: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendString:@">"];
    return description;
}
GEVec2 geVec2ApplyVec2i(GEVec2I vec2i);
GEVec2 geVec2AddVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2SubVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2Negate(GEVec2 self);
float geVec2DegreeAngle(GEVec2 self);
float geVec2Angle(GEVec2 self);
float geVec2DotVec2(GEVec2 self, GEVec2 vec2);
float geVec2LengthSquare(GEVec2 self);
CGFloat geVec2Length(GEVec2 self);
GEVec2 geVec2MulValue(GEVec2 self, float value);
GEVec2 geVec2DivValue(GEVec2 self, float value);
GEVec2 geVec2MidVec2(GEVec2 self, GEVec2 vec2);
CGFloat geVec2DistanceToVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2SetLength(GEVec2 self, float length);
GEVec2 geVec2Normalize(GEVec2 self);
NSInteger geVec2CompareTo(GEVec2 self, GEVec2 to);
ODPType* geVec2Type();
@interface GEVec2Wrap : NSObject
@property (readonly, nonatomic) GEVec2 value;

+ (id)wrapWithValue:(GEVec2)value;
- (id)initWithValue:(GEVec2)value;
@end



struct GEVec2I {
    NSInteger x;
    NSInteger y;
};
static inline GEVec2I GEVec2IMake(NSInteger x, NSInteger y) {
    return (GEVec2I){x, y};
}
static inline BOOL GEVec2IEq(GEVec2I s1, GEVec2I s2) {
    return s1.x == s2.x && s1.y == s2.y;
}
static inline NSUInteger GEVec2IHash(GEVec2I self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.y;
    return hash;
}
static inline NSString* GEVec2IDescription(GEVec2I self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEVec2I: "];
    [description appendFormat:@"x=%li", self.x];
    [description appendFormat:@", y=%li", self.y];
    [description appendString:@">"];
    return description;
}
GEVec2I geVec2IApplyVec2(GEVec2 vec2);
GEVec2I geVec2IAddVec2i(GEVec2I self, GEVec2I vec2i);
GEVec2I geVec2ISubVec2i(GEVec2I self, GEVec2I vec2i);
GEVec2I geVec2INegate(GEVec2I self);
NSInteger geVec2ICompareTo(GEVec2I self, GEVec2I to);
ODPType* geVec2IType();
@interface GEVec2IWrap : NSObject
@property (readonly, nonatomic) GEVec2I value;

+ (id)wrapWithValue:(GEVec2I)value;
- (id)initWithValue:(GEVec2I)value;
@end



struct GEVec3 {
    float x;
    float y;
    float z;
};
static inline GEVec3 GEVec3Make(float x, float y, float z) {
    return (GEVec3){x, y, z};
}
static inline BOOL GEVec3Eq(GEVec3 s1, GEVec3 s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y) && eqf4(s1.z, s2.z);
}
static inline NSUInteger GEVec3Hash(GEVec3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    return hash;
}
static inline NSString* GEVec3Description(GEVec3 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEVec3: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", z=%f", self.z];
    [description appendString:@">"];
    return description;
}
GEVec3 geVec3ApplyVec2Z(GEVec2 vec2, float z);
GEVec3 geVec3AddV(GEVec3 self, GEVec3 v);
GEVec3 geVec3Sqr(GEVec3 self);
GEVec3 geVec3Negate(GEVec3 self);
GEVec3 geVec3MulK(GEVec3 self, float k);
CGFloat geVec3DotVec3(GEVec3 self, GEVec3 vec3);
CGFloat geVec3LengthSquare(GEVec3 self);
CGFloat geVec3Length(GEVec3 self);
GEVec3 geVec3SetLength(GEVec3 self, CGFloat length);
GEVec3 geVec3Normalize(GEVec3 self);
ODPType* geVec3Type();
@interface GEVec3Wrap : NSObject
@property (readonly, nonatomic) GEVec3 value;

+ (id)wrapWithValue:(GEVec3)value;
- (id)initWithValue:(GEVec3)value;
@end



struct GEVec4 {
    float x;
    float y;
    float z;
    float w;
};
static inline GEVec4 GEVec4Make(float x, float y, float z, float w) {
    return (GEVec4){x, y, z, w};
}
static inline BOOL GEVec4Eq(GEVec4 s1, GEVec4 s2) {
    return eqf4(s1.x, s2.x) && eqf4(s1.y, s2.y) && eqf4(s1.z, s2.z) && eqf4(s1.w, s2.w);
}
static inline NSUInteger GEVec4Hash(GEVec4 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.x);
    hash = hash * 31 + float4Hash(self.y);
    hash = hash * 31 + float4Hash(self.z);
    hash = hash * 31 + float4Hash(self.w);
    return hash;
}
static inline NSString* GEVec4Description(GEVec4 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEVec4: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", z=%f", self.z];
    [description appendFormat:@", w=%f", self.w];
    [description appendString:@">"];
    return description;
}
GEVec4 geVec4ApplyVec3W(GEVec3 vec3, float w);
GEVec3 geVec4Xyz(GEVec4 self);
GEVec4 geVec4MulK(GEVec4 self, float k);
CGFloat geVec4LengthSquare(GEVec4 self);
CGFloat geVec4Length(GEVec4 self);
GEVec4 geVec4SetLength(GEVec4 self, CGFloat length);
GEVec4 geVec4Normalize(GEVec4 self);
ODPType* geVec4Type();
@interface GEVec4Wrap : NSObject
@property (readonly, nonatomic) GEVec4 value;

+ (id)wrapWithValue:(GEVec4)value;
- (id)initWithValue:(GEVec4)value;
@end



struct GEQuad {
    GEVec2 p1;
    GEVec2 p2;
    GEVec2 p3;
    GEVec2 p4;
};
static inline GEQuad GEQuadMake(GEVec2 p1, GEVec2 p2, GEVec2 p3, GEVec2 p4) {
    return (GEQuad){p1, p2, p3, p4};
}
static inline BOOL GEQuadEq(GEQuad s1, GEQuad s2) {
    return GEVec2Eq(s1.p1, s2.p1) && GEVec2Eq(s1.p2, s2.p2) && GEVec2Eq(s1.p3, s2.p3) && GEVec2Eq(s1.p4, s2.p4);
}
static inline NSUInteger GEQuadHash(GEQuad self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.p1);
    hash = hash * 31 + GEVec2Hash(self.p2);
    hash = hash * 31 + GEVec2Hash(self.p3);
    hash = hash * 31 + GEVec2Hash(self.p4);
    return hash;
}
static inline NSString* GEQuadDescription(GEQuad self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEQuad: "];
    [description appendFormat:@"p1=%@", GEVec2Description(self.p1)];
    [description appendFormat:@", p2=%@", GEVec2Description(self.p2)];
    [description appendFormat:@", p3=%@", GEVec2Description(self.p3)];
    [description appendFormat:@", p4=%@", GEVec2Description(self.p4)];
    [description appendString:@">"];
    return description;
}
GEQuad geQuadApplySize(float size);
GEQuad geQuadMulValue(GEQuad self, float value);
GEQuad geQuadAddVec2(GEQuad self, GEVec2 vec2);
GEQuad geQuadAddXY(GEQuad self, float x, float y);
GEQuadrant geQuadQuadrant(GEQuad self);
GEQuad geQuadIdentity();
ODPType* geQuadType();
@interface GEQuadWrap : NSObject
@property (readonly, nonatomic) GEQuad value;

+ (id)wrapWithValue:(GEQuad)value;
- (id)initWithValue:(GEQuad)value;
@end



struct GEQuadrant {
    GEQuad quads[4];
};
static inline GEQuadrant GEQuadrantMake(GEQuad quads[4]) {
    return (GEQuadrant){{quads[0], quads[1], quads[2], quads[3]}};
}
static inline BOOL GEQuadrantEq(GEQuadrant s1, GEQuadrant s2) {
    return s1.quads == s2.quads;
}
static inline NSUInteger GEQuadrantHash(GEQuadrant self) {
    NSUInteger hash = 0;
    hash = hash * 31 + 13 * (13 * (13 * GEQuadHash(self.quads[0]) + GEQuadHash(self.quads[1])) + GEQuadHash(self.quads[2])) + GEQuadHash(self.quads[3]);
    return hash;
}
static inline NSString* GEQuadrantDescription(GEQuadrant self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEQuadrant: "];
    [description appendFormat:@"quads=[%@, %@, %@, %@]", GEQuadDescription(self.quads[0]), GEQuadDescription(self.quads[1]), GEQuadDescription(self.quads[2]), GEQuadDescription(self.quads[3])];
    [description appendString:@">"];
    return description;
}
GEQuad geQuadrantRandomQuad(GEQuadrant self);
ODPType* geQuadrantType();
@interface GEQuadrantWrap : NSObject
@property (readonly, nonatomic) GEQuadrant value;

+ (id)wrapWithValue:(GEQuadrant)value;
- (id)initWithValue:(GEQuadrant)value;
@end



