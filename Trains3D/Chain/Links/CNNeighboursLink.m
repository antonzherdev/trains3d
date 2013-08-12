#import "cnTypes.h"
#import "CNNeighboursLink.h"
#import "CNTuple.h"


@implementation CNNeighboursLink {
}
- (id)init {
    self = [super init];
    
    return self;
}

+ (id)link {
    return [[self alloc] init];
}


- (CNYield *)buildYield:(CNYield *)yield {
    __block id prev = nil; 
    return [CNYield decorateYield:yield begin:^CNYieldResult(NSUInteger size) {
        return [yield beginYieldWithSize:size <= 1 ? 0 : size - 1];
    } yield:^CNYieldResult(id item) {
        CNYieldResult result = cnYieldContinue;
        if(prev != nil) result = [yield yieldItem:tuple(prev, item)];
        prev = item;
        return result;
    } end:nil all:nil];
}

@end