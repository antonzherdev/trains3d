#import "CNOption.h"


@implementation CNOption {

}
+ (id)none {
    return [NSNull null];
}

+ (id)opt:(id)value {
    return value == nil ? [NSNull null] : value;
}


@end