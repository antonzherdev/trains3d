#import <Foundation/Foundation.h>
#import "cnTypes.h"
#import "CNList.h"

@class CNChain;


@interface NSArray (CNChain)<CNList>
- (id) chain:(cnChainBuildBlock)block;
- (CNChain*) chain;

- (id) head;
- (id) randomItem;
- (void) forEach:(cnP)p;
- (BOOL) goOn:(BOOL(^)(id))on;
- (id)findWhere:(cnPredicate)predicate;
- (NSArray *)arrayByRemovingObject:(id)object;
- (id <CNSet>)toSet;
@end