#import "objd.h"
#import "GEVec.h"
#import "EGFont.h"
@class ATVar;
@class EGText;
@class EGGlobal;
@class ATReact;
@class EGBlendFunction;

@class EGStat;

@interface EGStat : NSObject {
@private
    CGFloat _accumDelta;
    NSUInteger _framesCount;
    CGFloat __frameRate;
    ATVar* _textVar;
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


