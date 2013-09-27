#import "objd.h"
#import "EGInput.h"
#import "GEVec.h"
@class TRRailroadBuilder;
@class EGTwoFingerTouchToMouse;
@class EGGlobal;
@class EGDirector;
@class TRRail;
@class TRRailConnector;
@class TRRailForm;

@class TRRailroadBuilderProcessor;
@class TRRailroadBuilderMouseProcessor;
typedef struct TRRailCorrection TRRailCorrection;

@interface TRRailroadBuilderProcessor : NSObject<EGInputProcessor>
@property (nonatomic, readonly) TRRailroadBuilder* builder;

+ (id)railroadBuilderProcessorWithBuilder:(TRRailroadBuilder*)builder;
- (id)initWithBuilder:(TRRailroadBuilder*)builder;
- (ODClassType*)type;
- (BOOL)processEvent:(EGEvent*)event;
+ (ODClassType*)type;
@end


struct TRRailCorrection {
    GEVec2i tile;
    GEVec2i start;
    GEVec2i end;
};
static inline TRRailCorrection TRRailCorrectionMake(GEVec2i tile, GEVec2i start, GEVec2i end) {
    return (TRRailCorrection){tile, start, end};
}
static inline BOOL TRRailCorrectionEq(TRRailCorrection s1, TRRailCorrection s2) {
    return GEVec2iEq(s1.tile, s2.tile) && GEVec2iEq(s1.start, s2.start) && GEVec2iEq(s1.end, s2.end);
}
static inline NSUInteger TRRailCorrectionHash(TRRailCorrection self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.tile);
    hash = hash * 31 + GEVec2iHash(self.start);
    hash = hash * 31 + GEVec2iHash(self.end);
    return hash;
}
NSString* TRRailCorrectionDescription(TRRailCorrection self);
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


