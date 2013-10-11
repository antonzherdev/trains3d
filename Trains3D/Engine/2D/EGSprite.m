#import "EGSprite.h"

#import "EGVertex.h"
#import "EGIndex.h"
#import "EGSimpleShaderSystem.h"
#import "EGMaterial.h"
#import "EGContext.h"
#import "EGShader.h"
#import "EGTexture.h"
@implementation EGD2D
static CNVoidRefArray _EGD2D_vertexes;
static EGMutableVertexBuffer* _EGD2D_vb;
static EGMutableVertexBuffer* _EGD2D_lineVb;
static CNVoidRefArray _EGD2D_lineVertexes;
static EGVertexArray* _EGD2D_lineVao;
static ODClassType* _EGD2D_type;

+ (void)initialize {
    [super initialize];
    _EGD2D_type = [ODClassType classTypeWithCls:[EGD2D class]];
    _EGD2D_vertexes = cnVoidRefArrayApplyTpCount(egBillboardBufferDataType(), 4);
    _EGD2D_vb = [EGVBO mutDesc:EGBillboard.vbDesc];
    _EGD2D_lineVb = [EGVBO mutMesh];
    _EGD2D_lineVertexes = cnVoidRefArrayApplyTpCount(egMeshDataType(), 2);
    _EGD2D_lineVao = [[EGMesh meshWithVertex:_EGD2D_lineVb index:EGEmptyIndexSource.lines] vaoShader:EGSimpleShaderSystem.colorShader];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at rect:(GERect)rect {
    [EGD2D drawSpriteMaterial:material at:at quad:geRectQuad(rect) uv:geRectQuad(geRectApplyXYWidthHeight(1.0, 1.0, -1.0, -1.0))];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv {
    CNVoidRefArray v = _EGD2D_vertexes;
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[0], material.color, uv.p[0]));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[1], material.color, uv.p[1]));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[2], material.color, uv.p[2]));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, EGBillboardBufferDataMake(at, quad.p[3], material.color, uv.p[3]));
    [_EGD2D_vb setArray:_EGD2D_vertexes];
    [EGGlobal.context.cullFace disabledF:^void() {
        [[EGBillboardShaderSystem.instance shaderForParam:material] drawParam:material vertex:_EGD2D_vb index:EGEmptyIndexSource.triangleStrip];
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
    GERect _uv;
    GEVec2 _position;
    GEVec2 _size;
}
static ODClassType* _EGSprite_type;
@synthesize material = _material;
@synthesize uv = _uv;
@synthesize position = _position;
@synthesize size = _size;

+ (id)sprite {
    return [[EGSprite alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _uv = geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0);
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
    [EGD2D drawSpriteMaterial:_material at:geVec3ApplyVec2Z(_position, 0.0) quad:geRectQuad(GERectMake(GEVec2Make(0.0, 0.0), _size)) uv:geRectQuad(_uv)];
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

+ (EGSprite*)applyMaterial:(EGColorSource*)material uv:(GERect)uv pixelsInPoint:(float)pixelsInPoint {
    EGSprite* s = [EGSprite sprite];
    s.material = material;
    s.uv = [((EGTexture*)([material.texture get])) uvRect:uv];
    s.size = geVec2DivF4(uv.size, pixelsInPoint);
    return s;
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


