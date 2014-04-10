#import "TRTrainCollisions.h"

#import "TRLevel.h"
#import "ATObserver.h"
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
        _cutDownObs = [_level.forest.treeWasCutDown observeF:^void(TRTree* tree) {
            TRTrainCollisions* _self = _weakSelf;
            if(_self != nil) [_self _cutDownTree:tree];
        }];
        _forestRestoredObs = [_level.forest.stateWasRestored observeF:^void(id<CNImIterable> trees) {
            TRTrainCollisions* _self = _weakSelf;
            if(_self != nil) [_self _restoreTrees:trees];
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
    return [self promptF:^NSArray*() {
        return __trains;
    }];
}

- (CNFuture*)addCity:(TRCity*)city {
    return [self futureF:^id() {
        [_dynamicWorld addCity:city];
        return nil;
    }];
}

- (CNFuture*)removeCity:(TRCity*)city {
    return [self futureF:^id() {
        [_dynamicWorld removeCity:city];
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

- (CNFuture*)addTrain:(TRTrain*)train state:(TRLiveTrainState*)state {
    return [self futureF:^id() {
        __trains = [__trains addItem:train];
        [_collisionsWorld addTrain:train state:state];
        [_dynamicWorld addTrain:train state:state];
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
    return [[self trains] flatMapF:^CNFuture*(NSArray* ts) {
        return [[[((NSArray*)(ts)) chain] map:^CNFuture*(TRTrain* _) {
            return [((TRTrain*)(_)) state];
        }] future];
    }];
}

- (CNFuture*)updateWithDelta:(CGFloat)delta {
    return [self onSuccessFuture:[self trainStates] f:^id(NSArray* states) {
        [_collisionsWorld updateWithStates:states delta:delta];
        [_dynamicWorld updateWithStates:states delta:delta];
        return nil;
    }];
}

- (CNFuture*)detect {
    return [self onSuccessFuture:[self trainStates] f:^NSArray*(NSArray* states) {
        return [_collisionsWorld detectStates:states];
    }];
}

- (CNFuture*)dieTrain:(TRTrain*)train liveState:(TRLiveTrainState*)liveState wasCollision:(BOOL)wasCollision {
    return [self futureF:^id() {
        [_collisionsWorld removeTrain:train];
        [_dynamicWorld dieTrain:train liveState:liveState wasCollision:wasCollision];
        return nil;
    }];
}

- (CNFuture*)dieTrain:(TRTrain*)train dieState:(TRDieTrainState*)dieState {
    return [self futureF:^id() {
        [_collisionsWorld removeTrain:train];
        [_dynamicWorld dieTrain:train dieState:dieState];
        return nil;
    }];
}

- (void)_init {
    [[_level.forest trees] onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            id<CNImIterable> trees = [t get];
            [self _addTrees:trees];
        }
    }];
}

- (CNFuture*)_addTrees:(id<CNIterable>)trees {
    return [self futureF:^id() {
        [_dynamicWorld addTrees:trees];
        return nil;
    }];
}

- (CNFuture*)_restoreTrees:(id<CNIterable>)trees {
    return [self futureF:^id() {
        [_dynamicWorld restoreTrees:trees];
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
    for(TRCar* car in train.cars) {
        [[self world] removeItem:car];
    }
}

- (void)updateWithStates:(NSArray*)states delta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

- (void)updateMatrixStates:(NSArray*)states {
    for(TRTrainState* state in states) {
        if(!([((TRTrainState*)(state)) isDying])) for(TRCarState* carState in [((TRTrainState*)(state)) carStates]) {
            id<EGPhysicsBody> body = [[self world] bodyForItem:((TRCarState*)(carState)).car];
            if(body != nil) [body setMatrix:[((TRCarState*)(carState)) matrix]];
        }
    }
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

- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    for(TRCarState* pos in [state carStates]) {
        EGCollisionBody* body = [EGCollisionBody collisionBodyWithData:((TRCarState*)(pos)).car shape:((TRCarState*)(pos)).carType.collision2dShape isKinematic:YES];
        [body setMatrix:[((TRCarState*)(pos)) matrix]];
        [_world addBody:body];
    }
}

- (void)updateWithStates:(NSArray*)states delta:(CGFloat)delta {
    for(TRCarsCollision* _ in [self detectStates:states]) {
        [_level processCollision:_];
    }
}

- (NSArray*)detectStates:(NSArray*)states {
    [self updateMatrixStates:states];
    return [[[[_world detect] chain] mapOpt:^TRCarsCollision*(EGCollision* collision) {
        if([((EGCollision*)(collision)).contacts allConfirm:^BOOL(EGContact* _) {
            return [self isOutOfMapContact:_];
        }]) return nil;
        id<CNImMap> statesMap = [[[[states chain] flatMap:^NSArray*(TRTrainState* _) {
            return [((TRTrainState*)(_)) carStates];
        }] map:^CNTuple*(TRCarState* _) {
            return tuple(((TRCarState*)(_)).car, _);
        }] toMap];
        TRCar* t1 = ((EGCollisionBody*)(((EGCollision*)(collision)).bodies.a)).data;
        TRCar* t2 = ((EGCollisionBody*)(((EGCollision*)(collision)).bodies.b)).data;
        TRLiveCarState* car1 = [ODObject asKindOfClass:[TRLiveCarState class] object:((TRCarState*)([statesMap optKey:t1]))];
        TRLiveCarState* car2 = [ODObject asKindOfClass:[TRLiveCarState class] object:((TRCarState*)([statesMap optKey:t2]))];
        if(car1 == nil || car2 == nil) return nil;
        TRRailPoint point = uwrap(TRRailPoint, (nonnil(([[[[[[[(@[wrap(TRRailPoint, ((TRLiveCarState*)(nonnil(car1))).head), wrap(TRRailPoint, ((TRLiveCarState*)(nonnil(car1))).tail)]) chain] mul:(@[wrap(TRRailPoint, ((TRLiveCarState*)(nonnil(car2))).head), wrap(TRRailPoint, ((TRLiveCarState*)(nonnil(car2))).tail)])] sortBy] ascBy:^id(CNTuple* pair) {
            TRRailPoint x = uwrap(TRRailPoint, ((CNTuple*)(pair)).a);
            TRRailPoint y = uwrap(TRRailPoint, ((CNTuple*)(pair)).b);
            if(x.form == y.form && GEVec2iEq(x.tile, y.tile)) return numf(floatAbs(x.x - y.x));
            else return @1000.0;
        }] endSort] map:^id(CNTuple* _) {
            return ((CNTuple*)(_)).a;
        }] head]))));
        TRTrain* tr1 = ((TRLiveCarState*)(nonnil(car1))).car.train;
        TRTrain* tr2 = ((TRLiveCarState*)(nonnil(car2))).car.train;
        return [TRCarsCollision carsCollisionWithTrains:((tr1 == tr2) ? ((NSArray*)((@[tr1]))) : (@[tr1, tr2])) railPoint:point];
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

+ (instancetype)carsCollisionWithTrains:(NSArray*)trains railPoint:(TRRailPoint)railPoint {
    return [[TRCarsCollision alloc] initWithTrains:trains railPoint:railPoint];
}

- (instancetype)initWithTrains:(NSArray*)trains railPoint:(TRRailPoint)railPoint {
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
        [self _init];
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
        EGRigidBody* _ = ((TRTree*)(tree)).body;
        if(_ != nil) [_world addBody:_];
    }];
}

- (void)restoreTrees:(id<CNIterable>)trees {
    [trees forEach:^void(TRTree* tree) {
        EGRigidBody* body = ((TRTree*)(tree)).body;
        if(body != nil) {
            if(!([[_world bodies] containsItem:body])) [_world addBody:body];
        }
    }];
}

- (void)cutDownTree:(TRTree*)tree {
    EGRigidBody* b = tree.body;
    if(b != nil) [_world removeBody:b];
}

- (void)addCity:(TRCity*)city {
    for(EGRigidBody* _ in city.bodies) {
        [_world addBody:_];
    }
}

- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    for(TRCarState* pos in [state carStates]) {
        EGRigidBody* body = [EGRigidBody kinematicData:((TRCarState*)(pos)).car shape:((TRCarState*)(pos)).carType.collision2dShape];
        body.matrix = [((TRCarState*)(pos)) matrix];
        [_world addBody:body];
    }
}

- (void)dieTrain:(TRTrain*)train liveState:(TRLiveTrainState*)liveState wasCollision:(BOOL)wasCollision {
    [__dyingTrains appendItem:train];
    __workCounter++;
    NSArray* carStates = [[[liveState.carStates chain] map:^TRDieCarState*(TRLiveCarState* carState) {
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
        GEVec3 vel = geVec3AddVec3((geVec3ApplyVec2Z((geVec2MulF4(vec, ((float)(train.speedFloat / len * 2)))), 0.0)), rnd);
        b.velocity = ((wasCollision) ? ((liveState.isBack) ? geVec3Negate(vel) : vel) : ((liveState.isBack) ? vel : geVec3Negate(vel)));
        b.angularVelocity = GEVec3Make((((float)(odFloatRndMinMax(-5.0, 5.0)))), (((float)(odFloatRndMinMax(-5.0, 5.0)))), (((float)(odFloatRndMinMax(-5.0, 5.0)))));
        [_world addBody:b];
        return [TRDieCarState dieCarStateWithCar:car matrix:b.matrix velocity:b.velocity angularVelocity:b.angularVelocity];
    }] toArray];
    [train setDieCarStates:carStates];
}

- (void)dieTrain:(TRTrain*)train dieState:(TRDieTrainState*)dieState {
    [__dyingTrains appendItem:train];
    __workCounter++;
    for(TRDieCarState* carState in dieState.carStates) {
        TRCar* car = carState.car;
        [_world removeItem:car];
        TRCarType* tp = carState.carType;
        EGRigidBody* b = [EGRigidBody dynamicData:car shape:tp.rigidShape mass:((float)(tp.weight))];
        b.matrix = carState.matrix;
        b.velocity = carState.velocity;
        b.angularVelocity = carState.angularVelocity;
        [_world addBody:b];
    }
}

- (void)removeCity:(TRCity*)city {
    for(EGRigidBody* _ in city.bodies) {
        [_world removeBody:_];
    }
}

- (void)removeTrain:(TRTrain*)train {
    [super removeTrain:train];
    if([__dyingTrains containsItem:train]) {
        [__dyingTrains removeItem:train];
        __workCounter--;
    }
}

- (void)updateWithStates:(NSArray*)states delta:(CGFloat)delta {
    if(__workCounter > 0) {
        [self updateMatrixStates:states];
        [_world updateWithDelta:delta];
        for(TRTrain* train in __dyingTrains) {
            [((TRTrain*)(train)) setDieCarStates:[[[((TRTrain*)(train)).cars chain] mapOpt:^TRDieCarState*(TRCar* car) {
                EGRigidBody* b = [_world bodyForItem:car];
                if(b != nil) return [TRDieCarState dieCarStateWithCar:car matrix:b.matrix velocity:b.velocity angularVelocity:b.angularVelocity];
                else return nil;
            }] toArray]];
        }
        [[_world newCollisions] forEach:^void(EGDynamicCollision* collision) {
            if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic && ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) return ;
            {
                TRCar* _ = ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).data;
                if(_ != nil) [_level knockDownTrain:_.train];
            }
            {
                TRCar* _ = ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).data;
                if(_ != nil) [_level knockDownTrain:_.train];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"level=%@", self.level];
    [description appendString:@">"];
    return description;
}

@end


