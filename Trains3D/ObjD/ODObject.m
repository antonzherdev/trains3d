#import "ODObject.h"
#import "CNRange.h"

@implementation NSNumber (ODObject)
- (NSInteger)compareTo:(id)to {
    return [self compare:to];
}
@end

CNRange* intRange(NSInteger x) {
    return [CNRange rangeWithStart:0 end:x step:1];
}

CNRange* uintRange(NSUInteger x) {
    return [CNRange rangeWithStart:0 end:x step:1];
}