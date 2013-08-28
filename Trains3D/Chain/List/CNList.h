#import "objdcore.h"
#import "CNCollection.h"
#import "CNSeq.h"
@class CNOption;
@class CNChain;

@class CNList;
@class CNFilledList;
@class CNEmptyList;
@class CNListIterator;

@interface CNList : NSObject<CNSeq>
+ (id)list;
- (id)init;
+ (CNList*)apply;
+ (CNList*)applyObject:(id)object;
+ (CNList*)applyObject:(id)object tail:(CNList*)tail;
- (id<CNIterator>)iterator;
- (CNList*)tail;
- (ODType*)type;
+ (ODType*)type;
@end


@interface CNFilledList : CNList
@property (nonatomic, readonly) id item;
@property (nonatomic, readonly) CNList* tail;

+ (id)filledListWithItem:(id)item tail:(CNList*)tail;
- (id)initWithItem:(id)item tail:(CNList*)tail;
- (id)head;
- (BOOL)isEmpty;
- (ODType*)type;
+ (ODType*)type;
@end


@interface CNEmptyList : CNList
+ (id)emptyList;
- (id)init;
- (id)head;
- (CNList*)tail;
- (BOOL)isEmpty;
- (ODType*)type;
+ (CNEmptyList*)instance;
+ (ODType*)type;
@end


@interface CNListIterator : NSObject<CNIterator>
@property (nonatomic, retain) CNList* list;

+ (id)listIterator;
- (id)init;
- (BOOL)hasNext;
- (id)next;
- (ODType*)type;
+ (ODType*)type;
@end


