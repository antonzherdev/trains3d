#import "objdcore.h"
#import "CNCollection.h"
@class ODClassType;
@class CNChain;
@class CNDispatchQueue;

@class CNHashSetBuilder;
@protocol CNSet;
@protocol CNMutableSet;

@protocol CNSet<CNIterable>
@end


@protocol CNMutableSet<CNSet, CNMutableIterable>
@end


@interface CNHashSetBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableSet* set;

+ (instancetype)hashSetBuilder;
- (instancetype)init;
- (ODClassType*)type;
- (void)appendItem:(id)item;
- (NSSet*)build;
+ (ODClassType*)type;
@end


