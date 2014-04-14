#import "objd.h"
#import "GEVec.h"
#import "EGFont.h"
@class ATVar;
@class EGText;
@class EGGlobal;
@class ATReact;
@class EGContext;
@class EGEnablingState;
@class EGBlendFunction;

@class EGStat;

@interface EGStat : NSObject {
@protected
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


