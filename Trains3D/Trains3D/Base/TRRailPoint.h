#import "objd.h"
#import "EGTypes.h"

@class TRRailPoint;
@class TRRailPointCorrection;
@class TRRailConnector;
@class TRRailForm;

@interface TRRailConnector : ODEnum
@property (nonatomic, readonly) NSInteger x;
@property (nonatomic, readonly) NSInteger y;
@property (nonatomic, readonly) NSInteger angle;

+ (TRRailConnector*)connectorForX:(NSInteger)x y:(NSInteger)y;
- (TRRailConnector*)otherSideConnector;
- (EGPointI)nextTile:(EGPointI)tile;
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
@property (nonatomic, readonly) float length;
@property (nonatomic, readonly) EGPoint(^pointFun)(float);

+ (TRRailForm*)formForConnector1:(TRRailConnector*)connector1 connector2:(TRRailConnector*)connector2;
+ (TRRailForm*)leftBottom;
+ (TRRailForm*)leftRight;
+ (TRRailForm*)leftTop;
+ (TRRailForm*)bottomTop;
+ (TRRailForm*)bottomRight;
+ (TRRailForm*)topRight;
+ (NSArray*)values;
@end


@interface TRRailPoint : NSObject
@property (nonatomic, readonly) EGPointI tile;
@property (nonatomic, readonly) TRRailForm* form;
@property (nonatomic, readonly) float x;
@property (nonatomic, readonly) BOOL back;
@property (nonatomic, readonly) EGPoint point;

+ (id)railPointWithTile:(EGPointI)tile form:(TRRailForm*)form x:(float)x back:(BOOL)back;
- (id)initWithTile:(EGPointI)tile form:(TRRailForm*)form x:(float)x back:(BOOL)back;
- (TRRailPoint*)addX:(float)x;
- (TRRailConnector*)startConnector;
- (TRRailConnector*)endConnector;
- (BOOL)isValid;
- (TRRailPointCorrection*)correct;
- (TRRailPoint*)invert;
- (TRRailPoint*)setX:(float)x;
- (EGPointI)nextTile;
@end


@interface TRRailPointCorrection : NSObject
@property (nonatomic, readonly) TRRailPoint* point;
@property (nonatomic, readonly) float error;

+ (id)railPointCorrectionWithPoint:(TRRailPoint*)point error:(float)error;
- (id)initWithPoint:(TRRailPoint*)point error:(float)error;
- (TRRailPoint*)addErrorToPoint;
@end


