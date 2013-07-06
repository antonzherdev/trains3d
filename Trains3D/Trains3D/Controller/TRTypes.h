#import "objd.h"
#import "EGTypes.h"

@class TRColor;
@class TRRailConnector;
@class TRRailForm;

@interface TRColor : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSInteger ordinal;
@property (nonatomic, readonly) EGColor color;

- (void)gl;
+ (TRColor*)orange;
+ (TRColor*)green;
+ (TRColor*)purple;
+ (NSArray*)values;
@end


@interface TRRailConnector : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSInteger ordinal;
@property (nonatomic, readonly) NSInteger x;
@property (nonatomic, readonly) NSInteger y;

+ (TRRailConnector*)connectorForX:(NSInteger)x y:(NSInteger)y;
+ (TRRailConnector*)left;
+ (TRRailConnector*)bottom;
+ (TRRailConnector*)top;
+ (TRRailConnector*)right;
+ (NSArray*)values;
@end


@interface TRRailForm : NSObject
@property (nonatomic, readonly) NSString* name;
@property (nonatomic, readonly) NSInteger ordinal;
@property (nonatomic, readonly) TRRailConnector* start;
@property (nonatomic, readonly) TRRailConnector* end;

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
};
typedef struct TRRailPoint TRRailPoint;
static inline TRRailPoint TRRailPointMake(EGIPoint tile, NSUInteger form, CGFloat x) {
    TRRailPoint ret;
    ret.tile = tile;
    ret.form = form;
    ret.x = x;
    return ret;
}
static inline BOOL TRRailPointEq(TRRailPoint s1, TRRailPoint s2) {
    return EGIPointEq(s1.tile, s2.tile) && s1.form == s2.form && s1.x == s2.x;
}

