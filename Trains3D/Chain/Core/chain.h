#import "cnTypes.h"
#import "CNChain.h"
#import "CNOption.h"
#import "CNTuple.h"
#import "NSObject+CNOption.h"
#import "NSArray+CNChain.h"
#import "NSDictionary+CNMap.h"

#define numi(expr) [NSNumber numberWithInt:expr]

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