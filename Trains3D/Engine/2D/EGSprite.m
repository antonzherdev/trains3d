#import "EGSprite.h"

#import "EGMaterial.h"
#import "GL.h"
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


