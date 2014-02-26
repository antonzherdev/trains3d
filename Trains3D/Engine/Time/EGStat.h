#import "objd.h"
#import "GEVec.h"
#import "EGFont.h"
@class EGGlobal;
@class EGBlendFunction;

@class EGStat;

@interface EGStat : NSObject
+ (instancetype)stat;
- (instancetype)init;
- (ODClassType*)type;
- (CGFloat)frameRate;
- (void)draw;
- (void)tickWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


