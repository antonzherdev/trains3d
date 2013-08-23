#import <Foundation/Foundation.h>
@class CNChain;
#import "CNSeq.h"

@class CNSortBuilder;

@interface CNSortBuilder : NSObject
@property (nonatomic, readonly) CNChain* chain;

+ (id)sortBuilderWithChain:(CNChain*)chain;
- (id)initWithChain:(CNChain*)chain;
- (CNSortBuilder*)ascBy:(id(^)(id))by;
- (CNSortBuilder*)descBy:(id(^)(id))by;
- (CNSortBuilder*)byF:(NSInteger(^)(id, id))f;
- (CNChain*)endSort;
@end


