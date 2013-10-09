#import "EGD3D.h"

#import "EGMaterial.h"
#import "EGContext.h"
#import "GL.h"
@implementation EGD3D
static CNVoidRefArray _EGD3D_vertexes;
static EGVertexBuffer* _EGD3D_vb;
static GEQuad _EGD3D_defaultQuadUv;
static ODClassType* _EGD3D_type;

+ (void)initialize {
    [super initialize];
    _EGD3D_type = [ODClassType classTypeWithCls:[EGD3D class]];
    _EGD3D_vertexes = cnVoidRefArrayApplyTpCount(egMeshDataType(), 4);
    _EGD3D_vb = [EGVertexBuffer mesh];
    _EGD3D_defaultQuadUv = geQuadApplyP0P1P2P3(GEVec2Make(0.0, 0.0), GEVec2Make(0.0, 1.0), GEVec2Make(1.0, 0.0), GEVec2Make(1.0, 1.0));
}

+ (void)drawQuadMaterial:(EGColorSource*)material quad3:(GEQuad3)quad3 {
    [EGD3D drawQuadMaterial:material quad3:quad3 uv:_EGD3D_defaultQuadUv];
}

+ (void)drawQuadMaterial:(EGColorSource*)material quad3:(GEQuad3)quad3 uv:(GEQuad)uv {
    CNVoidRefArray v = _EGD3D_vertexes;
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(uv.p[0], quad3.planeCoord.plane.n, geQuad3P0(quad3)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(uv.p[1], quad3.planeCoord.plane.n, geQuad3P1(quad3)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(uv.p[2], quad3.planeCoord.plane.n, geQuad3P2(quad3)));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, EGMeshDataMake(uv.p[3], quad3.planeCoord.plane.n, geQuad3P3(quad3)));
    [_EGD3D_vb setArray:_EGD3D_vertexes];
    [EGGlobal.context.cullFace disabledF:^void() {
        [material drawVb:_EGD3D_vb mode:GL_TRIANGLE_STRIP];
    }];
}

- (ODClassType*)type {
    return [EGD3D type];
}

+ (ODClassType*)type {
    return _EGD3D_type;
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


