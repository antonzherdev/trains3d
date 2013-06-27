#import "CNMulLink.h"
#import "CNTuple.h"


@implementation CNMulLink {
    id _collection;
}
- (id)initWithCollection:(id)collection {
    self = [super init];
    if (self) {
        _collection = cnResolveCollection(collection);
    }

    return self;
}

- (CNYield *)buildYield:(CNYield *)yield {
    return [CNYield decorateYield: yield begin:^CNYieldResult(NSUInteger size) {
        return [yield beginYieldWithSize:size*[_collection count]];

    } yield:^CNYieldResult(id a) {
        for(id b in _collection) {
            CNTuple *item = [CNTuple tupleWithA:a b: b];
            if([yield yieldItem:item] == cnYieldBreak) return cnYieldBreak;
        }
        return cnYieldContinue;
    } end:nil all:nil];
}

+ (id)linkWithCollection:(id)collection {
    return [[self alloc] initWithCollection:collection];
}

@end