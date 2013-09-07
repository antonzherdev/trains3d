#import "objdcore.h"
@class CNChain;
@protocol CNSeq;
@protocol CNMutableSeq;
@class NSArray;
@class NSMutableArray;
@class CNArrayBuilder;

@class CNSortBuilder;

@interface CNSortBuilder : NSObject
@property (nonatomic, readonly) CNChain* chain;

+ (id)sortBuilderWithChain:(CNChain*)chain;
- (id)initWithChain:(CNChain*)chain;
- (ODClassType*)type;
- (CNSortBuilder*)ascBy:(id(^)(id))by;
- (CNSortBuilder*)descBy:(id(^)(id))by;
- (CNSortBuilder*)andF:(NSInteger(^)(id, id))f;
- (CNChain*)endSort;
+ (ODClassType*)type;
@end


