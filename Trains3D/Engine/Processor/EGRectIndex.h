#import "objd.h"
#import "GERect.h"
#import "GEVec.h"

@class EGRectIndex;

@interface EGRectIndex : NSObject
@property (nonatomic, readonly) id<CNSeq> rects;

+ (id)rectIndexWithRects:(id<CNSeq>)rects;
- (id)initWithRects:(id<CNSeq>)rects;
- (ODClassType*)type;
- (id)applyPoint:(GEVec2)point;
+ (ODClassType*)type;
@end


