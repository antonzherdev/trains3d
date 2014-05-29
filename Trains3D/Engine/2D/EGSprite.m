#import "EGSprite.h"

#import "EGVertex.h"
#import "CNReact.h"
#import "GL.h"
#import "EGVertexArray.h"
#import "EGMaterial.h"
#import "EGContext.h"
#import "CNObserver.h"
#import "EGTexture.h"
#import "EGDirector.h"
#import "EGIndex.h"
#import "EGMesh.h"
#import "EGBillboardView.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
#import "EGInput.h"
@implementation EGSprite
static EGVertexBufferDesc* _EGSprite_vbDesc;
static CNClassType* _EGSprite_type;
@synthesize visible = _visible;
@synthesize material = _material;
@synthesize position = _position;
@synthesize rect = _rect;
@synthesize tap = _tap;

+ (instancetype)spriteWithVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect {
    return [[EGSprite alloc] initWithVisible:visible material:material position:position rect:rect];
}

- (instancetype)initWithVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect {
    self = [super init];
    if(self) {
        _visible = visible;
        _material = material;
        _position = position;
        _rect = rect;
        _vb = [EGVBO mutDesc:_EGSprite_vbDesc usage:GL_DYNAMIC_DRAW];
        __changed = [CNReactFlag reactFlagWithInitial:YES reacts:(@[((CNReact*)([material mapF:^EGTexture*(EGColorSource* _) {
    return ((EGColorSource*)(_)).texture;
}])), ((CNReact*)(position)), ((CNReact*)(rect)), ((CNReact*)(EGGlobal.context.viewSize))])];
        __materialChanged = [CNReactFlag reactFlagWithInitial:YES reacts:(@[material])];
        _tap = [CNSignal signal];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSprite class]) {
        _EGSprite_type = [CNClassType classTypeWithCls:[EGSprite class]];
        _EGSprite_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:egBillboardBufferDataType() position:0 uv:((int)(9 * 4)) normal:-1 color:((int)(5 * 4)) model:((int)(3 * 4))];
    }
}

+ (EGSprite*)applyVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position anchor:(GEVec2)anchor {
    return [EGSprite spriteWithVisible:visible material:material position:position rect:[EGSprite rectReactMaterial:material anchor:anchor]];
}

+ (EGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position anchor:(GEVec2)anchor {
    return [EGSprite applyVisible:[CNReact applyValue:@YES] material:material position:position anchor:anchor];
}

+ (CNReact*)rectReactMaterial:(CNReact*)material anchor:(GEVec2)anchor {
    return [material mapF:^id(EGColorSource* m) {
        GEVec2 s = geVec2DivF4([((EGTexture*)(nonnil(((EGColorSource*)(m)).texture))) size], ((float)([[EGDirector current] scale])));
        return wrap(GERect, (GERectMake((geVec2MulVec2(s, (geVec2DivF4((geVec2AddF4(anchor, 1.0)), -2.0)))), s)));
    }];
}

- (void)draw {
    if(!(unumb([_visible value]))) return ;
    if(unumb([__materialChanged value])) {
        _vao = [[EGMesh meshWithVertex:_vb index:EGEmptyIndexSource.triangleStrip] vaoShaderSystem:EGBillboardShaderSystem.projectionSpace material:[_material value] shadow:NO];
        [__materialChanged clear];
    }
    if(unumb([__changed value])) {
        EGBillboardBufferData* vertexes = cnPointerApplyTpCount(egBillboardBufferDataType(), 4);
        EGColorSource* m = [_material value];
        {
            GEVec3 __tmp__il__2t_2at = uwrap(GEVec3, [_position value]);
            GEQuad __tmp__il__2t_2quad = geRectStripQuad((geRectMulF((geRectDivVec2((uwrap(GERect, [_rect value])), (uwrap(GEVec2, [EGGlobal.context.scaledViewSize value])))), 2.0)));
            GEQuad __tmp__il__2t_2uv = geRectUpsideDownStripQuad((({
                EGTexture* __tmp_2t_2rp4l = m.texture;
                ((__tmp_2t_2rp4l != nil) ? [((EGTexture*)(m.texture)) uv] : geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0));
            })));
            {
                EGBillboardBufferData* __il__2t_2v = vertexes;
                __il__2t_2v->position = __tmp__il__2t_2at;
                __il__2t_2v->model = __tmp__il__2t_2quad.p0;
                __il__2t_2v->color = m.color;
                __il__2t_2v->uv = __tmp__il__2t_2uv.p0;
                __il__2t_2v++;
                __il__2t_2v->position = __tmp__il__2t_2at;
                __il__2t_2v->model = __tmp__il__2t_2quad.p1;
                __il__2t_2v->color = m.color;
                __il__2t_2v->uv = __tmp__il__2t_2uv.p1;
                __il__2t_2v++;
                __il__2t_2v->position = __tmp__il__2t_2at;
                __il__2t_2v->model = __tmp__il__2t_2quad.p2;
                __il__2t_2v->color = m.color;
                __il__2t_2v->uv = __tmp__il__2t_2uv.p2;
                __il__2t_2v++;
                __il__2t_2v->position = __tmp__il__2t_2at;
                __il__2t_2v->model = __tmp__il__2t_2quad.p3;
                __il__2t_2v->color = m.color;
                __il__2t_2v->uv = __tmp__il__2t_2uv.p3;
                __il__2t_2v + 1;
            }
        }
        [_vb setArray:vertexes count:4];
        cnPointerFree(vertexes);
        [__changed clear];
    }
    {
        EGCullFace* __tmp__il__3self = EGGlobal.context.cullFace;
        {
            unsigned int __il__3oldValue = [__tmp__il__3self disable];
            [((EGVertexArray*)(_vao)) draw];
            if(__il__3oldValue != GL_NONE) [__tmp__il__3self setValue:__il__3oldValue];
        }
    }
}

- (GERect)rectInViewport {
    GEVec4 pp = [[[EGGlobal.matrix value] wcp] mulVec4:geVec4ApplyVec3W((uwrap(GEVec3, [_position value])), 1.0)];
    return geRectAddVec2((geRectMulF((geRectDivVec2((uwrap(GERect, [_rect value])), (uwrap(GEVec2, [EGGlobal.context.scaledViewSize value])))), 2.0)), geVec4Xy(pp));
}

- (BOOL)containsViewportVec2:(GEVec2)vec2 {
    return unumb([_visible value]) && geRectContainsVec2([self rectInViewport], vec2);
}

- (BOOL)tapEvent:(id<EGEvent>)event {
    if([self containsViewportVec2:[event locationInViewport]]) {
        [_tap post];
        return YES;
    } else {
        return NO;
    }
}

- (EGRecognizer*)recognizer {
    return [EGRecognizer applyTp:[EGTap apply] on:^BOOL(id<EGEvent> _) {
        return [self tapEvent:_];
    }];
}

+ (EGSprite*)applyVisible:(CNReact*)visible material:(CNReact*)material position:(CNReact*)position {
    return [EGSprite spriteWithVisible:visible material:material position:position rect:[EGSprite rectReactMaterial:material anchor:GEVec2Make(0.0, 0.0)]];
}

+ (EGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position rect:(CNReact*)rect {
    return [EGSprite spriteWithVisible:[CNReact applyValue:@YES] material:material position:position rect:rect];
}

+ (EGSprite*)applyMaterial:(CNReact*)material position:(CNReact*)position {
    return [EGSprite spriteWithVisible:[CNReact applyValue:@YES] material:material position:position rect:[EGSprite rectReactMaterial:material anchor:GEVec2Make(0.0, 0.0)]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Sprite(%@, %@, %@, %@)", _visible, _material, _position, _rect];
}

- (CNClassType*)type {
    return [EGSprite type];
}

+ (EGVertexBufferDesc*)vbDesc {
    return _EGSprite_vbDesc;
}

+ (CNClassType*)type {
    return _EGSprite_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

