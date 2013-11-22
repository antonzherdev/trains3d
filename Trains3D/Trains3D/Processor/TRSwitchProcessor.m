#import "TRSwitchProcessor.h"

#import "TRLevel.h"
#import "EGCollisionBody.h"
#import "EGCollisionWorld.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "EGCollision.h"
#import "EGDirector.h"
@implementation TRSwitchProcessor{
    TRLevel* _level;
    EGCollisionBox2d* _switchShape;
    EGCollisionBox2d* _lightShape;
    EGCollisionBox2d* _narrowLightShape;
    EGCollisionWorld* _world;
    CNNotificationObserver* _obs;
}
static ODClassType* _TRSwitchProcessor_type;
@synthesize level = _level;
@synthesize switchShape = _switchShape;
@synthesize lightShape = _lightShape;
@synthesize narrowLightShape = _narrowLightShape;
@synthesize world = _world;

+ (id)switchProcessorWithLevel:(TRLevel*)level {
    return [[TRSwitchProcessor alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRSwitchProcessor* _weakSelf = self;
    if(self) {
        _level = level;
        _switchShape = [EGCollisionBox2d applyX:0.6 y:0.6];
        _lightShape = [EGCollisionBox2d applyX:0.5 y:0.6];
        _narrowLightShape = [EGCollisionBox2d applyX:0.5 y:0.5];
        _world = [EGCollisionWorld collisionWorld];
        _obs = [TRRailroad.changedNotification observeBy:^void(id _) {
            [_weakSelf.world clear];
            [[_weakSelf.level.railroad switches] forEach:^void(TRSwitch* aSwitch) {
                EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:aSwitch shape:_weakSelf.switchShape isKinematic:NO];
                [body translateX:((float)(((TRSwitch*)(aSwitch)).tile.x)) y:((float)(((TRSwitch*)(aSwitch)).tile.y)) z:0.0];
                [body rotateAngle:((float)(((TRSwitch*)(aSwitch)).connector.angle)) x:0.0 y:0.0 z:1.0];
                [body translateX:-0.2 y:0.0 z:0.0];
                [_weakSelf.world addBody:body];
            }];
            [[_weakSelf.level.railroad lights] forEach:^void(TRRailLight* light) {
                CNTuple* dy = [_weakSelf dyForLight:light];
                EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:light shape:dy.a isKinematic:NO];
                [body translateX:((float)(((TRRailLight*)(light)).tile.x)) y:((float)(((TRRailLight*)(light)).tile.y)) z:0.0];
                [body rotateAngle:((float)(((TRRailLight*)(light)).connector.angle)) x:0.0 y:0.0 z:1.0];
                GEVec3 shift = [((TRRailLight*)(light)) shift];
                [body translateX:shift.z y:shift.x + unumf4(dy.b) z:((float)(0.1 + [_weakSelf dzForLight:light]))];
                [body rotateAngle:90.0 x:0.0 y:1.0 z:0.0];
                [_weakSelf.world addBody:body];
            }];
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSwitchProcessor_type = [ODClassType classTypeWithCls:[TRSwitchProcessor class]];
}

- (CNTuple*)dyForLight:(TRRailLight*)light {
    if(light.connector == TRRailConnector.top || light.connector == TRRailConnector.bottom) {
        if([[self nextConnectLight:light] isKindOfClass:[TRRailLight class]]) return tuple(_narrowLightShape, @-0.15);
        else return tuple(_lightShape, @0.0);
    } else {
        if(light.connector == TRRailConnector.left && [[self nextConnectLight:light] isKindOfClass:[TRSwitch class]]) return tuple(_narrowLightShape, @0.15);
        else return tuple(_lightShape, @0.0);
    }
}

- (float)dzForLight:(TRRailLight*)light {
    if(light.connector == TRRailConnector.bottom && [[_level.railroad contentInTile:geVec2iAddVec2i(light.tile, GEVec2iMake(-1, 0)) connector:TRRailConnector.right] isKindOfClass:[TRRailLight class]]) {
        return -0.15;
    } else {
        if(light.connector == TRRailConnector.top && [[_level.railroad contentInTile:geVec2iAddVec2i(light.tile, GEVec2iMake(-1, 1)) connector:TRRailConnector.right] isKindOfClass:[TRRailLight class]]) return -0.15;
        else return 0.0;
    }
}

- (TRRailroadConnectorContent*)nextConnectLight:(TRRailLight*)light {
    TRRailConnector* c = light.connector;
    return [_level.railroad contentInTile:[c nextTile:light.tile] connector:[c otherSideConnector]];
}

- (EGRecognizers*)recognizers {
    return [EGRecognizers applyRecognizer:[EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> event) {
        id downed = [[_world closestCrossPointWithSegment:[event segment]] mapF:^TRRailroadConnectorContent*(EGCrossPoint* _) {
            return ((EGCrossPoint*)(_)).body.data;
        }];
        if([downed isDefined]) {
            [[ODObject asKindOfClass:[TRSwitch class] object:((TRRailroadConnectorContent*)([downed get]))] forEach:^void(TRSwitch* _) {
                [_level tryTurnTheSwitch:_];
            }];
            [[ODObject asKindOfClass:[TRRailLight class] object:((TRRailroadConnectorContent*)([downed get]))] forEach:^void(TRRailLight* _) {
                [((TRRailLight*)(_)) turn];
            }];
            return YES;
        } else {
            return NO;
        }
    }]];
}

- (BOOL)isProcessorActive {
    return !([[EGDirector current] isPaused]);
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


