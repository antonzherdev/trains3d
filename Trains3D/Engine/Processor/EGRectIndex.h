#import "objd.h"
#import "EGTypes.h"

@class EGRectIndex;

@interface EGRectIndex : NSObject
@property (nonatomic, readonly) id<CNSeq> rects;

+ (id)rectIndexWithRects:(id<CNSeq>)rects;
- (id)initWithRects:(id<CNSeq>)rects;
- (id)applyPoint:(EGPoint)point;
- (ODType*)type;
+ (ODType*)type;
@end


