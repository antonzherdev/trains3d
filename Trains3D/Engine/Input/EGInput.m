#import "EGInput.h"

#import "EGContext.h"
#import "EGScene.h"
#import "GEMat4.h"
@implementation EGEvent{
    GEVec2 _viewSize;
    id _camera;
}
static ODClassType* _EGEvent_type;
@synthesize viewSize = _viewSize;
@synthesize camera = _camera;

+ (id)eventWithViewSize:(GEVec2)viewSize camera:(id)camera {
    return [[EGEvent alloc] initWithViewSize:viewSize camera:camera];
}

- (id)initWithViewSize:(GEVec2)viewSize camera:(id)camera {
    self = [super init];
    if(self) {
        _viewSize = viewSize;
        _camera = camera;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEvent_type = [ODClassType classTypeWithCls:[EGEvent class]];
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

- (GELine3)segment {
    if([_camera isEmpty]) {
        return GELine3Make(geVec3ApplyVec2Z([self locationInView], 0.0), GEVec3Make(0.0, 0.0, 1000.0));
    } else {
        GEVec2 loc = geVec2SubVec2(geVec2MulValue(geVec2DivVec2(geVec2SubVec2([self locationInView], geVec2ApplyVec2i([EGGlobal.context viewport].origin)), geVec2ApplyVec2i([EGGlobal.context viewport].size)), 2.0), GEVec2Make(1.0, 1.0));
        GEMat4* mat4 = [[[[_camera get] matrixModel] wcp] inverse];
        GEVec4 p0 = [mat4 mulVec4:GEVec4Make(loc.x, loc.y, -1.0, 1.0)];
        GEVec4 p1 = [mat4 mulVec4:GEVec4Make(loc.x, loc.y, 1.0, 1.0)];
        return GELine3Make(geVec4Xyz(p0), geVec3SubVec3(geVec4Xyz(p1), geVec4Xyz(p0)));
    }
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
    }] map:^CNTuple*(CNTuple* _) {
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


