#import "objdcore.h"
#import "CNSeq.h"
#import "ODObject.h"
#import "CNCollection.h"
@class ODClassType;
@class CNChain;
@protocol CNSet;
@class CNHashSetBuilder;
@class CNDispatchQueue;

@class CNList;
@class CNFilledList;
@class CNEmptyList;
@class CNListIterator;

@interface CNList : NSObject<CNImSeq>
+ (instancetype)list;
- (instancetype)init;
- (ODClassType*)type;
+ (CNList*)apply;
+ (CNList*)applyItem:(id)item;
+ (CNList*)applyItem:(id)item tail:(CNList*)tail;
- (id<CNIterator>)iterator;
- (CNList*)tail;
- (CNList*)filterF:(BOOL(^)(id))f;
- (CNList*)reverse;
+ (ODClassType*)type;
@end


@interface CNFilledList : CNList
@property (nonatomic, readonly) id head;
@property (nonatomic, readonly) CNList* tail;
@property (nonatomic, readonly) NSUInteger count;

+ (instancetype)filledListWithHead:(id)head tail:(CNList*)tail;
- (instancetype)initWithHead:(id)head tail:(CNList*)tail;
- (ODClassType*)type;
- (id)headOpt;
- (BOOL)isEmpty;
- (CNList*)filterF:(BOOL(^)(id))f;
- (CNList*)reverse;
- (void)forEach:(void(^)(id))each;
+ (ODClassType*)type;
@end


@interface CNEmptyList : CNList
+ (instancetype)emptyList;
- (instancetype)init;
- (ODClassType*)type;
- (NSUInteger)count;
- (id)head;
- (id)headOpt;
- (CNList*)tail;
- (BOOL)isEmpty;
- (CNList*)filterF:(BOOL(^)(id))f;
- (CNList*)reverse;
- (void)forEach:(void(^)(id))each;
+ (CNEmptyList*)instance;
+ (ODClassType*)type;
@end


@interface CNListIterator : NSObject<CNIterator>
@property (nonatomic, retain) CNList* list;

+ (instancetype)listIterator;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


