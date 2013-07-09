#import "objd.h"
#import "EGTypes.h"

@class TRRailConnector;
@class TRRailForm;
typedef struct TRRailPoint TRRailPoint;
typedef struct TRRailPointCorrection TRRailPointCorrection;

@interface TRRailConnector : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSUInteger ordinal;
@property (nonatomic, readonly) NSInteger x;
@property (nonatomic, readonly) NSInteger y;

+ (TRRailConnector*)connectorForX:(NSInteger)x y:(NSInteger)y;
- (TRRailConnector*)otherSideConnector;
- (EGIPoint)nextTile:(EGIPoint)tile;
+ (TRRailConnector*)left;
+ (TRRailConnector*)bottom;
+ (TRRailConnector*)top;
+ (TRRailConnector*)right;
+ (NSArray*)values;
@end


@interface TRRailForm : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSUInteger ordinal;
@property (nonatomic, readonly) TRRailConnector* start;
@property (nonatomic, readonly) TRRailConnector* end;
@property (nonatomic, readonly) CGFloat length;

+ (TRRailForm*)formForConnector1:(TRRailConnector*)connector1 connector2:(TRRailConnector*)connector2;
+ (TRRailForm*)leftRight;
+ (TRRailForm*)leftBottom;
+ (TRRailForm*)leftTop;
+ (TRRailForm*)bottomTop;
+ (TRRailForm*)bottomRight;
+ (TRRailForm*)topRight;
+ (NSArray*)values;
@end


struct TRRailPoint {
    EGIPoint tile;
    NSUInteger form;
    CGFloat x;
    BOOL back;
};
static inline TRRailPoint TRRailPointMake(EGIPoint tile, NSUInteger form, CGFloat x, BOOL back) {
    TRRailPoint ret;
    ret.tile = tile;
    ret.form = form;
    ret.x = x;
    ret.back = back;
    return ret;
}
static inline BOOL TRRailPointEq(TRRailPoint s1, TRRailPoint s2) {
    return EGIPointEq(s1.tile, s2.tile) && s1.form == s2.form && eqf(s1.x, s2.x) && s1.back == s2.back;
}
TRRailPoint trRailPointAdd(TRRailPoint self, CGFloat x);
TRRailForm* trRailPointGetForm(TRRailPoint self);
TRRailConnector* trRailPointStartConnector(TRRailPoint self);
TRRailConnector* trRailPointEndConnector(TRRailPoint self);
BOOL trRailPointIsValid(TRRailPoint self);
TRRailPointCorrection trRailPointCorrect(TRRailPoint self);

struct TRRailPointCorrection {
    TRRailPoint point;
    CGFloat error;
};
static inline TRRailPointCorrection TRRailPointCorrectionMake(TRRailPoint point, CGFloat error) {
    TRRailPointCorrection ret;
    ret.point = point;
    ret.error = error;
    return ret;
}
static inline BOOL TRRailPointCorrectionEq(TRRailPointCorrection s1, TRRailPointCorrection s2) {
    return TRRailPointEq(s1.point, s2.point) && eqf(s1.error, s2.error);
}
