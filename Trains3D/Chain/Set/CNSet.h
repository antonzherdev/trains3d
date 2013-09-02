#import "objdcore.h"
#import "CNCollection.h"

@class CNHashSetBuilder;
@protocol CNSet;
@protocol CNMutableSet;

@protocol CNSet<CNIterable>
@end


@protocol CNMutableSet<CNSet>
@end


@interface CNHashSetBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableSet* set;

+ (id)hashSetBuilder;
- (id)init;
- (ODClassType*)type;
- (void)addObject:(id)object;
- (NSSet*)build;
+ (ODClassType*)type;
@end


