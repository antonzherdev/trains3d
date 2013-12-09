#import "EGSprite.h"

#import "EGVertex.h"
#import "EGIndex.h"
#import "EGSimpleShaderSystem.h"
#import "EGMaterial.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "GL.h"
#import "GEMat4.h"
#import "EGInput.h"
@implementation EGD2D
static CNVoidRefArray _EGD2D_vertexes;
static EGMutableVertexBuffer* _EGD2D_vb;
static EGVertexArray* _EGD2D_vaoForColor;
static EGVertexArray* _EGD2D_vaoForTexture;
static EGMutableVertexBuffer* _EGD2D_lineVb;
static CNVoidRefArray _EGD2D_lineVertexes;
static EGVertexArray* _EGD2D_lineVao;
static CNLazy* _EGD2D__lazy_circleVaoWithSegment;
static CNLazy* _EGD2D__lazy_circleVaoWithoutSegment;
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
    _EGD2D_lineVao = [[EGMesh meshWithVertex:_EGD2D_lineVb index:EGEmptyIndexSource.lines] vaoShader:[EGSimpleShaderSystem colorShader]];
    _EGD2D__lazy_circleVaoWithSegment = [CNLazy lazyWithF:^EGVertexArray*() {
        return [[EGMesh meshWithVertex:[EGVBO vec2Data:[ arrs(GEVec2, 4) {GEVec2Make(-1.0, -1.0), GEVec2Make(-1.0, 1.0), GEVec2Make(1.0, -1.0), GEVec2Make(1.0, 1.0)}]] index:EGEmptyIndexSource.triangleStrip] vaoShader:EGCircleShader.withSegment];
    }];
    _EGD2D__lazy_circleVaoWithoutSegment = [CNLazy lazyWithF:^EGVertexArray*() {
        return [[EGMesh meshWithVertex:[EGVBO vec2Data:[ arrs(GEVec2, 4) {GEVec2Make(-1.0, -1.0), GEVec2Make(-1.0, 1.0), GEVec2Make(1.0, -1.0), GEVec2Make(1.0, 1.0)}]] index:EGEmptyIndexSource.triangleStrip] vaoShader:EGCircleShader.withoutSegment];
    }];
}

+ (EGVertexArray*)circleVaoWithSegment {
    return [_EGD2D__lazy_circleVaoWithSegment get];
}

+ (EGVertexArray*)circleVaoWithoutSegment {
    return [_EGD2D__lazy_circleVaoWithoutSegment get];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at rect:(GERect)rect {
    [EGD2D drawSpriteMaterial:material at:at quad:geRectStripQuad(rect)];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad {
    if([material.texture isDefined]) [EGD2D drawSpriteMaterial:material at:at quad:quad uv:geRectUpsideDownStripQuad([((EGTexture*)([material.texture get])) uv])];
    else [EGD2D drawSpriteMaterial:material at:at quad:quad uv:geRectUpsideDownStripQuad(geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0))];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv {
    CNVoidRefArray v = _EGD2D_vertexes;
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p0, material.color, uv.p0));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p1, material.color, uv.p1));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p2, material.color, uv.p2));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p3, material.color, uv.p3));
    [_EGD2D_vb setArray:_EGD2D_vertexes];
    [EGGlobal.context.cullFace disabledF:^void() {
        if([material.texture isEmpty]) [_EGD2D_vaoForColor drawParam:material];
        else [_EGD2D_vaoForTexture drawParam:material];
    }];
}

+ (CNVoidRefArray)writeSpriteIn:(CNVoidRefArray)in material:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv {
    CNVoidRefArray v = cnVoidRefArrayWriteTpItem(in, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p0, material.color, uv.p0));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p1, material.color, uv.p1));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p2, material.color, uv.p2));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p3, material.color, uv.p3));
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

+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative segmentColor:(GEVec4)segmentColor start:(CGFloat)start end:(CGFloat)end {
    [EGGlobal.context.cullFace disabledF:^void() {
        GEVec2i vps = [EGGlobal.context viewport].size;
        GEVec2 rad = ((vps.y <= vps.x) ? GEVec2Make((radius * vps.y) / vps.x, radius) : GEVec2Make(radius, (radius * vps.x) / vps.y));
        [[EGD2D circleVaoWithSegment] drawParam:[EGCircleParam circleParamWithColor:backColor strokeColor:strokeColor position:at radius:rad relative:relative segment:[CNOption applyValue:[EGCircleSegment circleSegmentWithColor:segmentColor start:((float)(start)) end:((float)(end))]]]];
    }];
}

+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative {
    [EGGlobal.context.cullFace disabledF:^void() {
        GEVec2i vps = [EGGlobal.context viewport].size;
        GEVec2 rad = ((vps.y <= vps.x) ? GEVec2Make((radius * vps.y) / vps.x, radius) : GEVec2Make(radius, (radius * vps.x) / vps.y));
        [[EGD2D circleVaoWithoutSegment] drawParam:[EGCircleParam circleParamWithColor:backColor strokeColor:strokeColor position:at radius:rad relative:relative segment:[CNOption none]]];
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


@implementation EGCircleShaderBuilder{
    BOOL _segment;
}
static ODClassType* _EGCircleShaderBuilder_type;
@synthesize segment = _segment;

+ (id)circleShaderBuilderWithSegment:(BOOL)segment {
    return [[EGCircleShaderBuilder alloc] initWithSegment:segment];
}

- (id)initWithSegment:(BOOL)segment {
    self = [super init];
    if(self) _segment = segment;
    
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
        "uniform lowp vec2 radius;\n"
        "%@ highp vec2 coord;\n"
        "\n"
        "void main(void) {\n"
        "    highp vec4 pos = p*position;\n"
        "    pos.xy += model*radius;\n"
        "    gl_Position = pos;\n"
        "    coord = model;\n"
        "}", [self vertexHeader], [self ain], [self out]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@ highp vec2 coord;\n"
        "uniform lowp vec4 color;\n"
        "uniform lowp vec4 strokeColor;\n"
        "%@\n"
        "\n"
        "void main(void) {\n"
        "    lowp float tg = atan(coord.y, coord.x);\n"
        "    highp float dt = dot(coord, coord);\n"
        "    lowp float alpha = 0.0;\n"
        "%@\n"
        "}", [self fragmentHeader], [self in], ((_segment) ? @"uniform lowp vec4 sectorColor;\n"
        "uniform lowp float startTg;\n"
        "uniform lowp float endTg;" : @""), ((_segment) ? [NSString stringWithFormat:@"    if(endTg < startTg) {\n"
        "        alpha = sectorColor.w * clamp(\n"
        "            1.0 - smoothstep(0.95, 1.0, dt)\n"
        "            - (clamp(smoothstep(endTg - 0.1, endTg, tg) + 1.0 - smoothstep(startTg, startTg + 0.1, tg), 1.0, 2.0) - 1.0)\n"
        "        , 0.0, 1.0);\n"
        "    } else {\n"
        "        alpha = sectorColor.w * clamp(\n"
        "                1.0 - smoothstep(0.95, 1.0, dt)\n"
        "                - (1.0 - smoothstep(startTg, startTg + 0.1, tg))\n"
        "                - (smoothstep(endTg - 0.1, endTg, tg))\n"
        "        , 0.0, 1.0);\n"
        "    }\n"
        "    %@ = vec4(mix(\n"
        "            mix(color.xyz, sectorColor.xyz, alpha),\n"
        "            strokeColor.xyz, strokeColor.w*(smoothstep(0.75, 0.8, dt) - smoothstep(0.95, 1.0, dt))),\n"
        "        color.w * (1.0 - smoothstep(0.95, 1.0, dt)));", [self fragColor]] : [NSString stringWithFormat:@"    %@ = vec4(mix(color.xyz, strokeColor.xyz, strokeColor.w*(smoothstep(0.75, 0.8, dt) - smoothstep(0.95, 1.0, dt))),\n"
        "        color.w * (1.0 - smoothstep(0.95, 1.0, dt)));", [self fragColor]])];
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

- (NSString*)blendMode:(EGBlendMode*)mode a:(NSString*)a b:(NSString*)b {
    return mode.blend(a, b);
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
    EGCircleShaderBuilder* o = ((EGCircleShaderBuilder*)(other));
    return self.segment == o.segment;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.segment;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"segment=%d", self.segment];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCircleParam{
    GEVec4 _color;
    GEVec4 _strokeColor;
    GEVec3 _position;
    GEVec2 _radius;
    GEVec2 _relative;
    id _segment;
}
static ODClassType* _EGCircleParam_type;
@synthesize color = _color;
@synthesize strokeColor = _strokeColor;
@synthesize position = _position;
@synthesize radius = _radius;
@synthesize relative = _relative;
@synthesize segment = _segment;

+ (id)circleParamWithColor:(GEVec4)color strokeColor:(GEVec4)strokeColor position:(GEVec3)position radius:(GEVec2)radius relative:(GEVec2)relative segment:(id)segment {
    return [[EGCircleParam alloc] initWithColor:color strokeColor:strokeColor position:position radius:radius relative:relative segment:segment];
}

- (id)initWithColor:(GEVec4)color strokeColor:(GEVec4)strokeColor position:(GEVec3)position radius:(GEVec2)radius relative:(GEVec2)relative segment:(id)segment {
    self = [super init];
    if(self) {
        _color = color;
        _strokeColor = strokeColor;
        _position = position;
        _radius = radius;
        _relative = relative;
        _segment = segment;
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
    return GEVec4Eq(self.color, o.color) && GEVec4Eq(self.strokeColor, o.strokeColor) && GEVec3Eq(self.position, o.position) && GEVec2Eq(self.radius, o.radius) && GEVec2Eq(self.relative, o.relative) && [self.segment isEqual:o.segment];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + GEVec4Hash(self.strokeColor);
    hash = hash * 31 + GEVec3Hash(self.position);
    hash = hash * 31 + GEVec2Hash(self.radius);
    hash = hash * 31 + GEVec2Hash(self.relative);
    hash = hash * 31 + [self.segment hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", strokeColor=%@", GEVec4Description(self.strokeColor)];
    [description appendFormat:@", position=%@", GEVec3Description(self.position)];
    [description appendFormat:@", radius=%@", GEVec2Description(self.radius)];
    [description appendFormat:@", relative=%@", GEVec2Description(self.relative)];
    [description appendFormat:@", segment=%@", self.segment];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCircleSegment{
    GEVec4 _color;
    float _start;
    float _end;
}
static ODClassType* _EGCircleSegment_type;
@synthesize color = _color;
@synthesize start = _start;
@synthesize end = _end;

+ (id)circleSegmentWithColor:(GEVec4)color start:(float)start end:(float)end {
    return [[EGCircleSegment alloc] initWithColor:color start:start end:end];
}

- (id)initWithColor:(GEVec4)color start:(float)start end:(float)end {
    self = [super init];
    if(self) {
        _color = color;
        _start = start;
        _end = end;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCircleSegment_type = [ODClassType classTypeWithCls:[EGCircleSegment class]];
}

- (ODClassType*)type {
    return [EGCircleSegment type];
}

+ (ODClassType*)type {
    return _EGCircleSegment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGCircleSegment* o = ((EGCircleSegment*)(other));
    return GEVec4Eq(self.color, o.color) && eqf4(self.start, o.start) && eqf4(self.end, o.end);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec4Hash(self.color);
    hash = hash * 31 + float4Hash(self.start);
    hash = hash * 31 + float4Hash(self.end);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", start=%f", self.start];
    [description appendFormat:@", end=%f", self.end];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCircleShader{
    BOOL _segment;
    EGShaderAttribute* _model;
    EGShaderUniformVec4* _pos;
    EGShaderUniformMat4* _p;
    EGShaderUniformVec2* _radius;
    EGShaderUniformVec4* _color;
    EGShaderUniformVec4* _strokeColor;
    id _sectorColor;
    id _startTg;
    id _endTg;
}
static EGCircleShader* _EGCircleShader_withSegment;
static EGCircleShader* _EGCircleShader_withoutSegment;
static ODClassType* _EGCircleShader_type;
@synthesize segment = _segment;
@synthesize model = _model;
@synthesize pos = _pos;
@synthesize p = _p;
@synthesize radius = _radius;
@synthesize color = _color;
@synthesize strokeColor = _strokeColor;
@synthesize sectorColor = _sectorColor;
@synthesize startTg = _startTg;
@synthesize endTg = _endTg;

+ (id)circleShaderWithSegment:(BOOL)segment {
    return [[EGCircleShader alloc] initWithSegment:segment];
}

- (id)initWithSegment:(BOOL)segment {
    self = [super initWithProgram:[[EGCircleShaderBuilder circleShaderBuilderWithSegment:segment] program]];
    if(self) {
        _segment = segment;
        _model = [self attributeForName:@"model"];
        _pos = [self uniformVec4Name:@"position"];
        _p = [self uniformMat4Name:@"p"];
        _radius = [self uniformVec2Name:@"radius"];
        _color = [self uniformVec4Name:@"color"];
        _strokeColor = [self uniformVec4Name:@"strokeColor"];
        _sectorColor = ((_segment) ? [CNOption applyValue:[self uniformVec4Name:@"sectorColor"]] : [CNOption none]);
        _startTg = ((_segment) ? [CNOption applyValue:[self uniformF4Name:@"startTg"]] : [CNOption none]);
        _endTg = ((_segment) ? [CNOption applyValue:[self uniformF4Name:@"endTg"]] : [CNOption none]);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGCircleShader_type = [ODClassType classTypeWithCls:[EGCircleShader class]];
    _EGCircleShader_withSegment = [EGCircleShader circleShaderWithSegment:YES];
    _EGCircleShader_withoutSegment = [EGCircleShader circleShaderWithSegment:NO];
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_model setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
}

- (void)loadUniformsParam:(EGCircleParam*)param {
    [_pos applyVec4:geVec4AddVec2([[EGGlobal.matrix.value wc] mulVec4:geVec4ApplyVec3W(param.position, 1.0)], param.relative)];
    [_p applyMatrix:EGGlobal.matrix.value.p];
    [_radius applyVec2:param.radius];
    [_color applyVec4:param.color];
    [_strokeColor applyVec4:param.strokeColor];
    if(_segment) {
        EGCircleSegment* sec = [param.segment get];
        [((EGShaderUniformVec4*)([_sectorColor get])) applyVec4:sec.color];
        if(sec.start < sec.end) {
            [((EGShaderUniformF4*)([_startTg get])) applyF4:[self clampP:sec.start]];
            [((EGShaderUniformF4*)([_endTg get])) applyF4:[self clampP:sec.end]];
        } else {
            [((EGShaderUniformF4*)([_startTg get])) applyF4:[self clampP:sec.end]];
            [((EGShaderUniformF4*)([_endTg get])) applyF4:[self clampP:sec.start]];
        }
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

+ (EGCircleShader*)withSegment {
    return _EGCircleShader_withSegment;
}

+ (EGCircleShader*)withoutSegment {
    return _EGCircleShader_withoutSegment;
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
    EGCircleShader* o = ((EGCircleShader*)(other));
    return self.segment == o.segment;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.segment;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"segment=%d", self.segment];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSprite{
    EGMutableVertexBuffer* _vb;
    EGVertexArray* _vao;
    BOOL __changed;
    EGColorSource* __material;
    GEVec2 __position;
    GEVec2 __size;
}
static ODClassType* _EGSprite_type;

+ (id)sprite {
    return [[EGSprite alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _vb = [EGVBO mutDesc:EGBillboard.vbDesc];
        __changed = YES;
        __position = GEVec2Make(0.0, 0.0);
        __size = GEVec2Make(1.0, 1.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSprite_type = [ODClassType classTypeWithCls:[EGSprite class]];
}

+ (EGSprite*)applyMaterial:(EGColorSource*)material {
    EGSprite* s = [EGSprite sprite];
    [s setMaterial:material];
    return s;
}

+ (EGSprite*)applyMaterial:(EGColorSource*)material rect:(GERect)rect {
    EGSprite* s = [EGSprite sprite];
    [s setMaterial:material];
    [s setRect:rect];
    return s;
}

- (EGColorSource*)material {
    return __material;
}

- (void)setMaterial:(EGColorSource*)material {
    if(!([__material isEqual:material])) {
        __material = material;
        __changed = YES;
        _vao = [[EGMesh meshWithVertex:_vb index:EGEmptyIndexSource.triangleStrip] vaoShaderSystem:EGBillboardShaderSystem.instance material:material shadow:NO];
    }
}

- (void)draw {
    if(__changed) {
        CNVoidRefArray vertexes = cnVoidRefArrayApplyTpCount(egBillboardBufferDataType(), 4);
        [EGD2D writeSpriteIn:vertexes material:__material at:geVec3ApplyVec2Z(__position, 0.0) quad:geRectStripQuad(GERectMake(GEVec2Make(0.0, 0.0), __size)) uv:(([__material.texture isDefined]) ? geRectUpsideDownStripQuad([((EGTexture*)([[self material].texture get])) uv]) : geRectUpsideDownStripQuad(geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)))];
        [_vb setArray:vertexes];
        cnVoidRefArrayFree(vertexes);
        __changed = NO;
    }
    [EGGlobal.context.cullFace disabledF:^void() {
        [_vao draw];
    }];
}

- (GEVec2)position {
    return __position;
}

- (void)setPosition:(GEVec2)position {
    if(!(GEVec2Eq(__position, position))) {
        __position = position;
        __changed = YES;
    }
}

- (GEVec2)size {
    return __size;
}

- (void)setSize:(GEVec2)size {
    if(!(GEVec2Eq(__size, size))) {
        __size = size;
        __changed = YES;
    }
}

- (GERect)rect {
    return GERectMake(__position, __size);
}

- (void)setRect:(GERect)rect {
    [self setPosition:rect.p];
    [self setSize:rect.size];
}

+ (EGSprite*)applyTexture:(EGTexture*)texture {
    EGSprite* s = [EGSprite sprite];
    [s setMaterial:[EGColorSource applyTexture:texture]];
    return s;
}

- (void)adjustSize {
    if([__material.texture isDefined]) [self setSize:[((EGTexture*)([__material.texture get])) scaledSize]];
}

- (BOOL)containsVec2:(GEVec2)vec2 {
    return geRectContainsVec2(GERectMake(__position, __size), vec2);
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


@implementation EGButton{
    void(^_onDraw)(GERect);
    void(^_onClick)();
    GERect _rect;
}
static ODClassType* _EGButton_type;
@synthesize onDraw = _onDraw;
@synthesize onClick = _onClick;
@synthesize rect = _rect;

+ (id)buttonWithOnDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick {
    return [[EGButton alloc] initWithOnDraw:onDraw onClick:onClick];
}

- (id)initWithOnDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick {
    self = [super init];
    if(self) {
        _onDraw = onDraw;
        _onClick = onClick;
        _rect = geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGButton_type = [ODClassType classTypeWithCls:[EGButton class]];
}

+ (EGButton*)applyRect:(GERect)rect onDraw:(void(^)(GERect))onDraw onClick:(void(^)())onClick {
    EGButton* b = [EGButton buttonWithOnDraw:onDraw onClick:onClick];
    b.rect = rect;
    return b;
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    if(geRectContainsVec2(_rect, [event location])) {
        ((void(^)())(_onClick))();
        return YES;
    } else {
        return NO;
    }
}

- (void)draw {
    _onDraw(_rect);
}

+ (void(^)(GERect))drawTextFont:(EGFont*(^)())font color:(GEVec4)color text:(NSString*)text {
    EGText* tc = [EGText applyFont:nil text:text position:GEVec3Make(0.0, 0.0, 0.0) alignment:egTextAlignmentApplyXY(0.0, 0.0) color:color];
    return ^void(GERect rect) {
        [tc setFont:((EGFont*(^)())(font))()];
        [tc setPosition:geVec3ApplyVec2(geRectCenter(rect))];
        [tc draw];
    };
}

- (ODClassType*)type {
    return [EGButton type];
}

+ (ODClassType*)type {
    return _EGButton_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGButton* o = ((EGButton*)(other));
    return [self.onDraw isEqual:o.onDraw] && [self.onClick isEqual:o.onClick];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.onDraw hash];
    hash = hash * 31 + [self.onClick hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


