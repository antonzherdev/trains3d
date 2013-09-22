#import "EGInput.h"

#import "GEMat4.h"
@implementation EGEventCamera{
    GEMat4* _inverseMatrix;
    GERect _viewport;
}
static ODClassType* _EGEventCamera_type;
@synthesize inverseMatrix = _inverseMatrix;
@synthesize viewport = _viewport;

+ (id)eventCameraWithInverseMatrix:(GEMat4*)inverseMatrix viewport:(GERect)viewport {
    return [[EGEventCamera alloc] initWithInverseMatrix:inverseMatrix viewport:viewport];
}

- (id)initWithInverseMatrix:(GEMat4*)inverseMatrix viewport:(GERect)viewport {
    self = [super init];
    if(self) {
        _inverseMatrix = inverseMatrix;
        _viewport = viewport;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEventCamera_type = [ODClassType classTypeWithCls:[EGEventCamera class]];
}

- (ODClassType*)type {
    return [EGEventCamera type];
}

+ (ODClassType*)type {
    return _EGEventCamera_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEventCamera* o = ((EGEventCamera*)(other));
    return [self.inverseMatrix isEqual:o.inverseMatrix] && GERectEq(self.viewport, o.viewport);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.inverseMatrix hash];
    hash = hash * 31 + GERectHash(self.viewport);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"inverseMatrix=%@", self.inverseMatrix];
    [description appendFormat:@", viewport=%@", GERectDescription(self.viewport)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEvent{
    GEVec2 _viewSize;
    id _camera;
    CNLazy* __lazy_segment;
}
static ODClassType* _EGEvent_type;
@synthesize viewSize = _viewSize;
@synthesize camera = _camera;

+ (id)eventWithViewSize:(GEVec2)viewSize camera:(id)camera {
    return [[EGEvent alloc] initWithViewSize:viewSize camera:camera];
}

- (id)initWithViewSize:(GEVec2)viewSize camera:(id)camera {
    self = [super init];
    __weak EGEvent* _weakSelf = self;
    if(self) {
        _viewSize = viewSize;
        _camera = camera;
        __lazy_segment = [CNLazy lazyWithF:^id() {
            return wrap(GELine3, (([_weakSelf.camera isEmpty]) ? GELine3Make(geVec3ApplyVec2Z([_weakSelf locationInView], 0.0), GEVec3Make(0.0, 0.0, 1000.0)) : ^GELine3() {
                GERect viewport = ((EGEventCamera*)([_weakSelf.camera get])).viewport;
                GEVec2 loc = geVec2SubVec2(geVec2MulI(geVec2DivVec2(geVec2SubVec2([_weakSelf locationInView], viewport.origin), viewport.size), 2), GEVec2Make(1.0, 1.0));
                GEMat4* mat4 = ((EGEventCamera*)([_weakSelf.camera get])).inverseMatrix;
                GEVec4 p0 = [mat4 mulVec4:GEVec4Make(loc.x, loc.y, -1.0, 1.0)];
                GEVec4 p1 = [mat4 mulVec4:GEVec4Make(loc.x, loc.y, 1.0, 1.0)];
                return GELine3Make(geVec4Xyz(p0), geVec3SubVec3(geVec4Xyz(p1), geVec4Xyz(p0)));
            }()));
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEvent_type = [ODClassType classTypeWithCls:[EGEvent class]];
}

- (GELine3)segment {
    return uwrap(GELine3, [__lazy_segment get]);
}

- (EGEvent*)setCamera:(id)camera {
    @throw @"Method set is abstract";
}

- (GEVec2)locationInView {
    @throw @"Method locationInView is abstract";
}

- (GEVec2)location {
    return [self locationForDepth:0.0];
}

- (GEVec2)locationForDepth:(CGFloat)depth {
    if([_camera isEmpty]) return [self locationInView];
    else return geVec3Xy(geLine3RPlane([self segment], GEPlaneMake(GEVec3Make(0.0, 0.0, ((float)(depth))), GEVec3Make(0.0, 0.0, 1.0))));
}

- (BOOL)isLeftMouseDown {
    @throw @"Method isLeftMouseDown is abstract";
}

- (BOOL)isLeftMouseDrag {
    @throw @"Method isLeftMouseDrag is abstract";
}

- (BOOL)isLeftMouseUp {
    @throw @"Method isLeftMouseUp is abstract";
}

- (BOOL)leftMouseProcessor:(id<EGMouseProcessor>)processor {
    if([self isLeftMouseDown]) {
        return [processor mouseDownEvent:self];
    } else {
        if([self isLeftMouseDrag]) {
            return [processor mouseDragEvent:self];
        } else {
            if([self isLeftMouseUp]) return [processor mouseUpEvent:self];
            else return NO;
        }
    }
}

- (BOOL)isTouchBegan {
    @throw @"Method isTouchBegan is abstract";
}

- (BOOL)isTouchMoved {
    @throw @"Method isTouchMoved is abstract";
}

- (BOOL)isTouchEnded {
    @throw @"Method isTouchEnded is abstract";
}

- (BOOL)isTouchCanceled {
    @throw @"Method isTouchCanceled is abstract";
}

- (BOOL)touchProcessor:(id<EGTouchProcessor>)processor {
    if([self isTouchBegan]) {
        return [processor touchBeganEvent:self];
    } else {
        if([self isTouchMoved]) {
            return [processor touchMovedEvent:self];
        } else {
            if([self isTouchEnded]) {
                return [processor touchEndedEvent:self];
            } else {
                if([self isTouchCanceled]) return [processor touchCanceledEvent:self];
                else return NO;
            }
        }
    }
}

- (ODClassType*)type {
    return [EGEvent type];
}

+ (ODClassType*)type {
    return _EGEvent_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEvent* o = ((EGEvent*)(other));
    return GEVec2Eq(self.viewSize, o.viewSize) && [self.camera isEqual:o.camera];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.viewSize);
    hash = hash * 31 + [self.camera hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"viewSize=%@", GEVec2Description(self.viewSize)];
    [description appendFormat:@", camera=%@", self.camera];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGRectIndex{
    id<CNSeq> _rects;
}
static ODClassType* _EGRectIndex_type;
@synthesize rects = _rects;

+ (id)rectIndexWithRects:(id<CNSeq>)rects {
    return [[EGRectIndex alloc] initWithRects:rects];
}

- (id)initWithRects:(id<CNSeq>)rects {
    self = [super init];
    if(self) _rects = rects;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGRectIndex_type = [ODClassType classTypeWithCls:[EGRectIndex class]];
}

- (id)applyPoint:(GEVec2)point {
    return [[_rects findWhere:^BOOL(CNTuple* _) {
        return geRectContainsPoint(uwrap(GERect, _.a), point);
    }] mapF:^CNTuple*(CNTuple* _) {
        return ((CNTuple*)(_.b));
    }];
}

- (ODClassType*)type {
    return [EGRectIndex type];
}

+ (ODClassType*)type {
    return _EGRectIndex_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRectIndex* o = ((EGRectIndex*)(other));
    return [self.rects isEqual:o.rects];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.rects hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"rects=%@", self.rects];
    [description appendString:@">"];
    return description;
}

@end


