#import "EGSprite.h"

#import "EGMaterial.h"
#import "GL.h"
#import "EGTexture.h"
@implementation EGD2D
static CNVoidRefArray _EGD2D_vertexes;
static EGVertexBuffer* _EGD2D_vb;
static CNVoidRefArray _EGD2D_lineVertexes;
static ODClassType* _EGD2D_type;

+ (void)initialize {
    [super initialize];
    _EGD2D_type = [ODClassType classTypeWithCls:[EGD2D class]];
    _EGD2D_vertexes = cnVoidRefArrayApplyTpCount(egMeshDataType(), 4);
    _EGD2D_vb = [EGVertexBuffer mesh];
    _EGD2D_lineVertexes = cnVoidRefArrayApplyTpCount(egMeshDataType(), 2);
}

+ (void)drawSpriteMaterial:(EGColorSource*)material in:(GERect)in {
    [EGD2D drawSpriteMaterial:material in:in uv:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material in:(GERect)in uv:(GERect)uv {
    CNVoidRefArray v = _EGD2D_vertexes;
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(uv.p0, GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(in.p0, 0.0)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(geRectP1(uv), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(geRectP1(in), 0.0)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(geRectP2(uv), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(geRectP2(in), 0.0)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(geRectP3(uv), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(geRectP3(in), 0.0)));
    [_EGD2D_vb setArray:_EGD2D_vertexes];
    glDisable(GL_CULL_FACE);
    [material drawVb:_EGD2D_vb mode:GL_TRIANGLE_STRIP];
    glEnable(GL_CULL_FACE);
}

+ (void)drawLineMaterial:(EGColorSource*)material p0:(GEVec2)p0 p1:(GEVec2)p1 {
    CNVoidRefArray v = _EGD2D_lineVertexes;
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(GEVec2Make(0.0, 0.0), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(p0, 0.0)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(GEVec2Make(1.0, 1.0), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(p1, 0.0)));
    [_EGD2D_vb setArray:_EGD2D_lineVertexes];
    glDisable(GL_CULL_FACE);
    [material drawVb:_EGD2D_vb mode:((unsigned int)(GL_LINES))];
    glEnable(GL_CULL_FACE);
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
    [EGD2D drawSpriteMaterial:_material in:GERectMake(_position, _size) uv:_uv];
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


