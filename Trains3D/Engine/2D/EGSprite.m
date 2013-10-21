#import "EGSprite.h"

#import "EGVertex.h"
#import "EGIndex.h"
#import "EGSimpleShaderSystem.h"
#import "EGMaterial.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "GL.h"
#import "GEMat4.h"
@implementation EGD2D
static CNVoidRefArray _EGD2D_vertexes;
static EGMutableVertexBuffer* _EGD2D_vb;
static EGVertexArray* _EGD2D_vaoForColor;
static EGVertexArray* _EGD2D_vaoForTexture;
static EGMutableVertexBuffer* _EGD2D_lineVb;
static CNVoidRefArray _EGD2D_lineVertexes;
static EGVertexArray* _EGD2D_lineVao;
static CNLazy* _EGD2D__lazy_circleVaoForColor;
static ODClassType* _EGD2D_type;

+ (void)initialize {
    [super initialize];
    _EGD2D_type = [ODClassType classTypeWithCls:[EGD2D class]];
    _EGD2D_vertexes = cnVoidRefArrayApplyTpCount(egBillboardBufferDataType(), 4);
    _EGD2D_vb = [EGVBO mutDesc:EGBillboard.vbDesc];
    _EGD2D_vaoForColor = [[EGMesh meshWithVertex:_EGD2D_vb index:EGEmptyIndexSource.triangleStrip] vaoShader:[EGBillboardShader instanceForColor]];
    _EGD2D_vaoForTexture = [[EGMesh meshWithVertex:_EGD2D_vb index:EGEmptyIndexSource.triangleStrip] vaoShader:[EGBillboardShader instanceForTexture]];
    _EGD2D_lineVb = [EGVBO mutMesh];
    _EGD2D_lineVertexes = cnVoidRefArrayApplyTpCount(egMeshDataType(), 2);
    _EGD2D_lineVao = [[EGMesh meshWithVertex:_EGD2D_lineVb index:EGEmptyIndexSource.lines] vaoShader:EGSimpleShaderSystem.colorShader];
    _EGD2D__lazy_circleVaoForColor = [CNLazy lazyWithF:^EGVertexArray*() {
        return [[EGMesh meshWithVertex:[EGVBO vec2Data:[ arrs(GEVec2, 4) {GEVec2Make(-1.0, -1.0), GEVec2Make(-1.0, 1.0), GEVec2Make(1.0, -1.0), GEVec2Make(1.0, 1.0)}]] index:EGEmptyIndexSource.triangleStrip] vaoShader:EGCircleShader.instance];
    }];
}

+ (EGVertexArray*)circleVaoForColor {
    return [_EGD2D__lazy_circleVaoForColor get];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at rect:(GERect)rect {
    [EGD2D drawSpriteMaterial:material at:at quad:geRectQuad(rect)];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad {
    if([material.texture isDefined]) [EGD2D drawSpriteMaterial:material at:at quad:quad uv:geRectUpsideDownQuad([((EGTexture*)([material.texture get])) uv])];
    else [EGD2D drawSpriteMaterial:material at:at quad:quad uv:geRectUpsideDownQuad(geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0))];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv {
    CNVoidRefArray v = _EGD2D_vertexes;
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[0], material.color, uv.p[0]));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[1], material.color, uv.p[1]));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[2], material.color, uv.p[2]));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[3], material.color, uv.p[3]));
    [_EGD2D_vb setArray:_EGD2D_vertexes];
    [EGGlobal.context.cullFace disabledF:^void() {
        if([material.texture isEmpty]) [_EGD2D_vaoForColor drawParam:material];
        else [_EGD2D_vaoForTexture drawParam:material];
    }];
}

+ (CNVoidRefArray)writeSpriteIn:(CNVoidRefArray)in material:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv {
    CNVoidRefArray v = cnVoidRefArrayWriteTpItem(in, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[0], material.color, uv.p[0]));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[1], material.color, uv.p[1]));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[2], material.color, uv.p[2]));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[3], material.color, uv.p[3]));
    return v;
}

+ (CNVoidRefArray)writeQuadIndexIn:(CNVoidRefArray)in i:(unsigned int)i {
    return cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(cnVoidRefArrayWriteUInt4(in, i), i + 1), i + 2), i + 1), i + 2), i + 3);
}

+ (void)drawLineMaterial:(EGColorSource*)material p0:(GEVec2)p0 p1:(GEVec2)p1 {
    CNVoidRefArray v = _EGD2D_lineVertexes;
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(GEVec2Make(0.0, 0.0), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(p0, 0.0)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(GEVec2Make(1.0, 1.0), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(p1, 0.0)));
    [_EGD2D_lineVb setArray:_EGD2D_lineVertexes];
    [EGGlobal.context.cullFace disabledF:^void() {
        [_EGD2D_lineVao drawParam:material];
    }];
}

+ (void)drawCircleMaterial:(EGColorSource*)material at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative start:(CGFloat)start end:(CGFloat)end {
    [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.cullFace disabledF:^void() {
            [[EGD2D circleVaoForColor] drawParam:[EGCircleParam circleParamWithColor:material.color position:at radius:radius relative:relative start:((float)(start)) end:((float)(end))]];
        }];
    }];
}

- (ODClassType*)type {
    return [EGD2D type];
}

+ (ODClassType*)type {
    return _EGD2D_type;
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


@implementation EGCircleShaderBuilder
static ODClassType* _EGCircleShaderBuilder_type;

+ (id)circleShaderBuilder {
    return [[EGCircleShaderBuilder alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCircleShaderBuilder_type = [ODClassType classTypeWithCls:[EGCircleShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "%@ lowp vec2 model;\n"
        "\n"
        "uniform highp vec4 position;\n"
        "uniform mat4 p;\n"
        "uniform lowp float radius;\n"
        "%@ highp vec2 coord;\n"
        "\n"
        "void main(void) {\n"
        "    highp vec4 pos = position;\n"
        "    pos.x += model.x*radius;\n"
        "    pos.y += model.y*radius;\n"
        "    gl_Position = p*pos;\n"
        "    coord = model;\n"
        "}", [self vertexHeader], [self ain], [self out]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@ highp vec2 coord;\n"
        "uniform lowp vec4 color;\n"
        "uniform lowp float startTg;\n"
        "uniform lowp float endTg;\n"
        "\n"
        "void main(void) {\n"
        "    lowp float tg = atan(coord.y, coord.x);\n"
        "    if(endTg < startTg) {\n"
        "       %@ = vec4(color.xyz, color.w * (\n"
        "                1.0 - smoothstep(0.95, 1.0, dot(coord, coord))\n"
        "                - (clamp(smoothstep(endTg - 0.1, endTg, tg) + 1.0 - smoothstep(startTg, startTg + 0.1, tg), 1.0, 2.0) - 1.0)\n"
        "       ));\n"
        "    } else {\n"
        "        %@ = vec4(color.xyz, color.w * (\n"
        "                1.0 - smoothstep(0.95, 1.0, dot(coord, coord))\n"
        "                - (1.0 - smoothstep(startTg, startTg + 0.1, tg))\n"
        "                - (smoothstep(endTg - 0.1, endTg, tg))\n"
        "        ));\n"
        "    }\n"
        "}", [self fragmentHeader], [self in], [self fragColor], [self fragColor]];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Circle" vertex:[self vertex] fragment:[self fragment]];
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
    if([self version] == 100) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)shadow2D {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
}

- (ODClassType*)type {
    return [EGCircleShaderBuilder type];
}

+ (ODClassType*)type {
    return _EGCircleShaderBuilder_type;
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


@implementation EGCircleParam{
    GEVec4 _color;
    GEVec3 _position;
    float _radius;
    GEVec2 _relative;
    float _start;
    float _end;
}
static ODClassType* _EGCircleParam_type;
@synthesize color = _color;
@synthesize position = _position;
@synthesize radius = _radius;
@synthesize relative = _relative;
@synthesize start = _start;
@synthesize end = _end;

+ (id)circleParamWithColor:(GEVec4)color position:(GEVec3)position radius:(float)radius relative:(GEVec2)relative start:(float)start end:(float)end {
    return [[EGCircleParam alloc] initWithColor:color position:position radius:radius relative:relative start:start end:end];
}

- (id)initWithColor:(GEVec4)color position:(GEVec3)position radius:(float)radius relative:(GEVec2)relative start:(float)start end:(float)end {
    self = [super init];
    if(self) {
        _color = color;
        _position = position;
        _radius = radius;
        _relative = relative;
        _start = start;
        _end = end;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCircleParam_type = [ODClassType classTypeWithCls:[EGCircleParam class]];
}

- (ODClassType*)type {
    return [EGCircleParam type];
}

+ (ODClassType*)type {
    return _EGCircleParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCircleParam* o = ((EGCircleParam*)(other));
    return GEVec4Eq(self.color, o.color) && GEVec3Eq(self.position, o.position) && eqf4(self.radius, o.radius) && GEVec2Eq(self.relative, o.relative) && eqf4(self.start, o.start) && eqf4(self.end, o.end);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + GEVec3Hash(self.position);
    hash = hash * 31 + float4Hash(self.radius);
    hash = hash * 31 + GEVec2Hash(self.relative);
    hash = hash * 31 + float4Hash(self.start);
    hash = hash * 31 + float4Hash(self.end);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", position=%@", GEVec3Description(self.position)];
    [description appendFormat:@", radius=%f", self.radius];
    [description appendFormat:@", relative=%@", GEVec2Description(self.relative)];
    [description appendFormat:@", start=%f", self.start];
    [description appendFormat:@", end=%f", self.end];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCircleShader{
    EGShaderAttribute* _model;
    EGShaderUniformVec4* _pos;
    EGShaderUniformMat4* _p;
    EGShaderUniformF4* _radius;
    EGShaderUniformVec4* _color;
    EGShaderUniformF4* _startTg;
    EGShaderUniformF4* _endTg;
}
static EGCircleShader* _EGCircleShader_instance;
static ODClassType* _EGCircleShader_type;
@synthesize model = _model;
@synthesize pos = _pos;
@synthesize p = _p;
@synthesize radius = _radius;
@synthesize color = _color;
@synthesize startTg = _startTg;
@synthesize endTg = _endTg;

+ (id)circleShader {
    return [[EGCircleShader alloc] init];
}

- (id)init {
    self = [super initWithProgram:[[EGCircleShaderBuilder circleShaderBuilder] program]];
    if(self) {
        _model = [self attributeForName:@"model"];
        _pos = [self uniformVec4Name:@"position"];
        _p = [self uniformMat4Name:@"p"];
        _radius = [self uniformF4Name:@"radius"];
        _color = [self uniformVec4Name:@"color"];
        _startTg = [self uniformF4Name:@"startTg"];
        _endTg = [self uniformF4Name:@"endTg"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCircleShader_type = [ODClassType classTypeWithCls:[EGCircleShader class]];
    _EGCircleShader_instance = [EGCircleShader circleShader];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_model setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
}

- (void)loadUniformsParam:(EGCircleParam*)param {
    [_pos applyVec4:geVec4AddVec2([[EGGlobal.matrix.value wc] mulVec4:geVec4ApplyVec3W(param.position, 1.0)], param.relative)];
    [_p applyMatrix:EGGlobal.matrix.value.p];
    [_radius applyF4:param.radius];
    [_color applyVec4:param.color];
    if(param.start < param.end) {
        [_startTg applyF4:[self clampP:param.start]];
        [_endTg applyF4:[self clampP:param.end]];
    } else {
        [_startTg applyF4:[self clampP:param.end]];
        [_endTg applyF4:[self clampP:param.start]];
    }
}

- (float)clampP:(float)p {
    if(p < -M_PI) {
        return ((float)(2 * M_PI + p));
    } else {
        if(p > M_PI) return ((float)(-2 * M_PI + p));
        else return p;
    }
}

- (ODClassType*)type {
    return [EGCircleShader type];
}

+ (EGCircleShader*)instance {
    return _EGCircleShader_instance;
}

+ (ODClassType*)type {
    return _EGCircleShader_type;
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


@implementation EGSprite{
    EGColorSource* _material;
    GEVec2 _position;
    GEVec2 _size;
}
static ODClassType* _EGSprite_type;
@synthesize material = _material;
@synthesize position = _position;
@synthesize size = _size;

+ (id)sprite {
    return [[EGSprite alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _position = GEVec2Make(0.0, 0.0);
        _size = GEVec2Make(1.0, 1.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSprite_type = [ODClassType classTypeWithCls:[EGSprite class]];
}

- (void)draw {
    [EGD2D drawSpriteMaterial:_material at:geVec3ApplyVec2Z(_position, 0.0) quad:geRectQuad(GERectMake(GEVec2Make(0.0, 0.0), _size))];
}

- (GERect)rect {
    return GERectMake(_position, _size);
}

+ (EGSprite*)applyMaterial:(EGColorSource*)material size:(GEVec2)size {
    EGSprite* s = [EGSprite sprite];
    s.material = material;
    s.size = size;
    return s;
}

+ (EGSprite*)applyTexture:(EGTexture*)texture {
    EGSprite* s = [EGSprite sprite];
    s.material = [EGColorSource applyTexture:texture];
    return s;
}

- (void)adjustSize {
    if([_material.texture isDefined]) _size = [((EGTexture*)([_material.texture get])) scaledSize];
}

- (BOOL)containsVec2:(GEVec2)vec2 {
    return geRectContainsVec2(GERectMake(_position, _size), vec2);
}

- (ODClassType*)type {
    return [EGSprite type];
}

+ (ODClassType*)type {
    return _EGSprite_type;
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


@implementation EGLine2d{
    EGColorSource* _material;
    GEVec2 _p0;
    GEVec2 _p1;
}
static ODClassType* _EGLine2d_type;
@synthesize material = _material;
@synthesize p0 = _p0;
@synthesize p1 = _p1;

+ (id)line2d {
    return [[EGLine2d alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _p0 = GEVec2Make(0.0, 0.0);
        _p1 = GEVec2Make(1.0, 1.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGLine2d_type = [ODClassType classTypeWithCls:[EGLine2d class]];
}

+ (EGLine2d*)applyMaterial:(EGColorSource*)material {
    EGLine2d* l = [EGLine2d line2d];
    l.material = material;
    return l;
}

- (void)draw {
    [EGD2D drawLineMaterial:_material p0:_p0 p1:_p1];
}

- (ODClassType*)type {
    return [EGLine2d type];
}

+ (ODClassType*)type {
    return _EGLine2d_type;
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


