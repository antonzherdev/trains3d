#import <Foundation/Foundation.h>
@class CNChain;

@class CNIterable;
@class CNSet;

@protocol CNIterator<NSObject>
- (id)next;
@end


@protocol CNTraversable<NSObject>
- (void)forEach:(void(^)(id))each;
- (BOOL)goOn:(BOOL(^)(id))on;
- (CNChain*)chain;
- (id)head;
@end


@interface CNIterable : NSObject<CNTraversable>
+ (id)iterable;
- (id)init;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
- (id)head;
- (BOOL)isEmpty;
- (CNChain*)chain;
- (void)forEach:(void(^)(id))each;
- (BOOL)goOn:(BOOL(^)(id))on;
@end


@interface CNSet : CNIterable
+ (id)set;
- (id)init;
- (BOOL)containsObject:(id)object;
@end


