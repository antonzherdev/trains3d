#import <Foundation/Foundation.h>
@class CNChain;

@protocol CNIterator;
@protocol CNBuilder;
@protocol CNTraversable;
@protocol CNIterable;

@protocol CNIterator<NSObject>
- (BOOL)hasNext;
- (id)next;
@end


@protocol CNBuilder<NSObject>
- (void)addObject:(id)object;
- (id)build;
- (void)addAllObject:(id<CNTraversable>)object;
@end


@protocol CNTraversable<NSObject>
- (void)forEach:(void(^)(id))each;
- (BOOL)goOn:(BOOL(^)(id))on;
- (CNChain*)chain;
- (id)findWhere:(BOOL(^)(id))where;
- (id)head;
- (id)convertWithBuilder:(id<CNBuilder>)builder;
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
@end


