#import <Foundation/Foundation.h>
#import "cnTypes.h"


@interface CNNeighboursLink : NSObject <CNChainLink>
- (id)initWithRing:(BOOL)ring;

+ (id)linkWithRing:(BOOL)ring;
@end