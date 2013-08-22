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
#define numi8(expr) [NSNumber numberWithLong:expr]
#define unumi8(expr) [expr longValue]
#define numi(expr) [NSNumber numberWithInteger:expr]
#define unumi(expr) [expr integerValue]

#define numuc(expr) [NSNumber numberWithUnsignedChar:expr]
#define unumuc(expr) [expr unsignedCharValue]
#define numui4(expr) [NSNumber numberWithUnsignedInt:expr]
#define unumui4(expr) [expr unsignedIntValue]
#define numui8(expr) [NSNumber numberWithUnsignedLong:expr]
#define unumui8(expr) [expr unsignedLongValue]
#define numui(expr) [NSNumber numberWithUnsignedInteger:expr]
#define unumui(expr) [expr unsignedIntegerValue]


#define numf4(expr) [NSNumber numberWithFloat:expr]
#define unumf4(expr) [expr floatValue]
#define numf8(expr) [NSNumber numberWithDouble:expr]
#define unumf8(expr) [expr doubleValue]

#if defined(__LP64__) && __LP64__
#define numf(expr) [NSNumber numberWithDouble:expr]
#define unumf(expr) [expr doubleValue]
#else
#define numf(expr) [NSNumber numberWithFloat:expr]
#define unumf(expr) [expr floatValue]
#endif

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