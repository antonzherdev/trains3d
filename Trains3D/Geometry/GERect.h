#import "objd.h"
#import "GEVec.h"

typedef struct GERect GERect;
typedef struct GERectI GERectI;

struct GERect {
    CGFloat x;
    CGFloat width;
    CGFloat y;
    CGFloat height;
};
static inline GERect GERectMake(CGFloat x, CGFloat width, CGFloat y, CGFloat height) {
    return (GERect){x, width, y, height};
}
static inline BOOL GERectEq(GERect s1, GERect s2) {
    return eqf(s1.x, s2.x) && eqf(s1.width, s2.width) && eqf(s1.y, s2.y) && eqf(s1.height, s2.height);
}
static inline NSUInteger GERectHash(GERect self) {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.x);
    hash = hash * 31 + floatHash(self.width);
    hash = hash * 31 + floatHash(self.y);
    hash = hash * 31 + floatHash(self.height);
    return hash;
}
static inline NSString* GERectDescription(GERect self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GERect: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", width=%f", self.width];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", height=%f", self.height];
    [description appendString:@">"];
    return description;
}
BOOL geRectContainsPoint(GERect self, GEVec2 point);
CGFloat geRectX2(GERect self);
CGFloat geRectY2(GERect self);
GERect geRectNewXYXX2YY2(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2);
GERect geRectMoveXY(GERect self, CGFloat x, CGFloat y);
GERect geRectMoveToCenterForSize(GERect self, GEVec2 size);
GEVec2 geRectPoint(GERect self);
GEVec2 geRectSize(GERect self);
BOOL geRectIntersectsRect(GERect self, GERect rect);
GERect geRectThickenXY(GERect self, CGFloat x, CGFloat y);
ODPType* geRectType();
@interface GERectWrap : NSObject
@property (readonly, nonatomic) GERect value;

+ (id)wrapWithValue:(GERect)value;
- (id)initWithValue:(GERect)value;
@end



struct GERectI {
    NSInteger x;
    NSInteger width;
    NSInteger y;
    NSInteger height;
};
static inline GERectI GERectIMake(NSInteger x, NSInteger width, NSInteger y, NSInteger height) {
    return (GERectI){x, width, y, height};
}
static inline BOOL GERectIEq(GERectI s1, GERectI s2) {
    return s1.x == s2.x && s1.width == s2.width && s1.y == s2.y && s1.height == s2.height;
}
static inline NSUInteger GERectIHash(GERectI self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.width;
    hash = hash * 31 + self.y;
    hash = hash * 31 + self.height;
    return hash;
}
static inline NSString* GERectIDescription(GERectI self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<GERectI: "];
    [description appendFormat:@"x=%li", self.x];
    [description appendFormat:@", width=%li", self.width];
    [description appendFormat:@", y=%li", self.y];
    [description appendFormat:@", height=%li", self.height];
    [description appendString:@">"];
    return description;
}
GERectI geRectIApplyRect(GERect rect);
GERectI geRectINewXYXX2YY2(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2);
NSInteger geRectIX2(GERectI self);
NSInteger geRectIY2(GERectI self);
ODPType* geRectIType();
@interface GERectIWrap : NSObject
@property (readonly, nonatomic) GERectI value;

+ (id)wrapWithValue:(GERectI)value;
- (id)initWithValue:(GERectI)value;
@end



