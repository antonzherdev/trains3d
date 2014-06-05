#import "TRSnowView.h"

#import "TRWeather.h"
#import "PGContext.h"
#import "PGMaterial.h"
#import "PGVertex.h"
#import "GL.h"
@implementation TRSnowView
static CNClassType* _TRSnowView_type;
@synthesize weather = _weather;
@synthesize strength = _strength;
@synthesize system = _system;
@synthesize view = _view;

+ (instancetype)snowViewWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    return [[TRSnowView alloc] initWithWeather:weather strength:strength];
}

- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    self = [super init];
    if(self) {
        _weather = weather;
        _strength = strength;
        _system = [TRSnowParticleSystem snowParticleSystemWithWeather:weather strength:strength];
        _view = [TRSnowSystemView snowSystemViewWithSystem:_system];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowView class]) _TRSnowView_type = [CNClassType classTypeWithCls:[TRSnowView class]];
}

- (void)updateWithDelta:(CGFloat)delta {
    [_system updateWithDelta:delta];
}

- (void)complete {
    [_view prepare];
}

- (void)draw {
    [_view draw];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SnowView(%@, %f)", _weather, _strength];
}

- (CNClassType*)type {
    return [TRSnowView type];
}

+ (CNClassType*)type {
    return _TRSnowView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRSnowParticleSystem
static CNClassType* _TRSnowParticleSystem_type;
@synthesize weather = _weather;
@synthesize strength = _strength;

+ (instancetype)snowParticleSystemWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    return [[TRSnowParticleSystem alloc] initWithWeather:weather strength:strength];
}

- (instancetype)initWithWeather:(TRWeather*)weather strength:(CGFloat)strength {
    self = [super initWithParticleType:trSnowParticleType() maxCount:((unsigned int)(2000 * strength))];
    if(self) {
        _weather = weather;
        _strength = strength;
        _textureQuadrant = pgQuadQuadrant(pgQuadIdentity());
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowParticleSystem class]) _TRSnowParticleSystem_type = [CNClassType classTypeWithCls:[TRSnowParticleSystem class]];
}

- (void)_init {
    NSInteger __il__0i = 0;
    TRSnowParticle* __il__0p = self.particles;
    while(__il__0i < self.maxCount) {
        {
            __il__0p->position = pgVec2MulI(pgVec2Rnd(), 2);
            __il__0p->size = cnFloat4RndMinMax(0.004, 0.01);
            __il__0p->windVar = PGVec2Make((((float)(cnFloatRndMinMax(0.8, 1.2)))), (((float)(cnFloatRndMinMax(0.8, 1.2)))));
            __il__0p->urge = PGVec2Make((((float)(cnFloatRndMinMax(-0.03, 0.03)))), (((float)(cnFloatRndMinMax(-0.02, 0.02)))));
            __il__0p->uv = pgQuadrantRndQuad(_textureQuadrant);
        }
        __il__0i++;
        __il__0p++;
    }
}

- (void)doUpdateWithDelta:(CGFloat)delta {
    PGVec2 w = [_weather wind];
    PGVec2 ww = PGVec2Make((w.x + w.y) * 0.3, -float4Abs(w.y - w.x) * 0.3 - 0.05);
    {
        NSInteger __il__2i = 0;
        TRSnowParticle* __il__2p = self.particles;
        while(__il__2i < self.maxCount) {
            {
                PGVec2 vec = pgVec2AddVec2((pgVec2MulVec2(ww, __il__2p->windVar)), __il__2p->urge);
                __il__2p->position = pgVec2AddVec2(__il__2p->position, (pgVec2MulF(vec, delta)));
                if(__il__2p->position.y < -1.0) __il__2p->position = PGVec2Make(((float)(cnFloatRnd() * 2 - 1)), (((float)(cnFloatRndMinMax(1.5, 1.1)))));
                if(__il__2p->position.x > 1.0) __il__2p->position = PGVec2Make(-1.0, __il__2p->position.y);
                if(__il__2p->position.x < -1.0) __il__2p->position = PGVec2Make(1.0, __il__2p->position.y);
            }
            __il__2i++;
            __il__2p++;
        }
    }
}

- (unsigned int)doWriteToArray:(TRSnowData*)array {
    NSInteger __il__0i = 0;
    TRSnowParticle* __il__0p = self.particles;
    TRSnowData* __il__0a = array;
    while(__il__0i < self.maxCount) {
        __il__0a = ({
            TRSnowData* a = __il__0a;
            a->position = __il__0p->position;
            a->uv = __il__0p->uv.p0;
            a++;
            a->position = PGVec2Make(__il__0p->position.x + __il__0p->size, __il__0p->position.y);
            a->uv = __il__0p->uv.p1;
            a++;
            a->position = PGVec2Make(__il__0p->position.x + __il__0p->size, __il__0p->position.y + __il__0p->size);
            a->uv = __il__0p->uv.p2;
            a++;
            a->position = PGVec2Make(__il__0p->position.x, __il__0p->position.y + __il__0p->size);
            a->uv = __il__0p->uv.p3;
            a + 1;
        });
        __il__0i++;
        __il__0p++;
    }
    return self.maxCount;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SnowParticleSystem(%@, %f)", _weather, _strength];
}

- (unsigned int)vertexCount {
    return 4;
}

- (NSUInteger)indexCount {
    return 6;
}

- (unsigned int*)createIndexArray {
    unsigned int* indexPointer = cnPointerApplyBytesCount(4, [self indexCount] * [self maxCount]);
    unsigned int* ia = indexPointer;
    NSInteger i = 0;
    unsigned int j = 0;
    while(i < [self maxCount]) {
        *(ia + 0) = j;
        *(ia + 1) = j + 1;
        *(ia + 2) = j + 2;
        *(ia + 3) = j + 2;
        *(ia + 4) = j;
        *(ia + 5) = j + 3;
        ia += 6;
        i++;
        j += 4;
    }
    return indexPointer;
}

- (CNClassType*)type {
    return [TRSnowParticleSystem type];
}

+ (CNClassType*)type {
    return _TRSnowParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

NSString* trSnowParticleDescription(TRSnowParticle self) {
    return [NSString stringWithFormat:@"SnowParticle(%@, %f, %@, %@, %@)", pgVec2Description(self.position), self.size, pgVec2Description(self.windVar), pgVec2Description(self.urge), pgQuadDescription(self.uv)];
}
BOOL trSnowParticleIsEqualTo(TRSnowParticle self, TRSnowParticle to) {
    return pgVec2IsEqualTo(self.position, to.position) && eqf4(self.size, to.size) && pgVec2IsEqualTo(self.windVar, to.windVar) && pgVec2IsEqualTo(self.urge, to.urge) && pgQuadIsEqualTo(self.uv, to.uv);
}
NSUInteger trSnowParticleHash(TRSnowParticle self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(self.position);
    hash = hash * 31 + float4Hash(self.size);
    hash = hash * 31 + pgVec2Hash(self.windVar);
    hash = hash * 31 + pgVec2Hash(self.urge);
    hash = hash * 31 + pgQuadHash(self.uv);
    return hash;
}
CNPType* trSnowParticleType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[TRSnowParticleWrap class] name:@"TRSnowParticle" size:sizeof(TRSnowParticle) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRSnowParticle, ((TRSnowParticle*)(data))[i]);
    }];
    return _ret;
}
@implementation TRSnowParticleWrap{
    TRSnowParticle _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRSnowParticle)value {
    return [[TRSnowParticleWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRSnowParticle)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return trSnowParticleDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSnowParticleWrap* o = ((TRSnowParticleWrap*)(other));
    return trSnowParticleIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return trSnowParticleHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


NSString* trSnowDataDescription(TRSnowData self) {
    return [NSString stringWithFormat:@"SnowData(%@, %@)", pgVec2Description(self.position), pgVec2Description(self.uv)];
}
BOOL trSnowDataIsEqualTo(TRSnowData self, TRSnowData to) {
    return pgVec2IsEqualTo(self.position, to.position) && pgVec2IsEqualTo(self.uv, to.uv);
}
NSUInteger trSnowDataHash(TRSnowData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec2Hash(self.position);
    hash = hash * 31 + pgVec2Hash(self.uv);
    return hash;
}
CNPType* trSnowDataType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[TRSnowDataWrap class] name:@"TRSnowData" size:sizeof(TRSnowData) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRSnowData, ((TRSnowData*)(data))[i]);
    }];
    return _ret;
}
@implementation TRSnowDataWrap{
    TRSnowData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRSnowData)value {
    return [[TRSnowDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRSnowData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return trSnowDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSnowDataWrap* o = ((TRSnowDataWrap*)(other));
    return trSnowDataIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return trSnowDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation TRSnowSystemView
static PGVertexBufferDesc* _TRSnowSystemView_vbDesc;
static CNClassType* _TRSnowSystemView_type;

+ (instancetype)snowSystemViewWithSystem:(TRSnowParticleSystem*)system {
    return [[TRSnowSystemView alloc] initWithSystem:system];
}

- (instancetype)initWithSystem:(TRSnowParticleSystem*)system {
    self = [super initWithSystem:system vbDesc:[TRSnowSystemView vbDesc] shader:[TRSnowShader instance] material:[PGGlobal compressedTextureForFile:@"Snowflake" filter:PGTextureFilter_mipmapNearest] blendFunc:[PGBlendFunction premultiplied]];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowSystemView class]) {
        _TRSnowSystemView_type = [CNClassType classTypeWithCls:[TRSnowSystemView class]];
        _TRSnowSystemView_vbDesc = [PGVertexBufferDesc vertexBufferDescWithDataType:trSnowDataType() position:0 uv:((int)(2 * 4)) normal:-1 color:-1 model:-1];
    }
}

- (NSString*)description {
    return @"SnowSystemView";
}

- (CNClassType*)type {
    return [TRSnowSystemView type];
}

+ (PGVertexBufferDesc*)vbDesc {
    return _TRSnowSystemView_vbDesc;
}

+ (CNClassType*)type {
    return _TRSnowSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRSnowShaderText
static CNClassType* _TRSnowShaderText_type;
@synthesize fragment = _fragment;

+ (instancetype)snowShaderText {
    return [[TRSnowShaderText alloc] init];
}

- (instancetype)init {
    self = [super init];
    if(self) _fragment = [NSString stringWithFormat:@"%@\n"
        "%@ mediump vec2 fuv;\n"
        "uniform lowp sampler2D txt;\n"
        "\n"
        "void main(void) {\n"
        "   %@ = %@(txt, fuv);\n"
        "}", [self fragmentHeader], [self in], [self fragColor], [self texture2D]];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowShaderText class]) _TRSnowShaderText_type = [CNClassType classTypeWithCls:[TRSnowShaderText class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ highp vec2 position;\n"
        "%@ mediump vec2 uv;\n"
        "%@ mediump vec2 fuv;\n"
        "\n"
        "void main(void) {\n"
        "   gl_Position = vec4(position.x, position.y, 0, 1);\n"
        "   fuv = uv;\n"
        "}", [self vertexHeader], [self ain], [self ain], [self out]];
}

- (PGShaderProgram*)program {
    return [PGShaderProgram applyName:@"Snow" vertex:[self vertex] fragment:_fragment];
}

- (NSString*)description {
    return @"SnowShaderText";
}

- (CNClassType*)type {
    return [TRSnowShaderText type];
}

+ (CNClassType*)type {
    return _TRSnowShaderText_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRSnowShader
static TRSnowShader* _TRSnowShader_instance;
static CNClassType* _TRSnowShader_type;
@synthesize positionSlot = _positionSlot;
@synthesize uvSlot = _uvSlot;

+ (instancetype)snowShader {
    return [[TRSnowShader alloc] init];
}

- (instancetype)init {
    self = [super initWithProgram:[[TRSnowShaderText snowShaderText] program]];
    if(self) {
        _positionSlot = [self attributeForName:@"position"];
        _uvSlot = [self attributeForName:@"uv"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowShader class]) {
        _TRSnowShader_type = [CNClassType classTypeWithCls:[TRSnowShader class]];
        _TRSnowShader_instance = [TRSnowShader snowShader];
    }
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_position))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_uv))];
}

- (void)loadUniformsParam:(PGTexture*)param {
    [[PGGlobal context] bindTextureTexture:param];
}

- (NSString*)description {
    return @"SnowShader";
}

- (CNClassType*)type {
    return [TRSnowShader type];
}

+ (TRSnowShader*)instance {
    return _TRSnowShader_instance;
}

+ (CNClassType*)type {
    return _TRSnowShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

