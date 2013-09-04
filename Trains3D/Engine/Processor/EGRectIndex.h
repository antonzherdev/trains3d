#import "objd.h"
#import "EGTypes.h"

@class EGRectIndex;

@interface EGRectIndex : NSObject
@property (nonatomic, readonly) id<CNSeq> rects;

+ (id)rectIndexWithRects:(id<CNSeq>)rects;
- (id)initWithRects:(id<CNSeq>)rects;
- (ODClassType*)type;
- (id)applyPoint:(EGVec2)point;
+ (ODClassType*)type;
@end


