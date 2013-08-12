#import "ODObject.h"

@implementation NSNumber (ODObject)
- (NSInteger)compareTo:(id)to {
    return [self compare:to];
}
@end