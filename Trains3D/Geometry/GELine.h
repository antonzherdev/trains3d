#import "objd.h"
#import "GEVec.h"

typedef struct GELine3 GELine3;
typedef struct GEPlane GEPlane;

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
static inline NSString* GELine3Description(GELine3 self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GELine3: "];
    [description appendFormat:@"r0=%@", GEVec3Description(self.r0)];
    [description appendFormat:@", u=%@", GEVec3Description(self.u)];
    [description appendString:@">"];
    return description;
}
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
static inline NSString* GEPlaneDescription(GEPlane self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GEPlane: "];
    [description appendFormat:@"p0=%@", GEVec3Description(self.p0)];
    [description appendFormat:@", n=%@", GEVec3Description(self.n)];
    [description appendString:@">"];
    return description;
}
BOOL gePlaneContainsVec3(GEPlane self, GEVec3 vec3);
ODPType* gePlaneType();
@interface GEPlaneWrap : NSObject
@property (readonly, nonatomic) GEPlane value;

+ (id)wrapWithValue:(GEPlane)value;
- (id)initWithValue:(GEPlane)value;
@end



