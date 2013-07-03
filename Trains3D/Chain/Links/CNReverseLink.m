#import "CNReverseLink.h"


@implementation CNReverseLink {

}
- (id)init {
    self = [super init];
    if (self) {

    }

    return self;
}

- (CNYield *)buildYield:(CNYield *)yield {
    __block NSMutableArray* ret;
    return [CNYield decorateYield: yield begin:^CNYieldResult(NSUInteger size) {
        ret = [NSMutableArray arrayWithCapacity:size];
        return [yield beginYieldWithSize:size];

    } yield:^CNYieldResult(id item) {
        [ret insertObject:item atIndex:0];
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