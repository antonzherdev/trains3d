#import "objdcore.h"
#import "CNSeq.h"
#import "ODObject.h"
#import "CNCollection.h"
@class ODClassType;
@protocol CNSet;
@class CNHashSetBuilder;
@class CNChain;
@class CNDispatchQueue;

@class CNMutableList;
@class CNMutableListItem;
@class CNMutableListIterator;
@class CNMutableListImmutableIterator;

@interface CNMutableList : NSObject<CNMutableSeq>
+ (instancetype)mutableList;
- (instancetype)init;
- (ODClassType*)type;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id<CNMutableIterator>)mutableIterator;
- (void)prependItem:(id)item;
- (void)appendItem:(id)item;
- (void)removeListItem:(CNMutableListItem*)listItem;
- (void)clear;
- (void)removeHead;
- (void)forEach:(void(^)(id))each;
- (BOOL)goOn:(BOOL(^)(id))on;
- (void)mutableFilterBy:(BOOL(^)(id))by;
- (id)headOpt;
- (id)head;
+ (ODClassType*)type;
@end


@interface CNMutableListItem : NSObject
@property (nonatomic, retain) id data;
@property (nonatomic, retain) CNMutableListItem* next;
@property (nonatomic, weak) CNMutableListItem* prev;

+ (instancetype)mutableListItem;
- (instancetype)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface CNMutableListIterator : NSObject<CNMutableIterator>
@property (nonatomic, readonly) CNMutableList* list;
@property (nonatomic, retain) CNMutableListItem* item;

+ (instancetype)mutableListIteratorWithList:(CNMutableList*)list;
- (instancetype)initWithList:(CNMutableList*)list;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
- (void)remove;
- (void)setValue:(id)value;
+ (ODClassType*)type;
@end


@interface CNMutableListImmutableIterator : NSObject<CNIterator>
@property (nonatomic, weak) CNMutableListItem* item;

+ (instancetype)mutableListImmutableIterator;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


