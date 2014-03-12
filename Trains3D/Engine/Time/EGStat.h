#import "objd.h"
#import "GEVec.h"
#import "EGFont.h"
@class EGGlobal;
@class EGBlendFunction;

@class EGStat;

@interface EGStat : NSObject {
@private
    CGFloat _accumDelta;
    NSUInteger _framesCount;
    CGFloat __frameRate;
    EGText* _text;
}
+ (instancetype)stat;
- (instancetype)init;
- (ODClassType*)type;
- (CGFloat)frameRate;
- (void)draw;
- (void)tickWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


