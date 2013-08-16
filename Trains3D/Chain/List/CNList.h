#import <Foundation/Foundation.h>
#import "cnTypes.h"
#import "NSMutableArray+CNChain.h"
#import "CNCollection.h"
@class CNChain;
#import "CNSet.h"

@class CNArrayBuilder;
@protocol CNList;
@protocol CNMutableList;

@protocol CNList<CNIterable>
- (id)atIndex:(NSUInteger)index;
- (id)randomItem;
- (id<CNSet>)toSet;
- (id<CNList>)arrayByAddingObject:(id)object;
- (id<CNList>)arrayByRemovingObject:(id)object;
@end


@protocol CNMutableList<CNList>
- (void)addObject:(id)object;
- (void)removeObject:(id)object;
@end


@interface CNArrayBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableArray* array;

+ (id)arrayBuilder;
- (id)init;
- (void)addObject:(id)object;
- (NSArray*)build;
@end


