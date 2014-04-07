#import "EGCircle.h"

#import "EGContext.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "GL.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
@implementation EGCircleShaderBuilder
static ODClassType* _EGCircleShaderBuilder_type;
@synthesize segment = _segment;

+ (instancetype)circleShaderBuilderWithSegment:(BOOL)segment {
    return [[EGCircleShaderBuilder alloc] initWithSegment:segment];
}

- (instancetype)initWithSegment:(BOOL)segment {
    self = [super init];
    if(self) _segment = segment;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCircleShaderBuilder class]) _EGCircleShaderBuilder_type = [ODClassType classTypeWithCls:[EGCircleShaderBuilder class]];
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
        "   %@\n"
        "}", [self fragmentHeader], [self in], ((_segment) ? @"uniform lowp vec4 sectorColor;\n"
        "uniform lowp float startTg;\n"
        "uniform lowp float endTg;" : @""), ((_segment) ? [NSString stringWithFormat:@"    if(endTg < startTg) {\n"
        "        alpha = sectorColor.w * clamp(\n"
        "            1.0 - smoothstep(0.95, 1.0, dt)\n"
        "            - (clamp(smoothstep(endTg - 0.1, endTg, tg) + 1.0 - smoothstep(startTg, startTg + 0.1, tg), 1.0, 2.0) - 1.0)\n"
        "            , 0.0, 1.0);\n"
        "    } else {\n"
        "        alpha = sectorColor.w * clamp(\n"
        "            1.0 - smoothstep(0.95, 1.0, dt)\n"
        "            - (1.0 - smoothstep(startTg, startTg + 0.1, tg))\n"
        "            - (smoothstep(endTg - 0.1, endTg, tg))\n"
        "            , 0.0, 1.0);\n"
        "    }\n"
        "    %@ = vec4(mix(\n"
        "        mix(color.xyz, sectorColor.xyz, alpha),\n"
        "        strokeColor.xyz, strokeColor.w*(smoothstep(0.75, 0.8, dt) - smoothstep(0.95, 1.0, dt))),\n"
        "        color.w * (1.0 - smoothstep(0.95, 1.0, dt)));\n"
        "   ", [self fragColor]] : [NSString stringWithFormat:@"    %@ = vec4(mix(color.xyz, strokeColor.xyz, strokeColor.w*(smoothstep(0.75, 0.8, dt) - smoothstep(0.95, 1.0, dt))),\n"
        "        color.w * (1.0 - smoothstep(0.95, 1.0, dt)));\n"
        "   ", [self fragColor]])];
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
    return [EGCircleShaderBuilder type];
}

+ (ODClassType*)type {
    return _EGCircleShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"segment=%d", self.segment];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCircleParam
static ODClassType* _EGCircleParam_type;
@synthesize color = _color;
@synthesize strokeColor = _strokeColor;
@synthesize position = _position;
@synthesize radius = _radius;
@synthesize relative = _relative;
@synthesize segment = _segment;

+ (instancetype)circleParamWithColor:(GEVec4)color strokeColor:(GEVec4)strokeColor position:(GEVec3)position radius:(GEVec2)radius relative:(GEVec2)relative segment:(EGCircleSegment*)segment {
    return [[EGCircleParam alloc] initWithColor:color strokeColor:strokeColor position:position radius:radius relative:relative segment:segment];
}

- (instancetype)initWithColor:(GEVec4)color strokeColor:(GEVec4)strokeColor position:(GEVec3)position radius:(GEVec2)radius relative:(GEVec2)relative segment:(EGCircleSegment*)segment {
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
    if(self == [EGCircleParam class]) _EGCircleParam_type = [ODClassType classTypeWithCls:[EGCircleParam class]];
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


@implementation EGCircleSegment
static ODClassType* _EGCircleSegment_type;
@synthesize color = _color;
@synthesize start = _start;
@synthesize end = _end;

+ (instancetype)circleSegmentWithColor:(GEVec4)color start:(float)start end:(float)end {
    return [[EGCircleSegment alloc] initWithColor:color start:start end:end];
}

- (instancetype)initWithColor:(GEVec4)color start:(float)start end:(float)end {
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
    if(self == [EGCircleSegment class]) _EGCircleSegment_type = [ODClassType classTypeWithCls:[EGCircleSegment class]];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"color=%@", GEVec4Description(self.color)];
    [description appendFormat:@", start=%f", self.start];
    [description appendFormat:@", end=%f", self.end];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGCircleShader
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

+ (instancetype)circleShaderWithSegment:(BOOL)segment {
    return [[EGCircleShader alloc] initWithSegment:segment];
}

- (instancetype)initWithSegment:(BOOL)segment {
    self = [super initWithProgram:[[EGCircleShaderBuilder circleShaderBuilderWithSegment:segment] program]];
    if(self) {
        _segment = segment;
        _model = [self attributeForName:@"model"];
        _pos = [self uniformVec4Name:@"position"];
        _p = [self uniformMat4Name:@"p"];
        _radius = [self uniformVec2Name:@"radius"];
        _color = [self uniformVec4Name:@"color"];
        _strokeColor = [self uniformVec4Name:@"strokeColor"];
        _sectorColor = ((_segment) ? [self uniformVec4Name:@"sectorColor"] : nil);
        _startTg = ((_segment) ? [self uniformF4Name:@"startTg"] : nil);
        _endTg = ((_segment) ? [self uniformF4Name:@"endTg"] : nil);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCircleShader class]) {
        _EGCircleShader_type = [ODClassType classTypeWithCls:[EGCircleShader class]];
        _EGCircleShader_withSegment = [EGCircleShader circleShaderWithSegment:YES];
        _EGCircleShader_withoutSegment = [EGCircleShader circleShaderWithSegment:NO];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_model setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
}

- (void)loadUniformsParam:(EGCircleParam*)param {
    [_pos applyVec4:geVec4AddVec2(([[[EGGlobal.matrix value] wc] mulVec4:geVec4ApplyVec3W(((EGCircleParam*)(param)).position, 1.0)]), ((EGCircleParam*)(param)).relative)];
    [_p applyMatrix:[[EGGlobal.matrix value] p]];
    [_radius applyVec2:((EGCircleParam*)(param)).radius];
    [_color applyVec4:((EGCircleParam*)(param)).color];
    [_strokeColor applyVec4:((EGCircleParam*)(param)).strokeColor];
    if(_segment) {
        EGCircleSegment* sec = ((EGCircleSegment*)(((EGCircleParam*)(param)).segment));
        if(sec != nil) {
            [_sectorColor applyVec4:((EGCircleSegment*)(sec)).color];
            if(((EGCircleSegment*)(sec)).start < ((EGCircleSegment*)(sec)).end) {
                [_startTg applyF4:[self clampP:((EGCircleSegment*)(sec)).start]];
                [_endTg applyF4:[self clampP:((EGCircleSegment*)(sec)).end]];
            } else {
                [_startTg applyF4:[self clampP:((EGCircleSegment*)(sec)).end]];
                [_endTg applyF4:[self clampP:((EGCircleSegment*)(sec)).start]];
            }
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"segment=%d", self.segment];
    [description appendString:@">"];
    return description;
}

@end


