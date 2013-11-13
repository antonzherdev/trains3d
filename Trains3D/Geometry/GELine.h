#import "objd.h"
#import "GEVec.h"

typedef struct GELine2 GELine2;
typedef struct GELine3 GELine3;
typedef struct GEPlane GEPlane;
typedef struct GEPlaneCoord GEPlaneCoord;
typedef struct GEQuad3 GEQuad3;

struct GELine2 {
    GEVec2 r0;
    GEVec2 u;
};
static inline GELine2 GELine2Make(GEVec2 r0, GEVec2 u) {
    return (GELine2){r0, u};
}
static inline BOOL GELine2Eq(GELine2 s1, GELine2 s2) {
    return GEVec2Eq(s1.r0, s2.r0) && GEVec2Eq(s1.u, s2.u);
}
static inline NSUInteger GELine2Hash(GELine2 self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.r0);
    hash = hash * 31 + GEVec2Hash(self.u);
    return hash;
}
NSString* GELine2Description(GELine2 self);
GELine2 geLine2ApplyP0P1(GEVec2 p0, GEVec2 p1);
GEVec2 geLine2RT(GELine2 self, float t);
GEVec2 geLine2RPlane(GELine2 self, GEPlane plane);
float geLine2Angle(GELine2 self);
float geLine2DegreeAngle(GELine2 self);
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
id<CNSeq> geQuad3P(GEQuad3 self);
ODPType* geQuad3Type();
@interface GEQuad3Wrap : NSObject
@property (readonly, nonatomic) GEQuad3 value;

+ (id)wrapWithValue:(GEQuad3)value;
- (id)initWithValue:(GEQuad3)value;
@end



