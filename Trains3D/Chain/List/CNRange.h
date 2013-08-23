#import <Foundation/Foundation.h>
#import "CNCollection.h"
#import "CNSeq.h"
@class CNChain;

@class CNRange;
@class CNRangeIterator;

@interface CNRange : NSObject<CNSeq>
@property (nonatomic, readonly) NSInteger start;
@property (nonatomic, readonly) NSInteger end;
@property (nonatomic, readonly) NSInteger step;
@property (nonatomic, readonly) NSUInteger count;

+ (id)rangeWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step;
- (id)initWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step;
- (id)applyIndex:(NSUInteger)index;
- (id<CNIterator>)iterator;
- (CNRange*)setStep:(NSInteger)step;
- (BOOL)isEmpty;
@end


@interface CNRangeIterator : NSObject<CNIterator>
@property (nonatomic, readonly) NSInteger start;
@property (nonatomic, readonly) NSInteger end;
@property (nonatomic, readonly) NSInteger step;

+ (id)rangeIteratorWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step;
- (id)initWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step;
- (BOOL)hasNext;
- (id)next;
@end


