#import "TRCollisions.h"

#import "EGCollisionWorld.h"
#import "TRTrain.h"
#import "TRCar.h"
#import "EGCollision.h"
#import "EGCollisionBody.h"
#import "TRRailPoint.h"
#import "EGDynamicWorld.h"
@implementation TRCollisionWorld{
    EGCollisionWorld* _world;
}
static ODClassType* _TRCollisionWorld_type;

+ (id)collisionWorld {
    return [[TRCollisionWorld alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _world = [EGCollisionWorld collisionWorld];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCollisionWorld_type = [ODClassType classTypeWithCls:[TRCollisionWorld class]];
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
    return [[[[_world detect] chain] map:^TRCollision*(EGCollision* collision) {
        TRCar* car1 = ((TRCar*)(((EGCollisionBody*)(collision.bodies.a)).data));
        TRCar* car2 = ((TRCar*)(((EGCollisionBody*)(collision.bodies.b)).data));
        TRRailPoint* point = ((TRRailPoint*)([[[[[[[[(@[[car1 position].head, [car1 position].tail]) chain] mul:(@[[car2 position].head, [car2 position].tail])] sortBy] ascBy:^id(CNTuple* pair) {
            TRRailPoint* x = ((TRRailPoint*)(pair.a));
            TRRailPoint* y = ((TRRailPoint*)(pair.b));
            if(x.form == y.form && EGVec2IEq(x.tile, y.tile)) return numf(fabs(x.x - y.x));
            else return @1000;
        }] endSort] map:^TRRailPoint*(CNTuple* _) {
            return ((TRRailPoint*)(_.a));
        }] head] get]));
        return [TRCollision collisionWithCars:[CNPair pairWithA:car1 b:car2] railPoint:point];
    }] toArray];
}

- (ODClassType*)type {
    return [TRCollisionWorld type];
}

+ (ODClassType*)type {
    return _TRCollisionWorld_type;
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


@implementation TRCollision{
    CNPair* _cars;
    TRRailPoint* _railPoint;
}
static ODClassType* _TRCollision_type;
@synthesize cars = _cars;
@synthesize railPoint = _railPoint;

+ (id)collisionWithCars:(CNPair*)cars railPoint:(TRRailPoint*)railPoint {
    return [[TRCollision alloc] initWithCars:cars railPoint:railPoint];
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
    _TRCollision_type = [ODClassType classTypeWithCls:[TRCollision class]];
}

- (ODClassType*)type {
    return [TRCollision type];
}

+ (ODClassType*)type {
    return _TRCollision_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCollision* o = ((TRCollision*)(other));
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


@implementation TRDynamicWorld{
    EGDynamicWorld* _world;
}
static ODClassType* _TRDynamicWorld_type;

+ (id)dynamicWorld {
    return [[TRDynamicWorld alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _world = ^EGDynamicWorld*() {
        EGDynamicWorld* w = [EGDynamicWorld dynamicWorldWithGravity:EGVec3Make(0.0, 0.0, -10.0)];
        EGRigidBody* plane = [EGRigidBody rigidBodyWithData:nil shape:[EGCollisionPlane collisionPlaneWithNormal:EGVec3Make(0.0, 0.0, 1.0) distance:0.0] isKinematic:NO mass:0.0];
        plane.friction = 0.3;
        [w addBody:plane];
        return w;
    }();
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRDynamicWorld_type = [ODClassType classTypeWithCls:[TRDynamicWorld class]];
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
    return [TRDynamicWorld type];
}

+ (ODClassType*)type {
    return _TRDynamicWorld_type;
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


