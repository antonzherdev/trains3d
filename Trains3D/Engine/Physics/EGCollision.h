#import "objd.h"
#import "EGVec.h"

@class EGCollision2;
@class EGContact;
@class EGIndexFunFilteredIterable;
@class EGIndexFunFilteredIterator;

@interface EGCollision2 : NSObject
@property (nonatomic, readonly) CNPair* bodies;
@property (nonatomic, readonly) id<CNSeq> contacts;

+ (id)collision2WithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts;
- (id)initWithBodies:(CNPair*)bodies contacts:(id<CNSeq>)contacts;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGContact : NSObject
@property (nonatomic, readonly) EGVec3 a;
@property (nonatomic, readonly) EGVec3 b;

+ (id)contactWithA:(EGVec3)a b:(EGVec3)b;
- (id)initWithA:(EGVec3)a b:(EGVec3)b;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGIndexFunFilteredIterable : NSObject<CNIterable>
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (id)indexFunFilteredIterableWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (id)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (ODClassType*)type;
- (id<CNIterator>)iterator;
+ (ODClassType*)type;
@end


@interface EGIndexFunFilteredIterator : NSObject<CNIterator>
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (id)indexFunFilteredIteratorWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (id)initWithMaxCount:(NSUInteger)maxCount f:(id(^)(NSUInteger))f;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


