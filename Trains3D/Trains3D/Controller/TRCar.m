#import "TRCar.h"

#import "EGCollisionBody.h"
#import "TRTrain.h"
#import "EGDynamicWorld.h"
#import "GEFigure.h"
#import "GEMat4.h"
#import "TRRailPoint.h"
@implementation TREngineType{
    GEVec3 _tubePos;
}
static ODClassType* _TREngineType_type;
@synthesize tubePos = _tubePos;

+ (id)engineTypeWithTubePos:(GEVec3)tubePos {
    return [[TREngineType alloc] initWithTubePos:tubePos];
}

- (id)initWithTubePos:(GEVec3)tubePos {
    self = [super init];
    if(self) _tubePos = tubePos;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TREngineType_type = [ODClassType classTypeWithCls:[TREngineType class]];
}

- (ODClassType*)type {
    return [TREngineType type];
}

+ (ODClassType*)type {
    return _TREngineType_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TREngineType* o = ((TREngineType*)(other));
    return GEVec3Eq(self.tubePos, o.tubePos);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.tubePos);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tubePos=%@", GEVec3Description(self.tubePos)];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRCarType{
    CGFloat _width;
    CGFloat _height;
    CGFloat _weight;
    CGFloat _startToFront;
    CGFloat _frontToWheel;
    CGFloat _betweenWheels;
    CGFloat _wheelToBack;
    CGFloat _backToEnd;
    id _engineType;
    CGFloat _startToWheel;
    CGFloat _wheelToEnd;
    CGFloat _fullLength;
    id<EGCollisionShape> _collision2dShape;
    id<EGCollisionShape> _rigidShape;
}
static TRCarType* _TRCarType_car;
static TRCarType* _TRCarType_engine;
static NSArray* _TRCarType_values;
@synthesize width = _width;
@synthesize height = _height;
@synthesize weight = _weight;
@synthesize startToFront = _startToFront;
@synthesize frontToWheel = _frontToWheel;
@synthesize betweenWheels = _betweenWheels;
@synthesize wheelToBack = _wheelToBack;
@synthesize backToEnd = _backToEnd;
@synthesize engineType = _engineType;
@synthesize startToWheel = _startToWheel;
@synthesize wheelToEnd = _wheelToEnd;
@synthesize fullLength = _fullLength;
@synthesize collision2dShape = _collision2dShape;
@synthesize rigidShape = _rigidShape;

+ (id)carTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name width:(CGFloat)width height:(CGFloat)height weight:(CGFloat)weight startToFront:(CGFloat)startToFront frontToWheel:(CGFloat)frontToWheel betweenWheels:(CGFloat)betweenWheels wheelToBack:(CGFloat)wheelToBack backToEnd:(CGFloat)backToEnd engineType:(id)engineType {
    return [[TRCarType alloc] initWithOrdinal:ordinal name:name width:width height:height weight:weight startToFront:startToFront frontToWheel:frontToWheel betweenWheels:betweenWheels wheelToBack:wheelToBack backToEnd:backToEnd engineType:engineType];
}

- (id)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name width:(CGFloat)width height:(CGFloat)height weight:(CGFloat)weight startToFront:(CGFloat)startToFront frontToWheel:(CGFloat)frontToWheel betweenWheels:(CGFloat)betweenWheels wheelToBack:(CGFloat)wheelToBack backToEnd:(CGFloat)backToEnd engineType:(id)engineType {
    self = [super initWithOrdinal:ordinal name:name];
    if(self) {
        _width = width;
        _height = height;
        _weight = weight;
        _startToFront = startToFront;
        _frontToWheel = frontToWheel;
        _betweenWheels = betweenWheels;
        _wheelToBack = wheelToBack;
        _backToEnd = backToEnd;
        _engineType = engineType;
        _startToWheel = _startToFront + _frontToWheel;
        _wheelToEnd = _wheelToBack + _backToEnd;
        _fullLength = _startToWheel + _betweenWheels + _wheelToEnd;
        _collision2dShape = [EGCollisionBox2d applyX:((float)((_frontToWheel + _betweenWheels + _wheelToBack) / 2)) y:((float)(_width / 2))];
        _rigidShape = [EGCollisionBox applyX:((float)((_frontToWheel + _betweenWheels + _wheelToBack) / 2)) y:((float)(_width / 2)) z:((float)(_height / 2))];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCarType_car = [TRCarType carTypeWithOrdinal:0 name:@"car" width:0.18 height:0.3 weight:1.0 startToFront:0.05 frontToWheel:0.08 betweenWheels:0.44 wheelToBack:0.08 backToEnd:0.05 engineType:[CNOption none]];
    _TRCarType_engine = [TRCarType carTypeWithOrdinal:1 name:@"engine" width:0.2 height:0.3 weight:2.0 startToFront:0.05 frontToWheel:0.14 betweenWheels:0.32 wheelToBack:0.22 backToEnd:0.05 engineType:[CNOption opt:[TREngineType engineTypeWithTubePos:GEVec3Make(-0.10, 0.0, 0.5)]]];
    _TRCarType_values = (@[_TRCarType_car, _TRCarType_engine]);
}

- (BOOL)isEngine {
    return [_engineType isDefined];
}

+ (TRCarType*)car {
    return _TRCarType_car;
}

+ (TRCarType*)engine {
    return _TRCarType_engine;
}

+ (NSArray*)values {
    return _TRCarType_values;
}

@end


@implementation TRCar{
    __weak TRTrain* _train;
    TRCarType* _carType;
    EGCollisionBody* _collisionBody;
    CNLazy* __lazy_dynamicBody;
    TRCarPosition* __position;
}
static ODClassType* _TRCar_type;
@synthesize train = _train;
@synthesize carType = _carType;
@synthesize collisionBody = _collisionBody;

+ (id)carWithTrain:(TRTrain*)train carType:(TRCarType*)carType {
    return [[TRCar alloc] initWithTrain:train carType:carType];
}

- (id)initWithTrain:(TRTrain*)train carType:(TRCarType*)carType {
    self = [super init];
    __weak TRCar* _weakSelf = self;
    if(self) {
        _train = train;
        _carType = carType;
        _collisionBody = [EGCollisionBody collisionBodyWithData:self shape:_carType.collision2dShape isKinematic:YES];
        __lazy_dynamicBody = [CNLazy lazyWithF:^EGRigidBody*() {
            return ^EGRigidBody*() {
                GELineSegment* line = [_weakSelf position].line;
                CGFloat len = [line length];
                GEVec2 vec = [line vec];
                GEVec2 mid = [_weakSelf midPoint];
                EGRigidBody* b = [EGRigidBody dynamicData:self shape:_weakSelf.carType.rigidShape mass:((float)(_weakSelf.carType.weight))];
                b.matrix = [[[GEMat4 identity] translateX:mid.x y:mid.y z:((float)(_weakSelf.carType.height / 2))] rotateAngle:((float)([line degreeAngle])) x:0.0 y:0.0 z:1.0];
                GEVec3 rnd = GEVec3Make(((float)(randomFloatGap(-0.1, 0.1))), ((float)(randomFloatGap(-0.1, 0.1))), ((float)(randomFloatGap(0.0, 5.0))));
                GEVec3 vel = geVec3AddV(geVec3ApplyVec2Z(geVec2MulValue(vec, ((float)(_weakSelf.train.speedFloat / len * 2))), 0.0), rnd);
                b.velocity = (([_weakSelf.train isBack]) ? geVec3Negate(vel) : vel);
                b.angularVelocity = GEVec3Make(((float)(randomFloatGap(-5.0, 5.0))), ((float)(randomFloatGap(-5.0, 5.0))), ((float)(randomFloatGap(-5.0, 5.0))));
                return b;
            }();
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCar_type = [ODClassType classTypeWithCls:[TRCar class]];
}

- (EGRigidBody*)dynamicBody {
    return [__lazy_dynamicBody get];
}

- (TRCarPosition*)position {
    return __position;
}

- (void)setPosition:(TRCarPosition*)position {
    __position = position;
    GELineSegment* line = position.line;
    GEVec2 mid = [self midPoint];
    [_collisionBody setMatrix:[[[GEMat4 identity] translateX:mid.x y:mid.y z:0.0] rotateAngle:((float)([line degreeAngle])) x:0.0 y:0.0 z:1.0]];
}

- (GEVec2)midPoint {
    if(eqf(_carType.wheelToBack, _carType.frontToWheel)) {
        return [[self position].line mid];
    } else {
        GELineSegment* line = [self position].line;
        CGFloat len = [line length];
        GEVec2 vec = [line vec];
        GEVec2 dh = geVec2MulValue(vec, ((float)(_carType.frontToWheel / len)));
        GEVec2 dt = geVec2MulValue(vec, ((float)(_carType.wheelToBack / len)));
        return [[line moveWithPoint:geVec2MulValue(geVec2SubVec2(dh, dt), 0.5)] mid];
    }
}

- (ODClassType*)type {
    return [TRCar type];
}

+ (ODClassType*)type {
    return _TRCar_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCar* o = ((TRCar*)(other));
    return [self.train isEqual:o.train] && self.carType == o.carType;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.train hash];
    hash = hash * 31 + [self.carType ordinal];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendFormat:@", carType=%@", self.carType];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRCarPosition{
    TRRailPoint* _frontConnector;
    TRRailPoint* _head;
    TRRailPoint* _tail;
    TRRailPoint* _backConnector;
    GELineSegment* _line;
}
static ODClassType* _TRCarPosition_type;
@synthesize frontConnector = _frontConnector;
@synthesize head = _head;
@synthesize tail = _tail;
@synthesize backConnector = _backConnector;
@synthesize line = _line;

+ (id)carPositionWithFrontConnector:(TRRailPoint*)frontConnector head:(TRRailPoint*)head tail:(TRRailPoint*)tail backConnector:(TRRailPoint*)backConnector {
    return [[TRCarPosition alloc] initWithFrontConnector:frontConnector head:head tail:tail backConnector:backConnector];
}

- (id)initWithFrontConnector:(TRRailPoint*)frontConnector head:(TRRailPoint*)head tail:(TRRailPoint*)tail backConnector:(TRRailPoint*)backConnector {
    self = [super init];
    if(self) {
        _frontConnector = frontConnector;
        _head = head;
        _tail = tail;
        _backConnector = backConnector;
        _line = [GELineSegment lineSegmentWithP0:_tail.point p1:_head.point];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCarPosition_type = [ODClassType classTypeWithCls:[TRCarPosition class]];
}

- (ODClassType*)type {
    return [TRCarPosition type];
}

+ (ODClassType*)type {
    return _TRCarPosition_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCarPosition* o = ((TRCarPosition*)(other));
    return [self.frontConnector isEqual:o.frontConnector] && [self.head isEqual:o.head] && [self.tail isEqual:o.tail] && [self.backConnector isEqual:o.backConnector];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.frontConnector hash];
    hash = hash * 31 + [self.head hash];
    hash = hash * 31 + [self.tail hash];
    hash = hash * 31 + [self.backConnector hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"frontConnector=%@", self.frontConnector];
    [description appendFormat:@", head=%@", self.head];
    [description appendFormat:@", tail=%@", self.tail];
    [description appendFormat:@", backConnector=%@", self.backConnector];
    [description appendString:@">"];
    return description;
}

@end


