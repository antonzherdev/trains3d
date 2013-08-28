#import "CNOption.h"


@implementation CNOption {

}
static CNOption * _some;
+ (id)none {
    return [NSNull null];
}

+ (id)opt:(id)value {
    return value == nil ? [NSNull null] : value;
}

+ (void)initialize {
    [super initialize];
    _some = [[CNOption alloc] init];
}


+ (id)some:(id)value {
    return value == nil ? _some : value;
}
@end