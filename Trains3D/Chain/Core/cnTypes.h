#import "CNYield.h"

@class CNChain;
typedef void (^cnChainBuildBlock)(CNChain * chain);
typedef BOOL (^cnPredicate)(id x);
typedef id (^cnF)(id x);
typedef id (^cnF0)();
typedef void (^cnP)(id x);

@protocol CNChainLink <NSObject>
- (CNYield *)buildYield:(CNYield *)yield;
@end

extern id cnResolveCollection(id collection);

