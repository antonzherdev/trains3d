#import "objdcore.h"
#import "CNSeq.h"
#import "CNCollection.h"
@class ODClassType;
@class CNChain;
@protocol CNSet;
@class CNHashSetBuilder;
@class CNDispatchQueue;

@class CNImList;
@class CNFilledList;
@class CNEmptyList;
@class CNListIterator;
@class CNImListBuilder;

@interface CNImList : NSObject<CNImSeq>
+ (instancetype)imList;
- (instancetype)init;
- (ODClassType*)type;
+ (CNImList*)apply;
+ (CNImList*)applyItem:(id)item;
+ (CNImList*)applyItem:(id)item tail:(CNImList*)tail;
- (id<CNIterator>)iterator;
- (CNImList*)tail;
- (CNImList*)filterF:(BOOL(^)(id))f;
- (CNImList*)reverse;
+ (ODClassType*)type;
@end


@interface CNFilledList : CNImList {
@private
    id _head;
    CNImList* _tail;
    NSUInteger _count;
}
@property (nonatomic, readonly) id head;
@property (nonatomic, readonly) CNImList* tail;
@property (nonatomic, readonly) NSUInteger count;

+ (instancetype)filledListWithHead:(id)head tail:(CNImList*)tail;
- (instancetype)initWithHead:(id)head tail:(CNImList*)tail;
- (ODClassType*)type;
- (id)headOpt;
- (BOOL)isEmpty;
- (CNImList*)filterF:(BOOL(^)(id))f;
- (CNImList*)reverse;
- (void)forEach:(void(^)(id))each;
+ (ODClassType*)type;
@end


@interface CNEmptyList : CNImList
+ (instancetype)emptyList;
- (instancetype)init;
- (ODClassType*)type;
- (NSUInteger)count;
- (id)head;
- (id)headOpt;
- (CNImList*)tail;
- (BOOL)isEmpty;
- (CNImList*)filterF:(BOOL(^)(id))f;
- (CNImList*)reverse;
- (void)forEach:(void(^)(id))each;
+ (CNEmptyList*)instance;
+ (ODClassType*)type;
@end


@interface CNListIterator : NSObject<CNIterator> {
@private
    CNImList* _list;
}
@property (nonatomic, retain) CNImList* list;

+ (instancetype)listIterator;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


@interface CNImListBuilder : NSObject<CNBuilder> {
@private
    CNImList* _list;
}
+ (instancetype)imListBuilder;
- (instancetype)init;
- (ODClassType*)type;
- (void)appendItem:(id)item;
- (CNImList*)build;
+ (ODClassType*)type;
@end


