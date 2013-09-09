#import "objdcore.h"
#import "CNSeq.h"
#import "CNCollection.h"

@class CNList;
@class CNFilledList;
@class CNEmptyList;
@class CNListIterator;

@interface CNList : NSObject<CNSeq>
+ (id)list;
- (id)init;
- (ODClassType*)type;
+ (CNList*)apply;
+ (CNList*)applyItem:(id)item;
+ (CNList*)applyItem:(id)item tail:(CNList*)tail;
- (id<CNIterator>)iterator;
- (CNList*)tail;
- (CNList*)filterF:(BOOL(^)(id))f;
+ (ODClassType*)type;
@end


@interface CNFilledList : CNList
@property (nonatomic, readonly) id item;
@property (nonatomic, readonly) CNList* tail;
@property (nonatomic, readonly) NSUInteger count;

+ (id)filledListWithItem:(id)item tail:(CNList*)tail;
- (id)initWithItem:(id)item tail:(CNList*)tail;
- (ODClassType*)type;
- (id)head;
- (BOOL)isEmpty;
- (CNList*)filterF:(BOOL(^)(id))f;
+ (ODClassType*)type;
@end


@interface CNEmptyList : CNList
+ (id)emptyList;
- (id)init;
- (ODClassType*)type;
- (NSUInteger)count;
- (id)head;
- (CNList*)tail;
- (BOOL)isEmpty;
- (CNList*)filterF:(BOOL(^)(id))f;
+ (CNEmptyList*)instance;
+ (ODClassType*)type;
@end


@interface CNListIterator : NSObject<CNIterator>
@property (nonatomic, retain) CNList* list;

+ (id)listIterator;
- (id)init;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (ODClassType*)type;
@end


