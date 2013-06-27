#import <Foundation/Foundation.h>
#import "cnTypes.h"


@interface CNRangeLink : NSObject <CNChainLink>
- (id)initWithStart:(NSInteger)aStart end:(NSInteger)anEnd step:(NSInteger)aStep;

+ (id)linkWithStart:(NSInteger)aStart end:(NSInteger)anEnd step:(NSInteger)aStep;


@end