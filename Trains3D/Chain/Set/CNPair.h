#import "objd.h"
#import "CNCollection.h"
#import "CNSet.h"

@class CNPair;
@class CNPairIterator;

@interface CNPair : NSObject<CNSet>
@property (nonatomic, readonly) id a;
@property (nonatomic, readonly) id b;

+ (id)pairWithA:(id)a b:(id)b;
- (id)initWithA:(id)a b:(id)b;
+ (CNPair*)newWithA:(id)a b:(id)b;
- (BOOL)containsObject:(id)object;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id)head;
@end


@interface CNPairIterator : NSObject<CNIterator>
@property (nonatomic, readonly) CNPair* pair;

+ (id)pairIteratorWithPair:(CNPair*)pair;
- (id)initWithPair:(CNPair*)pair;
- (id)next;
@end


