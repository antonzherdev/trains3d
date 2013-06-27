#import "CNAppendLink.h"


@implementation CNAppendLink {
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
        return [yield beginYieldWithSize:size + [_collection count]];

    } yield:nil end:^CNYieldResult(CNYieldResult result) {
        if(result != cnYieldBreak) {
            for(id item in _collection) {
                result = [yield yieldItem:item];
                if(result == cnYieldBreak) break;
            }
        }
        return [yield endYieldWithResult:result];
    } all:nil];
}

+ (id)linkWithCollection:(id)collection {
    return [[self alloc] initWithCollection:collection];
}

@end