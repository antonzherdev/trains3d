#import "ODObject.h"
#import "CNRange.h"

@implementation NSNumber (ODObject)
- (NSInteger)compareTo:(id)to {
    return [self compare:to];
}
@end

CNRange* intRange(NSInteger x) {
    return [CNRange rangeWithStart:0 end:x - 1 step:1];
}
CNRange* intTo(NSInteger a, NSInteger b) {
    return [CNRange rangeWithStart:a end:b step:(a <= b) ? 1 : -1];
}

CNRange* uintRange(NSUInteger x) {
    return [CNRange rangeWithStart:0 end:x - 1 step:1];
}

CNRange* uintTo(NSUInteger a, NSUInteger b) {
    return [CNRange rangeWithStart:a end:b step:(a <= b) ? 1 : -1];
}
