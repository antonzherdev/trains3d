#import <Foundation/Foundation.h>
#import "NSMutableSet+CNChain.h"
#import "CNCollection.h"

@class CNHashSetBuilder;
@protocol CNSet;

@protocol CNSet<CNIterable>
@end


@interface CNHashSetBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableSet* set;

+ (id)hashSetBuilder;
- (id)init;
- (void)addObject:(id)object;
- (NSSet*)build;
@end


