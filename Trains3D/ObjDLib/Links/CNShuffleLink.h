#import "objdcore.h"
#import "CNChain.h"
#import "ODObject.h"
@class CNYield;
@class NSMutableArray;
@class ODClassType;

@class CNShuffleLink;

@interface CNShuffleLink : NSObject<CNChainLink>
+ (instancetype)shuffleLink;
- (instancetype)init;
- (ODClassType*)type;
- (CNYield*)buildYield:(CNYield*)yield;
+ (ODClassType*)type;
@end


