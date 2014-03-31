#import "objd.h"
@class GEMat4;
@class GEMat3;

typedef struct GEVec2 GEVec2;
typedef struct GEVec2i GEVec2i;
typedef struct GEVec3 GEVec3;
typedef struct GEVec4 GEVec4;
typedef struct GETriangle GETriangle;
typedef struct GEQuad GEQuad;
typedef struct GEQuadrant GEQuadrant;
typedef struct GERect GERect;
typedef struct GERectI GERectI;
typedef struct GELine2 GELine2;
typedef struct GELine3 GELine3;
typedef struct GEPlane GEPlane;
typedef struct GEPlaneCoord GEPlaneCoord;
typedef struct GEQuad3 GEQuad3;

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
GEVec2 geVec2ApplyF(CGFloat f);
GEVec2 geVec2ApplyF4(float f4);
GEVec2 geVec2Min();
GEVec2 geVec2Max();
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
float geVec2CrossVec2(GEVec2 self, GEVec2 vec2);
float geVec2LengthSquare(GEVec2 self);
float geVec2Length(GEVec2 self);
GEVec2 geVec2MidVec2(GEVec2 self, GEVec2 vec2);
float geVec2DistanceToVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2SetLength(GEVec2 self, float length);
GEVec2 geVec2Normalize(GEVec2 self);
NSInteger geVec2CompareTo(GEVec2 self, GEVec2 to);
GERect geVec2RectToVec2(GEVec2 self, GEVec2 vec2);
GERect geVec2RectInCenterWithSize(GEVec2 self, GEVec2 size);
GEVec2 geVec2Rnd();
BOOL geVec2IsEmpty(GEVec2 self);
GEVec2i geVec2Round(GEVec2 self);
GEVec2 geVec2MinVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2MaxVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2Abs(GEVec2 self);
float geVec2Ratio(GEVec2 self);
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
GEVec2 geVec2iAddVec2(GEVec2i self, GEVec2 vec2);
GEVec2i geVec2iAddVec2i(GEVec2i self, GEVec2i vec2i);
GEVec2 geVec2iSubVec2(GEVec2i self, GEVec2 vec2);
GEVec2i geVec2iSubVec2i(GEVec2i self, GEVec2i vec2i);
GEVec2i geVec2iMulI(GEVec2i self, NSInteger i);
GEVec2 geVec2iMulF(GEVec2i self, CGFloat f);
GEVec2 geVec2iMulF4(GEVec2i self, float f4);
GEVec2 geVec2iDivF4(GEVec2i self, float f4);
GEVec2 geVec2iDivF(GEVec2i self, CGFloat f);
GEVec2i geVec2iDivI(GEVec2i self, NSInteger i);
GEVec2i geVec2iNegate(GEVec2i self);
NSInteger geVec2iCompareTo(GEVec2i self, GEVec2i to);
GERectI geVec2iRectToVec2i(GEVec2i self, GEVec2i vec2i);
NSInteger geVec2iDotVec2i(GEVec2i self, GEVec2i vec2i);
NSInteger geVec2iLengthSquare(GEVec2i self);
float geVec2iLength(GEVec2i self);
float geVec2iRatio(GEVec2i self);
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
GEVec3 geVec3ApplyVec2(GEVec2 vec2);
GEVec3 geVec3ApplyVec2Z(GEVec2 vec2, float z);
GEVec3 geVec3ApplyVec2iZ(GEVec2i vec2i, float z);
GEVec3 geVec3ApplyF4(float f4);
GEVec3 geVec3ApplyF(CGFloat f);
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
BOOL geVec3IsEmpty(GEVec3 self);
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
GEVec4 geVec4ApplyF(CGFloat f);
GEVec4 geVec4ApplyF4(float f4);
GEVec4 geVec4ApplyVec3W(GEVec3 vec3, float w);
GEVec4 geVec4ApplyVec2ZW(GEVec2 vec2, float z, float w);
GEVec4 geVec4AddVec2(GEVec4 self, GEVec2 vec2);
GEVec4 geVec4AddVec3(GEVec4 self, GEVec3 vec3);
GEVec4 geVec4AddVec4(GEVec4 self, GEVec4 vec4);
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



struct GETriangle {
    GEVec2 p0;
    GEVec2 p1;
    GEVec2 p2;
};
static inline GETriangle GETriangleMake(GEVec2 p0, GEVec2 p1, GEVec2 p2) {
    return (GETriangle){p0, p1, p2};
}
static inline BOOL GETriangleEq(GETriangle s1, GETriangle s2) {
    return GEVec2Eq(s1.p0, s2.p0) && GEVec2Eq(s1.p1, s2.p1) && GEVec2Eq(s1.p2, s2.p2);
}
static inline NSUInteger GETriangleHash(GETriangle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.p0);
    hash = hash * 31 + GEVec2Hash(self.p1);
    hash = hash * 31 + GEVec2Hash(self.p2);
    return hash;
}
NSString* GETriangleDescription(GETriangle self);
BOOL geTriangleContainsVec2(GETriangle self, GEVec2 vec2);
ODPType* geTriangleType();
@interface GETriangleWrap : NSObject
@property (readonly, nonatomic) GETriangle value;

+ (id)wrapWithValue:(GETriangle)value;
- (id)initWithValue:(GETriangle)value;
@end



struct GEQuad {
    GEVec2 p0;
    GEVec2 p1;
    GEVec2 p2;
    GEVec2 p3;
};
static inline GEQuad GEQuadMake(GEVec2 p0, GEVec2 p1, GEVec2 p2, GEVec2 p3) {
    return (GEQuad){p0, p1, p2, p3};
}
static inline BOOL GEQuadEq(GEQuad s1, GEQuad s2) {
    return GEVec2Eq(s1.p0, s2.p0) && GEVec2Eq(s1.p1, s2.p1) && GEVec2Eq(s1.p2, s2.p2) && GEVec2Eq(s1.p3, s2.p3);
}
static inline NSUInteger GEQuadHash(GEQuad self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.p0);
    hash = hash * 31 + GEVec2Hash(self.p1);
    hash = hash * 31 + GEVec2Hash(self.p2);
    hash = hash * 31 + GEVec2Hash(self.p3);
    return hash;
}
NSString* GEQuadDescription(GEQuad self);
GEQuad geQuadApplySize(float size);
GEQuad geQuadAddVec2(GEQuad self, GEVec2 vec2);
GEQuad geQuadAddXY(GEQuad self, float x, float y);
GEQuad geQuadMulValue(GEQuad self, float value);
GEQuad geQuadMulMat3(GEQuad self, GEMat3* mat3);
GEQuadrant geQuadQuadrant(GEQuad self);
GEVec2 geQuadApplyIndex(GEQuad self, NSUInteger index);
GERect geQuadBoundingRect(GEQuad self);
NSArray* geQuadLines(GEQuad self);
NSArray* geQuadPs(GEQuad self);
GEVec2 geQuadClosestPointForVec2(GEQuad self, GEVec2 vec2);
BOOL geQuadContainsVec2(GEQuad self, GEVec2 vec2);
GEQuad geQuadMapF(GEQuad self, GEVec2(^f)(GEVec2));
GEVec2 geQuadCenter(GEQuad self);
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
    GEVec2 p;
    GEVec2 size;
};
static inline GERect GERectMake(GEVec2 p, GEVec2 size) {
    return (GERect){p, size};
}
static inline BOOL GERectEq(GERect s1, GERect s2) {
    return GEVec2Eq(s1.p, s2.p) && GEVec2Eq(s1.size, s2.size);
}
static inline NSUInteger GERectHash(GERect self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.p);
    hash = hash * 31 + GEVec2Hash(self.size);
    return hash;
}
NSString* GERectDescription(GERect self);
GERect geRectApplyXYWidthHeight(float x, float y, float width, float height);
GERect geRectApplyXYSize(float x, float y, GEVec2 size);
GERect geRectApplyRectI(GERectI rectI);
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
GERect geRectDivF(GERect self, CGFloat f);
GERect geRectDivF4(GERect self, float f4);
GEVec2 geRectPh(GERect self);
GEVec2 geRectPw(GERect self);
GEVec2 geRectPhw(GERect self);
GERect geRectMoveToCenterForSize(GERect self, GEVec2 size);
GEQuad geRectQuad(GERect self);
GEQuad geRectStripQuad(GERect self);
GEQuad geRectUpsideDownStripQuad(GERect self);
GERect geRectCenterX(GERect self);
GERect geRectCenterY(GERect self);
GEVec2 geRectCenter(GERect self);
GEVec2 geRectClosestPointForVec2(GERect self, GEVec2 vec2);
GEVec2 geRectPXY(GERect self, float x, float y);
ODPType* geRectType();
@interface GERectWrap : NSObject
@property (readonly, nonatomic) GERect value;

+ (id)wrapWithValue:(GERect)value;
- (id)initWithValue:(GERect)value;
@end



struct GERectI {
    GEVec2i p;
    GEVec2i size;
};
static inline GERectI GERectIMake(GEVec2i p, GEVec2i size) {
    return (GERectI){p, size};
}
static inline BOOL GERectIEq(GERectI s1, GERectI s2) {
    return GEVec2iEq(s1.p, s2.p) && GEVec2iEq(s1.size, s2.size);
}
static inline NSUInteger GERectIHash(GERectI self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.p);
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



struct GELine2 {
    GEVec2 p0;
    GEVec2 u;
};
static inline GELine2 GELine2Make(GEVec2 p0, GEVec2 u) {
    return (GELine2){p0, u};
}
static inline BOOL GELine2Eq(GELine2 s1, GELine2 s2) {
    return GEVec2Eq(s1.p0, s2.p0) && GEVec2Eq(s1.u, s2.u);
}
static inline NSUInteger GELine2Hash(GELine2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.p0);
    hash = hash * 31 + GEVec2Hash(self.u);
    return hash;
}
NSString* GELine2Description(GELine2 self);
GELine2 geLine2ApplyP0P1(GEVec2 p0, GEVec2 p1);
GEVec2 geLine2RT(GELine2 self, float t);
id geLine2CrossPointLine2(GELine2 self, GELine2 line2);
float geLine2Angle(GELine2 self);
float geLine2DegreeAngle(GELine2 self);
GELine2 geLine2SetLength(GELine2 self, float length);
GELine2 geLine2Normalize(GELine2 self);
GEVec2 geLine2Mid(GELine2 self);
GEVec2 geLine2P1(GELine2 self);
GELine2 geLine2AddVec2(GELine2 self, GEVec2 vec2);
GELine2 geLine2SubVec2(GELine2 self, GEVec2 vec2);
GEVec2 geLine2N(GELine2 self);
GEVec2 geLine2ProjectionVec2(GELine2 self, GEVec2 vec2);
id geLine2ProjectionOnSegmentVec2(GELine2 self, GEVec2 vec2);
GERect geLine2BoundingRect(GELine2 self);
GELine2 geLine2Positive(GELine2 self);
ODPType* geLine2Type();
@interface GELine2Wrap : NSObject
@property (readonly, nonatomic) GELine2 value;

+ (id)wrapWithValue:(GELine2)value;
- (id)initWithValue:(GELine2)value;
@end



struct GELine3 {
    GEVec3 r0;
    GEVec3 u;
};
static inline GELine3 GELine3Make(GEVec3 r0, GEVec3 u) {
    return (GELine3){r0, u};
}
static inline BOOL GELine3Eq(GELine3 s1, GELine3 s2) {
    return GEVec3Eq(s1.r0, s2.r0) && GEVec3Eq(s1.u, s2.u);
}
static inline NSUInteger GELine3Hash(GELine3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.r0);
    hash = hash * 31 + GEVec3Hash(self.u);
    return hash;
}
NSString* GELine3Description(GELine3 self);
GEVec3 geLine3RT(GELine3 self, float t);
GEVec3 geLine3RPlane(GELine3 self, GEPlane plane);
ODPType* geLine3Type();
@interface GELine3Wrap : NSObject
@property (readonly, nonatomic) GELine3 value;

+ (id)wrapWithValue:(GELine3)value;
- (id)initWithValue:(GELine3)value;
@end



struct GEPlane {
    GEVec3 p0;
    GEVec3 n;
};
static inline GEPlane GEPlaneMake(GEVec3 p0, GEVec3 n) {
    return (GEPlane){p0, n};
}
static inline BOOL GEPlaneEq(GEPlane s1, GEPlane s2) {
    return GEVec3Eq(s1.p0, s2.p0) && GEVec3Eq(s1.n, s2.n);
}
static inline NSUInteger GEPlaneHash(GEPlane self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.p0);
    hash = hash * 31 + GEVec3Hash(self.n);
    return hash;
}
NSString* GEPlaneDescription(GEPlane self);
BOOL gePlaneContainsVec3(GEPlane self, GEVec3 vec3);
GEPlane gePlaneAddVec3(GEPlane self, GEVec3 vec3);
GEPlane gePlaneMulMat4(GEPlane self, GEMat4* mat4);
ODPType* gePlaneType();
@interface GEPlaneWrap : NSObject
@property (readonly, nonatomic) GEPlane value;

+ (id)wrapWithValue:(GEPlane)value;
- (id)initWithValue:(GEPlane)value;
@end



struct GEPlaneCoord {
    GEPlane plane;
    GEVec3 x;
    GEVec3 y;
};
static inline GEPlaneCoord GEPlaneCoordMake(GEPlane plane, GEVec3 x, GEVec3 y) {
    return (GEPlaneCoord){plane, x, y};
}
static inline BOOL GEPlaneCoordEq(GEPlaneCoord s1, GEPlaneCoord s2) {
    return GEPlaneEq(s1.plane, s2.plane) && GEVec3Eq(s1.x, s2.x) && GEVec3Eq(s1.y, s2.y);
}
static inline NSUInteger GEPlaneCoordHash(GEPlaneCoord self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEPlaneHash(self.plane);
    hash = hash * 31 + GEVec3Hash(self.x);
    hash = hash * 31 + GEVec3Hash(self.y);
    return hash;
}
NSString* GEPlaneCoordDescription(GEPlaneCoord self);
GEPlaneCoord gePlaneCoordApplyPlaneX(GEPlane plane, GEVec3 x);
GEVec3 gePlaneCoordPVec2(GEPlaneCoord self, GEVec2 vec2);
GEPlaneCoord gePlaneCoordAddVec3(GEPlaneCoord self, GEVec3 vec3);
GEPlaneCoord gePlaneCoordSetX(GEPlaneCoord self, GEVec3 x);
GEPlaneCoord gePlaneCoordSetY(GEPlaneCoord self, GEVec3 y);
GEPlaneCoord gePlaneCoordMulMat4(GEPlaneCoord self, GEMat4* mat4);
ODPType* gePlaneCoordType();
@interface GEPlaneCoordWrap : NSObject
@property (readonly, nonatomic) GEPlaneCoord value;

+ (id)wrapWithValue:(GEPlaneCoord)value;
- (id)initWithValue:(GEPlaneCoord)value;
@end



struct GEQuad3 {
    GEPlaneCoord planeCoord;
    GEQuad quad;
};
static inline GEQuad3 GEQuad3Make(GEPlaneCoord planeCoord, GEQuad quad) {
    return (GEQuad3){planeCoord, quad};
}
static inline BOOL GEQuad3Eq(GEQuad3 s1, GEQuad3 s2) {
    return GEPlaneCoordEq(s1.planeCoord, s2.planeCoord) && GEQuadEq(s1.quad, s2.quad);
}
static inline NSUInteger GEQuad3Hash(GEQuad3 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEPlaneCoordHash(self.planeCoord);
    hash = hash * 31 + GEQuadHash(self.quad);
    return hash;
}
NSString* GEQuad3Description(GEQuad3 self);
GEVec3 geQuad3P0(GEQuad3 self);
GEVec3 geQuad3P1(GEQuad3 self);
GEVec3 geQuad3P2(GEQuad3 self);
GEVec3 geQuad3P3(GEQuad3 self);
NSArray* geQuad3Ps(GEQuad3 self);
GEQuad3 geQuad3MulMat4(GEQuad3 self, GEMat4* mat4);
ODPType* geQuad3Type();
@interface GEQuad3Wrap : NSObject
@property (readonly, nonatomic) GEQuad3 value;

+ (id)wrapWithValue:(GEQuad3)value;
- (id)initWithValue:(GEQuad3)value;
@end



