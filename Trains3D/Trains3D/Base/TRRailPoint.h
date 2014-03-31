#import "objd.h"
#import "GEVec.h"

@class TRRailConnector;
@class TRRailForm;
typedef struct TRRailPoint TRRailPoint;
typedef struct TRRailPointCorrection TRRailPointCorrection;

@interface TRRailConnector : ODEnum
@property (nonatomic, readonly) NSInteger x;
@property (nonatomic, readonly) NSInteger y;
@property (nonatomic, readonly) NSInteger angle;

+ (TRRailConnector*)connectorForX:(NSInteger)x y:(NSInteger)y;
- (TRRailConnector*)otherSideConnector;
- (CNPair*)neighbours;
- (GEVec2i)nextTile:(GEVec2i)tile;
- (GEVec2i)vec;
+ (TRRailConnector*)left;
+ (TRRailConnector*)bottom;
+ (TRRailConnector*)top;
+ (TRRailConnector*)right;
+ (NSArray*)values;
@end


@interface TRRailForm : ODEnum
@property (nonatomic, readonly) TRRailConnector* start;
@property (nonatomic, readonly) TRRailConnector* end;
@property (nonatomic, readonly) BOOL isTurn;
@property (nonatomic, readonly) CGFloat length;
@property (nonatomic, readonly) GEVec2(^pointFun)(CGFloat);

+ (TRRailForm*)formForConnector1:(TRRailConnector*)connector1 connector2:(TRRailConnector*)connector2;
- (BOOL)containsConnector:(TRRailConnector*)connector;
- (BOOL)isStraight;
- (GELine2)line;
- (NSArray*)connectors;
- (TRRailConnector*)otherConnectorThan:(TRRailConnector*)than;
+ (TRRailForm*)leftBottom;
+ (TRRailForm*)leftRight;
+ (TRRailForm*)leftTop;
+ (TRRailForm*)bottomTop;
+ (TRRailForm*)bottomRight;
+ (TRRailForm*)topRight;
+ (NSArray*)values;
@end


struct TRRailPoint {
    GEVec2i tile;
    __unsafe_unretained TRRailForm* form;
    CGFloat x;
    BOOL back;
    GEVec2 point;
};
static inline TRRailPoint TRRailPointMake(GEVec2i tile, TRRailForm* form, CGFloat x, BOOL back, GEVec2 point) {
    return (TRRailPoint){tile, form, x, back, point};
}
static inline BOOL TRRailPointEq(TRRailPoint s1, TRRailPoint s2) {
    return GEVec2iEq(s1.tile, s2.tile) && s1.form == s2.form && eqf(s1.x, s2.x) && s1.back == s2.back && GEVec2Eq(s1.point, s2.point);
}
static inline NSUInteger TRRailPointHash(TRRailPoint self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2iHash(self.tile);
    hash = hash * 31 + [self.form ordinal];
    hash = hash * 31 + floatHash(self.x);
    hash = hash * 31 + self.back;
    hash = hash * 31 + GEVec2Hash(self.point);
    return hash;
}
NSString* TRRailPointDescription(TRRailPoint self);
TRRailPoint trRailPointApply();
TRRailPoint trRailPointApplyTileFormXBack(GEVec2i tile, TRRailForm* form, CGFloat x, BOOL back);
TRRailPoint trRailPointAddX(TRRailPoint self, CGFloat x);
TRRailConnector* trRailPointStartConnector(TRRailPoint self);
TRRailConnector* trRailPointEndConnector(TRRailPoint self);
BOOL trRailPointIsValid(TRRailPoint self);
TRRailPointCorrection trRailPointCorrect(TRRailPoint self);
TRRailPoint trRailPointInvert(TRRailPoint self);
TRRailPoint trRailPointSetX(TRRailPoint self, CGFloat x);
GEVec2i trRailPointNextTile(TRRailPoint self);
TRRailPoint trRailPointStraight(TRRailPoint self);
BOOL trRailPointBetweenAB(TRRailPoint self, TRRailPoint a, TRRailPoint b);
ODPType* trRailPointType();
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
static inline BOOL TRRailPointCorrectionEq(TRRailPointCorrection s1, TRRailPointCorrection s2) {
    return TRRailPointEq(s1.point, s2.point) && eqf(s1.error, s2.error);
}
static inline NSUInteger TRRailPointCorrectionHash(TRRailPointCorrection self) {
    NSUInteger hash = 0;
    hash = hash * 31 + TRRailPointHash(self.point);
    hash = hash * 31 + floatHash(self.error);
    return hash;
}
NSString* TRRailPointCorrectionDescription(TRRailPointCorrection self);
TRRailPoint trRailPointCorrectionAddErrorToPoint(TRRailPointCorrection self);
ODPType* trRailPointCorrectionType();
@interface TRRailPointCorrectionWrap : NSObject
@property (readonly, nonatomic) TRRailPointCorrection value;

+ (id)wrapWithValue:(TRRailPointCorrection)value;
- (id)initWithValue:(TRRailPointCorrection)value;
@end



