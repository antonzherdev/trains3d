#import <Foundation/Foundation.h>
#import "cnTypes.h"


@interface CNMulLink : NSObject <CNChainLink>
- (id)initWithCollection:(id)collection;

+ (id)linkWithCollection:(id)collection;

@end