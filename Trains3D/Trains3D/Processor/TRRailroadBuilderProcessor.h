#import "objd.h"
#import "EGTypes.h"
@class EGProcessor;
@class EGMouseProcessor;
@class EGTouchProcessor;
@class EGEvent;
@class EGTwoFingerTouchToMouse;
@class TRRail;
@class TRSwitch;
@class TRRailroad;
@class TRRailroadBuilder;
#import "TRRailPoint.h"

@class TRRailroadBuilderProcessor;
@class TRRailroadBuilderMouseProcessor;
typedef struct TRRailCorrection TRRailCorrection;

@interface TRRailroadBuilderProcessor : NSObject
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (BOOL)processEvent:(EGEvent*)event;
@end


struct TRRailCorrection {
    EGIPoint tile;
    EGIPoint start;
    EGIPoint end;
};
static inline TRRailCorrection TRRailCorrectionMake(EGIPoint tile, EGIPoint start, EGIPoint end) {
    TRRailCorrection ret;
    ret.tile = tile;
    ret.start = start;
    ret.end = end;
    return ret;
}
static inline BOOL TRRailCorrectionEq(TRRailCorrection s1, TRRailCorrection s2) {
    return EGIPointEq(s1.tile, s2.tile) && EGIPointEq(s1.start, s2.start) && EGIPointEq(s1.end, s2.end);
}

@interface TRRailroadBuilderMouseProcessor : NSObject
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderMouseProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (BOOL)mouseDownEvent:(EGEvent*)event;
- (id)mouseDragEvent:(EGEvent*)event;
- (id)mouseUpEvent:(EGEvent*)event;
@end


