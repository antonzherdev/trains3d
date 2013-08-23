#import <Foundation/Foundation.h>
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
@end


@interface CNFilledList : CNList
@property (nonatomic, readonly) id item;
@property (nonatomic, readonly) CNList* tail;

+ (id)filledListWithItem:(id)item tail:(CNList*)tail;
- (id)initWithItem:(id)item tail:(CNList*)tail;
- (id)head;
- (BOOL)isEmpty;
@end


@interface CNEmptyList : CNList
+ (id)emptyList;
- (id)init;
- (id)head;
- (CNList*)tail;
- (BOOL)isEmpty;
+ (CNEmptyList*)instance;
@end


@interface CNListIterator : NSObject<CNIterator>
@property (nonatomic, retain) CNList* list;

+ (id)listIterator;
- (id)init;
- (BOOL)hasNext;
- (id)next;
@end


