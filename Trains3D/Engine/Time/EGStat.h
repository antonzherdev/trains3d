#import "objd.h"
#import "GEVec.h"
#import "EGFont.h"
@class EGGlobal;

@class EGStat;

@interface EGStat : NSObject
@property (nonatomic, readonly) EGFont* font;

+ (id)stat;
- (id)init;
- (ODClassType*)type;
- (NSUInteger)frameRate;
- (void)draw;
- (void)tickWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


