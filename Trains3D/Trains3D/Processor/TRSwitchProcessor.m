#import "TRSwitchProcessor.h"

#import "TRLevel.h"
#import "EGCollisionBody.h"
#import "EGCollisionWorld.h"
#import "TRRailroad.h"
#import "TRRailPoint.h"
#import "GEMat4.h"
#import "EGCollision.h"
#import "EGDirector.h"
@implementation TRSwitchProcessor{
    TRLevel* _level;
    EGCollisionBox2d* _switchShape;
    EGCollisionWorld* _world;
    CNNotificationObserver* _obs;
}
static ODClassType* _TRSwitchProcessor_type;
@synthesize level = _level;
@synthesize switchShape = _switchShape;
@synthesize world = _world;

+ (id)switchProcessorWithLevel:(TRLevel*)level {
    return [[TRSwitchProcessor alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRSwitchProcessor* _weakSelf = self;
    if(self) {
        _level = level;
        _switchShape = [EGCollisionBox2d applyX:0.45 y:0.45];
        _world = [EGCollisionWorld collisionWorld];
        _obs = [TRRailroad.changedNotification observeBy:^void(id _) {
            [_weakSelf.world clear];
            [[_weakSelf.level.railroad switches] forEach:^void(TRSwitch* aSwitch) {
                EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:aSwitch shape:_weakSelf.switchShape isKinematic:NO];
                [body translateX:((float)(((TRSwitch*)(aSwitch)).tile.x)) y:((float)(((TRSwitch*)(aSwitch)).tile.y)) z:0.0];
                [body rotateAngle:((float)(((TRSwitch*)(aSwitch)).connector.angle)) x:0.0 y:0.0 z:1.0];
                [body translateX:-_weakSelf.switchShape.size.x / 2 y:0.0 z:0.0];
                [_weakSelf.world addBody:body];
            }];
            [[_weakSelf.level.railroad lights] forEach:^void(TRRailLight* light) {
                CGFloat sz = 0.5;
                CGFloat sy = 0.6;
                GEVec3 sh = [((TRRailLight*)(light)) shift];
                float x = sh.z;
                float y = sh.x;
                float z = sh.y + sz / 4;
                if(((TRRailLight*)(light)).connector == TRRailConnector.top) {
                    TRRailroadConnectorContent* next = [_weakSelf nextConnectLight:light];
                    if([next isKindOfClass:[TRRailLight class]]) {
                        sy -= 0.15;
                        y -= 0.2;
                    }
                    if([next isKindOfClass:[TRSwitch class]]) {
                        sy -= 0.1;
                        y -= 0.1;
                    }
                    if([[_weakSelf.level.railroad contentInTile:geVec2iAddVec2i(((TRRailLight*)(light)).tile, GEVec2iMake(-1, 1)) connector:TRRailConnector.right] isKindOfClass:[TRRailLight class]]) {
                        z -= 0.15;
                        sz -= 0.2;
                    }
                }
                if(((TRRailLight*)(light)).connector == TRRailConnector.bottom) {
                    if([[_weakSelf nextConnectLight:light] isKindOfClass:[TRRailLight class]]) {
                        y -= 0.23;
                        sy -= 0.15;
                    }
                    TRRailroadConnectorContent* cont = [_weakSelf.level.railroad contentInTile:geVec2iAddVec2i(((TRRailLight*)(light)).tile, GEVec2iMake(-1, 0)) connector:TRRailConnector.right];
                    if([cont isKindOfClass:[TRRailLight class]] || [cont isKindOfClass:[TRSwitch class]]) {
                        z -= 0.1;
                        sz -= 0.1;
                    }
                    TRRailroadConnectorContent* cont2 = [_weakSelf.level.railroad contentInTile:((TRRailLight*)(light)).tile connector:TRRailConnector.left];
                    if([cont2 isKindOfClass:[TRSwitch class]]) {
                        y += 0.1;
                        sy -= 0.1;
                    }
                }
                if(((TRRailLight*)(light)).connector == TRRailConnector.left) {
                    if([[_weakSelf nextConnectLight:light] isKindOfClass:[TRSwitch class]]) {
                        sy -= 0.1;
                        y += 0.15;
                    }
                    if([[_weakSelf.level.railroad contentInTile:geVec2iAddVec2i(((TRRailLight*)(light)).tile, GEVec2iMake(-1, 1)) connector:TRRailConnector.bottom] isKindOfClass:[TRSwitch class]]) {
                        z -= 0.1;
                        sz -= 0.1;
                    }
                }
                if(((TRRailLight*)(light)).connector == TRRailConnector.right) {
                    if([[_weakSelf.level.railroad contentInTile:((TRRailLight*)(light)).tile connector:TRRailConnector.top] isKindOfClass:[TRSwitch class]]) {
                        z -= 0.1;
                        sz -= 0.1;
                    }
                }
                EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:light shape:[EGCollisionBox2d applyX:((float)(sz)) y:((float)(sy))] isKinematic:NO];
                GEMat4* stand = ((((TRRailLight*)(light)).connector == TRRailConnector.top || ((TRRailLight*)(light)).connector == TRRailConnector.bottom) ? [[GEMat4 identity] rotateAngle:90.0 x:1.0 y:0.0 z:0.0] : [[GEMat4 identity] rotateAngle:90.0 x:0.0 y:1.0 z:0.0]);
                GEMat4* moveToPlace = [[GEMat4 identity] translateX:x y:y z:z];
                GEMat4* rotateToConnector = [[GEMat4 identity] rotateAngle:((float)(((TRRailLight*)(light)).connector.angle)) x:0.0 y:0.0 z:1.0];
                GEMat4* moveToTile = [[GEMat4 identity] translateX:((float)(((TRRailLight*)(light)).tile.x)) y:((float)(((TRRailLight*)(light)).tile.y)) z:0.0];
                [body setMatrix:[[[moveToTile mulMatrix:rotateToConnector] mulMatrix:moveToPlace] mulMatrix:stand]];
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


