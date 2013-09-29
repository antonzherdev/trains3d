#import "TRTreeView.h"

#import "EGContext.h"
#import "EGTexture.h"
#import "GL.h"
#import "TRTree.h"
#import "EGBillboard.h"
@implementation TRTreeView{
    id<CNSeq> _textures;
    id<CNSeq> _materials;
    id<CNSeq> _rects;
}
static ODClassType* _TRTreeView_type;
@synthesize textures = _textures;
@synthesize materials = _materials;
@synthesize rects = _rects;

+ (id)treeView {
    return [[TRTreeView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _textures = (@[[EGGlobal textureForFile:@"Pine.png"], [EGGlobal textureForFile:@"Tree1.png"], [EGGlobal textureForFile:@"Tree2.png"], [EGGlobal textureForFile:@"Tree3.png"], [EGGlobal textureForFile:@"YellowTree.png"]]);
        _materials = [[[_textures chain] map:^EGColorSource*(EGTexture* _) {
            return [EGColorSource applyTexture:_];
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

- (void)drawForest:(TRForest*)forest {
    glAlphaFunc(GL_GREATER, 0.3);
    glEnable(GL_ALPHA_TEST);
    egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
        [[forest trees] forEach:^void(TRTree* _) {
            [self drawTree:_];
        }];
    });
    glDisable(GL_ALPHA_TEST);
}

- (void)drawTree:(TRTree*)tree {
    NSUInteger tp = tree.treeType.ordinal;
    GEQuad quad = geRectQuad(geRectMulVec2(uwrap(GERect, [_rects applyIndex:tp]), tree.size));
    [EGBillboard drawMaterial:[EGColorSource applyTexture:((EGTexture*)([_textures applyIndex:tp]))] at:geVec3ApplyVec2Z(tree.position, 0.0) quad:quad uv:geRectUpsideDownQuad(geRectApplyXYWidthHeight(0.0, 0.0, 0.5, 1.0))];
    CGFloat r = tree.rustle * 0.001;
    [EGBillboard drawMaterial:[EGColorSource applyTexture:((EGTexture*)([_textures applyIndex:tp]))] at:geVec3ApplyVec2Z(tree.position, 0.0) quad:geQuadApplyP0P1P2P3(geVec2AddVec2(quad.p[0], GEVec2Make(((float)(r)), ((float)(r)))), geVec2AddVec2(quad.p[1], GEVec2Make(((float)(-r)), ((float)(r)))), geVec2AddVec2(quad.p[2], GEVec2Make(((float)(r)), ((float)(-r)))), geVec2AddVec2(quad.p[3], GEVec2Make(((float)(-r)), ((float)(-r))))) uv:geRectUpsideDownQuad(geRectApplyXYWidthHeight(0.5, 0.0, 0.5, 1.0))];
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


