#import "CNChainItem.h"


@implementation CNChainItem {
    id<CNChainLink> _link;
@private
    CNChainItem* _next;
}
@synthesize next = _next;

- (id)initWithLink:(id <CNChainLink>)link {
    self = [super init];
    if (self) {
        _link = link;
    }

    return self;
}


+ (id)itemWithLink:(id <CNChainLink>)link {
    return [[self alloc] initWithLink:link];
}

- (CNYield *)buildYield:(CNYield *)yield {
    CNYield *nextYield = _next == nil ? yield : [_next buildYield:yield];
    return [_link buildYield:nextYield];
}

@end