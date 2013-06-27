#import <Foundation/Foundation.h>
#import "cnTypes.h"

@class CNChain;


@interface NSArray (CNChain)
- (id) chain:(cnChainBuildBlock)block;
- (CNChain*) chain;
- (CNChain*)filter:(cnPredicate)predicate;
- (CNChain*)filter:(cnPredicate)predicate selectivity:(double)selectivity;
- (CNChain*)map:(cnF)f;
@end