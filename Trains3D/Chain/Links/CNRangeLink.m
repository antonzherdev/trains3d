#import "CNSourceLink.h"
#import "CNRangeLink.h"


@implementation CNRangeLink {
    NSInteger start;
    NSInteger end;
    NSInteger step;
}
- (id)initWithStart:(NSInteger)aStart end:(NSInteger)anEnd step:(NSInteger)aStep {
    self = [super init];
    if (self) {
        start = aStart;
        end = anEnd;
        step = aStep;
    }

    return self;
}

+ (id)linkWithStart:(NSInteger)aStart end:(NSInteger)anEnd step:(NSInteger)aStep {
    return [[self alloc] initWithStart:aStart end:anEnd step:aStep];
}


- (CNYield *)buildYield:(CNYield *)yield {
    return [CNYield yieldWithBegin:nil yield:nil end:^CNYieldResult(CNYieldResult result) {
        if (result == cnYieldContinue) {
            if(end >= start) {
                result = [yield beginYieldWithSize:(NSUInteger) (end - start) / step];
                for(int i = start; i <= end; i += step) {
                    if(result == cnYieldBreak) break;
                    result = [yield yieldItem:[NSNumber numberWithInt:i]];
                }
            } else {
                result = [yield beginYieldWithSize:(NSUInteger) (start - end) / step];
                for(int i = start; i >= end; i -= step) {
                    if(result == cnYieldBreak) break;
                    result = [yield yieldItem:[NSNumber numberWithInt:i]];
                }
            }
            [yield endYieldWithResult:result];
        }
        return result;
    } all:nil];
}

@end