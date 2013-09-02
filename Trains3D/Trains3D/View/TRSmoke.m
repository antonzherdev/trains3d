#import "TRSmoke.h"

#import "CNData.h"
#import "EG.h"
#import "EGBuffer.h"
#import "EGShader.h"
#import "EGContext.h"
#import "TRTrain.h"
#import "TRRailPoint.h"
@implementation TRSmoke{
    __weak TRTrain* _train;
    CNList* __particles;
    TRCar* _engine;
    EGVec3 _tubePos;
    CGFloat _emitTime;
}
static CGFloat _TRSmoke_zSpeed = 0.1;
static CGFloat _TRSmoke_emitEvery = 0.1;
static ODClassType* _TRSmoke_type;
@synthesize train = _train;

+ (id)smokeWithTrain:(TRTrain*)train {
    return [[TRSmoke alloc] initWithTrain:train];
}

- (id)initWithTrain:(TRTrain*)train {
    self = [super init];
    if(self) {
        _train = train;
        __particles = [CNList apply];
        _engine = ((TRCar*)([[_train.cars head] get]));
        _tubePos = ((TREngineType*)([_engine.carType.engineType get])).tubePos;
        _emitTime = 0.0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmoke_type = [ODClassType classTypeWithCls:[TRSmoke class]];
}

- (CNList*)particles {
    return __particles;
}

- (void)updateWithDelta:(CGFloat)delta {
    _emitTime += delta;
    if(_emitTime > _TRSmoke_emitEvery) {
        _emitTime -= _TRSmoke_emitEvery;
        [self createParticle];
    }
    __particles = [__particles filterF:^BOOL(TRSmokeParticle* _) {
        return [_ isLive];
    }];
    [__particles forEach:^void(TRSmokeParticle* _) {
        [_ updateWithDelta:delta];
    }];
}

- (void)createParticle {
    EGPoint fPos = _engine.frontConnector.point;
    EGPoint bPos = _engine.backConnector.point;
    EGPoint delta = egPointSub(bPos, fPos);
    EGPoint tubeXY = egPointAdd(fPos, egPointSet(delta, ((CGFloat)(_tubePos.x))));
    EGVec3 emitterPos = egVec3Apply(tubeXY, _tubePos.z);
    TRSmokeParticle* p = [TRSmokeParticle smokeParticle];
    p.position = emitterPos;
    p.speed = egVec3Apply(egPointSet(delta, _train.speedFloat), ((float)(_TRSmoke_zSpeed)));
    __particles = [CNList applyObject:p tail:__particles];
}

- (ODClassType*)type {
    return [TRSmoke type];
}

+ (ODClassType*)type {
    return _TRSmoke_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSmoke* o = ((TRSmoke*)(other));
    return [self.train isEqual:o.train];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.train hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"train=%@", self.train];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSmokeParticle{
    EGVec3 _position;
    EGVec3 _speed;
    CGFloat _time;
}
static NSInteger _TRSmokeParticle_lifeTime = 10;
static CGFloat _TRSmokeParticle_dragCoefficient = 0.1;
static ODClassType* _TRSmokeParticle_type;
@synthesize position = _position;
@synthesize speed = _speed;
@synthesize time = _time;

+ (id)smokeParticle {
    return [[TRSmokeParticle alloc] init];
}

- (id)init {
    self = [super init];
    if(self) _time = 0.0;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeParticle_type = [ODClassType classTypeWithCls:[TRSmokeParticle class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    EGVec3 a = egVec3Mul(egVec3Sqr(_speed), ((float)(-_TRSmokeParticle_dragCoefficient)));
    _speed = egVec3Add(_speed, egVec3Mul(a, ((float)(delta))));
    _position = egVec3Add(_position, egVec3Mul(_speed, ((float)(delta))));
    _time += delta;
}

- (BOOL)isLive {
    return _time < _TRSmokeParticle_lifeTime;
}

- (ODClassType*)type {
    return [TRSmokeParticle type];
}

+ (NSInteger)lifeTime {
    return _TRSmokeParticle_lifeTime;
}

+ (CGFloat)dragCoefficient {
    return _TRSmokeParticle_dragCoefficient;
}

+ (ODClassType*)type {
    return _TRSmokeParticle_type;
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


@implementation TRSmokeView{
    EGVertexBuffer* _positionBuffer;
    EGIndexBuffer* _indexBuffer;
    TRSmokeShader* _shader;
}
static ODClassType* _TRSmokeView_type;
@synthesize positionBuffer = _positionBuffer;
@synthesize indexBuffer = _indexBuffer;
@synthesize shader = _shader;

+ (id)smokeView {
    return [[TRSmokeView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _positionBuffer = [EGVertexBuffer applyStride:((NSUInteger)(3 * 4))];
        _indexBuffer = [EGIndexBuffer apply];
        _shader = TRSmokeShader.instance;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeView_type = [ODClassType classTypeWithCls:[TRSmokeView class]];
}

- (void)drawSmoke:(TRSmoke*)smoke {
    CNList* particles = [smoke particles];
    NSUInteger n = [particles count];
    if(n == 0) return ;
    CNMutablePArray* positionArr = [CNMutablePArray applyTp:egVec3Type() count:((NSUInteger)(4 * n))];
    CNMutablePArray* indexArr = [CNMutablePArray applyTp:oduInt4Type() count:((NSUInteger)(6 * n))];
    __block NSUInteger i = 0;
    [particles forEach:^void(TRSmokeParticle* p) {
        EGVec3 v = p.position;
        [positionArr writeItem:voidRef(EGVec3Make(v.x - 0.1, v.y - 0.1, v.z))];
        [positionArr writeItem:voidRef(EGVec3Make(v.x + 0.1, v.y - 0.1, v.z))];
        [positionArr writeItem:voidRef(EGVec3Make(v.x + 0.1, v.y + 0.1, v.z))];
        [positionArr writeItem:voidRef(EGVec3Make(v.x - 0.1, v.y + 0.1, v.z))];
        [indexArr writeUInt4:((unsigned int)(i))];
        [indexArr writeUInt4:((unsigned int)(i + 1))];
        [indexArr writeUInt4:((unsigned int)(i + 2))];
        [indexArr writeUInt4:((unsigned int)(i + 2))];
        [indexArr writeUInt4:((unsigned int)(i + 3))];
        [indexArr writeUInt4:((unsigned int)(i))];
        i += 4;
    }];
    [_positionBuffer setData:positionArr];
    [_indexBuffer setData:indexArr];
    [_shader applyPositionBuffer:_positionBuffer draw:^void() {
        [_indexBuffer draw];
    }];
}

- (ODClassType*)type {
    return [TRSmokeView type];
}

+ (ODClassType*)type {
    return _TRSmokeView_type;
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


@implementation TRSmokeShader{
    EGShaderProgram* _program;
    EGShaderAttribute* _positionSlot;
    EGShaderUniform* _wcpUniform;
}
static NSString* _TRSmokeShader_vertex = @"attribute vec3 position;\n"
    "uniform mat4 wcp;\n"
    "\n"
    "void main(void) {\n"
    "   gl_Position = wcp * vec4(position, 1);\n"
    "}";
static NSString* _TRSmokeShader_fragment = @"void main(void) {\n"
    "   gl_FragColor = vec4(1, 0, 0, 0.5);\n"
    "}";
static TRSmokeShader* _TRSmokeShader_instance;
static ODClassType* _TRSmokeShader_type;
@synthesize program = _program;
@synthesize positionSlot = _positionSlot;
@synthesize wcpUniform = _wcpUniform;

+ (id)smokeShader {
    return [[TRSmokeShader alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _program = [EGShaderProgram applyVertex:_TRSmokeShader_vertex fragment:_TRSmokeShader_fragment];
        _positionSlot = [_program attributeForName:@"position"];
        _wcpUniform = [_program uniformForName:@"wcp"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeShader_type = [ODClassType classTypeWithCls:[TRSmokeShader class]];
    _TRSmokeShader_instance = [TRSmokeShader smokeShader];
}

- (void)applyPositionBuffer:(EGVertexBuffer*)positionBuffer draw:(void(^)())draw {
    [_program applyDraw:^void() {
        [positionBuffer applyDraw:^void() {
            [_positionSlot setFromBufferWithStride:((NSUInteger)(3 * 4)) valuesCount:3 valuesType:GL_FLOAT shift:0];
            [_wcpUniform setMatrix:[[EG context] wcp]];
            ((void(^)())(draw))();
        }];
    }];
}

- (ODClassType*)type {
    return [TRSmokeShader type];
}

+ (NSString*)vertex {
    return _TRSmokeShader_vertex;
}

+ (NSString*)fragment {
    return _TRSmokeShader_fragment;
}

+ (TRSmokeShader*)instance {
    return _TRSmokeShader_instance;
}

+ (ODClassType*)type {
    return _TRSmokeShader_type;
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


