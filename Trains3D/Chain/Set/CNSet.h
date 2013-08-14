#import <Foundation/Foundation.h>
#import "NSMutableSet+CNChain.h"
#import "CNCollection.h"

@class NSSetBuilder;

@protocol CNSet<CNIterable>
@end


@interface NSSetBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableSet* set;

+ (id)setBuilder;
- (id)init;
- (void)addObject:(id)object;
- (NSSet*)build;
@end


