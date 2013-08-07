#import "objd.h"
#import "EGTypes.h"

@class EGRectIndex;

@interface EGRectIndex : NSObject
@property (nonatomic, readonly) NSArray* rects;

+ (id)rectIndexWithRects:(NSArray*)rects;
- (id)initWithRects:(NSArray*)rects;
- (id)objectForPoint:(EGPoint)point;
@end


