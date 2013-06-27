#import <Foundation/Foundation.h>
#import "cnTypes.h"


@interface CNSourceLink : NSObject <CNChainLink>
- (id)initWithCollection:(NSObject<NSFastEnumeration>*)collection;

+ (id)linkWithCollection:(NSObject<NSFastEnumeration>*)collection;

@end