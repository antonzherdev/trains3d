#import "objdcore.h"
#import "ODObject.h"
@class ODClassType;
@class CNDispatchQueue;
@class CNChain;

@class CNIterableF;
@class CNEmptyIterator;
@protocol CNIterator;
@protocol CNMutableIterator;
@protocol CNBuilder;
@protocol CNTraversable;
@protocol CNMutableTraversable;
@protocol CNIterable;
@protocol CNMutableIterable;

@protocol CNIterator<NSObject>
- (BOOL)hasNext;
- (id)next;
@end


@protocol CNMutableIterator<CNIterator>
- (void)remove;
- (void)setValue:(id)value;
@end


@protocol CNBuilder<NSObject>
- (void)appendItem:(id)item;
- (id)build;
- (void)appendAllItems:(id<CNTraversable>)items;
@end


@protocol CNTraversable<NSObject>
- (void)forEach:(void(^)(id))each;
- (void)parForEach:(void(^)(id))each;
- (BOOL)goOn:(BOOL(^)(id))on;
- (CNChain*)chain;
- (id)findWhere:(BOOL(^)(id))where;
- (BOOL)existsWhere:(BOOL(^)(id))where;
- (BOOL)allConfirm:(BOOL(^)(id))confirm;
- (id)head;
- (id)headOpt;
- (id)convertWithBuilder:(id<CNBuilder>)builder;
@end


@protocol CNMutableTraversable<CNTraversable>
- (void)appendItem:(id)item;
- (BOOL)removeItem:(id)item;
- (void)clear;
@end


@protocol CNIterable<CNTraversable>
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id)head;
- (id)headOpt;
- (BOOL)isEmpty;
- (CNChain*)chain;
- (void)forEach:(void(^)(id))each;
- (void)parForEach:(void(^)(id))each;
- (BOOL)goOn:(BOOL(^)(id))on;
- (BOOL)containsItem:(id)item;
- (NSString*)description;
- (NSUInteger)hash;
@end


@protocol CNMutableIterable<CNIterable, CNMutableTraversable>
- (id<CNMutableIterator>)mutableIterator;
- (BOOL)removeItem:(id)item;
- (void)mutableFilterBy:(BOOL(^)(id))by;
@end


@interface CNIterableF : NSObject<CNIterable>
@property (nonatomic, readonly) id<CNIterator>(^iteratorF)();

+ (instancetype)iterableFWithIteratorF:(id<CNIterator>(^)())iteratorF;
- (instancetype)initWithIteratorF:(id<CNIterator>(^)())iteratorF;
- (ODClassType*)type;
- (id<CNIterator>)iterator;
+ (ODClassType*)type;
@end


@interface CNEmptyIterator : NSObject<CNIterator>
+ (instancetype)emptyIterator;
- (instancetype)init;
- (ODClassType*)type;
- (BOOL)hasNext;
- (id)next;
+ (CNEmptyIterator*)instance;
+ (ODClassType*)type;
@end


