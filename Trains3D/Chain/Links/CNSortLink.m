#import "CNSortLink.h"
#import "CNTreeSet.h"


@implementation CNSortLink {
   cnCompare _comparator;
}
- (id)init {
    self = [super init];
    if (self) {

    }

    return self;
}

- (id)initWithComparator:(cnCompare)comparator {
    self = [super init];
    if (self) {
        _comparator = comparator;
    }

    return self;
}

+ (id)linkWithComparator:(cnCompare)comparator {
    return [[self alloc] initWithComparator:comparator];
}


- (CNYield *)buildYield:(CNYield *)yield {
    __block CNMutableTreeSet* ret = [CNMutableTreeSet newWithComparator:_comparator];
    return [CNYield decorateYield: yield begin:nil yield:^CNYieldResult(id item) {
        [ret addObject:item];
        return cnYieldContinue;
    } end:^CNYieldResult(CNYieldResult result) {
        if(result != cnYieldBreak) {
            [yield yieldAll:ret];
        }
        return [yield endYieldWithResult:result];
    } all:nil];
}

+ (id)link {
    return [[self alloc] init];
}

@end