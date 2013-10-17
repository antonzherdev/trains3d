#import "TRSwitchProcessor.h"

#import "TRLevel.h"
#import "EGCollisionBody.h"
#import "EGCollisionWorld.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "EGCollision.h"
#import "EGContext.h"
#import "EGDirector.h"
@implementation TRSwitchProcessor{
    TRLevel* _level;
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
        _switchShape = [EGCollisionBox2d applyX:0.3 y:0.2];
        _lightShape = [EGCollisionBox2d applyX:0.4 y:0.24];
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
    return [event tapProcessor:self];
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
            EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:light shape:_lightShape isKinematic:NO];
            [body translateX:((float)(light.tile.x)) y:((float)(light.tile.y)) z:0.0];
            [body rotateAngle:((float)(light.connector.angle)) x:0.0 y:0.0 z:1.0];
            [body translateX:-0.45 y:0.2 z:0.1];
            [body rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
            [_world addBody:body];
        }];
    }];
}

- (BOOL)tapEvent:(EGEvent*)event {
    id downed = [[_world closestCrossPointWithSegment:[event segment]] mapF:^TRRailroadConnectorContent*(EGCrossPoint* _) {
        return ((TRRailroadConnectorContent*)(_.body.data));
    }];
    if([downed isDefined]) {
        [[ODObject asKindOfClass:[TRSwitch class] object:((TRRailroadConnectorContent*)([downed get]))] forEach:^void(TRSwitch* _) {
            [_level tryTurnTheSwitch:_];
        }];
        [[ODObject asKindOfClass:[TRRailLight class] object:((TRRailroadConnectorContent*)([downed get]))] forEach:^void(TRRailLight* _) {
            [_ turn];
        }];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)isProcessorActive {
    return !([[EGGlobal director] isPaused]);
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


