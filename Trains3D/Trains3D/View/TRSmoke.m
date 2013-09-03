#import "TRSmoke.h"

#import "CNData.h"
#import "EG.h"
#import "EGBuffer.h"
#import "EGShader.h"
#import "EGContext.h"
#import "EGTexture.h"
#import "EGMatrix.h"
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
    EGPoint fPos = (([_train isBack]) ? _engine.backConnector.point : _engine.frontConnector.point);
    EGPoint bPos = (([_train isBack]) ? _engine.frontConnector.point : _engine.backConnector.point);
    EGPoint delta = egPointSub(bPos, fPos);
    EGPoint tubeXY = egPointAdd(fPos, egPointSet(delta, ((CGFloat)(_tubePos.x))));
    EGVec3 emitterPos = egVec3Apply(tubeXY, _tubePos.z);
    TRSmokeParticle* p = [TRSmokeParticle smokeParticle];
    p.position = emitterPos;
    p.speed = egVec3Apply(egPointSet((([_train isBack]) ? egPointSub(fPos, bPos) : delta), _train.speedFloat), ((float)(_TRSmoke_zSpeed)));
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


ODPType* trSmokeBufferDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRSmokeBufferDataWrap class] name:@"TRSmokeBufferData" size:sizeof(TRSmokeBufferData) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRSmokeBufferData, ((TRSmokeBufferData*)(data))[i]);
    }];
    return _ret;
}
@implementation TRSmokeBufferDataWrap{
    TRSmokeBufferData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRSmokeBufferData)value {
    return [[TRSmokeBufferDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRSmokeBufferData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRSmokeBufferDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSmokeBufferDataWrap* o = ((TRSmokeBufferDataWrap*)(other));
    return TRSmokeBufferDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRSmokeBufferDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation TRSmokeView{
    EGVertexBuffer* _positionBuffer;
    EGIndexBuffer* _indexBuffer;
    TRSmokeShader* _shader;
    EGTexture* _texture;
}
static ODClassType* _TRSmokeView_type;
@synthesize positionBuffer = _positionBuffer;
@synthesize indexBuffer = _indexBuffer;
@synthesize shader = _shader;
@synthesize texture = _texture;

+ (id)smokeView {
    return [[TRSmokeView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _positionBuffer = [EGVertexBuffer applyStride:((NSUInteger)(3 * 4))];
        _indexBuffer = [EGIndexBuffer apply];
        _shader = TRSmokeShader.instance;
        _texture = [EG textureForFile:@"Smoke.png"];
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
    CNMutablePArray* positionArr = [CNMutablePArray applyTp:trSmokeBufferDataType() count:((NSUInteger)(6 * n))];
    CNMutablePArray* indexArr = [CNMutablePArray applyTp:oduInt4Type() count:((NSUInteger)(6 * n))];
    __block NSUInteger i = 0;
    [particles forEach:^void(TRSmokeParticle* p) {
        EGVec3 v = p.position;
        [positionArr writeItem:voidRef(TRSmokeBufferDataMake(v.x, v.y, v.z, 0.0, 0.0))];
        [positionArr writeItem:voidRef(TRSmokeBufferDataMake(v.x, v.y, v.z, 1.0, 0.0))];
        [positionArr writeItem:voidRef(TRSmokeBufferDataMake(v.x, v.y, v.z, 1.0, 1.0))];
        [positionArr writeItem:voidRef(TRSmokeBufferDataMake(v.x, v.y, v.z, 0.0, 1.0))];
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
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ZERO, GL_ONE_MINUS_SRC_ALPHA);
    [_shader applyTexture:_texture positionBuffer:_positionBuffer draw:^void() {
        [_indexBuffer draw];
    }];
    glDisable(GL_BLEND);
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
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
    EGShaderAttribute* _uvSlot;
    EGMatrix* _m;
    EGShaderUniform* _wcpUniform;
    EGShaderUniform* _mUniform;
}
static NSString* _TRSmokeShader_vertex = @"attribute vec3 position;\n"
    "attribute vec2 vertexUV;\n"
    "uniform mat4 m;\n"
    "uniform mat4 wcp;\n"
    "\n"
    "varying vec2 UV;\n"
    "\n"
    "void main(void) {\n"
    "   vec4 model = m * vec4(0.2*vertexUV.x - 0.1, 0.2*vertexUV.y - 0.1, 0, 1);\n"
    "   gl_Position = wcp * (vec4(position, 0) + model);\n"
    "   UV = vertexUV;\n"
    "}";
static NSString* _TRSmokeShader_fragment = @"varying vec2 UV;\n"
    "\n"
    "uniform sampler2D texture;\n"
    "\n"
    "void main(void) {\n"
    "   gl_FragColor = texture2D(texture, UV);\n"
    "}";
static TRSmokeShader* _TRSmokeShader_instance;
static ODClassType* _TRSmokeShader_type;
@synthesize program = _program;
@synthesize positionSlot = _positionSlot;
@synthesize uvSlot = _uvSlot;
@synthesize m = _m;
@synthesize wcpUniform = _wcpUniform;
@synthesize mUniform = _mUniform;

+ (id)smokeShader {
    return [[TRSmokeShader alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _program = [EGShaderProgram applyVertex:_TRSmokeShader_vertex fragment:_TRSmokeShader_fragment];
        _positionSlot = [_program attributeForName:@"position"];
        _uvSlot = [_program attributeForName:@"vertexUV"];
        _m = [[[EGMatrix identity] rotateAngle:60.0 x:1.0 y:0.0 z:0.0] rotateAngle:45.0 x:0.0 y:1.0 z:0.0];
        _wcpUniform = [_program uniformForName:@"wcp"];
        _mUniform = [_program uniformForName:@"m"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRSmokeShader_type = [ODClassType classTypeWithCls:[TRSmokeShader class]];
    _TRSmokeShader_instance = [TRSmokeShader smokeShader];
}

- (void)applyTexture:(EGTexture*)texture positionBuffer:(EGVertexBuffer*)positionBuffer draw:(void(^)())draw {
    [_program applyDraw:^void() {
        [texture applyDraw:^void() {
            [positionBuffer applyDraw:^void() {
                [_positionSlot setFromBufferWithStride:((NSUInteger)(5 * 4)) valuesCount:3 valuesType:GL_FLOAT shift:0];
                [_uvSlot setFromBufferWithStride:((NSUInteger)(5 * 4)) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(3 * 4))];
                [_wcpUniform setMatrix:[[EG context] wcp]];
                [_mUniform setMatrix:_m];
                ((void(^)())(draw))();
            }];
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


