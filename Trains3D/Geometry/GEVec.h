#import "objd.h"
@class GEMat4;

typedef struct GEVec2 GEVec2;
typedef struct GEVec2i GEVec2i;
typedef struct GEVec3 GEVec3;
typedef struct GEVec4 GEVec4;
typedef struct GEQuad GEQuad;
typedef struct GEQuadrant GEQuadrant;
typedef struct GERect GERect;
typedef struct GERecti GERecti;

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
GEVec2 geVec2ApplyVec2i(GEVec2i vec2i);
GEVec2 geVec2AddVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2SubVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2Negate(GEVec2 self);
float geVec2DegreeAngle(GEVec2 self);
float geVec2Angle(GEVec2 self);
float geVec2DotVec2(GEVec2 self, GEVec2 vec2);
float geVec2LengthSquare(GEVec2 self);
CGFloat geVec2Length(GEVec2 self);
GEVec2 geVec2MulValue(GEVec2 self, float value);
GEVec2 geVec2DivVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2DivF4(GEVec2 self, float f4);
GEVec2 geVec2DivF(GEVec2 self, CGFloat f);
GEVec2 geVec2MidVec2(GEVec2 self, GEVec2 vec2);
CGFloat geVec2DistanceToVec2(GEVec2 self, GEVec2 vec2);
GEVec2 geVec2SetLength(GEVec2 self, float length);
GEVec2 geVec2Normalize(GEVec2 self);
NSInteger geVec2CompareTo(GEVec2 self, GEVec2 to);
GERect geVec2RectToVec2(GEVec2 self, GEVec2 vec2);
GERect geVec2RectInCenterWithSize(GEVec2 self, GEVec2 size);
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
static inline NSString* GEVec2iDescription(GEVec2i self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEVec2i: "];
    [description appendFormat:@"x=%li", self.x];
    [description appendFormat:@", y=%li", self.y];
    [description appendString:@">"];
    return description;
}
GEVec2i geVec2iApplyVec2(GEVec2 vec2);
GEVec2i geVec2iAddVec2i(GEVec2i self, GEVec2i vec2i);
GEVec2i geVec2iSubVec2i(GEVec2i self, GEVec2i vec2i);
GEVec2 geVec2iDivF4(GEVec2i self, float f4);
GEVec2 geVec2iDivF(GEVec2i self, CGFloat f);
GEVec2i geVec2iDivI(GEVec2i self, NSInteger i);
GEVec2i geVec2iNegate(GEVec2i self);
NSInteger geVec2iCompareTo(GEVec2i self, GEVec2i to);
GERecti geVec2iRectToVec2i(GEVec2i self, GEVec2i vec2i);
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
static inline NSString* GEVec3Description(GEVec3 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEVec3: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", z=%f", self.z];
    [description appendString:@">"];
    return description;
}
GEVec3 geVec3ApplyVec2Z(GEVec2 vec2, float z);
GEVec3 geVec3AddVec3(GEVec3 self, GEVec3 vec3);
GEVec3 geVec3SubVec3(GEVec3 self, GEVec3 vec3);
GEVec3 geVec3Sqr(GEVec3 self);
GEVec3 geVec3Negate(GEVec3 self);
GEVec3 geVec3MulK(GEVec3 self, float k);
float geVec3DotVec3(GEVec3 self, GEVec3 vec3);
float geVec3LengthSquare(GEVec3 self);
CGFloat geVec3Length(GEVec3 self);
GEVec3 geVec3SetLength(GEVec3 self, float length);
GEVec3 geVec3Normalize(GEVec3 self);
GEVec2 geVec3Xy(GEVec3 self);
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



struct GERect {
    GEVec2 origin;
    GEVec2 size;
};
static inline GERect GERectMake(GEVec2 origin, GEVec2 size) {
    return (GERect){origin, size};
}
static inline BOOL GERectEq(GERect s1, GERect s2) {
    return GEVec2Eq(s1.origin, s2.origin) && GEVec2Eq(s1.size, s2.size);
}
static inline NSUInteger GERectHash(GERect self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.origin);
    hash = hash * 31 + GEVec2Hash(self.size);
    return hash;
}
static inline NSString* GERectDescription(GERect self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GERect: "];
    [description appendFormat:@"origin=%@", GEVec2Description(self.origin)];
    [description appendFormat:@", size=%@", GEVec2Description(self.size)];
    [description appendString:@">"];
    return description;
}
GERect geRectApplyXYWidthHeight(float x, float y, float width, float height);
float geRectX(GERect self);
float geRectY(GERect self);
float geRectX2(GERect self);
float geRectY2(GERect self);
float geRectWidth(GERect self);
float geRectHeight(GERect self);
BOOL geRectContainsPoint(GERect self, GEVec2 point);
GERect geRectAddVec2(GERect self, GEVec2 vec2);
GERect geRectMoveToCenterForSize(GERect self, GEVec2 size);
BOOL geRectIntersectsRect(GERect self, GERect rect);
GERect geRectThickenHalfSize(GERect self, GEVec2 halfSize);
GERect geRectDivVec2(GERect self, GEVec2 vec2);
GEVec2 geRectLeftBottom(GERect self);
GEVec2 geRectLeftTop(GERect self);
GEVec2 geRectRightTop(GERect self);
GEVec2 geRectRightBottom(GERect self);
ODPType* geRectType();
@interface GERectWrap : NSObject
@property (readonly, nonatomic) GERect value;

+ (id)wrapWithValue:(GERect)value;
- (id)initWithValue:(GERect)value;
@end



struct GERecti {
    GEVec2i origin;
    GEVec2i size;
};
static inline GERecti GERectiMake(GEVec2i origin, GEVec2i size) {
    return (GERecti){origin, size};
}
static inline BOOL GERectiEq(GERecti s1, GERecti s2) {
    return GEVec2iEq(s1.origin, s2.origin) && GEVec2iEq(s1.size, s2.size);
}
static inline NSUInteger GERectiHash(GERecti self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.origin);
    hash = hash * 31 + GEVec2iHash(self.size);
    return hash;
}
static inline NSString* GERectiDescription(GERecti self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GERecti: "];
    [description appendFormat:@"origin=%@", GEVec2iDescription(self.origin)];
    [description appendFormat:@", size=%@", GEVec2iDescription(self.size)];
    [description appendString:@">"];
    return description;
}
GERecti geRectiApplyXYWidthHeight(float x, float y, float width, float height);
GERecti geRectiApplyRect(GERect rect);
NSInteger geRectiX(GERecti self);
NSInteger geRectiY(GERecti self);
NSInteger geRectiX2(GERecti self);
NSInteger geRectiY2(GERecti self);
NSInteger geRectiWidth(GERecti self);
NSInteger geRectiHeight(GERecti self);
GERecti geRectiMoveToCenterForSize(GERecti self, GEVec2 size);
ODPType* geRectiType();
@interface GERectiWrap : NSObject
@property (readonly, nonatomic) GERecti value;

+ (id)wrapWithValue:(GERecti)value;
- (id)initWithValue:(GERecti)value;
@end



