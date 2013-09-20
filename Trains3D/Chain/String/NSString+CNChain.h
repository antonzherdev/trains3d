#import <Foundation/Foundation.h>
#import "CNSeq.h"

@protocol CNIterable;

@interface NSString (CNChain) <CNSeq>
- (id)tupleBy:(NSString *)by;

- (id <CNIterable>)splitBy:(NSString *)by;
@end