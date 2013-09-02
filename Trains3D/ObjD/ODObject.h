#import <Foundation/Foundation.h>
#import <math.h>
#import "ODType.h"

@class CNRange;

static inline BOOL eqf4(float a, float b) {
    return fabs(a - b) <= FLT_EPSILON;
}

static inline BOOL eqf8(double a, double b) {
    return fabs(a - b) <= DBL_EPSILON;
}

static inline BOOL eqf(CGFloat a, CGFloat b) {
    #if defined(__LP64__) && __LP64__
        return fabs(a - b) <= DBL_EPSILON;
    #else
        return fabs(a - b) <= FLT_EPSILON;
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

static inline NSInteger floatCompare(CGFloat a, CGFloat b) {
    return eqf(a, b) ? 0 : (a < b ? -1 : 1);
}

static inline NSInteger float4Compare(float a, float b) {
    return eqf4(a, b) ? 0 : (a < b ? -1 : 1);
}

static inline NSInteger float8Compare(double a, double b) {
    return eqf8(a, b) ? 0 : (a < b ? -1 : 1);
}


static inline NSInteger intCompare(NSInteger a, NSInteger b) {
    return a < b ? -1 : (a > b ? 1 : 0);
}

static inline NSInteger uintCompare(NSUInteger a, NSUInteger b) {
    return a < b ? -1 : (a > b ? 1 : 0);
}

static inline BOOL floatBetween(double s, double a, double b) {
    return a <= s && s <= b;
}

static inline BOOL intBetween(NSInteger s, NSInteger a, NSInteger b) {
    return a <= s && s <= b;
}

static inline BOOL uintBetween(NSUInteger s, NSUInteger a, NSUInteger b) {
    return a <= s && s <= b;
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
