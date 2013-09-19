#import "TRSwitchProcessor.h"

#import "TRLevel.h"
#import "TRRailPoint.h"
#import "EGCollisionBody.h"
#import "EGCollisionWorld.h"
#import "TRRailroad.h"
@implementation TRSwitchProcessor{
    TRLevel* _level;
    EGRectIndex* _index;
    id _downed;
    EGCollisionBox2d* _switchShape;
    EGCollisionBox2d* _lightShape;
    EGCollisionWorld* _world;
}
static ODClassType* _TRSwitchProcessor_type;
@synthesize level = _level;

+ (id)switchProcessorWithLevel:(TRLevel*)level {
    return [[TRSwitchProcessor alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _index = [EGRectIndex rectIndexWithRects:(@[tuple(wrap(GERect, geRectApplyXYWidthHeight(-0.1, 0.2, 0.2, 0.3)), tuple(TRRailConnector.top, @NO)), tuple(wrap(GERect, geRectApplyXYWidthHeight(-0.1, -0.5, 0.2, 0.3)), tuple(TRRailConnector.bottom, @NO)), tuple(wrap(GERect, geRectApplyXYWidthHeight(-0.5, -0.1, 0.3, 0.2)), tuple(TRRailConnector.left, @NO)), tuple(wrap(GERect, geRectApplyXYWidthHeight(0.2, -0.1, 0.3, 0.2)), tuple(TRRailConnector.right, @NO)), tuple(wrap(GERect, geRectApplyXYWidthHeight(0.15, 0.4, 0.1, 0.1)), tuple(TRRailConnector.top, @YES)), tuple(wrap(GERect, geRectApplyXYWidthHeight(-0.25, -0.5, 0.1, 0.1)), tuple(TRRailConnector.bottom, @YES)), tuple(wrap(GERect, geRectApplyXYWidthHeight(-0.5, 0.15, 0.1, 0.1)), tuple(TRRailConnector.left, @YES)), tuple(wrap(GERect, geRectApplyXYWidthHeight(0.4, -0.25, 0.1, 0.1)), tuple(TRRailConnector.right, @YES))])];
        _downed = [CNOption none];
        _switchShape = [EGCollisionBox2d applyX:0.3 y:0.2];
        _lightShape = [EGCollisionBox2d applyX:0.2 y:0.1];
        _world = [EGCollisionWorld collisionWorld];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSwitchProcessor_type = [ODClassType classTypeWithCls:[TRSwitchProcessor class]];
}

- (BOOL)processEvent:(EGEvent*)event {
    return [event leftMouseProcessor:self];
}

- (void)_init {
    [_level.railroad addChangeListener:^void() {
        [_world clear];
        [[_level.railroad switches] forEach:^void(TRSwitch* aSwitch) {
            EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:aSwitch shape:_switchShape isKinematic:NO];
            [body translateX:((float)(aSwitch.tile.x)) y:((float)(aSwitch.tile.y)) z:0.0];
            [body rotateAngle:((float)(aSwitch.connector.angle)) x:0.0 y:0.0 z:1.0];
            [body translateX:-0.35 y:0.0 z:0.0];
            [_world addBody:body];
        }];
        [[_level.railroad lights] forEach:^void(TRRailLight* light) {
            EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:light shape:_switchShape isKinematic:NO];
            [body translateX:((float)(light.tile.x)) y:((float)(light.tile.y - 0.4)) z:0.0];
            [body rotateAngle:((float)(light.connector.angle)) x:0.0 y:0.0 z:1.0];
            [body translateX:-0.45 y:-0.2 z:0.1];
            [body rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
            [_world addBody:body];
        }];
    }];
}

- (BOOL)mouseDownEvent:(EGEvent*)event {
    GEVec2 location = [event location];
    GEVec2i tile = geVec2iApplyVec2(location);
    GEVec2 relPoint = geVec2SubVec2(location, geVec2ApplyVec2i(tile));
    GELine3 s = [event segment];
    GEVec3 pp = geLine3RPlane(s, GEPlaneMake(GEVec3Make(0.0, 0.0, 0.0), GEVec3Make(0.0, 0.0, 1.0)));
    id cross = [_world closestCrossPointWithSegment:[event segment]];
    _downed = [[_index applyPoint:relPoint] flatMap:^id(CNTuple* v) {
        TRRailroadConnectorContent* content = [_level.railroad contentInTile:tile connector:((TRRailConnector*)(v.a))];
        if(unumb(v.b)) return [content asKindOfClass:[TRRailLight class]];
        else return [content asKindOfClass:[TRSwitch class]];
    }];
    return [_downed isDefined];
}

- (BOOL)mouseDragEvent:(EGEvent*)event {
    return [_downed isDefined];
}

- (BOOL)mouseUpEvent:(EGEvent*)event {
    if([_downed isDefined]) {
        [[((TRRailroadConnectorContent*)([_downed get])) asKindOfClass:[TRSwitch class]] forEach:^void(TRSwitch* _) {
            [_level tryTurnTheSwitch:_];
        }];
        [[((TRRailroadConnectorContent*)([_downed get])) asKindOfClass:[TRRailLight class]] forEach:^void(TRRailLight* _) {
            [_ turn];
        }];
        return YES;
    } else {
        return NO;
    }
}

- (ODClassType*)type {
    return [TRSwitchProcessor type];
}

+ (ODClassType*)type {
    return _TRSwitchProcessor_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSwitchProcessor* o = ((TRSwitchProcessor*)(other));
    return [self.level isEqual:o.level];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.level hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


