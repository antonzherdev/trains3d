#import "TRTrainCollisions.h"

#import "TRLevel.h"
#import "TRTree.h"
#import "TRCity.h"
#import "TRTrain.h"
#import "EGCollision.h"
#import "TRCar.h"
#import "EGCollisionWorld.h"
#import "EGCollisionBody.h"
#import "EGMapIso.h"
#import "EGDynamicWorld.h"
#import "GEMat4.h"
@implementation TRTrainCollisions
static ODClassType* _TRTrainCollisions_type;
@synthesize level = _level;

+ (instancetype)trainCollisionsWithLevel:(TRLevel*)level {
    return [[TRTrainCollisions alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRTrainCollisions* _weakSelf = self;
    if(self) {
        _level = level;
        _collisionsWorld = [TRTrainsCollisionWorld trainsCollisionWorldWithLevel:_level];
        _dynamicWorld = [TRTrainsDynamicWorld trainsDynamicWorldWithLevel:_level];
        __trains = (@[]);
        _cutDownObs = [TRForest.cutDownNotification observeSender:_level.forest by:^void(TRTree* tree) {
            TRTrainCollisions* _self = _weakSelf;
            [_self _cutDownTree:tree];
        }];
        if([self class] == [TRTrainCollisions class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainCollisions class]) _TRTrainCollisions_type = [ODClassType classTypeWithCls:[TRTrainCollisions class]];
}

- (CNFuture*)trains {
    return [self promptF:^id<CNImSeq>() {
        return __trains;
    }];
}

- (CNFuture*)addCity:(TRCity*)city {
    return [self futureF:^id() {
        [_dynamicWorld addCity:city];
        return nil;
    }];
}

- (CNFuture*)removeTrain:(TRTrain*)train {
    return [self futureF:^id() {
        __trains = [__trains subItem:train];
        [_collisionsWorld removeTrain:train];
        [_dynamicWorld removeTrain:train];
        return nil;
    }];
}

- (CNFuture*)addTrain:(TRTrain*)train {
    return [self onSuccessFuture:[train state] f:^id(TRTrainState* state) {
        __trains = [__trains addItem:train];
        [_collisionsWorld addTrain:train state:state];
        [_dynamicWorld addTrain:train state:state];
        return nil;
    }];
}

- (CNFuture*)trainStates {
    return [[self trains] flatMapF:^CNFuture*(id<CNImSeq> ts) {
        return [[[((id<CNImSeq>)(ts)) chain] map:^CNFuture*(TRTrain* _) {
            return [((TRTrain*)(_)) state];
        }] future];
    }];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self onSuccessFuture:[self trainStates] f:^id(id<CNImSeq> states) {
        [_collisionsWorld updateWithStates:states delta:delta];
        [_dynamicWorld updateWithStates:states delta:delta];
        return nil;
    }];
}

- (CNFuture*)detect {
    return [self onSuccessFuture:[self trainStates] f:^id<CNImSeq>(id<CNImSeq> states) {
        return [_collisionsWorld detectStates:states];
    }];
}

- (CNFuture*)dieTrain:(TRTrain*)train wasCollision:(BOOL)wasCollision {
    return [self onSuccessFuture:[train state] f:^id(TRTrainState* state) {
        [_collisionsWorld removeTrain:train];
        [_dynamicWorld dieTrain:train state:((TRLiveTrainState*)(state)) wasCollision:wasCollision];
        return nil;
    }];
}

- (void)_init {
    [[_level.forest trees] onSuccessF:^void(id<CNIterable> trees) {
        [self _addTrees:trees];
    }];
}

- (CNFuture*)_addTrees:(id<CNIterable>)trees {
    return [self futureF:^id() {
        [_dynamicWorld addTrees:trees];
        return nil;
    }];
}

- (CNFuture*)_cutDownTree:(TRTree*)tree {
    return [self futureF:^id() {
        [_dynamicWorld cutDownTree:tree];
        return nil;
    }];
}

- (ODClassType*)type {
    return [TRTrainCollisions type];
}

+ (ODClassType*)type {
    return _TRTrainCollisions_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTrainCollisions* o = ((TRTrainCollisions*)(other));
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


@implementation TRBaseTrainsCollisionWorld
static ODClassType* _TRBaseTrainsCollisionWorld_type;

+ (instancetype)baseTrainsCollisionWorld {
    return [[TRBaseTrainsCollisionWorld alloc] init];
}

- (instancetype)init {
    self = [super init];
    
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

- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    @throw @"Method add is abstract";
}

- (void)removeTrain:(TRTrain*)train {
    [train.cars forEach:^void(TRCar* car) {
        [[self world] removeItem:car];
    }];
}

- (void)updateWithStates:(id<CNImSeq>)states delta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

- (void)updateMatrixStates:(id<CNImSeq>)states {
    [states forEach:^void(TRTrainState* state) {
        if(!([((TRTrainState*)(state)) isDying])) [[((TRTrainState*)(state)) carStates] forEach:^void(TRCarState* carState) {
            [[[self world] bodyForItem:((TRCarState*)(carState)).car] forEach:^void(id<EGPhysicsBody> body) {
                [((id<EGPhysicsBody>)(body)) setMatrix:[((TRCarState*)(carState)) matrix]];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
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

- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    [[state carStates] forEach:^void(TRCarState* pos) {
        EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:((TRCarState*)(pos)).car shape:((TRCarState*)(pos)).carType.collision2dShape isKinematic:YES];
        [body setMatrix:[((TRCarState*)(pos)) matrix]];
        [_world addBody:body];
    }];
}

- (void)updateWithStates:(id<CNImSeq>)states delta:(CGFloat)delta {
    [[self detectStates:states] forEach:^void(TRCarsCollision* _) {
        [_level processCollision:_];
    }];
}

- (id<CNImSeq>)detectStates:(id<CNImSeq>)states {
    [self updateMatrixStates:states];
    return [[[[_world detect] chain] flatMap:^id(EGCollision* collision) {
        if([((EGCollision*)(collision)).contacts allConfirm:^BOOL(EGContact* _) {
    return [self isOutOfMapContact:_];
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
        TRTrain* tr1 = ((TRLiveCarState*)([car1 get])).car.train;
        TRTrain* tr2 = ((TRLiveCarState*)([car2 get])).car.train;
        return [CNOption someValue:[TRCarsCollision carsCollisionWithTrains:((tr1 == tr2) ? (@[tr1]) : (@[tr1, tr2])) railPoint:point]];
    }] toArray];
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

+ (instancetype)carsCollisionWithTrains:(id<CNImSeq>)trains railPoint:(TRRailPoint)railPoint {
    return [[TRCarsCollision alloc] initWithTrains:trains railPoint:railPoint];
}

- (instancetype)initWithTrains:(id<CNImSeq>)trains railPoint:(TRRailPoint)railPoint {
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

+ (instancetype)trainsDynamicWorldWithLevel:(TRLevel*)level {
    return [[TRTrainsDynamicWorld alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _world = [EGDynamicWorld dynamicWorldWithGravity:GEVec3Make(0.0, 0.0, -10.0)];
        __workCounter = 0;
        __dyingTrains = [NSMutableArray mutableArray];
        if([self class] == [TRTrainsDynamicWorld class]) [self _init];
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

- (void)_init {
    EGRigidBody* plane = [EGRigidBody rigidBodyWithData:nil shape:[EGCollisionPlane collisionPlaneWithNormal:GEVec3Make(0.0, 0.0, 1.0) distance:0.0] isKinematic:NO mass:0.0];
    plane.friction = 0.4;
    [_world addBody:plane];
}

- (void)addTrees:(id<CNIterable>)trees {
    [trees forEach:^void(TRTree* tree) {
        [((TRTree*)(tree)).body forEach:^void(EGRigidBody* _) {
            [_world addBody:_];
        }];
    }];
}

- (void)cutDownTree:(TRTree*)tree {
    [tree.body forEach:^void(EGRigidBody* b) {
        [_world removeBody:b];
    }];
}

- (void)addCity:(TRCity*)city {
    [city.bodies forEach:^void(EGRigidBody* _) {
        [_world addBody:_];
    }];
}

- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    [[state carStates] forEach:^void(TRCarState* pos) {
        EGRigidBody* body = [EGRigidBody kinematicData:((TRCarState*)(pos)).car shape:((TRCarState*)(pos)).carType.collision2dShape];
        body.matrix = [((TRCarState*)(pos)) matrix];
        [_world addBody:body];
    }];
}

- (void)dieTrain:(TRTrain*)train state:(TRLiveTrainState*)state wasCollision:(BOOL)wasCollision {
    [__dyingTrains appendItem:train];
    __workCounter++;
    id<CNImSeq> carStates = [[[state.carStates chain] map:^TRDieCarState*(TRLiveCarState* carState) {
        TRCar* car = ((TRLiveCarState*)(carState)).car;
        [_world removeItem:car];
        GELine2 line = ((TRLiveCarState*)(carState)).line;
        float len = geVec2Length(line.u);
        GEVec2 vec = line.u;
        GEVec2 mid = ((TRLiveCarState*)(carState)).midPoint;
        TRCarType* tp = ((TRLiveCarState*)(carState)).carType;
        EGRigidBody* b = [EGRigidBody dynamicData:car shape:tp.rigidShape mass:((float)(tp.weight))];
        b.matrix = [[[GEMat4 identity] translateX:mid.x y:mid.y z:((float)(tp.height / 2))] rotateAngle:geLine2DegreeAngle(line) x:0.0 y:0.0 z:1.0];
        GEVec3 rnd = GEVec3Make((((float)(odFloatRndMinMax(-0.1, 0.1)))), (((float)(odFloatRndMinMax(-0.1, 0.1)))), (((float)(odFloatRndMinMax(0.0, 5.0)))));
        GEVec3 vel = geVec3AddVec3((geVec3ApplyVec2Z((geVec2MulF(vec, train.speedFloat / len * 2)), 0.0)), rnd);
        b.velocity = ((wasCollision) ? ((state.isBack) ? geVec3Negate(vel) : vel) : ((state.isBack) ? vel : geVec3Negate(vel)));
        b.angularVelocity = GEVec3Make((((float)(odFloatRndMinMax(-5.0, 5.0)))), (((float)(odFloatRndMinMax(-5.0, 5.0)))), (((float)(odFloatRndMinMax(-5.0, 5.0)))));
        [_world addBody:b];
        return [TRDieCarState dieCarStateWithCar:car matrix:b.matrix];
    }] toArray];
    [train setDieCarStates:carStates];
}

- (void)removeTrain:(TRTrain*)train {
    [super removeTrain:train];
    if([__dyingTrains containsItem:train]) {
        [__dyingTrains removeItem:train];
        __workCounter--;
    }
}

- (void)updateWithStates:(id<CNImSeq>)states delta:(CGFloat)delta {
    if(__workCounter > 0) {
        [self updateMatrixStates:states];
        [_world updateWithDelta:delta];
        [__dyingTrains forEach:^void(TRTrain* train) {
            [((TRTrain*)(train)) setDieCarStates:[[[((TRTrain*)(train)).cars chain] map:^TRDieCarState*(TRCar* car) {
                return [TRDieCarState dieCarStateWithCar:car matrix:((EGRigidBody*)([[_world bodyForItem:car] get])).matrix];
            }] toArray]];
        }];
        [[_world newCollisions] forEach:^void(EGDynamicCollision* collision) {
            if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic && ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) return ;
            if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic) {
                [_level knockDownTrain:((TRCar*)(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).data)).train];
            } else {
                if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) [_level knockDownTrain:((TRCar*)(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).data)).train];
            }
            if([((EGDynamicCollision*)(collision)) impulse] > 0) {
                if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).data == nil || ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).data == nil) [_TRTrainsDynamicWorld_carAndGroundCollisionNotification postSender:_level data:numf4([((EGDynamicCollision*)(collision)) impulse])];
                else [_TRTrainsDynamicWorld_carsCollisionNotification postSender:_level data:numf4([((EGDynamicCollision*)(collision)) impulse])];
            }
        }];
    }
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


