#import "CNPrependLink.h"


@implementation CNPrependLink {
    id _collection;
}
- (id)initWithCollection:(id)collection {
    self = [super init];
    if (self) {
        _collection = collection;
    }

    return self;
}

- (CNYield *)buildYield:(CNYield *)yield {
    return [CNYield decorateYield: yield begin:^CNYieldResult(NSUInteger size) {
        if([yield beginYieldWithSize:size + [_collection count]] == cnYieldBreak) return cnYieldBreak;
        for(id item in _collection) {
            if([yield yieldItem:item] == cnYieldBreak) return cnYieldBreak;
        }
        return cnYieldContinue;
    } yield:nil end:nil all:nil];
}

+ (id)linkWithCollection:(id)collection {
    return [[self alloc] initWithCollection:collection];
}

@end