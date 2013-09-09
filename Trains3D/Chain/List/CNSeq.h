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
- (id<CNSeq>)arrayByAddingItem:(id)item;
- (id<CNSeq>)arrayByRemovingItem:(id)item;
- (BOOL)isEqualToSeq:(id<CNSeq>)seq;
@end


@protocol CNMutableSeq<CNSeq, CNMutableIterable>
@end


@interface CNArrayBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableArray* array;

+ (id)arrayBuilder;
- (id)init;
- (ODClassType*)type;
- (void)addItem:(id)item;
- (NSArray*)build;
+ (ODClassType*)type;
@end


