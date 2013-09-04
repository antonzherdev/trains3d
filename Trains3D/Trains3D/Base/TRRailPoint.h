#import "objd.h"
#import "EGTypes.h"
#import "EGVec.h"

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
- (EGVec2I)nextTile:(EGVec2I)tile;
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
@property (nonatomic, readonly) EGVec2(^pointFun)(CGFloat);

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
@property (nonatomic, readonly) EGVec2I tile;
@property (nonatomic, readonly) TRRailForm* form;
@property (nonatomic, readonly) CGFloat x;
@property (nonatomic, readonly) BOOL back;
@property (nonatomic, readonly) EGVec2 point;

+ (id)railPointWithTile:(EGVec2I)tile form:(TRRailForm*)form x:(CGFloat)x back:(BOOL)back;
- (id)initWithTile:(EGVec2I)tile form:(TRRailForm*)form x:(CGFloat)x back:(BOOL)back;
- (ODClassType*)type;
- (TRRailPoint*)addX:(CGFloat)x;
- (TRRailConnector*)startConnector;
- (TRRailConnector*)endConnector;
- (BOOL)isValid;
- (TRRailPointCorrection*)correct;
- (TRRailPoint*)invert;
- (TRRailPoint*)setX:(CGFloat)x;
- (EGVec2I)nextTile;
+ (ODClassType*)type;
@end


@interface TRRailPointCorrection : NSObject
@property (nonatomic, readonly) TRRailPoint* point;
@property (nonatomic, readonly) CGFloat error;

+ (id)railPointCorrectionWithPoint:(TRRailPoint*)point error:(CGFloat)error;
- (id)initWithPoint:(TRRailPoint*)point error:(CGFloat)error;
- (ODClassType*)type;
- (TRRailPoint*)addErrorToPoint;
+ (ODClassType*)type;
@end


