#import "EGCircle.h"

#import "EGVertex.h"
#import "GL.h"
#import "EGContext.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
#import "math.h"
@implementation EGCircleShaderBuilder
static CNClassType* _EGCircleShaderBuilder_type;
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
    if(self == [EGCircleShaderBuilder class]) _EGCircleShaderBuilder_type = [CNClassType classTypeWithCls:[EGCircleShaderBuilder class]];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"CircleShaderBuilder(%d)", _segment];
}

- (CNClassType*)type {
    return [EGCircleShaderBuilder type];
}

+ (CNClassType*)type {
    return _EGCircleShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGCircleParam
static CNClassType* _EGCircleParam_type;
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
    if(self == [EGCircleParam class]) _EGCircleParam_type = [CNClassType classTypeWithCls:[EGCircleParam class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CircleParam(%@, %@, %@, %@, %@, %@)", geVec4Description(_color), geVec4Description(_strokeColor), geVec3Description(_position), geVec2Description(_radius), geVec2Description(_relative), _segment];
}

- (CNClassType*)type {
    return [EGCircleParam type];
}

+ (CNClassType*)type {
    return _EGCircleParam_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGCircleSegment
static CNClassType* _EGCircleSegment_type;
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
    if(self == [EGCircleSegment class]) _EGCircleSegment_type = [CNClassType classTypeWithCls:[EGCircleSegment class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"CircleSegment(%@, %f, %f)", geVec4Description(_color), _start, _end];
}

- (CNClassType*)type {
    return [EGCircleSegment type];
}

+ (CNClassType*)type {
    return _EGCircleSegment_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGCircleShader
static EGCircleShader* _EGCircleShader_withSegment;
static EGCircleShader* _EGCircleShader_withoutSegment;
static CNClassType* _EGCircleShader_type;
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
        _sectorColor = ((segment) ? [self uniformVec4Name:@"sectorColor"] : nil);
        _startTg = ((segment) ? [self uniformF4Name:@"startTg"] : nil);
        _endTg = ((segment) ? [self uniformF4Name:@"endTg"] : nil);
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGCircleShader class]) {
        _EGCircleShader_type = [CNClassType classTypeWithCls:[EGCircleShader class]];
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
        EGCircleSegment* sec = ((EGCircleParam*)(param)).segment;
        if(sec != nil) {
            [((EGShaderUniformVec4*)(_sectorColor)) applyVec4:((EGCircleSegment*)(sec)).color];
            if(((EGCircleSegment*)(sec)).start < ((EGCircleSegment*)(sec)).end) {
                [((EGShaderUniformF4*)(_startTg)) applyF4:[self clampP:((EGCircleSegment*)(sec)).start]];
                [((EGShaderUniformF4*)(_endTg)) applyF4:[self clampP:((EGCircleSegment*)(sec)).end]];
            } else {
                [((EGShaderUniformF4*)(_startTg)) applyF4:[self clampP:((EGCircleSegment*)(sec)).end]];
                [((EGShaderUniformF4*)(_endTg)) applyF4:[self clampP:((EGCircleSegment*)(sec)).start]];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"CircleShader(%d)", _segment];
}

- (CNClassType*)type {
    return [EGCircleShader type];
}

+ (EGCircleShader*)withSegment {
    return _EGCircleShader_withSegment;
}

+ (EGCircleShader*)withoutSegment {
    return _EGCircleShader_withoutSegment;
}

+ (CNClassType*)type {
    return _EGCircleShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

