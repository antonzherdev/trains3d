#import "TRCollisions.h"

#import "EGMapIso.h"
#import "EGCollisionWorld.h"
#import "TRTrain.h"
#import "EGCollision.h"
#import "EGCollisionBody.h"
#import "TRLevel.h"
#import "EGDynamicWorld.h"
#import "TRTree.h"
#import "TRCity.h"
@implementation TRTrainsCollisionWorld{
    EGMapSso* _map;
    EGCollisionWorld* _world;
}
static ODClassType* _TRTrainsCollisionWorld_type;
@synthesize map = _map;

+ (id)trainsCollisionWorldWithMap:(EGMapSso*)map {
    return [[TRTrainsCollisionWorld alloc] initWithMap:map];
}

- (id)initWithMap:(EGMapSso*)map {
    self = [super init];
    if(self) {
        _map = map;
        _world = [EGCollisionWorld collisionWorld];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTrainsCollisionWorld class]) _TRTrainsCollisionWorld_type = [ODClassType classTypeWithCls:[TRTrainsCollisionWorld class]];
}

- (void)addTrain:(TRTrain*)train {
    [train.cars forEach:^void(TRCar* car) {
        [_world addBody:((TRCar*)(car)).collisionBody];
    }];
}

- (void)removeTrain:(TRTrain*)train {
    [train.cars forEach:^void(TRCar* car) {
        [_world removeBody:((TRCar*)(car)).collisionBody];
    }];
}

- (id<CNSeq>)detect {
    return [[[[_world detect] chain] flatMap:^id(EGCollision* collision) {
        if([((EGCollision*)(collision)).contacts allConfirm:^BOOL(EGContact* _) {
    return [self isOutOfMapContact:_];
}]) return [CNOption none];
        TRCar* car1 = ((CNWeak*)(((EGCollisionBody*)(((EGCollision*)(collision)).bodies.a)).data)).get;
        TRCar* car2 = ((CNWeak*)(((EGCollisionBody*)(((EGCollision*)(collision)).bodies.b)).data)).get;
        TRRailPoint point = uwrap(TRRailPoint, [[[[[[[(@[wrap(TRRailPoint, [car1 position].head), wrap(TRRailPoint, [car1 position].tail)]) chain] mul:(@[wrap(TRRailPoint, [car2 position].head), wrap(TRRailPoint, [car2 position].tail)])] sortBy] ascBy:^id(CNTuple* pair) {
            TRRailPoint x = uwrap(TRRailPoint, ((CNTuple*)(pair)).a);
            TRRailPoint y = uwrap(TRRailPoint, ((CNTuple*)(pair)).b);
            if(x.form == y.form && GEVec2iEq(x.tile, y.tile)) return numf(floatAbs(x.x - y.x));
            else return @1000;
        }] endSort] map:^id(CNTuple* _) {
            return ((CNTuple*)(_)).a;
        }] head]);
        return [CNOption someValue:[TRCarsCollision carsCollisionWithCars:[CNPair pairWithA:car1 b:car2] railPoint:point]];
    }] toArray];
}

- (BOOL)isOutOfMapContact:(EGContact*)contact {
    return geVec2Length([_map distanceToMapVec2:geVec3Xy(contact.a)]) > 0.5 && geVec2Length([_map distanceToMapVec2:geVec3Xy(contact.b)]) > 0.5;
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
    return [self.map isEqual:o.map];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.map hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"map=%@", self.map];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRCarsCollision{
    CNPair* _cars;
    TRRailPoint _railPoint;
}
static ODClassType* _TRCarsCollision_type;
@synthesize cars = _cars;
@synthesize railPoint = _railPoint;

+ (id)carsCollisionWithCars:(CNPair*)cars railPoint:(TRRailPoint)railPoint {
    return [[TRCarsCollision alloc] initWithCars:cars railPoint:railPoint];
}

- (id)initWithCars:(CNPair*)cars railPoint:(TRRailPoint)railPoint {
    self = [super init];
    if(self) {
        _cars = cars;
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
    return [self.cars isEqual:o.cars] && TRRailPointEq(self.railPoint, o.railPoint);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.cars hash];
    hash = hash * 31 + TRRailPointHash(self.railPoint);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"cars=%@", self.cars];
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

+ (id)trainsDynamicWorldWithLevel:(TRLevel*)level {
    return [[TRTrainsDynamicWorld alloc] initWithLevel:level];
}

- (id)initWithLevel:(TRLevel*)level {
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

- (void)addTrain:(TRTrain*)train {
    [train.cars forEach:^void(TRCar* car) {
        [_world addBody:((TRCar*)(car)).kinematicBody];
    }];
}

- (void)dieTrain:(TRTrain*)train {
    _workCounter++;
    [train.cars forEach:^void(TRCar* car) {
        [_world removeBody:((TRCar*)(car)).kinematicBody];
        [_world addBody:[((TRCar*)(car)) dynamicBody]];
    }];
}

- (void)removeTrain:(TRTrain*)train {
    if(train.isDying) _workCounter--;
    [train.cars forEach:^void(TRCar* car) {
        if(train.isDying) [_world removeBody:[((TRCar*)(car)) dynamicBody]];
        else [_world removeBody:((TRCar*)(car)).kinematicBody];
    }];
}

- (void)updateWithDelta:(CGFloat)delta {
    if(_workCounter > 0) {
        [_world updateWithDelta:delta];
        [[_world newCollisions] forEach:^void(EGDynamicCollision* collision) {
            if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic && ((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) return ;
            if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).isKinematic) {
                [_level knockDownTrain:((TRCar*)(((CNWeak*)(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.a)).data)).get)).train];
            } else {
                if(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).isKinematic) [_level knockDownTrain:((TRCar*)(((CNWeak*)(((EGRigidBody*)(((EGDynamicCollision*)(collision)).bodies.b)).data)).get)).train];
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


