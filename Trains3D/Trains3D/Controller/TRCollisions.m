#import "TRCollisions.h"

#import "TRLevel.h"
#import "EGCollisionWorld.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "EGCollisionBody.h"
#import "EGCollision.h"
#import "EGMapIso.h"
#import "EGDynamicWorld.h"
#import "TRTree.h"
#import "TRCity.h"
@implementation TRTrainsCollisionWorld{
    __weak TRLevel* _level;
    EGCollisionWorld* _world;
    NSMutableDictionary* _bodies;
}
static ODClassType* _TRTrainsCollisionWorld_type;
@synthesize level = _level;
@synthesize world = _world;
@synthesize bodies = _bodies;

+ (instancetype)trainsCollisionWorldWithLevel:(TRLevel*)level {
    return [[TRTrainsCollisionWorld alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _world = [EGCollisionWorld collisionWorld];
        _bodies = [NSMutableDictionary mutableDictionary];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainsCollisionWorld class]) _TRTrainsCollisionWorld_type = [ODClassType classTypeWithCls:[TRTrainsCollisionWorld class]];
}

- (void)addTrain:(TRTrainActor*)train {
    [[train carPositions] onSuccessF:^void(id<CNSeq> _) {
        [self.actor addTrain:train carPositions:_];
    }];
}

- (void)addTrain:(TRTrainActor*)train carPositions:(id<CNSeq>)carPositions {
    __block NSInteger i = 0;
    [_bodies setKey:train value:[[[carPositions chain] map:^EGCollisionBody*(TRCarPosition* pos) {
        EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:tuple(train, numi(i)) shape:((TRCarPosition*)(pos)).carType.collision2dShape isKinematic:YES];
        i++;
        [body setMatrix:((TRCarPosition*)(pos)).matrix];
        [_world addBody:body];
        return body;
    }] toArray]];
}

- (void)removeTrain:(TRTrainActor*)train {
    [[_bodies takeKey:train] forEach:^void(id<CNSeq> bodies) {
        [((id<CNSeq>)(bodies)) forEach:^void(EGCollisionBody* _) {
            [_world removeBody:_];
        }];
    }];
}

- (CNFuture*)detect {
    return [[[[[_level trainActors] chain] map:^CNFuture*(TRTrainActor* train) {
        return [[((TRTrainActor*)(train)) carPositions] mapF:^CNTuple*(id<CNSeq> _) {
            return tuple(train, _);
        }];
    }] futureF:^id<CNMap>(CNChain* _) {
        return [_ toMap];
    }] flatMapF:^CNFuture*(id<CNMap> _) {
        return [self.actor _detectPositionsMap:_];
    }];
}

- (CNFuture*)_detectPositionsMap:(id<CNMap>)positionsMap {
    __weak TRTrainsCollisionWorld* _weakSelf = self;
    return [self futureF:^id<CNSeq>() {
        [positionsMap forEach:^void(CNTuple* t) {
            [[((id<CNSeq>)([_weakSelf.bodies getKey:((CNTuple*)(t)).a orValue:(@[])])) chain] zipForA:((CNTuple*)(t)).b by:^void(EGCollisionBody* body, TRCarPosition* pos) {
                [((EGCollisionBody*)(body)) setMatrix:((TRCarPosition*)(pos)).matrix];
            }];
        }];
        return [[[[_weakSelf.world detect] chain] flatMap:^id(EGCollision* collision) {
            if([((EGCollision*)(collision)).contacts allConfirm:^BOOL(EGContact* _) {
    return [_weakSelf isOutOfMapContact:_];
}]) return [CNOption none];
            CNTuple* t1 = ((EGCollisionBody*)(((EGCollision*)(collision)).bodies.a)).data;
            CNTuple* t2 = ((EGCollisionBody*)(((EGCollision*)(collision)).bodies.b)).data;
            TRCarPosition* car1 = [((id<CNSeq>)([positionsMap applyKey:t1.a])) applyIndex:((NSUInteger)(unumi(t1.b)))];
            TRCarPosition* car2 = [((id<CNSeq>)([positionsMap applyKey:t2.a])) applyIndex:((NSUInteger)(unumi(t2.b)))];
            TRRailPoint point = uwrap(TRRailPoint, [[[[[[[(@[wrap(TRRailPoint, car1.head), wrap(TRRailPoint, car1.tail)]) chain] mul:(@[wrap(TRRailPoint, car2.head), wrap(TRRailPoint, car2.tail)])] sortBy] ascBy:^id(CNTuple* pair) {
                TRRailPoint x = uwrap(TRRailPoint, ((CNTuple*)(pair)).a);
                TRRailPoint y = uwrap(TRRailPoint, ((CNTuple*)(pair)).b);
                if(x.form == y.form && GEVec2iEq(x.tile, y.tile)) return numf(floatAbs(x.x - y.x));
                else return @1000;
            }] endSort] map:^id(CNTuple* _) {
                return ((CNTuple*)(_)).a;
            }] head]);
            return [CNOption someValue:[TRCarsCollision carsCollisionWithTrains:[[(@[t1.a, t2.a]) chain] toSet] railPoint:point]];
        }] toArray];
    }];
}

- (BOOL)isOutOfMapContact:(EGContact*)contact {
    return geVec2Length([_level.map distanceToMapVec2:geVec3Xy(contact.a)]) > 0.5 && geVec2Length([_level.map distanceToMapVec2:geVec3Xy(contact.b)]) > 0.5;
}

- (ODClassType*)type {
    return [TRTrainsCollisionWorld type];
}

+ (ODClassType*)type {
    return _TRTrainsCollisionWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainsCollisionWorld* o = ((TRTrainsCollisionWorld*)(other));
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


@implementation TRCarsCollision{
    id<CNSet> _trains;
    TRRailPoint _railPoint;
}
static ODClassType* _TRCarsCollision_type;
@synthesize trains = _trains;
@synthesize railPoint = _railPoint;

+ (instancetype)carsCollisionWithTrains:(id<CNSet>)trains railPoint:(TRRailPoint)railPoint {
    return [[TRCarsCollision alloc] initWithTrains:trains railPoint:railPoint];
}

- (instancetype)initWithTrains:(id<CNSet>)trains railPoint:(TRRailPoint)railPoint {
    self = [super init];
    if(self) {
        _trains = trains;
        _railPoint = railPoint;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCarsCollision class]) _TRCarsCollision_type = [ODClassType classTypeWithCls:[TRCarsCollision class]];
}

- (ODClassType*)type {
    return [TRCarsCollision type];
}

+ (ODClassType*)type {
    return _TRCarsCollision_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCarsCollision* o = ((TRCarsCollision*)(other));
    return [self.trains isEqual:o.trains] && TRRailPointEq(self.railPoint, o.railPoint);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.trains hash];
    hash = hash * 31 + TRRailPointHash(self.railPoint);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"trains=%@", self.trains];
    [description appendFormat:@", railPoint=%@", TRRailPointDescription(self.railPoint)];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainsDynamicWorld{
    __weak TRLevel* _level;
    EGDynamicWorld* _world;
    CNNotificationObserver* _cutDownObs;
    NSInteger _workCounter;
}
static CNNotificationHandle* _TRTrainsDynamicWorld_carsCollisionNotification;
static CNNotificationHandle* _TRTrainsDynamicWorld_carAndGroundCollisionNotification;
static ODClassType* _TRTrainsDynamicWorld_type;
@synthesize level = _level;
@synthesize world = _world;
@synthesize cutDownObs = _cutDownObs;
@synthesize workCounter = _workCounter;

+ (instancetype)trainsDynamicWorldWithLevel:(TRLevel*)level {
    return [[TRTrainsDynamicWorld alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    if(self) {
        _level = level;
        _world = ^EGDynamicWorld*() {
            EGDynamicWorld* w = [EGDynamicWorld dynamicWorldWithGravity:GEVec3Make(0.0, 0.0, -10.0)];
            EGRigidBody* plane = [EGRigidBody rigidBodyWithData:nil shape:[EGCollisionPlane collisionPlaneWithNormal:GEVec3Make(0.0, 0.0, 1.0) distance:0.0] isKinematic:NO mass:0.0];
            plane.friction = 0.4;
            [w addBody:plane];
            [[_level.forest trees] forEach:^void(TRTree* tree) {
                [((TRTree*)(tree)).body forEach:^void(EGRigidBody* _) {
                    [w addBody:_];
                }];
            }];
            return w;
        }();
        _cutDownObs = [TRTree.cutDownNotification observeBy:^void(TRTree* tree, id _) {
            [((TRTree*)(tree)).body forEach:^void(EGRigidBody* b) {
                [_weakSelf.world removeBody:b];
            }];
        }];
        _workCounter = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainsDynamicWorld class]) {
        _TRTrainsDynamicWorld_type = [ODClassType classTypeWithCls:[TRTrainsDynamicWorld class]];
        _TRTrainsDynamicWorld_carsCollisionNotification = [CNNotificationHandle notificationHandleWithName:@"carsCollisionNotification"];
        _TRTrainsDynamicWorld_carAndGroundCollisionNotification = [CNNotificationHandle notificationHandleWithName:@"carAndGroundCollisionNotification"];
    }
}

- (void)addCity:(TRCity*)city {
    [city.bodies forEach:^void(EGRigidBody* _) {
        [_world addBody:_];
    }];
}

- (void)addTrain:(TRTrainActor*)train {
    [[train kinematicBodies] forEach:^void(EGRigidBody* body) {
        [_world addBody:body];
    }];
}

- (void)dieTrain:(TRTrainActor*)train {
    _workCounter++;
    [[train kinematicBodies] forEach:^void(EGRigidBody* body) {
        [_world removeBody:body];
    }];
    [[train dynamicBodies] onSuccessF:^void(id<CNSeq> _) {
        [self.actor addDynamicBodies:_];
    }];
}

- (void)addDynamicBodies:(id<CNSeq>)bodies {
    [bodies forEach:^void(EGRigidBody* _) {
        [_world addBody:_];
    }];
}

- (void)removeTrain:(TRTrainActor*)train {
    [[train isDying] onSuccessF:^void(id isDying) {
        if(unumb(isDying)) [self.actor removeDiedTrainTrain:train];
        else [self.actor removeAliveTrainTrain:train];
    }];
}

- (void)removeAliveTrainTrain:(TRTrainActor*)train {
    [[train kinematicBodies] forEach:^void(EGRigidBody* body) {
        [_world removeBody:body];
    }];
}

- (void)removeDiedTrainTrain:(TRTrainActor*)train {
    _workCounter--;
    [[train dynamicBodies] onSuccessF:^void(id<CNSeq> _) {
        [self.actor removeDynamicBodies:_];
    }];
}

- (void)removeDynamicBodies:(id<CNSeq>)bodies {
    [bodies forEach:^void(EGRigidBody* _) {
        [_world removeBody:_];
    }];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    if(_workCounter > 0) return [[[[[_level trainActors] chain] map:^CNFuture*(TRTrainActor* _) {
        return [((TRTrainActor*)(_)) writeKinematicMatrix];
    }] voidFuture] flatMapF:^CNFuture*(id _) {
        return [self.actor _updateWithDelta:delta];
    }];
    else return [CNFuture successfulResult:nil];
}

- (CNFuture*)_updateWithDelta:(CGFloat)delta {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self futureF:^id() {
        if(_weakSelf.workCounter > 0) {
            [_weakSelf.world updateWithDelta:delta];
            [[_weakSelf.world newCollisions] forEach:^void(EGDynamicCollision* collision) {
                if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic && ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) return ;
                if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic) {
                    [_weakSelf.level knockDownTrain:[TRTrainActor trainActorWith_train:((TRCar*)(((CNWeak*)(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).data)).get)).train]];
                } else {
                    if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) [_weakSelf.level knockDownTrain:[TRTrainActor trainActorWith_train:((TRCar*)(((CNWeak*)(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).data)).get)).train]];
                }
                if([((EGDynamicCollision*)(collision)) impulse] > 0) {
                    if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).data == nil || ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).data == nil) [[TRTrainsDynamicWorld carAndGroundCollisionNotification] postSender:_weakSelf.level data:numf4([((EGDynamicCollision*)(collision)) impulse])];
                    else [[TRTrainsDynamicWorld carsCollisionNotification] postSender:_weakSelf.level data:numf4([((EGDynamicCollision*)(collision)) impulse])];
                }
            }];
        }
        return nil;
    }];
}

- (ODClassType*)type {
    return [TRTrainsDynamicWorld type];
}

+ (CNNotificationHandle*)carsCollisionNotification {
    return _TRTrainsDynamicWorld_carsCollisionNotification;
}

+ (CNNotificationHandle*)carAndGroundCollisionNotification {
    return _TRTrainsDynamicWorld_carAndGroundCollisionNotification;
}

+ (ODClassType*)type {
    return _TRTrainsDynamicWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainsDynamicWorld* o = ((TRTrainsDynamicWorld*)(other));
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


