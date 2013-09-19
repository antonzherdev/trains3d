#import "TRCollisions.h"

#import "EGCollisionWorld.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "EGCollision.h"
#import "EGCollisionBody.h"
#import "TRRailPoint.h"
#import "EGDynamicWorld.h"
@implementation TRTrainsCollisionWorld{
    EGCollisionWorld* _world;
}
static ODClassType* _TRTrainsCollisionWorld_type;

+ (id)trainsCollisionWorld {
    return [[TRTrainsCollisionWorld alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _world = [EGCollisionWorld collisionWorld];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainsCollisionWorld_type = [ODClassType classTypeWithCls:[TRTrainsCollisionWorld class]];
}

- (void)addTrain:(TRTrain*)train {
    [[train cars] forEach:^void(TRCar* car) {
        [_world addBody:car.collisionBody];
    }];
}

- (void)removeTrain:(TRTrain*)train {
    [[train cars] forEach:^void(TRCar* car) {
        [_world removeBody:car.collisionBody];
    }];
}

- (id<CNSeq>)detect {
    return [[[[_world detect] chain] map:^TRCarsCollision*(EGCollision* collision) {
        TRCar* car1 = ((TRCar*)(((EGCollisionBody*)(collision.bodies.a)).data));
        TRCar* car2 = ((TRCar*)(((EGCollisionBody*)(collision.bodies.b)).data));
        TRRailPoint* point = ((TRRailPoint*)([[[[[[[[(@[[car1 position].head, [car1 position].tail]) chain] mul:(@[[car2 position].head, [car2 position].tail])] sortBy] ascBy:^id(CNTuple* pair) {
            TRRailPoint* x = ((TRRailPoint*)(pair.a));
            TRRailPoint* y = ((TRRailPoint*)(pair.b));
            if(x.form == y.form && GEVec2iEq(x.tile, y.tile)) return numf(fabs(x.x - y.x));
            else return @1000;
        }] endSort] map:^TRRailPoint*(CNTuple* _) {
            return ((TRRailPoint*)(_.a));
        }] head] get]));
        return [TRCarsCollision carsCollisionWithCars:[CNPair pairWithA:car1 b:car2] railPoint:point];
    }] toArray];
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


@implementation TRCarsCollision{
    CNPair* _cars;
    TRRailPoint* _railPoint;
}
static ODClassType* _TRCarsCollision_type;
@synthesize cars = _cars;
@synthesize railPoint = _railPoint;

+ (id)carsCollisionWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint {
    return [[TRCarsCollision alloc] initWithCars:cars railPoint:railPoint];
}

- (id)initWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint {
    self = [super init];
    if(self) {
        _cars = cars;
        _railPoint = railPoint;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCarsCollision_type = [ODClassType classTypeWithCls:[TRCarsCollision class]];
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
    return [self.cars isEqual:o.cars] && [self.railPoint isEqual:o.railPoint];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.cars hash];
    hash = hash * 31 + [self.railPoint hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"cars=%@", self.cars];
    [description appendFormat:@", railPoint=%@", self.railPoint];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTrainsDynamicWorld{
    EGDynamicWorld* _world;
}
static ODClassType* _TRTrainsDynamicWorld_type;

+ (id)trainsDynamicWorld {
    return [[TRTrainsDynamicWorld alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _world = ^EGDynamicWorld*() {
        EGDynamicWorld* w = [EGDynamicWorld dynamicWorldWithGravity:GEVec3Make(0.0, 0.0, -10.0)];
        EGRigidBody* plane = [EGRigidBody rigidBodyWithData:nil shape:[EGCollisionPlane collisionPlaneWithNormal:GEVec3Make(0.0, 0.0, 1.0) distance:0.0] isKinematic:NO mass:0.0];
        plane.friction = 0.4;
        [w addBody:plane];
        return w;
    }();
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTrainsDynamicWorld_type = [ODClassType classTypeWithCls:[TRTrainsDynamicWorld class]];
}

- (void)addTrain:(TRTrain*)train {
}

- (void)dieTrain:(TRTrain*)train {
    [[train cars] forEach:^void(TRCar* car) {
        [_world addBody:[car dynamicBody]];
    }];
}

- (void)removeTrain:(TRTrain*)train {
    [[train cars] forEach:^void(TRCar* car) {
        [_world removeBody:[car dynamicBody]];
    }];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_world updateWithDelta:delta];
}

- (ODClassType*)type {
    return [TRTrainsDynamicWorld type];
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


