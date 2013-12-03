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
    EGVertexArray* _vao;
    EGColorSource* _shadowMaterial;
    EGVertexArray* _shadowVao;
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
        _texture = [EGGlobal textureForFile:[NSString stringWithFormat:@"%@.png", _forest.rules.forestType.name] magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST];
        _material = [EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:_texture];
        _vb = [EGVBO mutDesc:EGBillboard.vbDesc];
        _ib = [EGIBO mut];
        _vao = [[EGMesh meshWithVertex:_vb index:_ib] vaoShaderSystem:EGBillboardShaderSystem.instance material:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:_texture] shadow:NO];
        _shadowMaterial = [EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:_texture alphaTestLevel:0.1];
        _shadowVao = [[EGMesh meshWithVertex:_vb index:_ib] vaoShader:[EGBillboardShaderSystem.instance shaderForParam:_shadowMaterial renderTarget:EGShadowRenderTarget.aDefault]];
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
            if([EGGlobal.context.renderTarget isShadow]) [_shadowVao drawParam:_shadowMaterial];
            else [_vao draw];
        }];
    }];
}

- (CNVoidRefArray)writeA:(CNVoidRefArray)a tree:(TRTree*)tree {
    TRTreeType* tp = tree.treeType;
    GEQuad mainUv = tp.uvQuad;
    GEQuad rustleUv = geQuadAddVec2(mainUv, GEVec2Make(geRectWidth(tp.uv), 0.0));
    GEPlaneCoord planeCoord = GEPlaneCoordMake(GEPlaneMake(GEVec3Make(0.0, 0.0, 0.0), GEVec3Make(0.0, 0.0, 1.0)), GEVec3Make(1.0, 0.0, 0.0), GEVec3Make(0.0, 1.0, 0.0));
    GEPlaneCoord mPlaneCoord = gePlaneCoordSetY(planeCoord, geVec3Normalize(geVec3AddVec3(planeCoord.y, GEVec3Make([tree incline].x, 0.0, [tree incline].y))));
    GEQuad quad = geRectStripQuad(geRectMulVec2(geRectCenterX(geRectApplyXYSize(0.0, 0.0, tp.size)), tree.size));
    GEQuad3 quad3 = GEQuad3Make(mPlaneCoord, quad);
    GEQuad mQuad = GEQuadMake(geVec3Xy(geQuad3P0(quad3)), geVec3Xy(geQuad3P1(quad3)), geVec3Xy(geQuad3P2(quad3)), geVec3Xy(geQuad3P3(quad3)));
    CNVoidRefArray aa = a;
    aa = [EGD2D writeSpriteIn:aa material:_material at:geVec3ApplyVec2Z(tree.position, 0.0) quad:mQuad uv:mainUv];
    CGFloat r = tree.rustle * 0.1 * tp.rustleStrength;
    GEPlaneCoord rPlaneCoord = gePlaneCoordSetY(gePlaneCoordSetX(mPlaneCoord, geVec3AddVec3(mPlaneCoord.x, GEVec3Make(0.0, ((float)(r)), 0.0))), geVec3SubVec3(mPlaneCoord.y, GEVec3Make(((float)(r)), 0.0, 0.0)));
    GEQuad3 rQuad3 = GEQuad3Make(rPlaneCoord, quad);
    aa = [EGD2D writeSpriteIn:aa material:_material at:geVec3ApplyVec2Z(geVec2AddVec2(tree.position, GEVec2Make(0.001, -0.001)), 0.0) quad:GEQuadMake(geVec3Xy(geQuad3P0(rQuad3)), geVec3Xy(geQuad3P1(rQuad3)), geVec3Xy(geQuad3P2(rQuad3)), geVec3Xy(geQuad3P3(rQuad3))) uv:rustleUv];
    return aa;
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


