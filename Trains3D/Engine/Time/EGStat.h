#import "objd.h"
#import "GEVec.h"
#import "EGFont.h"
@class CNVar;
@class EGText;
@class EGGlobal;
@class CNReact;
@class EGContext;
@class EGEnablingState;
@class EGBlendFunction;

@class EGStat;

@interface EGStat : NSObject {
@protected
    CGFloat _accumDelta;
    NSUInteger _framesCount;
    CGFloat __frameRate;
    CNVar* _textVar;
    EGText* _text;
}
+ (instancetype)stat;
- (instancetype)init;
- (CNClassType*)type;
- (CGFloat)frameRate;
- (void)draw;
- (void)tickWithDelta:(CGFloat)delta;
- (NSString*)description;
+ (CNClassType*)type;
@end


