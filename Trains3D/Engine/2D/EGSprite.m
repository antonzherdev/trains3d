#import "EGSprite.h"

#import "EGVertex.h"
#import "EGIndex.h"
#import "EGSimpleShaderSystem.h"
#import "EGMaterial.h"
#import "EGTexture.h"
#import "EGContext.h"
@implementation EGD2D
static CNVoidRefArray _EGD2D_vertexes;
static EGMutableVertexBuffer* _EGD2D_vb;
static EGVertexArray* _EGD2D_vaoForColor;
static EGVertexArray* _EGD2D_vaoForTexture;
static EGMutableVertexBuffer* _EGD2D_lineVb;
static CNVoidRefArray _EGD2D_lineVertexes;
static EGVertexArray* _EGD2D_lineVao;
static CNLazy* _EGD2D__lazy_circleVb;
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
    _EGD2D__lazy_circleVb = [CNLazy lazyWithF:^EGMutableVertexBuffer*() {
        return [EGVBO mutDesc:EGBillboard.vbDesc];
    }];
    _EGD2D__lazy_circleVaoForColor = [CNLazy lazyWithF:^EGVertexArray*() {
        return [[EGMesh meshWithVertex:[EGD2D circleVb] index:EGEmptyIndexSource.triangleFan] vaoShader:[EGBillboardShader instanceForColor]];
    }];
}

+ (EGMutableVertexBuffer*)circleVb {
    return ((EGMutableVertexBuffer*)([_EGD2D__lazy_circleVb get]));
}

+ (EGVertexArray*)circleVaoForColor {
    return ((EGVertexArray*)([_EGD2D__lazy_circleVaoForColor get]));
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

+ (void)drawCircleMaterial:(EGColorSource*)material at:(GEVec3)at radius:(float)radius segments:(unsigned int)segments start:(CGFloat)start end:(CGFloat)end {
    CGFloat theta = (2 * M_PI) / segments;
    CGFloat c = cos(theta);
    CGFloat s = sin(theta);
    CGFloat t = 0.0;
    float x = radius;
    CGFloat y = 0.0;
    CNVoidRefArray vertexes = cnVoidRefArrayApplyTpCount(egBillboardBufferDataType(), ((NSUInteger)(segments + 2)));
    CNVoidRefArray v = vertexes;
    NSInteger ii = 0;
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, GEVec2Make(0.0, 0.0), material.color, GEVec2Make(0.0, 0.0)));
    while(ii <= segments) {
        v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, GEVec2Make(x, ((float)(y))), material.color, GEVec2Make(0.0, 0.0)));
        t = ((CGFloat)(x));
        x = ((float)(c * x - s * y));
        y = s * t + c * y;
        ii++;
    }
    [[EGD2D circleVb] setArray:vertexes];
    [EGGlobal.context.cullFace disabledF:^void() {
        [[EGD2D circleVaoForColor] drawParam:material];
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


