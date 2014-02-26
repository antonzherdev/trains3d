#import "objdcore.h"
#import "CNChain.h"
@class CNYield;
@protocol CNTraversable;
@class ODClassType;

@class CNFlatLink;

@interface CNFlatLink : NSObject<CNChainLink>
@property (nonatomic, readonly) CGFloat factor;

+ (instancetype)flatLinkWithFactor:(CGFloat)factor;
- (instancetype)initWithFactor:(CGFloat)factor;
- (ODClassType*)type;
- (CNYield*)buildYield:(CNYield*)yield;
+ (ODClassType*)type;
@end


