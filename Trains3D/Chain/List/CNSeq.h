#import <Foundation/Foundation.h>
#import "CNCollection.h"
@class CNChain;
#import "CNSet.h"

@class CNArrayBuilder;
@protocol CNSeq;
@protocol CNMutableSeq;

@protocol CNSeq<CNIterable>
- (id)applyIndex:(NSUInteger)index;
- (id)randomItem;
- (id<CNSet>)toSet;
- (id<CNSeq>)arrayByAddingObject:(id)object;
- (id<CNSeq>)arrayByRemovingObject:(id)object;
@end


@protocol CNMutableSeq<CNSeq>
@end


@interface CNArrayBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableArray* array;

+ (id)arrayBuilder;
- (id)init;
- (void)addObject:(id)object;
- (NSArray*)build;
@end


