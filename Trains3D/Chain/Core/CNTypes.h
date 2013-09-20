#import "CNYield.h"
#import "CNTuple.h"


typedef void* VoidRef;
@class CNChain;
typedef void (^cnChainBuildBlock)(CNChain * chain);
typedef BOOL (^cnPredicate)(id x);
typedef NSInteger (^cnCompare)(id x, id y);
typedef id (^cnF)(id x);
typedef id (^cnF2)(id x, id y);
typedef id (^cnF3)(id x, id y, id z);
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

#define nums(expr) [NSNumber numberWithUnsignedShort:expr]
#define unums(expr) [expr unsignedShortValue]

#define numb(expr) [NSNumber numberWithBool:expr]
#define unumb(expr) [expr boolValue]

#define val(expr) \
        ({ \
            __typeof__(expr) chainReservedPrefix_lVar = expr; \
            [NSValue valueWithBytes:&chainReservedPrefix_lVar objCType:@encode(__typeof__(expr))]; \
        })
#define voidRef(expr) \
        ({ \
            __typeof__(expr) chainReservedPrefix_lVar = expr; \
            (void*)&chainReservedPrefix_lVar; \
        })

#define uval(tp, expr) \
        ({ \
            tp chainReservedPrefix_uval; \
            [expr getValue:&chainReservedPrefix_uval]; \
            chainReservedPrefix_uval; \
        })

#define wrap(tp, expr) [tp ## Wrap wrapWithValue:expr]

#define uwrap(tp, expr) [((tp ## Wrap*)expr) value]


#define arr(p_type, p_f, p_count)  CNPArray applyStride:sizeof(p_type) wrap:^id(VoidRef arr, NSUInteger i) { \
    return p_f(((p_type*)(arr))[i]);\
} count:p_count copyBytes:(p_type[])
#define arrp(p_type, p_f, p_count)  CNPArray applyStride:sizeof(p_type) wrap:^id(VoidRef arr, NSUInteger i) { \
    return p_f(((p_type*)(arr))[i]);\
} count:p_count copyBytes:(p_type*)
#define arrc(p_count) arr(char, numc, p_count)
#define arruc(p_count) arr(unsigned char, numuc, p_count)
#define arri(p_count) arr(NSInteger, numi, p_count)
#define arrui(p_count) arr(NSUInteger, numui, p_count)
#define arri4(p_count) arr(int, numi4, p_count)
#define arrui4(p_count) arr(unsigned int, numui4, p_count)
#define arri8(p_count) arr(long, numi8, p_count)
#define arrui8(p_count) arr(unsigned long, numui8, p_count)
#define arrf(p_count) arr(CGFloat, numf, p_count)
#define arrf4(p_count) arr(float, numf4, p_count)
#define arrf8(p_count) arr(double, numf8, p_count)
#define arrs(p_type, p_count) CNPArray applyStride:sizeof(p_type) wrap:^id(void* arr, NSUInteger i) { \
    return wrap(p_type, ((p_type*)(arr))[i]);\
} count:p_count copyBytes:(p_type[])

static inline NSUInteger randomMax(NSUInteger max) {
    return arc4random_uniform((u_int32_t)(max + 1));
}

static inline CGFloat randomFloat() {
    return (CGFloat)drand48();
}

static inline CGFloat randomPercents(CGFloat o) {
    return 1 + o - 2*o*(CGFloat)drand48();
}

static inline CGFloat randomFloatGap(CGFloat s, CGFloat e) {
    return (CGFloat)drand48() * (e - s) + s;
}


static inline NSUInteger VoidRefHash(void * v) {
    return (NSUInteger) v;
}

static inline BOOL VoidRefEq(void * a, void * b) {
    return a == b;
}

static inline NSString* VoidRefDescription(void * v) {
    return [NSString stringWithFormat:@"%p", v];
}

static inline void* copy(void * mem, NSUInteger len) {
    void* ret = malloc(len);
    memcpy(ret, mem, len);
    return ret;
}



#define tuple(anA, aB) [CNTuple tupleWithA:anA b: aB]
#define tuple3(anA, aB, aC) [CNTuple3 tuple3WithA:anA b: aB c:aC]
#define tuple4(anA, aB, aC, aD) [CNTuple4 tuple4WithA:anA b: aB c:aC d:aD]
