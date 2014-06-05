#import "TRCar.h"

#import "PGCollisionBody.h"
#import "TRTrain.h"
#import "PGMat4.h"
#import "TRRailroad.h"
@implementation TREngineType
static CNClassType* _TREngineType_type;
@synthesize tubePos = _tubePos;
@synthesize tubeSize = _tubeSize;

+ (instancetype)engineTypeWithTubePos:(PGVec3)tubePos tubeSize:(CGFloat)tubeSize {
    return [[TREngineType alloc] initWithTubePos:tubePos tubeSize:tubeSize];
}

- (instancetype)initWithTubePos:(PGVec3)tubePos tubeSize:(CGFloat)tubeSize {
    self = [super init];
    if(self) {
        _tubePos = tubePos;
        _tubeSize = tubeSize;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TREngineType class]) _TREngineType_type = [CNClassType classTypeWithCls:[TREngineType class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"EngineType(%@, %f)", pgVec3Description(_tubePos), _tubeSize];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TREngineType class]])) return NO;
    TREngineType* o = ((TREngineType*)(to));
    return pgVec3IsEqualTo(_tubePos, o->_tubePos) && eqf(_tubeSize, o->_tubeSize);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec3Hash(_tubePos);
    hash = hash * 31 + floatHash(_tubeSize);
    return hash;
}

- (CNClassType*)type {
    return [TREngineType type];
}

+ (CNClassType*)type {
    return _TREngineType_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

TRCarType* TRCarType_Values[5];
TRCarType* TRCarType_car_Desc;
TRCarType* TRCarType_engine_Desc;
TRCarType* TRCarType_expressCar_Desc;
TRCarType* TRCarType_expressEngine_Desc;
@implementation TRCarType{
    CGFloat _width;
    CGFloat _height;
    CGFloat _weight;
    CGFloat _startToFront;
    CGFloat _frontToWheel;
    CGFloat _betweenWheels;
    CGFloat _wheelToBack;
    CGFloat _backToEnd;
    TREngineType* _engineType;
    CGFloat _startToWheel;
    CGFloat _wheelToEnd;
    CGFloat _fullLength;
    id<PGCollisionShape> _collision2dShape;
    id<PGCollisionShape> _rigidShape;
}
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

+ (instancetype)carTypeWithOrdinal:(NSUInteger)ordinal name:(NSString*)name width:(CGFloat)width height:(CGFloat)height weight:(CGFloat)weight startToFront:(CGFloat)startToFront frontToWheel:(CGFloat)frontToWheel betweenWheels:(CGFloat)betweenWheels wheelToBack:(CGFloat)wheelToBack backToEnd:(CGFloat)backToEnd engineType:(TREngineType*)engineType {
    return [[TRCarType alloc] initWithOrdinal:ordinal name:name width:width height:height weight:weight startToFront:startToFront frontToWheel:frontToWheel betweenWheels:betweenWheels wheelToBack:wheelToBack backToEnd:backToEnd engineType:engineType];
}

- (instancetype)initWithOrdinal:(NSUInteger)ordinal name:(NSString*)name width:(CGFloat)width height:(CGFloat)height weight:(CGFloat)weight startToFront:(CGFloat)startToFront frontToWheel:(CGFloat)frontToWheel betweenWheels:(CGFloat)betweenWheels wheelToBack:(CGFloat)wheelToBack backToEnd:(CGFloat)backToEnd engineType:(TREngineType*)engineType {
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
        _startToWheel = startToFront + frontToWheel;
        _wheelToEnd = wheelToBack + backToEnd;
        _fullLength = _startToWheel + betweenWheels + _wheelToEnd;
        _collision2dShape = [PGCollisionBox2d applyX:((float)(frontToWheel + betweenWheels + wheelToBack)) y:((float)(width))];
        _rigidShape = [PGCollisionBox applyX:((float)(frontToWheel + betweenWheels + wheelToBack)) y:((float)(width)) z:((float)(height))];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    TRCarType_car_Desc = [TRCarType carTypeWithOrdinal:0 name:@"car" width:0.16 height:0.3 weight:1.0 startToFront:0.05 frontToWheel:0.06 betweenWheels:0.44 wheelToBack:0.06 backToEnd:0.05 engineType:nil];
    TRCarType_engine_Desc = [TRCarType carTypeWithOrdinal:1 name:@"engine" width:0.18 height:0.3 weight:2.0 startToFront:0.05 frontToWheel:0.14 betweenWheels:0.32 wheelToBack:0.22 backToEnd:0.05 engineType:[TREngineType engineTypeWithTubePos:PGVec3Make(-0.08, 0.0, 0.4) tubeSize:3.0]];
    TRCarType_expressCar_Desc = [TRCarType carTypeWithOrdinal:2 name:@"expressCar" width:0.16 height:0.3 weight:1.0 startToFront:0.05 frontToWheel:0.06 betweenWheels:0.44 wheelToBack:0.06 backToEnd:0.05 engineType:nil];
    TRCarType_expressEngine_Desc = [TRCarType carTypeWithOrdinal:3 name:@"expressEngine" width:0.18 height:0.3 weight:3.0 startToFront:0.05 frontToWheel:0.14 betweenWheels:0.32 wheelToBack:0.19 backToEnd:0.05 engineType:[TREngineType engineTypeWithTubePos:PGVec3Make(-0.03, 0.0, 0.35) tubeSize:1.0]];
    TRCarType_Values[0] = nil;
    TRCarType_Values[1] = TRCarType_car_Desc;
    TRCarType_Values[2] = TRCarType_engine_Desc;
    TRCarType_Values[3] = TRCarType_expressCar_Desc;
    TRCarType_Values[4] = TRCarType_expressEngine_Desc;
}

- (BOOL)isEngine {
    return _engineType != nil;
}

+ (NSArray*)values {
    return (@[TRCarType_car_Desc, TRCarType_engine_Desc, TRCarType_expressCar_Desc, TRCarType_expressEngine_Desc]);
}

+ (TRCarType*)value:(TRCarTypeR)r {
    return TRCarType_Values[r];
}

@end

@implementation TRCar
static CNClassType* _TRCar_type;
@synthesize train = _train;
@synthesize carType = _carType;
@synthesize number = _number;

+ (instancetype)carWithTrain:(TRTrain*)train carType:(TRCarTypeR)carType number:(NSUInteger)number {
    return [[TRCar alloc] initWithTrain:train carType:carType number:number];
}

- (instancetype)initWithTrain:(TRTrain*)train carType:(TRCarTypeR)carType number:(NSUInteger)number {
    self = [super init];
    if(self) {
        _train = train;
        _carType = carType;
        _number = number;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCar class]) _TRCar_type = [CNClassType classTypeWithCls:[TRCar class]];
}

- (BOOL)isEqualCar:(TRCar*)car {
    return self == car;
}

- (NSUInteger)hash {
    return ((NSUInteger)(self));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Car(%@, %@, %lu)", _train, [TRCarType value:_carType], (unsigned long)_number];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil) return NO;
    if([to isKindOfClass:[TRCar class]]) return [self isEqualCar:((TRCar*)(to))];
    return NO;
}

- (CNClassType*)type {
    return [TRCar type];
}

+ (CNClassType*)type {
    return _TRCar_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRCarState
static CNClassType* _TRCarState_type;
@synthesize car = _car;
@synthesize carType = _carType;

+ (instancetype)carStateWithCar:(TRCar*)car {
    return [[TRCarState alloc] initWithCar:car];
}

- (instancetype)initWithCar:(TRCar*)car {
    self = [super init];
    if(self) {
        _car = car;
        _carType = car->_carType;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRCarState class]) _TRCarState_type = [CNClassType classTypeWithCls:[TRCarState class]];
}

- (PGMat4*)matrix {
    @throw @"Method matrix is abstract";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CarState(%@)", _car];
}

- (CNClassType*)type {
    return [TRCarState type];
}

+ (CNClassType*)type {
    return _TRCarState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRDieCarState
static CNClassType* _TRDieCarState_type;
@synthesize matrix = _matrix;
@synthesize velocity = _velocity;
@synthesize angularVelocity = _angularVelocity;

+ (instancetype)dieCarStateWithCar:(TRCar*)car matrix:(PGMat4*)matrix velocity:(PGVec3)velocity angularVelocity:(PGVec3)angularVelocity {
    return [[TRDieCarState alloc] initWithCar:car matrix:matrix velocity:velocity angularVelocity:angularVelocity];
}

- (instancetype)initWithCar:(TRCar*)car matrix:(PGMat4*)matrix velocity:(PGVec3)velocity angularVelocity:(PGVec3)angularVelocity {
    self = [super initWithCar:car];
    if(self) {
        _matrix = matrix;
        _velocity = velocity;
        _angularVelocity = angularVelocity;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRDieCarState class]) _TRDieCarState_type = [CNClassType classTypeWithCls:[TRDieCarState class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"DieCarState(%@, %@, %@)", _matrix, pgVec3Description(_velocity), pgVec3Description(_angularVelocity)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRDieCarState class]])) return NO;
    TRDieCarState* o = ((TRDieCarState*)(to));
    return [_matrix isEqual:o->_matrix] && pgVec3IsEqualTo(_velocity, o->_velocity) && pgVec3IsEqualTo(_angularVelocity, o->_angularVelocity);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [_matrix hash];
    hash = hash * 31 + pgVec3Hash(_velocity);
    hash = hash * 31 + pgVec3Hash(_angularVelocity);
    return hash;
}

- (CNClassType*)type {
    return [TRDieCarState type];
}

+ (CNClassType*)type {
    return _TRDieCarState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRLiveCarState
static CNClassType* _TRLiveCarState_type;
@synthesize frontConnector = _frontConnector;
@synthesize head = _head;
@synthesize tail = _tail;
@synthesize backConnector = _backConnector;
@synthesize line = _line;
@synthesize midPoint = _midPoint;
@synthesize matrix = _matrix;

+ (instancetype)liveCarStateWithCar:(TRCar*)car frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector line:(PGLine2)line {
    return [[TRLiveCarState alloc] initWithCar:car frontConnector:frontConnector head:head tail:tail backConnector:backConnector line:line];
}

- (instancetype)initWithCar:(TRCar*)car frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector line:(PGLine2)line {
    self = [super initWithCar:car];
    if(self) {
        _frontConnector = frontConnector;
        _head = head;
        _tail = tail;
        _backConnector = backConnector;
        _line = line;
        _midPoint = ({
            PGLine2 line = _line;
            ((eqf([TRCarType value:self.carType].wheelToBack, [TRCarType value:self.carType].frontToWheel)) ? pgVec2AddVec2(line.p0, (pgVec2DivI(line.u, 2))) : ({
                PGVec2 u = pgVec2SetLength(line.u, pgVec2Length(line.u) - ([TRCarType value:self.carType].wheelToBack - [TRCarType value:self.carType].frontToWheel));
                pgVec2AddVec2(line.p0, (pgVec2DivI(u, 2)));
            }));
        });
        _matrix = [[[PGMat4 identity] translateX:_midPoint.x y:_midPoint.y z:0.0] rotateAngle:pgLine2DegreeAngle(line) x:0.0 y:0.0 z:1.0];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRLiveCarState class]) _TRLiveCarState_type = [CNClassType classTypeWithCls:[TRLiveCarState class]];
}

+ (TRLiveCarState*)applyCar:(TRCar*)car frontConnector:(TRRailPoint)frontConnector head:(TRRailPoint)head tail:(TRRailPoint)tail backConnector:(TRRailPoint)backConnector {
    return [TRLiveCarState liveCarStateWithCar:car frontConnector:frontConnector head:head tail:tail backConnector:backConnector line:pgLine2ApplyP0P1(tail.point, head.point)];
}

- (BOOL)isOnRail:(TRRail*)rail {
    return (pgVec2iIsEqualTo(_head.tile, rail->_tile) && _head.form == rail->_form) || (pgVec2iIsEqualTo(_tail.tile, rail->_tile) && _tail.form == rail->_form);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"LiveCarState(%@, %@, %@, %@, %@)", trRailPointDescription(_frontConnector), trRailPointDescription(_head), trRailPointDescription(_tail), trRailPointDescription(_backConnector), pgLine2Description(_line)];
}

- (BOOL)isEqual:(id)to {
    if(self == to) return YES;
    if(to == nil || !([to isKindOfClass:[TRLiveCarState class]])) return NO;
    TRLiveCarState* o = ((TRLiveCarState*)(to));
    return trRailPointIsEqualTo(_frontConnector, o->_frontConnector) && trRailPointIsEqualTo(_head, o->_head) && trRailPointIsEqualTo(_tail, o->_tail) && trRailPointIsEqualTo(_backConnector, o->_backConnector) && pgLine2IsEqualTo(_line, o->_line);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + trRailPointHash(_frontConnector);
    hash = hash * 31 + trRailPointHash(_head);
    hash = hash * 31 + trRailPointHash(_tail);
    hash = hash * 31 + trRailPointHash(_backConnector);
    hash = hash * 31 + pgLine2Hash(_line);
    return hash;
}

- (CNClassType*)type {
    return [TRLiveCarState type];
}

+ (CNClassType*)type {
    return _TRLiveCarState_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

