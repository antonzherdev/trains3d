#import <Foundation/Foundation.h>
#import "cnTypes.h"
#import "NSMutableArray+CNChain.h"
#import "CNCollection.h"
@class CNChain;
#import "CNSet.h"

@class NSArrayBuilder;

@protocol CNList<CNIterable>
- (id)atIndex:(NSUInteger)index;
- (id)randomItem;
- (id<CNSet>)toSet;
@end


@interface NSArrayBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableArray* array;

+ (id)arrayBuilder;
- (id)init;
- (void)addObject:(id)object;
- (NSArray*)build;
@end


