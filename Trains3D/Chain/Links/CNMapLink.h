#import <Foundation/Foundation.h>
#import "cnTypes.h"


@interface CNMapLink : NSObject <CNChainLink>
- (id)initWithF:(cnF)f;

+ (id)linkWithF:(cnF)f;

@end