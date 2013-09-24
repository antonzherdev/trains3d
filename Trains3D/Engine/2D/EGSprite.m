#import "EGSprite.h"

#import "EGMaterial.h"
#import "GL.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "GEMat4.h"
@implementation EGSprite
static CNVoidRefArray _EGSprite_vertexes;
static EGVertexBuffer* _EGSprite_vb;
static ODClassType* _EGSprite_type;

+ (void)initialize {
    [super initialize];
    _EGSprite_type = [ODClassType classTypeWithCls:[EGSprite class]];
    _EGSprite_vertexes = cnVoidRefArrayApplyTpCount(egMeshDataType(), 4);
    _EGSprite_vb = [EGVertexBuffer mesh];
}

+ (void)drawMaterial:(EGColorSource*)material in:(GERect)in {
    [EGSprite drawMaterial:material in:in uv:geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0)];
}

+ (void)drawMaterial:(EGColorSource*)material in:(GERect)in uv:(GERect)uv {
    CNVoidRefArray v = _EGSprite_vertexes;
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(geRectLeftBottom(uv), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(geRectLeftBottom(in), 0.0)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(geRectLeftTop(uv), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(geRectLeftTop(in), 0.0)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(geRectRightBottom(uv), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(geRectRightBottom(in), 0.0)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(geRectRightTop(uv), GEVec3Make(0.0, 0.0, 1.0), geVec3ApplyVec2Z(geRectRightTop(in), 0.0)));
    [_EGSprite_vb setArray:_EGSprite_vertexes];
    glDisable(GL_CULL_FACE);
    [material drawVb:_EGSprite_vb mode:GL_TRIANGLE_STRIP];
    glEnable(GL_CULL_FACE);
}

+ (void)fixedDrawMaterial:(EGColorSource*)material uv:(GERect)uv at:(GEVec2)at alignment:(GEVec2)alignment {
    GEVec2 size = geVec2MulI(geVec2DivVec2(geVec2MulVec2([((EGTexture*)([material.texture get])) size], uv.size), geVec2ApplyVec2i([EGGlobal.context viewport].size)), 2);
    EGMatrixModel* m = EGGlobal.context.matrixStack.value;
    EGGlobal.context.matrixStack.value = EGMatrixModel.identity;
    [EGSprite drawMaterial:material in:GERectMake(geVec2SubVec2(geVec4Xy([[m mwcp] mulVec4:GEVec4Make(at.x, at.y, 0.0, 1.0)]), geVec2MulVec2(size, geVec2AddF(geVec2DivI(alignment, 2), 0.5))), size) uv:uv];
    EGGlobal.context.matrixStack.value = m;
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


