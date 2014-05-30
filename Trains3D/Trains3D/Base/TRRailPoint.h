#import "objd.h"
#import "GEVec.h"

@class TRRailConnector;
@class TRRailForm;
typedef struct TRRailPoint TRRailPoint;
typedef struct TRRailPointCorrection TRRailPointCorrection;

typedef enum TRRailConnectorR {
    TRRailConnector_Nil = 0,
    TRRailConnector_left = 1,
    TRRailConnector_bottom = 2,
    TRRailConnector_top = 3,
    TRRailConnector_right = 4
} TRRailConnectorR;
@interface TRRailConnector : CNEnum
@property (nonatomic, readonly) NSInteger x;
@property (nonatomic, readonly) NSInteger y;
@property (nonatomic, readonly) NSInteger angle;

+ (TRRailConnectorR)connectorForX:(NSInteger)x y:(NSInteger)y;
- (TRRailConnectorR)otherSideConnector;
- (CNPair*)neighbours;
- (GEVec2i)nextTile:(GEVec2i)tile;
- (GEVec2i)vec;
+ (NSArray*)values;
+ (TRRailConnector*)value:(TRRailConnectorR)r;
@end


typedef enum TRRailFormR {
    TRRailForm_Nil = 0,
    TRRailForm_leftBottom = 1,
    TRRailForm_leftRight = 2,
    TRRailForm_leftTop = 3,
    TRRailForm_bottomTop = 4,
    TRRailForm_bottomRight = 5,
    TRRailForm_topRight = 6
} TRRailFormR;
@interface TRRailForm : CNEnum
@property (nonatomic, readonly) TRRailConnectorR start;
@property (nonatomic, readonly) TRRailConnectorR end;
@property (nonatomic, readonly) BOOL isTurn;
@property (nonatomic, readonly) CGFloat length;
@property (nonatomic, readonly) GEVec2(^pointFun)(CGFloat);

+ (TRRailFormR)formForConnector1:(TRRailConnectorR)connector1 connector2:(TRRailConnectorR)connector2;
- (BOOL)containsConnector:(TRRailConnectorR)connector;
- (BOOL)isStraight;
- (GELine2)line;
- (NSArray*)connectors;
- (TRRailConnectorR)otherConnectorThan:(TRRailConnectorR)than;
+ (NSArray*)values;
+ (TRRailForm*)value:(TRRailFormR)r;
@end


struct TRRailPoint {
    GEVec2i tile;
    TRRailFormR form;
    CGFloat x;
    BOOL back;
    GEVec2 point;
};
static inline TRRailPoint TRRailPointMake(GEVec2i tile, TRRailFormR form, CGFloat x, BOOL back, GEVec2 point) {
    return (TRRailPoint){tile, form, x, back, point};
}
TRRailPoint trRailPointApply();
TRRailPoint trRailPointApplyTileFormXBack(GEVec2i tile, TRRailFormR form, CGFloat x, BOOL back);
TRRailPoint trRailPointAddX(TRRailPoint self, CGFloat x);
TRRailConnectorR trRailPointStartConnector(TRRailPoint self);
TRRailConnectorR trRailPointEndConnector(TRRailPoint self);
BOOL trRailPointIsValid(TRRailPoint self);
TRRailPointCorrection trRailPointCorrect(TRRailPoint self);
TRRailPoint trRailPointInvert(TRRailPoint self);
TRRailPoint trRailPointSetX(TRRailPoint self, CGFloat x);
GEVec2i trRailPointNextTile(TRRailPoint self);
TRRailPoint trRailPointStraight(TRRailPoint self);
BOOL trRailPointBetweenAB(TRRailPoint self, TRRailPoint a, TRRailPoint b);
NSString* trRailPointDescription(TRRailPoint self);
BOOL trRailPointIsEqualTo(TRRailPoint self, TRRailPoint to);
NSUInteger trRailPointHash(TRRailPoint self);
CNPType* trRailPointType();
@interface TRRailPointWrap : NSObject
@property (readonly, nonatomic) TRRailPoint value;

+ (id)wrapWithValue:(TRRailPoint)value;
- (id)initWithValue:(TRRailPoint)value;
@end



struct TRRailPointCorrection {
    TRRailPoint point;
    CGFloat error;
};
static inline TRRailPointCorrection TRRailPointCorrectionMake(TRRailPoint point, CGFloat error) {
    return (TRRailPointCorrection){point, error};
}
TRRailPoint trRailPointCorrectionAddErrorToPoint(TRRailPointCorrection self);
NSString* trRailPointCorrectionDescription(TRRailPointCorrection self);
BOOL trRailPointCorrectionIsEqualTo(TRRailPointCorrection self, TRRailPointCorrection to);
NSUInteger trRailPointCorrectionHash(TRRailPointCorrection self);
CNPType* trRailPointCorrectionType();
@interface TRRailPointCorrectionWrap : NSObject
@property (readonly, nonatomic) TRRailPointCorrection value;

+ (id)wrapWithValue:(TRRailPointCorrection)value;
- (id)initWithValue:(TRRailPointCorrection)value;
@end



