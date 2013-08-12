#import <Foundation/Foundation.h>
#import "CNOption.h"
#import "cnTypes.h"
#import "CNCollection.h"

@class CNRange;
@class CNRangeIterator;

@interface CNRange : CNIterable
@property (nonatomic, readonly) NSInteger start;
@property (nonatomic, readonly) NSInteger end;
@property (nonatomic, readonly) NSInteger step;

+ (id)rangeWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step;
- (id)initWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step;
- (NSUInteger)count;
- (id<CNIterator>)iterator;
@end


@interface CNRangeIterator : NSObject<CNIterator>
@property (nonatomic, readonly) NSInteger start;
@property (nonatomic, readonly) NSInteger end;
@property (nonatomic, readonly) NSInteger step;

+ (id)rangeIteratorWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step;
- (id)initWithStart:(NSInteger)start end:(NSInteger)end step:(NSInteger)step;
- (id)next;
@end


