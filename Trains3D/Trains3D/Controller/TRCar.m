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

+ (id)engineTypeWithTubePos:(GEVec3)tubePos tubeSize:(CGFloat)tubeSize {
    return [[TREngineType alloc] initWithTubePos:tubePos tubeSize:tubeSize];
}

- (id)initWithTubePos:(GEVec3)tubePos tubeSize:(CGFloat)tubeSize {
    self = [super init];
    if(self) {
        _tubePos = tubePos;
        _tubeSize = tubeSize;
    }
    
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
    EGCollisionBody* _collisionBody;
    EGRigidBody* _kinematicBody;
    CNLazy* __lazy_dynamicBody;
    TRCarPosition __position;
}
static ODClassType* _TRCar_type;
@synthesize train = _train;
@synthesize carType = _carType;
@synthesize collisionBody = _collisionBody;
@synthesize kinematicBody = _kinematicBody;

+ (id)carWithTrain:(TRTrain*)train carType:(TRCarType*)carType {
    return [[TRCar alloc] initWithTrain:train carType:carType];
}

- (id)initWithTrain:(TRTrain*)train carType:(TRCarType*)carType {
    self = [super init];
    __weak TRCar* _weakSelf = self;
    if(self) {
        _train = train;
        _carType = carType;
        _collisionBody = [EGCollisionBody collisionBodyWithData:[CNWeak weakWithGet:self] shape:_carType.collision2dShape isKinematic:YES];
        _kinematicBody = [EGRigidBody kinematicData:[CNWeak weakWithGet:self] shape:_carType.collision2dShape];
        __lazy_dynamicBody = [CNLazy lazyWithF:^EGRigidBody*() {
            return ^EGRigidBody*() {
                GELine2 line = [_weakSelf position].line;
                float len = geVec2Length(line.u);
                GEVec2 vec = line.u;
                GEVec2 mid = [_weakSelf midPoint];
                EGRigidBody* b = [EGRigidBody dynamicData:[CNWeak weakWithGet:_weakSelf] shape:_weakSelf.carType.rigidShape mass:((float)(_weakSelf.carType.weight))];
                b.matrix = [[[GEMat4 identity] translateX:mid.x y:mid.y z:((float)(_weakSelf.carType.height / 2))] rotateAngle:geLine2DegreeAngle(line) x:0.0 y:0.0 z:1.0];
                GEVec3 rnd = GEVec3Make(((float)(odFloatRndMinMax(-0.1, 0.1))), ((float)(odFloatRndMinMax(-0.1, 0.1))), ((float)(odFloatRndMinMax(0.0, 5.0))));
                GEVec3 vel = geVec3AddVec3(geVec3ApplyVec2Z(geVec2MulF(vec, _weakSelf.train.speedFloat / len * 2), 0.0), rnd);
                b.velocity = (([_weakSelf.train isBack]) ? geVec3Negate(vel) : vel);
                b.angularVelocity = GEVec3Make(((float)(odFloatRndMinMax(-5.0, 5.0))), ((float)(odFloatRndMinMax(-5.0, 5.0))), ((float)(odFloatRndMinMax(-5.0, 5.0))));
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

- (TRCarPosition)position {
    return __position;
}

- (void)setPosition:(TRCarPosition)position {
    __position = position;
    GELine2 line = position.line;
    GEVec2 mid = [self midPoint];
    GEMat4* m = [[[GEMat4 identity] translateX:mid.x y:mid.y z:0.0] rotateAngle:geLine2DegreeAngle(line) x:0.0 y:0.0 z:1.0];
    [_collisionBody setMatrix:m];
    _kinematicBody.matrix = m;
}

- (GEVec2)midPoint {
    GELine2 line = [self position].line;
    if(eqf(_carType.wheelToBack, _carType.frontToWheel)) {
        return geVec2AddVec2(line.p0, geVec2DivI(line.u, 2));
    } else {
        GEVec2 u = geVec2SetLength(line.u, geVec2Length(line.u) - (_carType.wheelToBack - _carType.frontToWheel));
        return geVec2AddVec2(line.p0, geVec2DivI(u, 2));
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


NSString* TRCarPositionDescription(TRCarPosition self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRCarPosition: "];
    [description appendFormat:@"frontConnector=%@", TRRailPointDescription(self.frontConnector)];
    [description appendFormat:@", head=%@", TRRailPointDescription(self.head)];
    [description appendFormat:@", tail=%@", TRRailPointDescription(self.tail)];
    [description appendFormat:@", backConnector=%@", TRRailPointDescription(self.backConnector)];
    [description appendFormat:@", line=%@", GELine2Description(self.line)];
    [description appendString:@">"];
    return description;
}
TRCarPosition trCarPositionApplyFrontConnectorHeadTailBackConnector(TRRailPoint frontConnector, TRRailPoint head, TRRailPoint tail, TRRailPoint backConnector) {
    return TRCarPositionMake(frontConnector, head, tail, backConnector, geLine2ApplyP0P1(tail.point, head.point));
}
BOOL trCarPositionIsInTile(TRCarPosition self, GEVec2i tile) {
    return GEVec2iEq(self.head.tile, tile) || GEVec2iEq(self.tail.tile, tile);
}
BOOL trCarPositionIsOnRail(TRCarPosition self, TRRail* rail) {
    return (GEVec2iEq(self.head.tile, rail.tile) && self.head.form == rail.form) || (GEVec2iEq(self.tail.tile, rail.tile) && self.tail.form == rail.form);
}
ODPType* trCarPositionType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRCarPositionWrap class] name:@"TRCarPosition" size:sizeof(TRCarPosition) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRCarPosition, ((TRCarPosition*)(data))[i]);
    }];
    return _ret;
}
@implementation TRCarPositionWrap{
    TRCarPosition _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRCarPosition)value {
    return [[TRCarPositionWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRCarPosition)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRCarPositionDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRCarPositionWrap* o = ((TRCarPositionWrap*)(other));
    return TRCarPositionEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRCarPositionHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



