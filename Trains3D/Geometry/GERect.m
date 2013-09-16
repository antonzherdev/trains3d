#import "GERect.h"

BOOL geRectContainsPoint(GERect self, GEVec2 point) {
    return self.x <= point.x && point.x <= self.x + self.width && self.y <= point.y && point.y <= self.y + self.height;
}
CGFloat geRectX2(GERect self) {
    return self.x + self.width;
}
CGFloat geRectY2(GERect self) {
    return self.y + self.height;
}
GERect geRectNewXYXX2YY2(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2) {
    return GERectMake(x, x2 - x, y, y2 - y);
}
GERect geRectMoveXY(GERect self, CGFloat x, CGFloat y) {
    return GERectMake(self.x + x, self.width, self.y + y, self.height);
}
GERect geRectMoveToCenterForSize(GERect self, GEVec2 size) {
    return GERectMake(((CGFloat)((size.x - self.width) / 2)), self.width, ((CGFloat)((size.y - self.height) / 2)), self.height);
}
GEVec2 geRectPoint(GERect self) {
    return GEVec2Make(((float)(self.x)), ((float)(self.y)));
}
GEVec2 geRectSize(GERect self) {
    return GEVec2Make(((float)(self.width)), ((float)(self.height)));
}
BOOL geRectIntersectsRect(GERect self, GERect rect) {
    return self.x <= geRectX2(rect) && geRectX2(self) >= rect.x && self.y <= geRectY2(rect) && geRectY2(self) >= rect.y;
}
GERect geRectThickenXY(GERect self, CGFloat x, CGFloat y) {
    return GERectMake(self.x - x, self.width + 2 * x, self.y - y, self.height + 2 * y);
}
ODType* geRectType() {
    static ODType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GERectWrap class] name:@"GERect" size:sizeof(GERect) wrap:^id(void* data, NSUInteger i) {
        return wrap(GERect, ((GERect*)(data))[i]);
    }];
    return _ret;
}
@implementation GERectWrap{
    GERect _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GERect)value {
    return [[GERectWrap alloc] initWithValue:value];
}

- (id)initWithValue:(GERect)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return GERectDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GERectWrap* o = ((GERectWrap*)(other));
    return GERectEq(_value, o.value);
}

- (NSUInteger)hash {
    return GERectHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



GERectI geRectIApplyRect(GERect rect) {
    return GERectIMake(lround(rect.x), lround(rect.width), lround(rect.y), lround(rect.height));
}
GERectI geRectINewXYXX2YY2(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2) {
    return GERectIMake(((NSInteger)(x)), ((NSInteger)(x2 - x)), ((NSInteger)(y)), ((NSInteger)(y2 - y)));
}
NSInteger geRectIX2(GERectI self) {
    return self.x + self.width;
}
NSInteger geRectIY2(GERectI self) {
    return self.y + self.height;
}
ODType* geRectIType() {
    static ODType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[GERectIWrap class] name:@"GERectI" size:sizeof(GERectI) wrap:^id(void* data, NSUInteger i) {
        return wrap(GERectI, ((GERectI*)(data))[i]);
    }];
    return _ret;
}
@implementation GERectIWrap{
    GERectI _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(GERectI)value {
    return [[GERectIWrap alloc] initWithValue:value];
}

- (id)initWithValue:(GERectI)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return GERectIDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    GERectIWrap* o = ((GERectIWrap*)(other));
    return GERectIEq(_value, o.value);
}

- (NSUInteger)hash {
    return GERectIHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



