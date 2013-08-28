#import "objdcore.h"
#import "CNCollection.h"

@class CNHashSetBuilder;
@protocol CNSet;
@protocol CNMutableSet;

@protocol CNSet<CNIterable>
- (ODType*)type;
@end


@protocol CNMutableSet<CNSet>
- (ODType*)type;
@end


@interface CNHashSetBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableSet* set;

+ (id)hashSetBuilder;
- (id)init;
- (void)addObject:(id)object;
- (NSSet*)build;
- (ODType*)type;
+ (ODType*)type;
@end


