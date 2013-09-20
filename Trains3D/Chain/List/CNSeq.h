#import "objdcore.h"
#import "CNCollection.h"
@protocol CNSet;
@class CNHashSetBuilder;
@class CNChain;
@class ODClassType;
@class NSArray;

@class CNArrayBuilder;
@class CNIndexFunSeq;
@class CNIndexFunSeqIterator;
@protocol CNSeq;
@protocol CNMutableSeq;

@protocol CNSeq<CNIterable>
- (id)applyIndex:(NSUInteger)index;
- (id)randomItem;
- (id<CNSet>)toSet;
- (id<CNSeq>)arrayByAddingItem:(id)item;
- (id<CNSeq>)arrayByRemovingItem:(id)item;
- (BOOL)isEqualToSeq:(id<CNSeq>)seq;
- (BOOL)isEmpty;
- (id)head;
@end


@protocol CNMutableSeq<CNSeq, CNMutableIterable>
@end


@interface CNArrayBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableArray* array;

+ (id)arrayBuilder;
- (id)init;
- (ODClassType*)type;
- (void)addItem:(id)item;
- (NSArray*)build;
+ (ODClassType*)type;
@end


@interface CNIndexFunSeq : NSObject<CNSeq>
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) id(^f)(NSUInteger);

+ (id)indexFunSeqWithCount:(NSUInteger)count f:(id(^)(NSUInteger))f;
- (id)initWithCount:(NSUInteger)count f:(id(^)(NSUInteger))f;
- (ODClassType*)type;
- (id)applyIndex:(NSUInteger)index;
- (id<CNIterator>)iterator;
+ (ODClassType*)type;
@end


@interface CNIndexFunSeqIterator : NSObject<CNIterator>
@property (nonatomic, readonly) NSUInteger count;
@property (nonatomic, readonly) id(^f)(NSUInteger);
@property (nonatomic) NSUInteger i;

+ (id)indexFunSeqIteratorWithCount:(NSUInteger)count f:(id(^)(NSUInteger))f;
- (id)initWithCount:(NSUInteger)count f:(id(^)(NSUInteger))f;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


