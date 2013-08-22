#import "CNYield.h"

@class CNChain;
typedef void (^cnChainBuildBlock)(CNChain * chain);
typedef BOOL (^cnPredicate)(id x);
typedef NSInteger (^cnCompare)(id x, id y);
typedef id (^cnF)(id x);
typedef id (^cnF2)(id x, id y);
typedef id (^cnF0)();
typedef void (^cnP)(id x);

@protocol CNChainLink <NSObject>
- (CNYield *)buildYield:(CNYield *)yield;
@end

extern id cnResolveCollection(id collection);


#define numc(expr) [NSNumber numberWithChar:expr]
#define unumc(expr) [expr charValue]
#define numi4(expr) [NSNumber numberWithInt:expr]
#define unumi4(expr) [expr intValue]
#define numi(expr) [NSNumber numberWithLong:expr]
#define unumi(expr) [expr longValue]

#define numuc(expr) [NSNumber numberWithUnsignedChar:expr]
#define unumuc(expr) [expr unsignedCharValue]
#define numui(expr) [NSNumber numberWithUnsignedInt:expr]
#define unumui(expr) [expr unsignedIntValue]
#define numul(expr) [NSNumber numberWithUnsignedLong:expr]
#define unumul(expr) [expr unsignedLongValue]

#define numf(expr) [NSNumber numberWithFloat:expr]
#define unumf(expr) [expr floatValue]
#define numd(expr) [NSNumber numberWithDouble:expr]
#define unumd(expr) [expr doubleValue]
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
    return arc4random_uniform((u_int32_t)(max + 1));
}