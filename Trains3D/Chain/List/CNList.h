#import <Foundation/Foundation.h>
#import "CNCollection.h"

@class NSArrayBuilder;

@protocol CNList<CNIterable>
- (id)atIndex:(NSUInteger)index;
@end


@interface NSArrayBuilder : NSObject<CNBuilder>
@property (nonatomic, readonly) NSMutableArray* array;

+ (id)arrayBuilder;
- (id)init;
- (void)addObject:(id)object;
- (NSArray*)build;
@end


