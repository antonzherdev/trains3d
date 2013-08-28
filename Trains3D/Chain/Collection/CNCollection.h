#import "objdcore.h"
@class CNChain;

@protocol CNIterator;
@protocol CNBuilder;
@protocol CNTraversable;
@protocol CNMutableTraversable;
@protocol CNIterable;
@protocol CNMutableIterable;

@protocol CNIterator<NSObject>
- (BOOL)hasNext;
- (id)next;
- (ODType*)type;
@end


@protocol CNBuilder<NSObject>
- (void)addObject:(id)object;
- (id)build;
- (void)addAllObject:(id<CNTraversable>)object;
- (ODType*)type;
@end


@protocol CNTraversable<NSObject>
- (void)forEach:(void(^)(id))each;
- (BOOL)goOn:(BOOL(^)(id))on;
- (CNChain*)chain;
- (id)findWhere:(BOOL(^)(id))where;
- (id)head;
- (id)convertWithBuilder:(id<CNBuilder>)builder;
- (ODType*)type;
@end


@protocol CNMutableTraversable<CNTraversable>
- (void)addObject:(id)object;
- (void)removeObject:(id)object;
- (ODType*)type;
@end


@protocol CNIterable<CNTraversable>
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id)head;
- (BOOL)isEmpty;
- (CNChain*)chain;
- (void)forEach:(void(^)(id))each;
- (BOOL)goOn:(BOOL(^)(id))on;
- (BOOL)containsObject:(id)object;
- (NSString*)description;
- (ODType*)type;
@end


@protocol CNMutableIterable<CNIterable>
- (ODType*)type;
@end


