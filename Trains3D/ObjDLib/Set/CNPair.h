#import "objdcore.h"
#import "CNSet.h"
#import "CNCollection.h"
@class ODClassType;
@class CNDispatchQueue;
@class CNChain;

@class CNPair;
@class CNPairIterator;

@interface CNPair : NSObject<CNImSet> {
@private
    id _a;
    id _b;
}
@property (nonatomic, readonly) id a;
@property (nonatomic, readonly) id b;

+ (instancetype)pairWithA:(id)a b:(id)b;
- (instancetype)initWithA:(id)a b:(id)b;
- (ODClassType*)type;
+ (CNPair*)newWithA:(id)a b:(id)b;
- (BOOL)containsItem:(id)item;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id)head;
- (id)headOpt;
+ (ODClassType*)type;
@end


@interface CNPairIterator : NSObject<CNIterator> {
@private
    CNPair* _pair;
    NSInteger _state;
}
@property (nonatomic, readonly) CNPair* pair;

+ (instancetype)pairIteratorWithPair:(CNPair*)pair;
- (instancetype)initWithPair:(CNPair*)pair;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


