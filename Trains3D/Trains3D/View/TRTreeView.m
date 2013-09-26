#import "TRTreeView.h"

#import "EGTexture.h"
#import "EGContext.h"
#import "GL.h"
#import "TRTree.h"
#import "EGBillboard.h"
@implementation TRTreeView{
    EGTexture* _pineTexture;
    EGColorSource* _pine;
    GERect _pineRect;
}
static ODClassType* _TRTreeView_type;
@synthesize pineTexture = _pineTexture;
@synthesize pine = _pine;
@synthesize pineRect = _pineRect;

+ (id)treeView {
    return [[TRTreeView alloc] init];
}

- (id)init {
    self = [super init];
    if(self) {
        _pineTexture = [EGGlobal textureForFile:@"Pine.png"];
        _pine = [EGColorSource applyTexture:_pineTexture];
        _pineRect = geRectCenterX(GERectMake(GEVec2Make(0.0, 0.0), geVec2DivF4([_pineTexture size], [_pineTexture size].y * 2)));
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _TRTreeView_type = [ODClassType classTypeWithCls:[TRTreeView class]];
}

- (void)drawTrees:(TRTrees*)trees {
    glAlphaFunc(GL_GREATER, 0.2);
    glEnable(GL_ALPHA_TEST);
    egBlendFunctionApplyDraw(egBlendFunctionStandard(), ^void() {
        [trees.trees forEach:^void(TRTree* _) {
            [self drawTree:_];
        }];
    });
    glDisable(GL_ALPHA_TEST);
}

- (void)drawTree:(TRTree*)tree {
    [EGBillboard drawMaterial:_pine at:geVec3ApplyVec2Z(tree.position, 0.0) rect:_pineRect];
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


