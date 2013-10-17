#import "EGInput.h"

#import "EGContext.h"
#import "EGDirector.h"
#import "GEMat4.h"
@implementation EGEventCamera{
    EGMatrixModel* _matrixModel;
    GERect _viewport;
}
static ODClassType* _EGEventCamera_type;
@synthesize matrixModel = _matrixModel;
@synthesize viewport = _viewport;

+ (id)eventCameraWithMatrixModel:(EGMatrixModel*)matrixModel viewport:(GERect)viewport {
    return [[EGEventCamera alloc] initWithMatrixModel:matrixModel viewport:viewport];
}

- (id)initWithMatrixModel:(EGMatrixModel*)matrixModel viewport:(GERect)viewport {
    self = [super init];
    if(self) {
        _matrixModel = matrixModel;
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
    return [self.matrixModel isEqual:o.matrixModel] && GERectEq(self.viewport, o.viewport);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.matrixModel hash];
    hash = hash * 31 + GERectHash(self.viewport);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"matrixModel=%@", self.matrixModel];
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
                GEVec2 loc = [_weakSelf locationInViewport];
                GEMat4* mat4 = [[((EGEventCamera*)([_weakSelf.camera get])).matrixModel wcp] inverse];
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

- (GEVec2)locationInViewport {
    GERect viewport = ((EGEventCamera*)([_camera get])).viewport;
    return geVec2SubVec2(geVec2MulI(geVec2DivVec2(geVec2SubVec2([self locationInView], viewport.p0), viewport.size), 2), GEVec2Make(1.0, 1.0));
}

- (GEVec2)locationForDepth:(CGFloat)depth {
    if([_camera isEmpty]) return [self locationInView];
    else return geVec3Xy(geLine3RPlane([self segment], GEPlaneMake(GEVec3Make(0.0, 0.0, ((float)(depth))), GEVec3Make(0.0, 0.0, 1.0))));
}

- (BOOL)checkViewport {
    return [_camera isEmpty] || geRectContainsVec2(((EGEventCamera*)([_camera get])).viewport, [self locationInView]);
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
    if(!([self checkViewport])) {
        return NO;
    } else {
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
    if(!([self checkViewport])) {
        return NO;
    } else {
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
}

- (BOOL)isTap {
    @throw @"Method isTap is abstract";
}

- (BOOL)tapProcessor:(id<EGTapProcessor>)processor {
    if(!([self checkViewport])) {
        return NO;
    } else {
        if([self isTap]) return [processor tapEvent:self];
        else return NO;
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


