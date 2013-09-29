#import "TRTreeView.h"

#import "TRTree.h"
#import "EGContext.h"
#import "EGTexture.h"
#import "GL.h"
#import "TRWeather.h"
#import "EGBillboard.h"
@implementation TRTreeView{
    TRForest* _forest;
    id<CNSeq> _textures;
    id<CNSeq> _materials;
    id<CNSeq> _rects;
    GEQuad _mainUv;
    GEQuad _rustleUv;
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
            return [EGColorSource applyTexture:_];
        }] toArray];
        _rects = [[[_textures chain] map:^id(EGTexture* _) {
            return wrap(GERect, geRectCenterX(geRectApplyXYWidthHeight(0.0, 0.0, [_ size].x / ([_ size].y * 4), [_ size].y / ([_ size].y * 2))));
        }] toArray];
        _mainUv = geRectUpsideDownQuad(geRectApplyXYWidthHeight(0.0, 0.0, 0.5, 1.0));
        _rustleUv = geRectUpsideDownQuad(geRectApplyXYWidthHeight(0.5, 0.0, 0.5, 1.0));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeView_type = [ODClassType classTypeWithCls:[TRTreeView class]];
}

- (void)draw {
    glAlphaFunc(GL_GREATER, 0.3);
    glEnable(GL_ALPHA_TEST);
    GEVec2 wind = [_forest.weather wind];
    GEPlaneCoord planeCoord = GEPlaneCoordMake(GEPlaneMake(GEVec3Make(0.0, 0.0, 0.0), GEVec3Make(0.0, 0.0, 1.0)), GEVec3Make(1.0, 0.0, 0.0), GEVec3Make(0.0, 1.0, 0.0));
    GEPlaneCoord mPlaneCoord = gePlaneCoordSetY(planeCoord, geVec3Normalize(geVec3AddVec3(planeCoord.y, GEVec3Make(wind.x, 0.0, wind.y))));
    egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
        [[_forest trees] forEach:^void(TRTree* _) {
            [self drawTree:_ planeCoord:mPlaneCoord];
        }];
    });
    glDisable(GL_ALPHA_TEST);
}

- (void)drawTree:(TRTree*)tree planeCoord:(GEPlaneCoord)planeCoord {
    NSUInteger tp = tree.treeType.ordinal;
    GEQuad quad = geRectQuad(geRectMulVec2(uwrap(GERect, [_rects applyIndex:tp]), tree.size));
    GEQuad3 quad3 = GEQuad3Make(planeCoord, quad);
    GEQuad mQuad = geQuadApplyP0P1P2P3(geVec3Xy(geQuad3P0(quad3)), geVec3Xy(geQuad3P1(quad3)), geVec3Xy(geQuad3P2(quad3)), geVec3Xy(geQuad3P3(quad3)));
    [EGBillboard drawMaterial:((EGColorSource*)([_materials applyIndex:tp])) at:geVec3ApplyVec2Z(tree.position, 0.0) quad:mQuad uv:_mainUv];
    CGFloat r = tree.rustle * 0.003;
    GEPlaneCoord rPlaneCoord = gePlaneCoordSetX(planeCoord, geVec3AddVec3(planeCoord.x, GEVec3Make(0.0, ((float)(r)), 0.0)));
    GEQuad3 rQuad3 = GEQuad3Make(rPlaneCoord, quad);
    [EGBillboard drawMaterial:[EGColorSource applyTexture:((EGTexture*)([_textures applyIndex:tp]))] at:geVec3ApplyVec2Z(tree.position, 0.0) quad:geQuadApplyP0P1P2P3(geVec3Xy(geQuad3P0(rQuad3)), geVec3Xy(geQuad3P1(rQuad3)), geVec3Xy(geQuad3P2(rQuad3)), geVec3Xy(geQuad3P3(rQuad3))) uv:_rustleUv];
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


