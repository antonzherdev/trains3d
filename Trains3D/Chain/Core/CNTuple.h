#import <Foundation/Foundation.h>
#import "ODObject.h"

@class CNTuple;

@interface CNTuple : NSObject<ODComparable>
@property (nonatomic, readonly) id a;
@property (nonatomic, readonly) id b;

+ (id)tupleWithA:(id)a b:(id)b;
- (id)initWithA:(id)a b:(id)b;
- (NSInteger)compareTo:(CNTuple*)to;
@end


#define tuple(anA, aB) [CNTuple tupleWithA:anA b: aB]
