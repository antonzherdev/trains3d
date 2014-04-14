#import "TRSnowView.h"

#import "TRWeather.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "GL.h"
@implementation TRSnowView
static ODClassType* _TRSnowView_type;
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
        _system = [TRSnowParticleSystem snowParticleSystemWithWeather:_weather strength:_strength];
        _view = [TRSnowSystemView snowSystemViewWithSystem:_system];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowView class]) _TRSnowView_type = [ODClassType classTypeWithCls:[TRSnowView class]];
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

- (ODClassType*)type {
    return [TRSnowView type];
}

+ (ODClassType*)type {
    return _TRSnowView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"weather=%@", self.weather];
    [description appendFormat:@", strength=%f", self.strength];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSnowParticleSystem
static ODClassType* _TRSnowParticleSystem_type;
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
        _textureQuadrant = geQuadQuadrant(geQuadIdentity());
        [self _init];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowParticleSystem class]) _TRSnowParticleSystem_type = [ODClassType classTypeWithCls:[TRSnowParticleSystem class]];
}

- (void)_init {
    NSInteger __inline__0_i = 0;
    TRSnowParticle* __inline__0_p = self.particles;
    while(__inline__0_i < self.maxCount) {
        {
            __inline__0_p->position = geVec2MulF4(geVec2Rnd(), 2.0);
            __inline__0_p->size = odFloat4RndMinMax(0.004, 0.01);
            __inline__0_p->windVar = GEVec2Make((((float)(odFloatRndMinMax(0.8, 1.2)))), (((float)(odFloatRndMinMax(0.8, 1.2)))));
            __inline__0_p->urge = GEVec2Make((((float)(odFloatRndMinMax(-0.03, 0.03)))), (((float)(odFloatRndMinMax(-0.02, 0.02)))));
            __inline__0_p->uv = geQuadrantRndQuad(_textureQuadrant);
        }
        __inline__0_i++;
        __inline__0_p++;
    }
}

- (void)doUpdateWithDelta:(CGFloat)delta {
    GEVec2 w = [_weather wind];
    GEVec2 ww = GEVec2Make((w.x + w.y) * 0.3, -float4Abs(w.y - w.x) * 0.3 - 0.05);
    {
        NSInteger __inline__2_i = 0;
        TRSnowParticle* __inline__2_p = self.particles;
        while(__inline__2_i < self.maxCount) {
            {
                GEVec2 vec = geVec2AddVec2((geVec2MulVec2(ww, __inline__2_p->windVar)), __inline__2_p->urge);
                __inline__2_p->position = geVec2AddVec2(__inline__2_p->position, (geVec2MulF4(vec, ((float)(delta)))));
                if(__inline__2_p->position.y < -1.0) __inline__2_p->position = GEVec2Make(((float)(odFloatRnd() * 2 - 1)), (((float)(odFloatRndMinMax(1.5, 1.1)))));
                if(__inline__2_p->position.x > 1.0) __inline__2_p->position = GEVec2Make(-1.0, __inline__2_p->position.y);
                if(__inline__2_p->position.x < -1.0) __inline__2_p->position = GEVec2Make(1.0, __inline__2_p->position.y);
            }
            __inline__2_i++;
            __inline__2_p++;
        }
    }
}

- (void)doWriteToArray:(TRSnowData*)array {
    NSInteger __inline__0_i = 0;
    TRSnowParticle* __inline__0_p = self.particles;
    TRSnowData* __inline__0_a = array;
    while(__inline__0_i < self.maxCount) {
        __inline__0_a = ({
            TRSnowData* a = __inline__0_a;
            a->position = __inline__0_p->position;
            a->uv = __inline__0_p->uv.p0;
            a++;
            a->position = GEVec2Make(__inline__0_p->position.x + __inline__0_p->size, __inline__0_p->position.y);
            a->uv = __inline__0_p->uv.p1;
            a++;
            a->position = GEVec2Make(__inline__0_p->position.x + __inline__0_p->size, __inline__0_p->position.y + __inline__0_p->size);
            a->uv = __inline__0_p->uv.p2;
            a++;
            a->position = GEVec2Make(__inline__0_p->position.x, __inline__0_p->position.y + __inline__0_p->size);
            a->uv = __inline__0_p->uv.p3;
            a + 1;
        });
        __inline__0_i++;
        __inline__0_p++;
    }
}

- (unsigned int)vertexCount {
    return 4;
}

- (NSUInteger)indexCount {
    return 6;
}

- (unsigned int*)createIndexArray {
    unsigned int* indexPointer = cnPointerApplyBytes(((NSUInteger)(4 * [self indexCount] * [self maxCount])));
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

- (ODClassType*)type {
    return [TRSnowParticleSystem type];
}

+ (ODClassType*)type {
    return _TRSnowParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"weather=%@", self.weather];
    [description appendFormat:@", strength=%f", self.strength];
    [description appendString:@">"];
    return description;
}

@end


NSString* TRSnowParticleDescription(TRSnowParticle self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRSnowParticle: "];
    [description appendFormat:@"position=%@", GEVec2Description(self.position)];
    [description appendFormat:@", size=%f", self.size];
    [description appendFormat:@", windVar=%@", GEVec2Description(self.windVar)];
    [description appendFormat:@", urge=%@", GEVec2Description(self.urge)];
    [description appendFormat:@", uv=%@", GEQuadDescription(self.uv)];
    [description appendString:@">"];
    return description;
}
ODPType* trSnowParticleType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRSnowParticleWrap class] name:@"TRSnowParticle" size:sizeof(TRSnowParticle) wrap:^id(void* data, NSUInteger i) {
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
    return TRSnowParticleDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSnowParticleWrap* o = ((TRSnowParticleWrap*)(other));
    return TRSnowParticleEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRSnowParticleHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



NSString* TRSnowDataDescription(TRSnowData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRSnowData: "];
    [description appendFormat:@"position=%@", GEVec2Description(self.position)];
    [description appendFormat:@", uv=%@", GEVec2Description(self.uv)];
    [description appendString:@">"];
    return description;
}
ODPType* trSnowDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRSnowDataWrap class] name:@"TRSnowData" size:sizeof(TRSnowData) wrap:^id(void* data, NSUInteger i) {
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
    return TRSnowDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRSnowDataWrap* o = ((TRSnowDataWrap*)(other));
    return TRSnowDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRSnowDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation TRSnowSystemView
static EGVertexBufferDesc* _TRSnowSystemView_vbDesc;
static ODClassType* _TRSnowSystemView_type;

+ (instancetype)snowSystemViewWithSystem:(TRSnowParticleSystem*)system {
    return [[TRSnowSystemView alloc] initWithSystem:system];
}

- (instancetype)initWithSystem:(TRSnowParticleSystem*)system {
    self = [super initWithSystem:system vbDesc:TRSnowSystemView.vbDesc shader:TRSnowShader.instance material:[EGGlobal compressedTextureForFile:@"Snowflake" filter:EGTextureFilter.mipmapNearest] blendFunc:EGBlendFunction.premultiplied];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRSnowSystemView class]) {
        _TRSnowSystemView_type = [ODClassType classTypeWithCls:[TRSnowSystemView class]];
        _TRSnowSystemView_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:trSnowDataType() position:0 uv:((int)(2 * 4)) normal:-1 color:-1 model:-1];
    }
}

- (ODClassType*)type {
    return [TRSnowSystemView type];
}

+ (EGVertexBufferDesc*)vbDesc {
    return _TRSnowSystemView_vbDesc;
}

+ (ODClassType*)type {
    return _TRSnowSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"system=%@", self.system];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRSnowShaderText
static ODClassType* _TRSnowShaderText_type;
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
    if(self == [TRSnowShaderText class]) _TRSnowShaderText_type = [ODClassType classTypeWithCls:[TRSnowShaderText class]];
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

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Snow" vertex:[self vertex] fragment:_fragment];
}

- (NSString*)versionString {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)vertexHeader {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)fragmentHeader {
    return [NSString stringWithFormat:@"#version %ld\n"
        "%@", (long)[self version], [self fragColorDeclaration]];
}

- (NSString*)fragColorDeclaration {
    if([self isFragColorDeclared]) return @"";
    else return @"out lowp vec4 fragColor;";
}

- (BOOL)isFragColorDeclared {
    return EGShaderProgram.version < 110;
}

- (NSInteger)version {
    return EGShaderProgram.version;
}

- (NSString*)ain {
    if([self version] < 150) return @"attribute";
    else return @"in";
}

- (NSString*)in {
    if([self version] < 150) return @"varying";
    else return @"in";
}

- (NSString*)out {
    if([self version] < 150) return @"varying";
    else return @"out";
}

- (NSString*)fragColor {
    if([self version] > 100) return @"fragColor";
    else return @"gl_FragColor";
}

- (NSString*)texture2D {
    if([self version] > 100) return @"texture";
    else return @"texture2D";
}

- (NSString*)shadowExt {
    if([self version] == 100 && [EGGlobal.settings shadowType] == EGShadowType.shadow2d) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)sampler2DShadow {
    if([EGGlobal.settings shadowType] == EGShadowType.shadow2d) return @"sampler2DShadow";
    else return @"sampler2D";
}

- (NSString*)shadow2DTexture:(NSString*)texture vec3:(NSString*)vec3 {
    if([EGGlobal.settings shadowType] == EGShadowType.shadow2d) return [NSString stringWithFormat:@"%@(%@, %@)", [self shadow2DEXT], texture, vec3];
    else return [NSString stringWithFormat:@"(%@(%@, %@.xy).x < %@.z ? 0.0 : 1.0)", [self texture2D], texture, vec3, vec3];
}

- (NSString*)blendMode:(EGBlendMode*)mode a:(NSString*)a b:(NSString*)b {
    return mode.blend(a, b);
}

- (NSString*)shadow2DEXT {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
}

- (ODClassType*)type {
    return [TRSnowShaderText type];
}

+ (ODClassType*)type {
    return _TRSnowShaderText_type;
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


@implementation TRSnowShader
static TRSnowShader* _TRSnowShader_instance;
static ODClassType* _TRSnowShader_type;
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
        _TRSnowShader_type = [ODClassType classTypeWithCls:[TRSnowShader class]];
        _TRSnowShader_instance = [TRSnowShader snowShader];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
}

- (void)loadUniformsParam:(EGTexture*)param {
    [EGGlobal.context bindTextureTexture:param];
}

- (ODClassType*)type {
    return [TRSnowShader type];
}

+ (TRSnowShader*)instance {
    return _TRSnowShader_instance;
}

+ (ODClassType*)type {
    return _TRSnowShader_type;
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


