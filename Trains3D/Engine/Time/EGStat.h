#import "objd.h"
#import "EGMaterial.h"
#import "GEVec.h"
#import "EGFont.h"
@class EGGlobal;

@class EGStat;

@interface EGStat : NSObject
@property (nonatomic, readonly) EGFont* font;

+ (id)stat;
- (id)init;
- (ODClassType*)type;
- (CGFloat)frameRate;
- (void)draw;
- (void)tickWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


