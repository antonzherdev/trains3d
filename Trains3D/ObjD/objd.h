#import <Foundation/Foundation.h>
#import "ODLazy.h"
#import "chain.h"
#import "ODEnum.h"
#import "ODObject.h"
#import <math.h>

static inline BOOL eqf(CGFloat a, CGFloat b) {
    return fabs(a - b) <= DBL_EPSILON;
}

#define max(a, b) MAX(a, b)
#define min(a, b) MIN(a, b)
