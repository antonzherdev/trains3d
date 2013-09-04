#import "objd.h"
#import "EGTypes.h"
#import "EGProcessor.h"
@class EGTwoFingerTouchToMouse;
@class TRRailroadConnectorContent;
@class TREmptyConnector;
@class TRRail;
@class TRSwitch;
@class TRLight;
@class TRObstacleType;
@class TRObstacle;
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
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


struct TRRailCorrection {
    EGVec2I tile;
    EGVec2I start;
    EGVec2I end;
};
static inline TRRailCorrection TRRailCorrectionMake(EGVec2I tile, EGVec2I start, EGVec2I end) {
    TRRailCorrection ret;
    ret.tile = tile;
    ret.start = start;
    ret.end = end;
    return ret;
}
static inline BOOL TRRailCorrectionEq(TRRailCorrection s1, TRRailCorrection s2) {
    return EGVec2IEq(s1.tile, s2.tile) && EGVec2IEq(s1.start, s2.start) && EGVec2IEq(s1.end, s2.end);
}
static inline NSUInteger TRRailCorrectionHash(TRRailCorrection self) {
    NSUInteger hash = 0;
    hash = hash * 31 + EGVec2IHash(self.tile);
    hash = hash * 31 + EGVec2IHash(self.start);
    hash = hash * 31 + EGVec2IHash(self.end);
    return hash;
}
static inline NSString* TRRailCorrectionDescription(TRRailCorrection self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRRailCorrection: "];
    [description appendFormat:@"tile=%@", EGVec2IDescription(self.tile)];
    [description appendFormat:@", start=%@", EGVec2IDescription(self.start)];
    [description appendFormat:@", end=%@", EGVec2IDescription(self.end)];
    [description appendString:@">"];
    return description;
}
ODPType* trRailCorrectionType();
@interface TRRailCorrectionWrap : NSObject
@property (readonly, nonatomic) TRRailCorrection value;

+ (id)wrapWithValue:(TRRailCorrection)value;
- (id)initWithValue:(TRRailCorrection)value;
@end



@interface TRRailroadBuilderMouseProcessor : NSObject<EGMouseProcessor>
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderMouseProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (ODClassType*)type;
- (BOOL)mouseDownEvent:(EGEvent*)event;
- (BOOL)mouseDragEvent:(EGEvent*)event;
- (BOOL)mouseUpEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


