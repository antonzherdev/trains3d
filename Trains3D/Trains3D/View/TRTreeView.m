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
        _textures = (@[[EGGlobal textureForFile:@"Pine.png"], [EGGlobal textureForFile:@"Tree1.png"]]);
        _materials = [[[_textures chain] map:^EGColorSource*(EGTexture* _) {
            return [EGColorSource applyTexture:_];
        }] toArray];
        _rects = [[[_textures chain] map:^id(EGTexture* _) {
            return wrap(GERect, GERectMake(GEVec2Make(0.0, 0.0), geVec2DivF4([_ size], [_ size].y * 2)));
        }] toArray];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeView_type = [ODClassType classTypeWithCls:[TRTreeView class]];
}

- (void)drawForest:(TRForest*)forest {
    glAlphaFunc(GL_GREATER, 0.2);
    glEnable(GL_ALPHA_TEST);
    egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
        [forest.trees forEach:^void(TRTree* _) {
            [self drawTree:_];
        }];
    });
    glDisable(GL_ALPHA_TEST);
}

- (void)drawTree:(TRTree*)tree {
    NSUInteger tp = tree.treeType.ordinal;
    [EGBillboard drawMaterial:[EGColorSource applyTexture:((EGTexture*)([_textures applyIndex:tp]))] at:geVec3ApplyVec2Z(tree.position, 0.0) rect:geRectCenterX(geRectMulVec2(uwrap(GERect, [_rects applyIndex:tp]), tree.size))];
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


