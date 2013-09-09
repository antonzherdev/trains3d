#import "objdcore.h"
#import "CNCollection.h"
@protocol CNSet;
@class CNHashSetBuilder;
@class CNChain;

@class CNArrayBuilder;
@protocol CNSeq;
@protocol CNMutableSeq;

@protocol CNSeq<CNIterable>
- (id)applyIndex:(NSUInteger)index;
- (id)randomItem;
- (id<CNSet>)toSet;
- (id<CNSeq>)arrayByAddingObject:(id)object;
- (id<CNSeq>)arrayByRemovingObject:(id)object;
- (BOOL)isEqualToSeq:(id<CNSeq>)seq;
@end


@protocol CNMutableSeq<CNSeq>
@end


@interface CNArrayBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableArray* array;

+ (id)arrayBuilder;
- (id)init;
- (ODClassType*)type;
- (void)addObject:(id)object;
- (NSArray*)build;
+ (ODClassType*)type;
@end


