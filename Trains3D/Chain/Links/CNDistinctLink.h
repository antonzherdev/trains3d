#import <Foundation/Foundation.h>
#import "cnTypes.h"


@interface CNDistinctLink : NSObject <CNChainLink>
- (id)initWithSelectivity:(double)selectivity;
+ (id)linkWithSelectivity:(double)selectivity;
@end