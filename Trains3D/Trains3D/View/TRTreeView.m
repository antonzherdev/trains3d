#import "TRTreeView.h"

#import "TRTree.h"
#import "EGContext.h"
#import "EGTexture.h"
#import "EGSprite.h"
@implementation TRTreeView{
    TRForest* _forest;
    id<CNSeq> _textures;
    id<CNSeq> _materials;
    id<CNSeq> _rects;
}
static ODClassType* _TRTreeView_type;
@synthesize forest = _forest;
@synthesize textures = _textures;
@synthesize materials = _materials;
@synthesize rects = _rects;

+ (id)treeViewWithForest:(TRForest*)forest {
    return [[TRTreeView alloc] initWithForest:forest];
}

- (id)initWithForest:(TRForest*)forest {
    self = [super init];
    if(self) {
        _forest = forest;
        _textures = (@[[EGGlobal textureForFile:@"Pine.png"], [EGGlobal textureForFile:@"Tree1.png"], [EGGlobal textureForFile:@"Tree2.png"], [EGGlobal textureForFile:@"Tree3.png"], [EGGlobal textureForFile:@"YellowTree.png"]]);
        _materials = [[[_textures chain] map:^EGColorSource*(EGTexture* _) {
            return [EGColorSource colorSourceWithColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:[CNOption applyValue:_] alphaTestLevel:0.3];
        }] toArray];
        _rects = [[[_textures chain] map:^id(EGTexture* _) {
            return wrap(GERect, geRectCenterX(geRectApplyXYWidthHeight(0.0, 0.0, [_ size].x / ([_ size].y * 4), [_ size].y / ([_ size].y * 2))));
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeView_type = [ODClassType classTypeWithCls:[TRTreeView class]];
}

- (void)draw {
    egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
        [[_forest trees] forEach:^void(TRTree* _) {
            [self drawTree:_];
        }];
    });
}

- (void)drawTree:(TRTree*)tree {
    CGFloat uvw = tree.treeType.width;
    GEQuad mainUv = geRectUpsideDownQuad(geRectApplyXYWidthHeight(0.0, 0.0, ((float)(uvw)), 1.0));
    GEQuad rustleUv = geQuadAddVec2(mainUv, GEVec2Make(((float)(uvw)), 0.0));
    GEPlaneCoord planeCoord = GEPlaneCoordMake(GEPlaneMake(GEVec3Make(0.0, 0.0, 0.0), GEVec3Make(0.0, 0.0, 1.0)), GEVec3Make(1.0, 0.0, 0.0), GEVec3Make(0.0, 1.0, 0.0));
    GEPlaneCoord mPlaneCoord = gePlaneCoordSetY(planeCoord, geVec3Normalize(geVec3AddVec3(planeCoord.y, GEVec3Make([tree incline].x, 0.0, [tree incline].y))));
    NSUInteger tp = tree.treeType.ordinal;
    GEQuad quad = geRectQuad(geRectMulVec2(uwrap(GERect, [_rects applyIndex:tp]), tree.size));
    GEQuad3 quad3 = GEQuad3Make(mPlaneCoord, quad);
    GEQuad mQuad = geQuadApplyP0P1P2P3(geVec3Xy(geQuad3P0(quad3)), geVec3Xy(geQuad3P1(quad3)), geVec3Xy(geQuad3P2(quad3)), geVec3Xy(geQuad3P3(quad3)));
    [EGD2D drawSpriteMaterial:((EGColorSource*)([_materials applyIndex:tp])) at:geVec3ApplyVec2Z(tree.position, 0.0) quad:mQuad uv:mainUv];
    CGFloat r = tree.rustle * 0.04;
    GEPlaneCoord rPlaneCoord = gePlaneCoordSetX(mPlaneCoord, geVec3AddVec3(mPlaneCoord.x, GEVec3Make(0.0, ((float)(r)), 0.0)));
    GEQuad3 rQuad3 = GEQuad3Make(rPlaneCoord, quad);
    [EGD2D drawSpriteMaterial:((EGColorSource*)([_materials applyIndex:tp])) at:geVec3ApplyVec2Z(tree.position, 0.0) quad:geQuadApplyP0P1P2P3(geVec3Xy(geQuad3P0(rQuad3)), geVec3Xy(geQuad3P1(rQuad3)), geVec3Xy(geQuad3P2(rQuad3)), geVec3Xy(geQuad3P3(rQuad3))) uv:rustleUv];
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


