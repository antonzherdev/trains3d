#import <Foundation/Foundation.h>
#import "CNOption.h"
#import "cnTypes.h"
#import "CNCollection.h"
#import "CNList.h"
@class CNChain;

@class CNRange;
@class CNRangeIterator;

@interface CNRange : NSObject<CNList>
@property (nonatomic, readonly) NSInteger start;
@property (nonatomic, readonly) NSInteger end;
@property (nonatomic, readonly) NSInteger step;
@property (nonatomic, readonly) NSUInteger count;

+ (id)rangeWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step;
- (id)initWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step;
- (id)atIndex:(NSUInteger)index;
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


