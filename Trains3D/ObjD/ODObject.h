#import <Foundation/Foundation.h>
#import <math.h>

@class CNRange;

static inline BOOL eqf(CGFloat a, CGFloat b) {
    return fabs(a - b) <= DBL_EPSILON;
}

#define max(a, b) MAX(a, b)
#define min(a, b) MIN(a, b)

@protocol ODComparable<NSObject>
- (NSInteger)compareTo:(id)to;
@end

@interface NSNumber(ODObject)<ODComparable>
- (NSInteger)compareTo:(id)to;
@end

static inline NSInteger floatCompare(double a, double b) {
    return eqf(a, b) ? 0 : (a < b ? -1 : 1);
}

static inline NSInteger intCompare(NSInteger a, NSInteger b) {
    return a < b ? -1 : (a > b ? 1 : 0);
}

static inline NSInteger uintCompare(NSUInteger a, NSUInteger b) {
    return a < b ? -1 : (a > b ? 1 : 0);
}

CNRange* intRange(NSInteger x) ;
CNRange* uintRange(NSUInteger x) ;