#import "objd.h"
@class GEMat4;

typedef struct GEVec2 GEVec2;
typedef struct GEVec2i GEVec2i;
typedef struct GEVec3 GEVec3;
typedef struct GEVec4 GEVec4;
typedef struct GEQuad GEQuad;
typedef struct GEQuadrant GEQuadrant;
typedef struct GERect GERect;
typedef struct GERectI GERectI;

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
NSString* GEVec2Description(GEVec2 self);
GEVec2 geVec2ApplyVec2i(GEVec2i vec2i);
GEVec2 geVec2AddVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2AddF4(GEVec2 self, float f4);
GEVec2 geVec2AddF(GEVec2 self, CGFloat f);
GEVec2 geVec2AddI(GEVec2 self, NSInteger i);
GEVec2 geVec2SubVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2SubF4(GEVec2 self, float f4);
GEVec2 geVec2SubF(GEVec2 self, CGFloat f);
GEVec2 geVec2SubI(GEVec2 self, NSInteger i);
GEVec2 geVec2MulVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2MulF4(GEVec2 self, float f4);
GEVec2 geVec2MulF(GEVec2 self, CGFloat f);
GEVec2 geVec2MulI(GEVec2 self, NSInteger i);
GEVec2 geVec2DivVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2DivF4(GEVec2 self, float f4);
GEVec2 geVec2DivF(GEVec2 self, CGFloat f);
GEVec2 geVec2DivI(GEVec2 self, NSInteger i);
GEVec2 geVec2Negate(GEVec2 self);
float geVec2DegreeAngle(GEVec2 self);
float geVec2Angle(GEVec2 self);
float geVec2DotVec2(GEVec2 self, GEVec2 vec2);
float geVec2LengthSquare(GEVec2 self);
CGFloat geVec2Length(GEVec2 self);
GEVec2 geVec2MidVec2(GEVec2 self, GEVec2 vec2);
CGFloat geVec2DistanceToVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2SetLength(GEVec2 self, float length);
GEVec2 geVec2Normalize(GEVec2 self);
NSInteger geVec2CompareTo(GEVec2 self, GEVec2 to);
GERect geVec2RectToVec2(GEVec2 self, GEVec2 vec2);
GERect geVec2RectInCenterWithSize(GEVec2 self, GEVec2 size);
GEVec2 geVec2Rnd();
ODPType* geVec2Type();
@interface GEVec2Wrap : NSObject
@property (readonly, nonatomic) GEVec2 value;

+ (id)wrapWithValue:(GEVec2)value;
- (id)initWithValue:(GEVec2)value;
@end



struct GEVec2i {
    NSInteger x;
    NSInteger y;
};
static inline GEVec2i GEVec2iMake(NSInteger x, NSInteger y) {
    return (GEVec2i){x, y};
}
static inline BOOL GEVec2iEq(GEVec2i s1, GEVec2i s2) {
    return s1.x == s2.x && s1.y == s2.y;
}
static inline NSUInteger GEVec2iHash(GEVec2i self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.y;
    return hash;
}
NSString* GEVec2iDescription(GEVec2i self);
GEVec2i geVec2iApplyVec2(GEVec2 vec2);
GEVec2i geVec2iAddVec2i(GEVec2i self, GEVec2i vec2i);
GEVec2i geVec2iSubVec2i(GEVec2i self, GEVec2i vec2i);
GEVec2 geVec2iDivF4(GEVec2i self, float f4);
GEVec2 geVec2iDivF(GEVec2i self, CGFloat f);
GEVec2i geVec2iDivI(GEVec2i self, NSInteger i);
GEVec2i geVec2iNegate(GEVec2i self);
NSInteger geVec2iCompareTo(GEVec2i self, GEVec2i to);
GERectI geVec2iRectToVec2i(GEVec2i self, GEVec2i vec2i);
ODPType* geVec2iType();
@interface GEVec2iWrap : NSObject
@property (readonly, nonatomic) GEVec2i value;

+ (id)wrapWithValue:(GEVec2i)value;
- (id)initWithValue:(GEVec2i)value;
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
NSString* GEVec3Description(GEVec3 self);
GEVec3 geVec3ApplyVec2Z(GEVec2 vec2, float z);
GEVec3 geVec3AddVec3(GEVec3 self, GEVec3 vec3);
GEVec3 geVec3SubVec3(GEVec3 self, GEVec3 vec3);
GEVec3 geVec3Sqr(GEVec3 self);
GEVec3 geVec3Negate(GEVec3 self);
GEVec3 geVec3MulK(GEVec3 self, float k);
float geVec3DotVec3(GEVec3 self, GEVec3 vec3);
GEVec3 geVec3CrossVec3(GEVec3 self, GEVec3 vec3);
float geVec3LengthSquare(GEVec3 self);
CGFloat geVec3Length(GEVec3 self);
GEVec3 geVec3SetLength(GEVec3 self, float length);
GEVec3 geVec3Normalize(GEVec3 self);
GEVec2 geVec3Xy(GEVec3 self);
GEVec3 geVec3Rnd();
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
NSString* GEVec4Description(GEVec4 self);
GEVec4 geVec4ApplyVec3W(GEVec3 vec3, float w);
GEVec3 geVec4Xyz(GEVec4 self);
GEVec2 geVec4Xy(GEVec4 self);
GEVec4 geVec4MulK(GEVec4 self, float k);
GEVec4 geVec4DivMat4(GEVec4 self, GEMat4* mat4);
GEVec4 geVec4DivF4(GEVec4 self, float f4);
GEVec4 geVec4DivF(GEVec4 self, CGFloat f);
GEVec4 geVec4DivI(GEVec4 self, NSInteger i);
float geVec4LengthSquare(GEVec4 self);
CGFloat geVec4Length(GEVec4 self);
GEVec4 geVec4SetLength(GEVec4 self, float length);
GEVec4 geVec4Normalize(GEVec4 self);
ODPType* geVec4Type();
@interface GEVec4Wrap : NSObject
@property (readonly, nonatomic) GEVec4 value;

+ (id)wrapWithValue:(GEVec4)value;
- (id)initWithValue:(GEVec4)value;
@end



struct GEQuad {
    GEVec2 p[4];
};
static inline GEQuad GEQuadMake(GEVec2 p[4]) {
    return (GEQuad){{p[0], p[1], p[2], p[3]}};
}
static inline BOOL GEQuadEq(GEQuad s1, GEQuad s2) {
    return s1.p == s2.p;
}
static inline NSUInteger GEQuadHash(GEQuad self) {
    NSUInteger hash = 0;
    hash = hash * 31 + 13 * (13 * (13 * GEVec2Hash(self.p[0]) + GEVec2Hash(self.p[1])) + GEVec2Hash(self.p[2])) + GEVec2Hash(self.p[3]);
    return hash;
}
NSString* GEQuadDescription(GEQuad self);
GEQuad geQuadApplyP0P1P2P3(GEVec2 p0, GEVec2 p1, GEVec2 p2, GEVec2 p3);
GEQuad geQuadApplySize(float size);
GEQuad geQuadMulValue(GEQuad self, float value);
GEQuad geQuadAddVec2(GEQuad self, GEVec2 vec2);
GEQuad geQuadAddXY(GEQuad self, float x, float y);
GEQuadrant geQuadQuadrant(GEQuad self);
GEVec2 geQuadApplyIndex(GEQuad self, NSUInteger index);
GERect geQuadBoundingRect(GEQuad self);
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
NSString* GEQuadrantDescription(GEQuadrant self);
GEQuad geQuadrantRndQuad(GEQuadrant self);
ODPType* geQuadrantType();
@interface GEQuadrantWrap : NSObject
@property (readonly, nonatomic) GEQuadrant value;

+ (id)wrapWithValue:(GEQuadrant)value;
- (id)initWithValue:(GEQuadrant)value;
@end



struct GERect {
    GEVec2 p0;
    GEVec2 size;
};
static inline GERect GERectMake(GEVec2 p0, GEVec2 size) {
    return (GERect){p0, size};
}
static inline BOOL GERectEq(GERect s1, GERect s2) {
    return GEVec2Eq(s1.p0, s2.p0) && GEVec2Eq(s1.size, s2.size);
}
static inline NSUInteger GERectHash(GERect self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.p0);
    hash = hash * 31 + GEVec2Hash(self.size);
    return hash;
}
NSString* GERectDescription(GERect self);
GERect geRectApplyXYWidthHeight(float x, float y, float width, float height);
float geRectX(GERect self);
float geRectY(GERect self);
float geRectX2(GERect self);
float geRectY2(GERect self);
float geRectWidth(GERect self);
float geRectHeight(GERect self);
BOOL geRectContainsVec2(GERect self, GEVec2 vec2);
GERect geRectAddVec2(GERect self, GEVec2 vec2);
GERect geRectSubVec2(GERect self, GEVec2 vec2);
GERect geRectMulF(GERect self, CGFloat f);
GERect geRectMulVec2(GERect self, GEVec2 vec2);
BOOL geRectIntersectsRect(GERect self, GERect rect);
GERect geRectThickenHalfSize(GERect self, GEVec2 halfSize);
GERect geRectDivVec2(GERect self, GEVec2 vec2);
GEVec2 geRectP1(GERect self);
GEVec2 geRectP2(GERect self);
GEVec2 geRectP3(GERect self);
GERect geRectMoveToCenterForSize(GERect self, GEVec2 size);
GEQuad geRectQuad(GERect self);
GEQuad geRectUpsideDownQuad(GERect self);
GERect geRectCenterX(GERect self);
GERect geRectCenterY(GERect self);
ODPType* geRectType();
@interface GERectWrap : NSObject
@property (readonly, nonatomic) GERect value;

+ (id)wrapWithValue:(GERect)value;
- (id)initWithValue:(GERect)value;
@end



struct GERectI {
    GEVec2i origin;
    GEVec2i size;
};
static inline GERectI GERectIMake(GEVec2i origin, GEVec2i size) {
    return (GERectI){origin, size};
}
static inline BOOL GERectIEq(GERectI s1, GERectI s2) {
    return GEVec2iEq(s1.origin, s2.origin) && GEVec2iEq(s1.size, s2.size);
}
static inline NSUInteger GERectIHash(GERectI self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.origin);
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}
NSString* GERectIDescription(GERectI self);
GERectI geRectIApplyXYWidthHeight(float x, float y, float width, float height);
GERectI geRectIApplyRect(GERect rect);
NSInteger geRectIX(GERectI self);
NSInteger geRectIY(GERectI self);
NSInteger geRectIX2(GERectI self);
NSInteger geRectIY2(GERectI self);
NSInteger geRectIWidth(GERectI self);
NSInteger geRectIHeight(GERectI self);
GERectI geRectIMoveToCenterForSize(GERectI self, GEVec2 size);
ODPType* geRectIType();
@interface GERectIWrap : NSObject
@property (readonly, nonatomic) GERectI value;

+ (id)wrapWithValue:(GERectI)value;
- (id)initWithValue:(GERectI)value;
@end



