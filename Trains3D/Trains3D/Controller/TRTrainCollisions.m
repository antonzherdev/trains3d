#import "TRTrainCollisions.h"

#import "TRLevel.h"
#import "CNObserver.h"
#import "TRTree.h"
#import "CNFuture.h"
#import "TRCity.h"
#import "TRTrain.h"
#import "CNChain.h"
#import "PGCollision.h"
#import "PGCollisionWorld.h"
#import "PGCollisionBody.h"
#import "CNSortBuilder.h"
#import "PGMapIso.h"
#import "PGDynamicWorld.h"
#import "PGMat4.h"
@implementation TRTrainCollisions
static CNClassType* _TRTrainCollisions_type;
@synthesize level = _level;

+ (instancetype)trainCollisionsWithLevel:(TRLevel*)level {
    return [[TRTrainCollisions alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    __weak TRTrainCollisions* _weakSelf = self;
    if(self) {
        _level = level;
        _collisionsWorld = [TRTrainsCollisionWorld trainsCollisionWorldWithLevel:level];
        _dynamicWorld = [TRTrainsDynamicWorld trainsDynamicWorldWithLevel:level];
        __trains = ((NSArray*)((@[])));
        _cutDownObs = [level->_forest->_treeWasCutDown observeF:^void(TRTree* tree) {
            TRTrainCollisions* _self = _weakSelf;
            if(_self != nil) [_self _cutDownTree:tree];
        }];
        _forestRestoredObs = [level->_forest->_stateWasRestored observeF:^void(id<CNImIterable> trees) {
            TRTrainCollisions* _self = _weakSelf;
            if(_self != nil) [_self _restoreTrees:trees];
        }];
        if([self class] == [TRTrainCollisions class]) [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainCollisions class]) _TRTrainCollisions_type = [CNClassType classTypeWithCls:[TRTrainCollisions class]];
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
        return [[[((NSArray*)(ts)) chain] mapF:^CNFuture*(TRTrain* _) {
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
    [[_level->_forest trees] onCompleteF:^void(CNTry* t) {
        if([t isSuccess]) {
            NSArray* trees = [t get];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"TrainCollisions(%@)", _level];
}

- (CNClassType*)type {
    return [TRTrainCollisions type];
}

+ (CNClassType*)type {
    return _TRTrainCollisions_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRBaseTrainsCollisionWorld
static CNClassType* _TRBaseTrainsCollisionWorld_type;

+ (instancetype)baseTrainsCollisionWorld {
    return [[TRBaseTrainsCollisionWorld alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRBaseTrainsCollisionWorld class]) _TRBaseTrainsCollisionWorld_type = [CNClassType classTypeWithCls:[TRBaseTrainsCollisionWorld class]];
}

- (PGPhysicsWorld*)world {
    @throw @"Method world is abstract";
}

- (TRLevel*)level {
    @throw @"Method level is abstract";
}

- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    @throw @"Method add is abstract";
}

- (void)removeTrain:(TRTrain*)train {
    for(TRCar* car in train->_cars) {
        [[self world] removeItem:car];
    }
}

- (void)updateWithStates:(NSArray*)states delta:(CGFloat)delta {
    @throw @"Method updateWith is abstract";
}

- (void)updateMatrixStates:(NSArray*)states {
    for(TRTrainState* state in states) {
        if(!([((TRTrainState*)(state)) isDying])) for(TRCarState* carState in [((TRTrainState*)(state)) carStates]) {
            id<PGPhysicsBody> body = [[self world] bodyForItem:((TRCarState*)(carState))->_car];
            if(body != nil) [((id<PGPhysicsBody>)(body)) setMatrix:[((TRCarState*)(carState)) matrix]];
        }
    }
}

- (NSString*)description {
    return @"BaseTrainsCollisionWorld";
}

- (CNClassType*)type {
    return [TRBaseTrainsCollisionWorld type];
}

+ (CNClassType*)type {
    return _TRBaseTrainsCollisionWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTrainsCollisionWorld
static CNClassType* _TRTrainsCollisionWorld_type;
@synthesize level = _level;
@synthesize world = _world;

+ (instancetype)trainsCollisionWorldWithLevel:(TRLevel*)level {
    return [[TRTrainsCollisionWorld alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _world = [PGCollisionWorld collisionWorld];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainsCollisionWorld class]) _TRTrainsCollisionWorld_type = [CNClassType classTypeWithCls:[TRTrainsCollisionWorld class]];
}

- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    for(TRCarState* pos in [state carStates]) {
        PGCollisionBody* body = [PGCollisionBody collisionBodyWithData:((TRCarState*)(pos))->_car shape:[TRCarType value:((TRCarState*)(pos))->_carType].collision2dShape isKinematic:YES];
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
    return [[[[_world detect] chain] mapOptF:^TRCarsCollision*(PGCollision* collision) {
        if([((PGCollision*)(collision))->_contacts allConfirm:^BOOL(PGContact* _) {
            return [self isOutOfMapContact:_];
        }]) return nil;
        NSDictionary* statesMap = [[[[states chain] flatMapF:^NSArray*(TRTrainState* _) {
            return [((TRTrainState*)(_)) carStates];
        }] mapF:^CNTuple*(TRCarState* _) {
            return tuple(((TRCarState*)(_))->_car, _);
        }] toMap];
        TRCar* t1 = ((PGCollisionBody*)(((PGCollision*)(collision))->_bodies->_a)).data;
        TRCar* t2 = ((PGCollisionBody*)(((PGCollision*)(collision))->_bodies->_b)).data;
        TRLiveCarState* car1 = [CNObject asKindOfClass:[TRLiveCarState class] object:((TRCarState*)([statesMap applyKey:t1]))];
        TRLiveCarState* car2 = [CNObject asKindOfClass:[TRLiveCarState class] object:((TRCarState*)([statesMap applyKey:t2]))];
        if(car1 == nil || car2 == nil) return nil;
        TRRailPoint point = uwrap(TRRailPoint, (nonnil(([[[[[[[(@[wrap(TRRailPoint, ((TRLiveCarState*)(nonnil(car1)))->_head), wrap(TRRailPoint, ((TRLiveCarState*)(nonnil(car1)))->_tail)]) chain] mulBy:(@[wrap(TRRailPoint, ((TRLiveCarState*)(nonnil(car2)))->_head), wrap(TRRailPoint, ((TRLiveCarState*)(nonnil(car2)))->_tail)])] sortBy] ascBy:^id(CNTuple* pair) {
            TRRailPoint x = uwrap(TRRailPoint, ((CNTuple*)(pair))->_a);
            TRRailPoint y = uwrap(TRRailPoint, ((CNTuple*)(pair))->_b);
            if(x.form == y.form && pgVec2iIsEqualTo(x.tile, y.tile)) return numf(floatAbs(x.x - y.x));
            else return @1000.0;
        }] endSort] mapF:^id(CNTuple* _) {
            return ((CNTuple*)(_))->_a;
        }] head]))));
        TRTrain* tr1 = ((TRLiveCarState*)(nonnil(car1)))->_car->_train;
        TRTrain* tr2 = ((TRLiveCarState*)(nonnil(car2)))->_car->_train;
        return [TRCarsCollision carsCollisionWithTrains:((tr1 == tr2) ? ((NSArray*)((@[tr1]))) : (@[tr1, tr2])) railPoint:point];
    }] toArray];
}

- (BOOL)isOutOfMapContact:(PGContact*)contact {
    return pgVec2Length([_level->_map distanceToMapVec2:pgVec3Xy(contact->_a)]) > 0.5 && pgVec2Length([_level->_map distanceToMapVec2:pgVec3Xy(contact->_b)]) > 0.5;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TrainsCollisionWorld(%@)", _level];
}

- (CNClassType*)type {
    return [TRTrainsCollisionWorld type];
}

+ (CNClassType*)type {
    return _TRTrainsCollisionWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRCarsCollision
static CNClassType* _TRCarsCollision_type;
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
    if(self == [TRCarsCollision class]) _TRCarsCollision_type = [CNClassType classTypeWithCls:[TRCarsCollision class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CarsCollision(%@, %@)", _trains, trRailPointDescription(_railPoint)];
}

- (CNClassType*)type {
    return [TRCarsCollision type];
}

+ (CNClassType*)type {
    return _TRCarsCollision_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTrainsDynamicWorld
static CNSignal* _TRTrainsDynamicWorld_carsCollision;
static CNSignal* _TRTrainsDynamicWorld_carAndGroundCollision;
static CNClassType* _TRTrainsDynamicWorld_type;
@synthesize level = _level;
@synthesize world = _world;

+ (instancetype)trainsDynamicWorldWithLevel:(TRLevel*)level {
    return [[TRTrainsDynamicWorld alloc] initWithLevel:level];
}

- (instancetype)initWithLevel:(TRLevel*)level {
    self = [super init];
    if(self) {
        _level = level;
        _world = [PGDynamicWorld dynamicWorldWithGravity:PGVec3Make(0.0, 0.0, -10.0)];
        __workCounter = 0;
        __dyingTrains = [CNMArray array];
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainsDynamicWorld class]) {
        _TRTrainsDynamicWorld_type = [CNClassType classTypeWithCls:[TRTrainsDynamicWorld class]];
        _TRTrainsDynamicWorld_carsCollision = [CNSignal signal];
        _TRTrainsDynamicWorld_carAndGroundCollision = [CNSignal signal];
    }
}

- (void)_init {
    PGRigidBody* plane = [PGRigidBody rigidBodyWithData:nil shape:[PGCollisionPlane collisionPlaneWithNormal:PGVec3Make(0.0, 0.0, 1.0) distance:0.0] isKinematic:NO mass:0.0];
    plane.friction = 0.4;
    [_world addBody:plane];
}

- (void)addTrees:(id<CNIterable>)trees {
    id<CNIterator> __il__0i = [trees iterator];
    while([__il__0i hasNext]) {
        TRTree* tree = [__il__0i next];
        {
            PGRigidBody* _ = ((TRTree*)(tree))->_body;
            if(_ != nil) [_world addBody:_];
        }
    }
}

- (void)restoreTrees:(id<CNIterable>)trees {
    id<CNIterator> __il__0i = [trees iterator];
    while([__il__0i hasNext]) {
        TRTree* tree = [__il__0i next];
        {
            PGRigidBody* body = ((TRTree*)(tree))->_body;
            if(body != nil) {
                if(!([[_world bodies] containsItem:body])) [_world addBody:body];
            }
        }
    }
}

- (void)cutDownTree:(TRTree*)tree {
    PGRigidBody* b = tree->_body;
    if(b != nil) [_world removeBody:b];
}

- (void)addCity:(TRCity*)city {
    for(PGRigidBody* _ in city->_bodies) {
        [_world addBody:_];
    }
}

- (void)addTrain:(TRTrain*)train state:(TRTrainState*)state {
    for(TRCarState* pos in [state carStates]) {
        PGRigidBody* body = [PGRigidBody kinematicData:((TRCarState*)(pos))->_car shape:[TRCarType value:((TRCarState*)(pos))->_carType].collision2dShape];
        body.matrix = [((TRCarState*)(pos)) matrix];
        [_world addBody:body];
    }
}

- (void)dieTrain:(TRTrain*)train liveState:(TRLiveTrainState*)liveState wasCollision:(BOOL)wasCollision {
    [__dyingTrains appendItem:train];
    __workCounter++;
    NSArray* carStates = [[[liveState->_carStates chain] mapF:^TRDieCarState*(TRLiveCarState* carState) {
        TRCar* car = ((TRLiveCarState*)(carState))->_car;
        [_world removeItem:car];
        PGLine2 line = ((TRLiveCarState*)(carState))->_line;
        float len = pgVec2Length(line.u);
        PGVec2 vec = line.u;
        PGVec2 mid = ((TRLiveCarState*)(carState))->_midPoint;
        TRCarTypeR tp = ((TRLiveCarState*)(carState))->_carType;
        PGRigidBody* b = [PGRigidBody dynamicData:car shape:[TRCarType value:tp].rigidShape mass:((float)([TRCarType value:tp].weight))];
        b.matrix = [[[PGMat4 identity] translateX:mid.x y:mid.y z:((float)([TRCarType value:tp].height / 2))] rotateAngle:pgLine2DegreeAngle(line) x:0.0 y:0.0 z:1.0];
        PGVec3 rnd = PGVec3Make((((float)(cnFloatRndMinMax(-0.1, 0.1)))), (((float)(cnFloatRndMinMax(-0.1, 0.1)))), (((float)(cnFloatRndMinMax(0.0, 5.0)))));
        PGVec3 vel = pgVec3AddVec3((pgVec3ApplyVec2Z((pgVec2MulF(vec, train->_speedFloat / len * 2)), 0.0)), rnd);
        b.velocity = ((wasCollision) ? ((liveState->_isBack) ? pgVec3Negate(vel) : vel) : ((liveState->_isBack) ? vel : pgVec3Negate(vel)));
        b.angularVelocity = PGVec3Make((((float)(cnFloatRndMinMax(-5.0, 5.0)))), (((float)(cnFloatRndMinMax(-5.0, 5.0)))), (((float)(cnFloatRndMinMax(-5.0, 5.0)))));
        [_world addBody:b];
        return [TRDieCarState dieCarStateWithCar:car matrix:b.matrix velocity:b.velocity angularVelocity:b.angularVelocity];
    }] toArray];
    [train setDieCarStates:carStates];
}

- (void)dieTrain:(TRTrain*)train dieState:(TRDieTrainState*)dieState {
    [__dyingTrains appendItem:train];
    __workCounter++;
    for(TRDieCarState* carState in dieState->_carStates) {
        TRCar* car = carState->_car;
        [_world removeItem:car];
        TRCarTypeR tp = carState->_carType;
        PGRigidBody* b = [PGRigidBody dynamicData:car shape:[TRCarType value:tp].rigidShape mass:((float)([TRCarType value:tp].weight))];
        b.matrix = carState->_matrix;
        b.velocity = carState->_velocity;
        b.angularVelocity = carState->_angularVelocity;
        [_world addBody:b];
    }
}

- (void)removeCity:(TRCity*)city {
    for(PGRigidBody* _ in city->_bodies) {
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
            [((TRTrain*)(train)) setDieCarStates:[[[((TRTrain*)(train))->_cars chain] mapOptF:^TRDieCarState*(TRCar* car) {
                PGRigidBody* b = [_world bodyForItem:car];
                if(b != nil) return [TRDieCarState dieCarStateWithCar:car matrix:((PGRigidBody*)(b)).matrix velocity:((PGRigidBody*)(b)).velocity angularVelocity:((PGRigidBody*)(b)).angularVelocity];
                else return nil;
            }] toArray]];
        }
        {
            id<CNIterator> __il__0t_3i = [[_world newCollisions] iterator];
            while([__il__0t_3i hasNext]) {
                PGDynamicCollision* collision = [__il__0t_3i next];
                {
                    if(((PGRigidBody*)(((PGDynamicCollision*)(collision))->_bodies->_a)).isKinematic && ((PGRigidBody*)(((PGDynamicCollision*)(collision))->_bodies->_b)).isKinematic) return ;
                    {
                        TRCar* _ = ((PGRigidBody*)(((PGDynamicCollision*)(collision))->_bodies->_a)).data;
                        if(_ != nil) [_level knockDownTrain:((TRCar*)(_))->_train];
                    }
                    {
                        TRCar* _ = ((PGRigidBody*)(((PGDynamicCollision*)(collision))->_bodies->_b)).data;
                        if(_ != nil) [_level knockDownTrain:((TRCar*)(_))->_train];
                    }
                    if([((PGDynamicCollision*)(collision)) impulse] > 0) {
                        if(((PGRigidBody*)(((PGDynamicCollision*)(collision))->_bodies->_a)).data == nil || ((PGRigidBody*)(((PGDynamicCollision*)(collision))->_bodies->_b)).data == nil) [_TRTrainsDynamicWorld_carAndGroundCollision postData:numf4([((PGDynamicCollision*)(collision)) impulse])];
                        else [_TRTrainsDynamicWorld_carsCollision postData:numf4([((PGDynamicCollision*)(collision)) impulse])];
                    }
                }
            }
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TrainsDynamicWorld(%@)", _level];
}

- (CNClassType*)type {
    return [TRTrainsDynamicWorld type];
}

+ (CNSignal*)carsCollision {
    return _TRTrainsDynamicWorld_carsCollision;
}

+ (CNSignal*)carAndGroundCollision {
    return _TRTrainsDynamicWorld_carAndGroundCollision;
}

+ (CNClassType*)type {
    return _TRTrainsDynamicWorld_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

