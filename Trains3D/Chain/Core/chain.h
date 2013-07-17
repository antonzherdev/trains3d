#import "cnTypes.h"
#import "CNChain.h"
#import "CNOption.h"
#import "CNTuple.h"
#import "NSObject+CNOption.h"
#import "NSNull+CNOption.h"
#import "NSArray+CNChain.h"
#import "NSMutableDictionary+CNChain.h"
#import "NSDictionary+CNChain.h"

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
