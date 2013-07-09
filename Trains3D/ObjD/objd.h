#import <Foundation/Foundation.h>
#import "ODLazy.h"
#import "chain.h"
#import <math.h>

static inline BOOL eqf(CGFloat a, CGFloat b) {
    return fabs(a - b) <= DBL_EPSILON;
}