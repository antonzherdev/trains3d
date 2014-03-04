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
@implementation TRBaseTrainsCollisionWorld{
    NSMutableArray* __trains;
}
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
        [self.actor addTrain:train state:state];
    }];
}

- (CNFuture*)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    @throw @"Method add is abstract";
}

- (void)_addTrain:(TRTrain*)train state:(TRTrainState*)state {
    [__trains addItem:train];
}

- (CNFuture*)removeTrain:(TRTrain*)train {
    __weak TRBaseTrainsCollisionWorld* _weakSelf = self;
    return [self futureF:^id() {
        [_weakSelf _removeTrain:train];
        return nil;
    }];
}

- (void)_removeTrain:(TRTrain*)train {
    [__trains removeItem:train];
    [train.cars forEach:^void(TRCar* car) {
        [[self world] removeItem:car];
    }];
}

- (CNFuture*)updateF:(CNFuture*(^)(id<CNSeq>))f {
    return [[[[__trains chain] map:^CNFuture*(TRTrain* _) {
        return [((TRTrain*)(_)) state];
    }] futureArray] flatMapF:^CNFuture*(id<CNSeq> m) {
        return f(m);
    }];
}

- (void)updateMatrixStates:(id<CNSeq>)states {
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


@implementation TRTrainsCollisionWorld{
    __weak TRLevel* _level;
    EGCollisionWorld* _world;
}
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
        [_weakSelf _addTrain:train state:state];
        [[state carStates] forEach:^void(TRCarState* pos) {
            EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:((TRCarState*)(pos)).car shape:((TRCarState*)(pos)).carType.collision2dShape isKinematic:YES];
            [body setMatrix:[((TRCarState*)(pos)) matrix]];
            [_weakSelf.world addBody:body];
        }];
        return nil;
    }];
}

- (CNFuture*)detect {
    __weak TRTrainsCollisionWorld* _weakSelf = self;
    return [self updateF:^CNFuture*(id<CNSeq> m) {
        return [_weakSelf.actor _detectStates:m];
    }];
}

- (CNFuture*)_detectStates:(id<CNSeq>)states {
    __weak TRTrainsCollisionWorld* _weakSelf = self;
    return [self futureF:^id<CNSeq>() {
        [_weakSelf updateMatrixStates:states];
        return [[[[_weakSelf.world detect] chain] flatMap:^id(EGCollision* collision) {
            if([((EGCollision*)(collision)).contacts allConfirm:^BOOL(EGContact* _) {
    return [_weakSelf isOutOfMapContact:_];
}]) return [CNOption none];
            id<CNMap> statesMap = [[[[states chain] flatMap:^id<CNSeq>(TRTrainState* _) {
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
    NSInteger __workCounter;
    NSMutableArray* __dyingTrains;
}
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
            [[_level.forest trees] forEach:^void(TRTree* tree) {
                [((TRTree*)(tree)).body forEach:^void(EGRigidBody* _) {
                    [w addBody:_];
                }];
            }];
            return w;
        }();
        _cutDownObs = [TRTree.cutDownNotification observeBy:^void(TRTree* tree, id _) {
            [_weakSelf.actor cutDownTree:tree];
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

- (CNFuture*)cutDownTree:(TRTree*)tree {
    return [self promptF:^id() {
        return nil;
    }];
}

- (CNFuture*)addCity:(TRCity*)city {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self promptF:^id() {
        [city.bodies forEach:^void(EGRigidBody* _) {
            [_weakSelf.world addBody:_];
        }];
        return nil;
    }];
}

- (CNFuture*)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self futureF:^id() {
        [_weakSelf _addTrain:train state:state];
        [[state carStates] forEach:^void(TRCarState* pos) {
            EGRigidBody* body = [EGRigidBody kinematicData:((TRCarState*)(pos)).car shape:((TRCarState*)(pos)).carType.collision2dShape];
            body.matrix = [((TRCarState*)(pos)) matrix];
            [_weakSelf.world addBody:body];
        }];
        return nil;
    }];
}

- (void)dieTrain:(TRTrain*)train {
    [[train state] onSuccessF:^void(TRTrainState* _) {
        [self.actor dieTrain:train state:((TRLiveTrainState*)(_))];
    }];
}

- (CNFuture*)dieTrain:(TRTrain*)train state:(TRLiveTrainState*)state {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self futureF:^CNFuture*() {
        [_weakSelf._dyingTrains addItem:train];
        _weakSelf._workCounter++;
        id<CNSeq> carStates = [[[state.carStates chain] map:^TRDieCarState*(TRLiveCarState* carState) {
            [_weakSelf.world removeItem:((TRLiveCarState*)(carState)).car];
            GELine2 line = ((TRLiveCarState*)(carState)).line;
            float len = geVec2Length(line.u);
            GEVec2 vec = line.u;
            GEVec2 mid = ((TRLiveCarState*)(carState)).midPoint;
            TRCarType* tp = ((TRLiveCarState*)(carState)).carType;
            EGRigidBody* b = [EGRigidBody dynamicData:[CNWeak weakWithGet:_weakSelf] shape:tp.rigidShape mass:((float)(tp.weight))];
            b.matrix = [[[GEMat4 identity] translateX:mid.x y:mid.y z:((float)(tp.height / 2))] rotateAngle:geLine2DegreeAngle(line) x:0.0 y:0.0 z:1.0];
            GEVec3 rnd = GEVec3Make((((float)(odFloatRndMinMax(-0.1, 0.1)))), (((float)(odFloatRndMinMax(-0.1, 0.1)))), (((float)(odFloatRndMinMax(0.0, 5.0)))));
            GEVec3 vel = geVec3AddVec3((geVec3ApplyVec2Z((geVec2MulF(vec, train.speedFloat / len * 2)), 0.0)), rnd);
            b.velocity = ((state.isBack) ? geVec3Negate(vel) : vel);
            b.angularVelocity = GEVec3Make((((float)(odFloatRndMinMax(-5.0, 5.0)))), (((float)(odFloatRndMinMax(-5.0, 5.0)))), (((float)(odFloatRndMinMax(-5.0, 5.0)))));
            [_weakSelf.world addBody:b];
            return [TRDieCarState dieCarStateWithCar:((TRLiveCarState*)(carState)).car matrix:b.matrix];
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
    if(__workCounter > 0) return [self updateF:^CNFuture*(id<CNSeq> m) {
        return [_weakSelf.actor _updateWithDelta:delta states:m];
    }];
    else return [CNFuture successfulResult:nil];
}

- (CNFuture*)_updateWithDelta:(CGFloat)delta states:(id<CNSeq>)states {
    __weak TRTrainsDynamicWorld* _weakSelf = self;
    return [self futureF:^id() {
        if(_weakSelf._workCounter > 0) {
            [_weakSelf updateMatrixStates:states];
            [_weakSelf.world updateWithDelta:delta];
            [_weakSelf._dyingTrains forEach:^void(TRTrain* train) {
                [((TRTrain*)(train)) setDieCarStates:[[[((TRTrain*)(train)).cars chain] map:^TRDieCarState*(TRCar* car) {
                    return [TRDieCarState dieCarStateWithCar:car matrix:[((EGCollisionBody*)([[_weakSelf.world bodyForItem:car] get])) matrix]];
                }] toArray]];
            }];
            [[_weakSelf.world newCollisions] forEach:^void(EGDynamicCollision* collision) {
                if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic && ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) return ;
                if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic) {
                    [_weakSelf.level knockDownTrain:((TRCar*)(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).data)).train];
                } else {
                    if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) [_weakSelf.level knockDownTrain:((TRCar*)(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).data)).train];
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


