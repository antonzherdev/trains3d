#import "CNYield.h"

@class CNChain;
typedef void (^cnChainBuildBlock)(CNChain * chain);
typedef BOOL (^cnPredicate)(id x);
typedef id (^cnF)(id x);
typedef id (^cnF2)(id x, id y);
typedef id (^cnF0)();
typedef void (^cnP)(id x);

@protocol CNChainLink <NSObject>
- (CNYield *)buildYield:(CNYield *)yield;
@end

extern id cnResolveCollection(id collection);


#define numi(expr) [NSNumber numberWithLong:expr]
#define unumi(expr) [expr longValue]
#define numf(expr) [NSNumber numberWithDouble:expr]
#define unumf(expr) [expr doubleValue]
#define numb(expr) [NSNumber numberWithBool:expr]
#define unumb(expr) [expr boolValue]

#define val(expr) \
        ({ \
            __typeof__(expr) chainReservedPrefix_lVar = expr; \
            [NSValue valueWithBytes:&chainReservedPrefix_lVar objCType:@encode(__typeof__(expr))]; \
        })

#define uval(tp, expr) \
        ({ \
            tp chainReservedPrefix_uval; \
            [expr getValue:&chainReservedPrefix_uval]; \
            chainReservedPrefix_uval; \
        })

#define wrap(tp, expr) [tp ## Wrap wrapWithValue:expr]

#define uwrap(tp, expr) [((tp ## Wrap*)expr) value]

static inline NSUInteger randomWith(NSUInteger max) {
    return arc4random_uniform((u_int32_t)max);
}