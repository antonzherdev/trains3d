#import "EGRect.h"

BOOL egRectContainsPoint(EGRect self, EGVec2 point) {
    return self.x <= point.x && point.x <= self.x + self.width && self.y <= point.y && point.y <= self.y + self.height;
}
CGFloat egRectX2(EGRect self) {
    return self.x + self.width;
}
CGFloat egRectY2(EGRect self) {
    return self.y + self.height;
}
EGRect egRectNewXYXX2YY2(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2) {
    return EGRectMake(x, x2 - x, y, y2 - y);
}
EGRect egRectMoveXY(EGRect self, CGFloat x, CGFloat y) {
    return EGRectMake(self.x + x, self.width, self.y + y, self.height);
}
EGRect egRectMoveToCenterForSize(EGRect self, EGVec2 size) {
    return EGRectMake(((CGFloat)((size.x - self.width) / 2)), self.width, ((CGFloat)((size.y - self.height) / 2)), self.height);
}
EGVec2 egRectPoint(EGRect self) {
    return EGVec2Make(((float)(self.x)), ((float)(self.y)));
}
EGVec2 egRectSize(EGRect self) {
    return EGVec2Make(((float)(self.width)), ((float)(self.height)));
}
BOOL egRectIntersectsRect(EGRect self, EGRect rect) {
    return self.x <= egRectX2(rect) && egRectX2(self) >= rect.x && self.y <= egRectY2(rect) && egRectY2(self) >= rect.y;
}
EGRect egRectThickenXY(EGRect self, CGFloat x, CGFloat y) {
    return EGRectMake(self.x - x, self.width + 2 * x, self.y - y, self.height + 2 * y);
}
ODPType* egRectType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGRectWrap class] name:@"EGRect" size:sizeof(EGRect) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGRect, ((EGRect*)(data))[i]);
    }];
    return _ret;
}
@implementation EGRectWrap{
    EGRect _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGRect)value {
    return [[EGRectWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGRect)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGRectDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRectWrap* o = ((EGRectWrap*)(other));
    return EGRectEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGRectHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



EGRectI egRectIApplyRect(EGRect rect) {
    return EGRectIMake(lround(rect.x), lround(rect.width), lround(rect.y), lround(rect.height));
}
EGRectI egRectINewXYXX2YY2(CGFloat x, CGFloat x2, CGFloat y, CGFloat y2) {
    return EGRectIMake(((NSInteger)(x)), ((NSInteger)(x2 - x)), ((NSInteger)(y)), ((NSInteger)(y2 - y)));
}
NSInteger egRectIX2(EGRectI self) {
    return self.x + self.width;
}
NSInteger egRectIY2(EGRectI self) {
    return self.y + self.height;
}
ODPType* egRectIType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGRectIWrap class] name:@"EGRectI" size:sizeof(EGRectI) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGRectI, ((EGRectI*)(data))[i]);
    }];
    return _ret;
}
@implementation EGRectIWrap{
    EGRectI _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGRectI)value {
    return [[EGRectIWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGRectI)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGRectIDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRectIWrap* o = ((EGRectIWrap*)(other));
    return EGRectIEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGRectIHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



