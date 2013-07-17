#import "cnTypes.h"
#import "CNFlatMapLink.h"
#import "CNChain.h"


@implementation CNFlatMapLink {
    double _factor;
    cnF _f;
}
- (id)initWithF:(cnF)f factor:(double)factor {
    self = [super init];
    if (self) {
        _f = [f copy];
        _factor = factor;
    }

    return self;
}

+ (id)linkWithF:(cnF)f factor:(double)factor {
    return [[self alloc] initWithF:f factor:factor];
}


- (CNYield *)buildYield:(CNYield *)yield {
    return [CNYield decorateYield:yield begin:^CNYieldResult(NSUInteger size) {
        return [yield beginYieldWithSize:(NSUInteger) (size * _factor)];
    } yield:^CNYieldResult(id item) {
        id o = _f(item);
        if([o isKindOfClass:[CNChain class]]) {
            __block CNYieldResult ret = cnYieldContinue;
            [o apply:[CNYield yieldWithBegin:nil yield:^CNYieldResult(id x) {
                ret = [yield yieldItem:x];
                return ret;
            } end:nil all:nil]];
            return ret;
        } else {
            for(id x in o) {
                if([yield yieldItem:x] == cnYieldBreak) return cnYieldBreak;
            }
            return cnYieldContinue;
        }

    } end:nil all:nil];
}

@end