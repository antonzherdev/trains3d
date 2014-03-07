#import <Foundation/Foundation.h>
#import "CNSeq.h"

@interface NSMutableArray (CNChain) <CNMSeq>
+ (NSMutableArray *)mutableArray;

+ (NSMutableArray *)applyCapacity:(NSUInteger)size;
@end