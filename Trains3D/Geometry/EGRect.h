#import "objd.h"
#import "EGVec.h"

typedef struct EGRect EGRect;
typedef struct EGRectI EGRectI;

struct EGRect {
    CGFloat x;
    CGFloat width;
    CGFloat y;
    CGFloat height;
};
static inline EGRect EGRectMake(CGFloat x, CGFloat width, CGFloat y, CGFloat height) {
    return (EGRect){x, width, y, height};
}
static inline BOOL EGRectEq(EGRect s1, EGRect s2) {
    return eqf(s1.x, s2.x) && eqf(s1.width, s2.width) && eqf(s1.y, s2.y) && eqf(s1.height, s2.height);
}
static inline NSUInteger EGRectHash(EGRect self) {
    NSUInteger hash = 0;
    hash = hash * 31 + floatHash(self.x);
    hash = hash * 31 + floatHash(self.width);
    hash = hash * 31 + floatHash(self.y);
    hash = hash * 31 + floatHash(self.height);
    return hash;
}
static inline NSString* EGRectDescription(EGRect self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGRect: "];
    [description appendFormat:@"x=%f", self.x];
    [description appendFormat:@", width=%f", self.width];
    [description appendFormat:@", y=%f", self.y];
    [description appendFormat:@", height=%f", self.height];
    [description appendString:@">"];
    return description;
}
BOOL egRectContainsPoint(EGRect self, EGVec2 point);
CGFloat egRectX2(EGRect self);
CGFloat egRectY2(EGRect self);
EGRect egRectNewXYXX2YY2(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2);
EGRect egRectMoveXY(EGRect self, CGFloat x, CGFloat y);
EGRect egRectMoveToCenterForSize(EGRect self, EGVec2 size);
EGVec2 egRectPoint(EGRect self);
EGVec2 egRectSize(EGRect self);
BOOL egRectIntersectsRect(EGRect self, EGRect rect);
EGRect egRectThickenXY(EGRect self, CGFloat x, CGFloat y);
ODPType* egRectType();
@interface EGRectWrap : NSObject
@property (readonly, nonatomic) EGRect value;

+ (id)wrapWithValue:(EGRect)value;
- (id)initWithValue:(EGRect)value;
@end



struct EGRectI {
    NSInteger x;
    NSInteger width;
    NSInteger y;
    NSInteger height;
};
static inline EGRectI EGRectIMake(NSInteger x, NSInteger width, NSInteger y, NSInteger height) {
    return (EGRectI){x, width, y, height};
}
static inline BOOL EGRectIEq(EGRectI s1, EGRectI s2) {
    return s1.x == s2.x && s1.width == s2.width && s1.y == s2.y && s1.height == s2.height;
}
static inline NSUInteger EGRectIHash(EGRectI self) {
    NSUInteger hash = 0;
    hash = hash * 31 + self.x;
    hash = hash * 31 + self.width;
    hash = hash * 31 + self.y;
    hash = hash * 31 + self.height;
    return hash;
}
static inline NSString* EGRectIDescription(EGRectI self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGRectI: "];
    [description appendFormat:@"x=%li", self.x];
    [description appendFormat:@", width=%li", self.width];
    [description appendFormat:@", y=%li", self.y];
    [description appendFormat:@", height=%li", self.height];
    [description appendString:@">"];
    return description;
}
EGRectI egRectIApplyRect(EGRect rect);
EGRectI egRectINewXYXX2YY2(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2);
NSInteger egRectIX2(EGRectI self);
NSInteger egRectIY2(EGRectI self);
ODPType* egRectIType();
@interface EGRectIWrap : NSObject
@property (readonly, nonatomic) EGRectI value;

+ (id)wrapWithValue:(EGRectI)value;
- (id)initWithValue:(EGRectI)value;
@end



