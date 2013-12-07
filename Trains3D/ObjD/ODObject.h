#import <Foundation/Foundation.h>
#import <math.h>
#import <float.h>
#import "ODType.h"

#define OD_DBL_EPSILON 2.2204460492503131E-16
#define OD_FLT_EPSILON 1.19209290E-07F
@class CNRange;

static inline BOOL eqf4(float a, float b) {
    return fabs(a - b) <= OD_FLT_EPSILON;
}

static inline BOOL eqf8(double a, double b) {
    return fabs(a - b) <= OD_DBL_EPSILON;
}

static inline BOOL eqf(CGFloat a, CGFloat b) {
    #if defined(__LP64__) && __LP64__
        return fabs(a - b) <= OD_DBL_EPSILON;
    #else
        return fabs(a - b) <= OD_FLT_EPSILON;
    #endif
}

#define max(a, b) MAX(a, b)
#define min(a, b) MIN(a, b)

@protocol ODComparable<NSObject>
- (NSInteger)compareTo:(id)to;
@end

@interface NSNumber(ODObject)<ODComparable>
- (NSInteger)compareTo:(id)to;
@end

static inline NSInteger floatCompareTo(CGFloat a, CGFloat b) {
    return eqf(a, b) ? 0 : (a < b ? -1 : 1);
}

static inline NSInteger float4CompareTo(float a, float b) {
    return eqf4(a, b) ? 0 : (a < b ? -1 : 1);
}

static inline NSInteger float8CompareTo(double a, double b) {
    return eqf8(a, b) ? 0 : (a < b ? -1 : 1);
}


static inline NSInteger intCompareTo(NSInteger a, NSInteger b) {
    return a < b ? -1 : (a > b ? 1 : 0);
}

static inline NSInteger uintCompareTo(NSUInteger a, NSUInteger b) {
    return a < b ? -1 : (a > b ? 1 : 0);
}

static inline BOOL floatBetween(CGFloat s, CGFloat a, CGFloat b) {
    return a <= s && s <= b;
}

static inline BOOL float4Between(float s, float a, float b) {
    return a <= s && s <= b;
}

static inline BOOL float8Between(double s, double a, double b) {
    return a <= s && s <= b;
}

static inline BOOL intBetween(NSInteger s, NSInteger a, NSInteger b) {
    return a <= s && s <= b;
}

static inline BOOL uintBetween(NSUInteger s, NSUInteger a, NSUInteger b) {
    return a <= s && s <= b;
}

static inline CGFloat floatAbs(CGFloat f) {
    return f < 0 ? -f : f;
}

static inline float float4Abs(float f) {
    return f < 0 ? -f : f;
}
static inline CGFloat odFloatRndMinMax(CGFloat s, CGFloat e) {
    return (CGFloat)drand48() * (e - s) + s;
}

static inline CGFloat odFloatRnd() {
    return (CGFloat)drand48();
}

static inline float odFloat4RndMinMax(float s, float e) {
    return (float)drand48() * (e - s) + s;
}

static inline float odFloat4Rnd() {
    return (float)drand48();
}


static inline CGFloat floatNoisePercents(CGFloat self, CGFloat o) {
    return self*(1 + o - 2*o*(CGFloat)drand48());
}

static inline float float4NoisePercents(float self, float o) {
    return self*(1 + o - 2*o*(float)drand48());
}

static inline float float4MaxB(float self, float b) {
    return max(self, b);
}

static inline NSUInteger uintMaxB(NSUInteger self, NSUInteger b) {
    return max(self, b);
}

static inline CGFloat floatMaxB(CGFloat self, CGFloat b) {
    return max(self, b);
}

static inline float float4MinB(float self, float b) {
    return min(self, b);
}

static inline NSUInteger uintMinB(NSUInteger self, NSUInteger b) {
    return min(self, b);
}

static inline CGFloat floatMinB(CGFloat self, CGFloat b) {
    return min(self, b);
}

static inline NSInteger floatRound(CGFloat self) {
    return lround(self);
}

static inline NSInteger float4Round(float self) {
    return lroundf(self);
}


static inline NSUInteger oduIntRndMax(NSUInteger max) {
    return arc4random_uniform((u_int32_t)(max + 1));
}

#define OD_DBL_MAX 1.7976931348623157E+308
//#define OD_DBL_MIN 2.2250738585072014E-308
#define OD_FLT_MAX 3.40282347E+38F

static inline CGFloat odFloatMax() {
    return OD_DBL_MAX;
}

static inline CGFloat odFloatMin() {
    return -OD_DBL_MAX;
}

static inline float odFloat4Max() {
    return OD_FLT_MAX;
}

static inline float odFloat4Min() {
    return -OD_FLT_MAX;
}


static inline char byteAbs(char f) {
    return f < 0 ? -f : f;
}

static inline int intAbs(int f) {
    return f < 0 ? -f : f;
}


#define floatHash(f) [numf(f) hash]
#define float4Hash(f) [numf4(f) hash]
#define float8Hash(f) [numf8(f) hash]

CNRange* intRange(NSInteger x) ;
CNRange* intTo(NSInteger a, NSInteger b);
CNRange* uintRange(NSUInteger x) ;
CNRange* uintTo(NSUInteger a, NSUInteger b);

ODPType * odByteType();
ODPType * odInt4Type();
ODPType * oduInt4Type();
ODPType * odFloat4Type();

@interface NSObject(ODObject)
+ (id)object;
@end

@interface ODObject : NSObject
+ (id)asKindOfClass:(Class)pClass object:(id)obj;
+ (id)asKindOfProtocol:(Protocol *)protocol object:(id)obj;
@end