#import <Foundation/Foundation.h>


#define tuple(anA, aB) [CNTuple tupleWithA:anA b: aB]

@interface CNTuple : NSObject <NSCopying>
@property (readonly, nonatomic) id a;
@property (readonly, nonatomic) id b;

- (id)initWithA:(id)anA b:(id)aB;

+ (id)tupleWithA:(id)anA b:(id)aB;

- (BOOL)isEqual:(id)other;

- (BOOL)isEqualToTuple:(CNTuple *)tuple;

- (NSUInteger)hash;

- (NSString *)description;

- (id)copyWithZone:(NSZone *)zone;
@end