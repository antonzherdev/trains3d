#import "objd.h"
#import "EGTypes.h"

@class EGRectIndex;

@interface EGRectIndex : NSObject
@property (nonatomic, readonly) id<CNList> rects;

+ (id)rectIndexWithRects:(id<CNList>)rects;
- (id)initWithRects:(id<CNList>)rects;
- (id)applyPoint:(EGPoint)point;
@end


