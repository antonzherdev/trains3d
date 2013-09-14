#import "objd.h"
#import "EGProcessor.h"
#import "GEVec.h"
@class TRRailroadBuilder;
@class EGTwoFingerTouchToMouse;
@class TRRail;
@class TRRailConnector;
@class TRRailForm;

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
    GEVec2I tile;
    GEVec2I start;
    GEVec2I end;
};
static inline TRRailCorrection TRRailCorrectionMake(GEVec2I tile, GEVec2I start, GEVec2I end) {
    return (TRRailCorrection){tile, start, end};
}
static inline BOOL TRRailCorrectionEq(TRRailCorrection s1, TRRailCorrection s2) {
    return GEVec2IEq(s1.tile, s2.tile) && GEVec2IEq(s1.start, s2.start) && GEVec2IEq(s1.end, s2.end);
}
static inline NSUInteger TRRailCorrectionHash(TRRailCorrection self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2IHash(self.tile);
    hash = hash * 31 + GEVec2IHash(self.start);
    hash = hash * 31 + GEVec2IHash(self.end);
    return hash;
}
static inline NSString* TRRailCorrectionDescription(TRRailCorrection self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRRailCorrection: "];
    [description appendFormat:@"tile=%@", GEVec2IDescription(self.tile)];
    [description appendFormat:@", start=%@", GEVec2IDescription(self.start)];
    [description appendFormat:@", end=%@", GEVec2IDescription(self.end)];
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


