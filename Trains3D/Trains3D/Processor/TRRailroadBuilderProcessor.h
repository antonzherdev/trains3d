#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"
@class EGTwoFingerTouchToMouse;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRRailroad;
@class TRRailroadBuilder;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;

@class TRRailroadBuilderProcessor;
@class TRRailroadBuilderMouseProcessor;
typedef struct TRRailCorrection TRRailCorrection;

@interface TRRailroadBuilderProcessor : NSObject<EGProcessor>
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (BOOL)processEvent:(EGEvent*)event;
@end


struct TRRailCorrection {
    EGPointI tile;
    EGPointI start;
    EGPointI end;
};
static inline TRRailCorrection TRRailCorrectionMake(EGPointI tile, EGPointI start, EGPointI end) {
    TRRailCorrection ret;
    ret.tile = tile;
    ret.start = start;
    ret.end = end;
    return ret;
}
static inline BOOL TRRailCorrectionEq(TRRailCorrection s1, TRRailCorrection s2) {
    return EGPointIEq(s1.tile, s2.tile) && EGPointIEq(s1.start, s2.start) && EGPointIEq(s1.end, s2.end);
}
static inline NSUInteger TRRailCorrectionHash(TRRailCorrection self) {
    NSUInteger hash = 0;
    hash = hash * 31 + EGPointIHash(self.tile);
    hash = hash * 31 + EGPointIHash(self.start);
    hash = hash * 31 + EGPointIHash(self.end);
    return hash;
}
static inline NSString* TRRailCorrectionDescription(TRRailCorrection self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRRailCorrection: "];
    [description appendFormat:@"tile=%@", EGPointIDescription(self.tile)];
    [description appendFormat:@", start=%@", EGPointIDescription(self.start)];
    [description appendFormat:@", end=%@", EGPointIDescription(self.end)];
    [description appendString:@">"];
    return description;
}

@interface TRRailroadBuilderMouseProcessor : NSObject<EGMouseProcessor>
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderMouseProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (BOOL)mouseDownEvent:(EGEvent*)event;
- (BOOL)mouseDragEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
@end


