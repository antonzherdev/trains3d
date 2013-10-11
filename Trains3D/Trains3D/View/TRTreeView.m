#import "TRTreeView.h"

#import "TRTree.h"
#import "EGTexture.h"
#import "GL.h"
#import "EGContext.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "EGIndex.h"
#import "EGMesh.h"
#import "EGSprite.h"
@implementation TRTreeView{
    TRForest* _forest;
    EGTexture* _texture;
    EGColorSource* _material;
    EGMutableVertexBuffer* _vb;
    EGMutableIndexBuffer* _ib;
    EGVertexArray* _mesh;
}
static ODClassType* _TRTreeView_type;
@synthesize forest = _forest;
@synthesize texture = _texture;
@synthesize material = _material;

+ (id)treeViewWithForest:(TRForest*)forest {
    return [[TRTreeView alloc] initWithForest:forest];
}

- (id)initWithForest:(TRForest*)forest {
    self = [super init];
    if(self) {
        _forest = forest;
        _texture = [EGGlobal textureForFile:@"Pine.png" magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_LINEAR];
        _material = [EGColorSource colorSourceWithColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:[CNOption applyValue:_texture] alphaTestLevel:0.3];
        _vb = [EGVBO mutDesc:EGBillboard.vbDesc];
        _ib = [EGIBO mut];
        _mesh = [[EGMesh meshWithVertex:_vb index:_ib] vaoShaderSystem:EGBillboardShaderSystem.instance material:_material shadow:YES];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeView_type = [ODClassType classTypeWithCls:[TRTreeView class]];
}

- (void)prepare {
    CNVoidRefArray ar = cnVoidRefArrayApplyTpCount(egBillboardBufferDataType(), ((NSUInteger)(8 * [[_forest trees] count])));
    CNVoidRefArray iar = cnVoidRefArrayApplyTpCount(oduInt4Type(), ((NSUInteger)(12 * [[_forest trees] count])));
    __block CNVoidRefArray a = ar;
    __block CNVoidRefArray ia = iar;
    __block unsigned int i = 0;
    [[_forest trees] forEach:^void(TRTree* tree) {
        a = [self writeA:a tree:tree];
        ia = [EGD2D writeQuadIndexIn:ia i:i];
        ia = [EGD2D writeQuadIndexIn:ia i:i + 4];
        i += 8;
    }];
    [_vb setArray:ar];
    [_ib setArray:iar];
    cnVoidRefArrayFree(ar);
    cnVoidRefArrayFree(iar);
}

- (void)draw {
    [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.cullFace disabledF:^void() {
            [_mesh draw];
        }];
    }];
}

- (CNVoidRefArray)writeA:(CNVoidRefArray)a tree:(TRTree*)tree {
    CGFloat uvw = tree.treeType.width;
    GEQuad mainUv = geRectUpsideDownQuad(geRectApplyXYWidthHeight(0.0, 0.0, ((float)(uvw)), 1.0));
    GEQuad rustleUv = geQuadAddVec2(mainUv, GEVec2Make(((float)(uvw)), 0.0));
    GEPlaneCoord planeCoord = GEPlaneCoordMake(GEPlaneMake(GEVec3Make(0.0, 0.0, 0.0), GEVec3Make(0.0, 0.0, 1.0)), GEVec3Make(1.0, 0.0, 0.0), GEVec3Make(0.0, 1.0, 0.0));
    GEPlaneCoord mPlaneCoord = gePlaneCoordSetY(planeCoord, geVec3Normalize(geVec3AddVec3(planeCoord.y, GEVec3Make([tree incline].x, 0.0, [tree incline].y))));
    NSUInteger tp = tree.treeType.ordinal;
    GEQuad quad = geRectQuad(geRectMulVec2(geRectCenterX(geRectApplyXYWidthHeight(0.0, 0.0, [_texture size].x / ([_texture size].y * 4), 0.5)), tree.size));
    GEQuad3 quad3 = GEQuad3Make(mPlaneCoord, quad);
    GEQuad mQuad = geQuadApplyP0P1P2P3(geVec3Xy(geQuad3P0(quad3)), geVec3Xy(geQuad3P1(quad3)), geVec3Xy(geQuad3P2(quad3)), geVec3Xy(geQuad3P3(quad3)));
    a = [EGD2D writeSpriteIn:a material:_material at:geVec3ApplyVec2Z(tree.position, 0.0) quad:mQuad uv:mainUv];
    CGFloat r = tree.rustle * 0.04;
    GEPlaneCoord rPlaneCoord = gePlaneCoordSetX(mPlaneCoord, geVec3AddVec3(mPlaneCoord.x, GEVec3Make(0.0, ((float)(r)), 0.0)));
    GEQuad3 rQuad3 = GEQuad3Make(rPlaneCoord, quad);
    a = [EGD2D writeSpriteIn:a material:_material at:geVec3ApplyVec2Z(tree.position, 0.0) quad:geQuadApplyP0P1P2P3(geVec3Xy(geQuad3P0(rQuad3)), geVec3Xy(geQuad3P1(rQuad3)), geVec3Xy(geQuad3P2(rQuad3)), geVec3Xy(geQuad3P3(rQuad3))) uv:rustleUv];
    return a;
}

- (ODClassType*)type {
    return [TRTreeView type];
}

+ (ODClassType*)type {
    return _TRTreeView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTreeView* o = ((TRTreeView*)(other));
    return [self.forest isEqual:o.forest];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.forest hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"forest=%@", self.forest];
    [description appendString:@">"];
    return description;
}

@end


