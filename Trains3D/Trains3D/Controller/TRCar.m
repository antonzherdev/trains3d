#import "TRCar.h"

#import "EGCollisionBody.h"
#import "TRTrain.h"
#import "EGDynamicWorld.h"
#import "GEMat4.h"
#import "TRRailroad.h"
@implementation TREngineType{
    GEVec3 _tubePos;
    CGFloat _tubeSize;
}
static ODClassType* _TREngineType_type;
@synthesize tubePos = _tubePos;
@synthesize tubeSize = _tubeSize;

+ (instancetype)engineTypeWithTubePos:(GEVec3)tubePos tubeSize:(CGFloat)tubeSize {
    return [[TREngineType alloc] initWithTubePos:tubePos tubeSize:tubeSize];
}

- (instancetype)initWithTubePos:(GEVec3)tubePos tubeSize:(CGFloat)tubeSize {
    self = [super init];
    if(self) {
        _tubePos = tubePos;
        _tubeSize = tubeSize;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TREngineType class]) _TREngineType_type = [ODClassType classTypeWithCls:[TREngineType class]];
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
    return GEVec3Eq(self.tubePos, o.tubePos) && eqf(self.tubeSize, o.tubeSize);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec3Hash(self.tubePos);
    hash = hash * 31 + floatHash(self.tubeSize);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"tubePos=%@", GEVec3Description(self.tubePos)];
    [description appendFormat:@", tubeSize=%f", self.tubeSize];
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
static TRCarType* _TRCarType_expressCar;
static TRCarType* _TRCarType_expressEngine;
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

+ (instancetype)carTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name width:(CGFloat)width height:(CGFloat)height weight:(CGFloat)weight startToFront:(CGFloat)startToFront frontToWheel:(CGFloat)frontToWheel betweenWheels:(CGFloat)betweenWheels wheelToBack:(CGFloat)wheelToBack backToEnd:(CGFloat)backToEnd engineType:(id)engineType {
    return [[TRCarType alloc] initWithOrdinal:ordinal name:name width:width height:height weight:weight startToFront:startToFront frontToWheel:frontToWheel betweenWheels:betweenWheels wheelToBack:wheelToBack backToEnd:backToEnd engineType:engineType];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name width:(CGFloat)width height:(CGFloat)height weight:(CGFloat)weight startToFront:(CGFloat)startToFront frontToWheel:(CGFloat)frontToWheel betweenWheels:(CGFloat)betweenWheels wheelToBack:(CGFloat)wheelToBack backToEnd:(CGFloat)backToEnd engineType:(id)engineType {
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
        _collision2dShape = [EGCollisionBox2d applyX:((float)(_frontToWheel + _betweenWheels + _wheelToBack)) y:((float)(_width))];
        _rigidShape = [EGCollisionBox applyX:((float)(_frontToWheel + _betweenWheels + _wheelToBack)) y:((float)(_width)) z:((float)(_height))];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRCarType_car = [TRCarType carTypeWithOrdinal:0 name:@"car" width:0.16 height:0.3 weight:1.0 startToFront:0.05 frontToWheel:0.06 betweenWheels:0.44 wheelToBack:0.06 backToEnd:0.05 engineType:[CNOption none]];
    _TRCarType_engine = [TRCarType carTypeWithOrdinal:1 name:@"engine" width:0.18 height:0.3 weight:2.0 startToFront:0.05 frontToWheel:0.14 betweenWheels:0.32 wheelToBack:0.22 backToEnd:0.05 engineType:[CNOption applyValue:[TREngineType engineTypeWithTubePos:GEVec3Make(-0.06, 0.0, 0.4) tubeSize:3.0]]];
    _TRCarType_expressCar = [TRCarType carTypeWithOrdinal:2 name:@"expressCar" width:0.16 height:0.3 weight:1.0 startToFront:0.05 frontToWheel:0.06 betweenWheels:0.44 wheelToBack:0.06 backToEnd:0.05 engineType:[CNOption none]];
    _TRCarType_expressEngine = [TRCarType carTypeWithOrdinal:3 name:@"expressEngine" width:0.18 height:0.3 weight:3.0 startToFront:0.05 frontToWheel:0.14 betweenWheels:0.32 wheelToBack:0.19 backToEnd:0.05 engineType:[CNOption applyValue:[TREngineType engineTypeWithTubePos:GEVec3Make(-0.03, 0.0, 0.35) tubeSize:1.0]]];
    _TRCarType_values = (@[_TRCarType_car, _TRCarType_engine, _TRCarType_expressCar, _TRCarType_expressEngine]);
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

+ (TRCarType*)expressCar {
    return _TRCarType_expressCar;
}

+ (TRCarType*)expressEngine {
    return _TRCarType_expressEngine;
}

+ (NSArray*)values {
    return _TRCarType_values;
}

@end


@implementation TRCar{
    __weak TRTrain* _train;
    TRCarType* _carType;
    EGRigidBody* _kinematicBody;
    CNLazy* __lazy_dynamicBody;
    TRCarPosition* __position;
    GEMat4* __matrix;
}
static ODClassType* _TRCar_type;
@synthesize train = _train;
@synthesize carType = _carType;
@synthesize kinematicBody = _kinematicBody;
@synthesize _position = __position;

+ (instancetype)carWithTrain:(TRTrain*)train carType:(TRCarType*)carType {
    return [[TRCar alloc] initWithTrain:train carType:carType];
}

- (instancetype)initWithTrain:(TRTrain*)train carType:(TRCarType*)carType {
    self = [super init];
    __weak TRCar* _weakSelf = self;
    if(self) {
        _train = train;
        _carType = carType;
        _kinematicBody = [EGRigidBody kinematicData:[CNWeak weakWithGet:self] shape:_carType.collision2dShape];
        __lazy_dynamicBody = [CNLazy lazyWithF:^EGRigidBody*() {
            return ^EGRigidBody*() {
                GELine2 line = [_weakSelf position].line;
                float len = geVec2Length(line.u);
                GEVec2 vec = line.u;
                GEVec2 mid = _weakSelf._position.midPoint;
                EGRigidBody* b = [EGRigidBody dynamicData:[CNWeak weakWithGet:_weakSelf] shape:_weakSelf.carType.rigidShape mass:((float)(_weakSelf.carType.weight))];
                b.matrix = [[[GEMat4 identity] translateX:mid.x y:mid.y z:((float)(_weakSelf.carType.height / 2))] rotateAngle:geLine2DegreeAngle(line) x:0.0 y:0.0 z:1.0];
                GEVec3 rnd = GEVec3Make((((float)(odFloatRndMinMax(-0.1, 0.1)))), (((float)(odFloatRndMinMax(-0.1, 0.1)))), (((float)(odFloatRndMinMax(0.0, 5.0)))));
                GEVec3 vel = geVec3AddVec3((geVec3ApplyVec2Z((geVec2MulF(vec, _weakSelf.train.speedFloat / len * 2)), 0.0)), rnd);
                b.velocity = (([_weakSelf.train isBack]) ? geVec3Negate(vel) : vel);
                b.angularVelocity = GEVec3Make((((float)(odFloatRndMinMax(-5.0, 5.0)))), (((float)(odFloatRndMinMax(-5.0, 5.0)))), (((float)(odFloatRndMinMax(-5.0, 5.0)))));
                return b;
            }();
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCar class]) _TRCar_type = [ODClassType classTypeWithCls:[TRCar class]];
}

- (EGRigidBody*)dynamicBody {
    return [__lazy_dynamicBody get];
}

- (TRCarPosition*)position {
    return __position;
}

- (void)setPosition:(TRCarPosition*)position {
    __position = position;
}

- (void)writeKinematicMatrix {
    _kinematicBody.matrix = __position.matrix;
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
    TRCarType* _carType;
    TRRailPoint _frontConnector;
    TRRailPoint _head;
    TRRailPoint _tail;
    TRRailPoint _backConnector;
    GELine2 _line;
    GEVec2 _midPoint;
    GEMat4* _matrix;
}
static ODClassType* _TRCarPosition_type;
@synthesize carType = _carType;
@synthesize frontConnector = _frontConnector;
@synthesize head = _head;
@synthesize tail = _tail;
@synthesize backConnector = _backConnector;
@synthesize line = _line;
@synthesize midPoint = _midPoint;
@synthesize matrix = _matrix;

+ (instancetype)carPositionWithCarType:(TRCarType*)carType frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector line:(GELine2)line {
    return [[TRCarPosition alloc] initWithCarType:carType frontConnector:frontConnector head:head tail:tail backConnector:backConnector line:line];
}

- (instancetype)initWithCarType:(TRCarType*)carType frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector line:(GELine2)line {
    self = [super init];
    if(self) {
        _carType = carType;
        _frontConnector = frontConnector;
        _head = head;
        _tail = tail;
        _backConnector = backConnector;
        _line = line;
        _midPoint = ^GEVec2() {
            GELine2 line = _line;
            if(eqf(_carType.wheelToBack, _carType.frontToWheel)) {
                return geVec2AddVec2(line.p0, (geVec2DivI(line.u, 2)));
            } else {
                GEVec2 u = geVec2SetLength(line.u, geVec2Length(line.u) - (_carType.wheelToBack - _carType.frontToWheel));
                return geVec2AddVec2(line.p0, (geVec2DivI(u, 2)));
            }
        }();
        _matrix = [[[GEMat4 identity] translateX:_midPoint.x y:_midPoint.y z:0.0] rotateAngle:geLine2DegreeAngle(_line) x:0.0 y:0.0 z:1.0];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCarPosition class]) _TRCarPosition_type = [ODClassType classTypeWithCls:[TRCarPosition class]];
}

+ (TRCarPosition*)applyCarType:(TRCarType*)carType frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector {
    return [TRCarPosition carPositionWithCarType:carType frontConnector:frontConnector head:head tail:tail backConnector:backConnector line:geLine2ApplyP0P1(tail.point, head.point)];
}

- (BOOL)isOnRail:(TRRail*)rail {
    return (GEVec2iEq(_head.tile, rail.tile) && _head.form == rail.form) || (GEVec2iEq(_tail.tile, rail.tile) && _tail.form == rail.form);
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
    return self.carType == o.carType && TRRailPointEq(self.frontConnector, o.frontConnector) && TRRailPointEq(self.head, o.head) && TRRailPointEq(self.tail, o.tail) && TRRailPointEq(self.backConnector, o.backConnector) && GELine2Eq(self.line, o.line);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.carType ordinal];
    hash = hash * 31 + TRRailPointHash(self.frontConnector);
    hash = hash * 31 + TRRailPointHash(self.head);
    hash = hash * 31 + TRRailPointHash(self.tail);
    hash = hash * 31 + TRRailPointHash(self.backConnector);
    hash = hash * 31 + GELine2Hash(self.line);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"carType=%@", self.carType];
    [description appendFormat:@", frontConnector=%@", TRRailPointDescription(self.frontConnector)];
    [description appendFormat:@", head=%@", TRRailPointDescription(self.head)];
    [description appendFormat:@", tail=%@", TRRailPointDescription(self.tail)];
    [description appendFormat:@", backConnector=%@", TRRailPointDescription(self.backConnector)];
    [description appendFormat:@", line=%@", GELine2Description(self.line)];
    [description appendString:@">"];
    return description;
}

@end


