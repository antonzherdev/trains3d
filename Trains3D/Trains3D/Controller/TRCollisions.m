#import "TRCollisions.h"

#import "EGCollision.h"
#import "TRLevel.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "EGCollisionBody.h"
#import "EGCollisionWorld.h"
#import "EGMapIso.h"
#import "EGDynamicWorld.h"
#import "TRTree.h"
#import "TRCity.h"
#import "GEMat4.h"
@implementation TRBaseTrainsCollisionWorld
static ODClassType* _TRBaseTrainsCollisionWorld_type;

+ (instancetype)baseTrainsCollisionWorld {
    return [[TRBaseTrainsCollisionWorld alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) __trains = [NSMutableArray mutableArray];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRBaseTrainsCollisionWorld class]) _TRBaseTrainsCollisionWorld_type = [ODClassType classTypeWithCls:[TRBaseTrainsCollisionWorld class]];
}

- (EGPhysicsWorld*)world {
    @throw @"Method world is abstract";
}

- (TRLevel*)level {
    @throw @"Method level is abstract";
}

- (void)addTrain:(TRTrain*)train {
    [[train state] onSuccessF:^void(TRTrainState* state) {
        [[self actor] addTrain:train state:state];
    }];
}

- (CNFuture*)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    @throw @"Method add is abstract";
}

- (void)_addTrain:(TRTrain*)train state:(TRTrainState*)state {
    [__trains appendItem:train];
}

- (CNFuture*)removeTrain:(TRTrain*)train {
    __weak TRBaseTrainsCollisionWorld* _weakSelf = self;
    return [self futureF:^id() {
        TRBaseTrainsCollisionWorld* _self = _weakSelf;
        [_self _removeTrain:train];
        return nil;
    }];
}

- (void)_removeTrain:(TRTrain*)train {
    [__trains removeItem:train];
    [train.cars forEach:^void(TRCar* car) {
        [[self world] removeItem:car];
    }];
}

- (CNFuture*)updateF:(CNFuture*(^)(id<CNImSeq>))f {
    return [[[[__trains chain] map:^CNFuture*(TRTrain* _) {
        return [((TRTrain*)(_)) state];
    }] future] flatMapF:^CNFuture*(id<CNImSeq> m) {
        return f(m);
    }];
}

- (void)updateMatrixStates:(id<CNImSeq>)states {
    [states forEach:^void(TRTrainState* state) {
        if(!([((TRTrainState*)(state)) isDying])) [[((TRTrainState*)(state)) carStates] forEach:^void(TRCarState* carState) {
            [[[self world] bodyForItem:((TRCarState*)(carState)).car] forEach:^void(EGCollisionBody* body) {
                [((EGCollisionBody*)(body)) setMatrix:[((TRCarState*)(carState)) matrix]];
            }];
        }];
    }];
}

- (ODClassType*)type {
    return [TRBaseTrainsCollisionWorld type];
}

+ (ODClassType*)type {
    return _TRBaseTrainsCollisionWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainsCollisionWorld
static ODClassType* _TRTrainsCollisionWorld_type;
@synthesize level = _level;
@synthesize world = _world;

+ (instancetype)trainsCollisionWorldWithLevel:(TRLevel*)level {
    return [[TRTrainsCollisionWorld alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _world = [EGCollisionWorld collisionWorld];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainsCollisionWorld class]) _TRTrainsCollisionWorld_type = [ODClassType classTypeWithCls:[TRTrainsCollisionWorld class]];
}

- (CNFuture*)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    __weak TRTrainsCollisionWorld* _weakSelf = self;
    return [self futureF:^id() {
        TRTrainsCollisionWorld* _self = _weakSelf;
        [_self _addTrain:train state:state];
        [[state carStates] forEach:^void(TRCarState* pos) {
            TRTrainsCollisionWorld* _self = _weakSelf;
            EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:((TRCarState*)(pos)).car shape:((TRCarState*)(pos)).carType.collision2dShape isKinematic:YES];
            [body setMatrix:[((TRCarState*)(pos)) matrix]];
            [_self->_world addBody:body];
        }];
        return nil;
    }];
}

- (CNFuture*)detect {
    __weak TRTrainsCollisionWorld* _weakSelf = self;
    return [self updateF:^CNFuture*(id<CNImSeq> m) {
        TRTrainsCollisionWorld* _self = _weakSelf;
        return [[_self actor] _detectStates:m];
    }];
}

- (CNFuture*)_detectStates:(id<CNImSeq>)states {
    __weak TRTrainsCollisionWorld* _weakSelf = self;
    return [self futureF:^id<CNImSeq>() {
        TRTrainsCollisionWorld* _self = _weakSelf;
        [_self updateMatrixStates:states];
        return [[[[_self->_world detect] chain] flatMap:^id(EGCollision* collision) {
            if([((EGCollision*)(collision)).contacts allConfirm:^BOOL(EGContact* _) {
    TRTrainsCollisionWorld* _self = _weakSelf;
    return [_self isOutOfMapContact:_];
}]) return [CNOption none];
            id<CNImMap> statesMap = [[[[states chain] flatMap:^id<CNImSeq>(TRTrainState* _) {
                return [((TRTrainState*)(_)) carStates];
            }] map:^CNTuple*(TRCarState* _) {
                return tuple(((TRCarState*)(_)).car, _);
            }] toMap];
            TRCar* t1 = ((EGCollisionBody*)(((EGCollision*)(collision)).bodies.a)).data;
            TRCar* t2 = ((EGCollisionBody*)(((EGCollision*)(collision)).bodies.b)).data;
            id car1 = [[statesMap optKey:t1] flatMapF:^id(TRCarState* _) {
                return [ODObject asKindOfClass:[TRLiveCarState class] object:((TRCarState*)(_))];
            }];
            id car2 = [[statesMap optKey:t2] flatMapF:^id(TRCarState* _) {
                return [ODObject asKindOfClass:[TRLiveCarState class] object:((TRCarState*)(_))];
            }];
            if([car1 isEmpty] || [car2 isEmpty]) return [CNOption none];
            TRRailPoint point = uwrap(TRRailPoint, ([[[[[[[(@[wrap(TRRailPoint, ((TRLiveCarState*)([car1 get])).head), wrap(TRRailPoint, ((TRLiveCarState*)([car1 get])).tail)]) chain] mul:(@[wrap(TRRailPoint, ((TRLiveCarState*)([car2 get])).head), wrap(TRRailPoint, ((TRLiveCarState*)([car2 get])).tail)])] sortBy] ascBy:^id(CNTuple* pair) {
                TRRailPoint x = uwrap(TRRailPoint, ((CNTuple*)(pair)).a);
                TRRailPoint y = uwrap(TRRailPoint, ((CNTuple*)(pair)).b);
                if(x.form == y.form && GEVec2iEq(x.tile, y.tile)) return numf(floatAbs(x.x - y.x));
                else return @1000;
            }] endSort] map:^id(CNTuple* _) {
                return ((CNTuple*)(_)).a;
            }] head]));
            return [CNOption someValue:[TRCarsCollision carsCollisionWithTrains:[[(@[((TRLiveCarState*)([car1 get])).car.train, ((TRLiveCarState*)([car2 get])).car.train]) chain] toSet] railPoint:point]];
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


@implementation TRCarsCollision
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


@implementation TRTrainsDynamicWorld
static CNNotificationHandle* _TRTrainsDynamicWorld_carsCollisionNotification;
static CNNotificationHandle* _TRTrainsDynamicWorld_carAndGroundCollisionNotification;
static ODClassType* _TRTrainsDynamicWorld_type;
@synthesize level = _level;
@synthesize world = _world;
@synthesize _workCounter = __workCounter;
@synthesize _dyingTrains = __dyingTrains;

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
            [[_level.forest trees] onSuccessF:^void(id<CNIterable> trees) {
                TRTrainsDynamicWorld* _self = _weakSelf;
                [[_self actor] addTrees:trees];
            }];
            return w;
        }();
        _cutDownObs = [TRForest.cutDownNotification observeSender:_level.forest by:^void(TRTree* tree) {
            TRTrainsDynamicWorld* _self = _weakSelf;
            [[_self actor] cutDownTree:tree];
        }];
        __workCounter = 0;
        __dyingTrains = [NSMutableArray mutableArray];
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

- (CNFuture*)addTrees:(id<CNIterable>)trees {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self futureF:^id() {
        [trees forEach:^void(TRTree* tree) {
            [((TRTree*)(tree)).body forEach:^void(EGRigidBody* _) {
                TRTrainsDynamicWorld* _self = _weakSelf;
                [_self->_world addBody:_];
            }];
        }];
        return nil;
    }];
}

- (CNFuture*)cutDownTree:(TRTree*)tree {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self promptF:^id() {
        [tree.body forEach:^void(EGRigidBody* b) {
            TRTrainsDynamicWorld* _self = _weakSelf;
            [_self->_world removeBody:b];
        }];
        return nil;
    }];
}

- (CNFuture*)addCity:(TRCity*)city {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self promptF:^id() {
        [city.bodies forEach:^void(EGRigidBody* _) {
            TRTrainsDynamicWorld* _self = _weakSelf;
            [_self->_world addBody:_];
        }];
        return nil;
    }];
}

- (CNFuture*)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self futureF:^id() {
        TRTrainsDynamicWorld* _self = _weakSelf;
        [_self _addTrain:train state:state];
        [[state carStates] forEach:^void(TRCarState* pos) {
            TRTrainsDynamicWorld* _self = _weakSelf;
            EGRigidBody* body = [EGRigidBody kinematicData:((TRCarState*)(pos)).car shape:((TRCarState*)(pos)).carType.collision2dShape];
            body.matrix = [((TRCarState*)(pos)) matrix];
            [_self->_world addBody:body];
        }];
        return nil;
    }];
}

- (void)dieTrain:(TRTrain*)train {
    [[train state] onSuccessF:^void(TRTrainState* _) {
        [[self actor] dieTrain:train state:((TRLiveTrainState*)(_))];
    }];
}

- (CNFuture*)dieTrain:(TRTrain*)train state:(TRLiveTrainState*)state {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self futureF:^CNFuture*() {
        TRTrainsDynamicWorld* _self = _weakSelf;
        [_self->__dyingTrains appendItem:train];
        _self->__workCounter++;
        id<CNImSeq> carStates = [[[state.carStates chain] map:^TRDieCarState*(TRLiveCarState* carState) {
            TRTrainsDynamicWorld* _self = _weakSelf;
            TRCar* car = ((TRLiveCarState*)(carState)).car;
            [_self->_world removeItem:car];
            GELine2 line = ((TRLiveCarState*)(carState)).line;
            float len = geVec2Length(line.u);
            GEVec2 vec = line.u;
            GEVec2 mid = ((TRLiveCarState*)(carState)).midPoint;
            TRCarType* tp = ((TRLiveCarState*)(carState)).carType;
            EGRigidBody* b = [EGRigidBody dynamicData:car shape:tp.rigidShape mass:((float)(tp.weight))];
            b.matrix = [[[GEMat4 identity] translateX:mid.x y:mid.y z:((float)(tp.height / 2))] rotateAngle:geLine2DegreeAngle(line) x:0.0 y:0.0 z:1.0];
            GEVec3 rnd = GEVec3Make((((float)(odFloatRndMinMax(-0.1, 0.1)))), (((float)(odFloatRndMinMax(-0.1, 0.1)))), (((float)(odFloatRndMinMax(0.0, 5.0)))));
            GEVec3 vel = geVec3AddVec3((geVec3ApplyVec2Z((geVec2MulF(vec, train.speedFloat / len * 2)), 0.0)), rnd);
            b.velocity = ((state.isBack) ? geVec3Negate(vel) : vel);
            b.angularVelocity = GEVec3Make((((float)(odFloatRndMinMax(-5.0, 5.0)))), (((float)(odFloatRndMinMax(-5.0, 5.0)))), (((float)(odFloatRndMinMax(-5.0, 5.0)))));
            [_self->_world addBody:b];
            return [TRDieCarState dieCarStateWithCar:car matrix:b.matrix];
        }] toArray];
        return [train setDieCarStates:carStates];
    }];
}

- (void)_removeTrain:(TRTrain*)train {
    [super _removeTrain:train];
    if([__dyingTrains containsItem:train]) {
        [__dyingTrains removeItem:train];
        __workCounter--;
    }
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    if(__workCounter > 0) return [self updateF:^CNFuture*(id<CNImSeq> m) {
        TRTrainsDynamicWorld* _self = _weakSelf;
        return [[_self actor] _updateWithDelta:delta states:m];
    }];
    else return [CNFuture successfulResult:nil];
}

- (CNFuture*)_updateWithDelta:(CGFloat)delta states:(id<CNImSeq>)states {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self futureF:^id() {
        TRTrainsDynamicWorld* _self = _weakSelf;
        if(_self->__workCounter > 0) {
            [_self updateMatrixStates:states];
            [_self->_world updateWithDelta:delta];
            [_self->__dyingTrains forEach:^void(TRTrain* train) {
                [((TRTrain*)(train)) setDieCarStates:[[[((TRTrain*)(train)).cars chain] map:^TRDieCarState*(TRCar* car) {
                    TRTrainsDynamicWorld* _self = _weakSelf;
                    return [TRDieCarState dieCarStateWithCar:car matrix:[((EGCollisionBody*)([[_self->_world bodyForItem:car] get])) matrix]];
                }] toArray]];
            }];
            [[_self->_world newCollisions] forEach:^void(EGDynamicCollision* collision) {
                TRTrainsDynamicWorld* _self = _weakSelf;
                if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic && ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) return ;
                if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic) {
                    [_self->_level knockDownTrain:((TRCar*)(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).data)).train];
                } else {
                    if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) [_self->_level knockDownTrain:((TRCar*)(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).data)).train];
                }
                if([((EGDynamicCollision*)(collision)) impulse] > 0) {
                    if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).data == nil || ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).data == nil) [[TRTrainsDynamicWorld carAndGroundCollisionNotification] postSender:_self->_level data:numf4([((EGDynamicCollision*)(collision)) impulse])];
                    else [[TRTrainsDynamicWorld carsCollisionNotification] postSender:_self->_level data:numf4([((EGDynamicCollision*)(collision)) impulse])];
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


