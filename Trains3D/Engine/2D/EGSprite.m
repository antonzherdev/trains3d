#import "EGSprite.h"

#import "EGVertex.h"
#import "ATReact.h"
#import "GL.h"
#import "EGVertexArray.h"
#import "EGMaterial.h"
#import "EGContext.h"
#import "ATObserver.h"
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
static ODClassType* _EGSprite_type;
@synthesize visible = _visible;
@synthesize material = _material;
@synthesize position = _position;
@synthesize rect = _rect;
@synthesize tap = _tap;

+ (instancetype)spriteWithVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position rect:(ATReact*)rect {
    return [[EGSprite alloc] initWithVisible:visible material:material position:position rect:rect];
}

- (instancetype)initWithVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position rect:(ATReact*)rect {
    self = [super init];
    if(self) {
        _visible = visible;
        _material = material;
        _position = position;
        _rect = rect;
        _vb = [EGVBO mutDesc:_EGSprite_vbDesc usage:GL_DYNAMIC_DRAW];
        __changed = [ATReactFlag reactFlagWithInitial:YES reacts:(@[((ATReact*)([_material mapF:^EGTexture*(EGColorSource* _) {
    return ((EGColorSource*)(_)).texture;
}])), ((ATReact*)(_position)), ((ATReact*)(_rect)), ((ATReact*)(EGGlobal.context.viewSize))])];
        __materialChanged = [ATReactFlag reactFlagWithInitial:YES reacts:(@[_material])];
        _tap = [ATSignal signal];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSprite class]) {
        _EGSprite_type = [ODClassType classTypeWithCls:[EGSprite class]];
        _EGSprite_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:egBillboardBufferDataType() position:0 uv:((int)(9 * 4)) normal:-1 color:((int)(5 * 4)) model:((int)(3 * 4))];
    }
}

+ (EGSprite*)applyVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position anchor:(GEVec2)anchor {
    return [EGSprite spriteWithVisible:visible material:material position:position rect:[EGSprite rectReactMaterial:material anchor:anchor]];
}

+ (EGSprite*)applyMaterial:(ATReact*)material position:(ATReact*)position anchor:(GEVec2)anchor {
    return [EGSprite applyVisible:[ATReact applyValue:@YES] material:material position:position anchor:anchor];
}

+ (ATReact*)rectReactMaterial:(ATReact*)material anchor:(GEVec2)anchor {
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
            GEVec3 __tmp_2_2at = uwrap(GEVec3, [_position value]);
            GEQuad __tmp_2_2quad = geRectStripQuad((geRectMulF((geRectDivVec2((uwrap(GERect, [_rect value])), (uwrap(GEVec2, [EGGlobal.context.scaledViewSize value])))), 2.0)));
            GEQuad __tmp_2_2uv = geRectUpsideDownStripQuad((({
                EGTexture* __tmp_2_2 = m.texture;
                ((__tmp_2_2 != nil) ? [((EGTexture*)(m.texture)) uv] : geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0));
            })));
            {
                EGBillboardBufferData* __inline__2_2_v = vertexes;
                __inline__2_2_v->position = __tmp_2_2at;
                __inline__2_2_v->model = __tmp_2_2quad.p0;
                __inline__2_2_v->color = m.color;
                __inline__2_2_v->uv = __tmp_2_2uv.p0;
                __inline__2_2_v++;
                __inline__2_2_v->position = __tmp_2_2at;
                __inline__2_2_v->model = __tmp_2_2quad.p1;
                __inline__2_2_v->color = m.color;
                __inline__2_2_v->uv = __tmp_2_2uv.p1;
                __inline__2_2_v++;
                __inline__2_2_v->position = __tmp_2_2at;
                __inline__2_2_v->model = __tmp_2_2quad.p2;
                __inline__2_2_v->color = m.color;
                __inline__2_2_v->uv = __tmp_2_2uv.p2;
                __inline__2_2_v++;
                __inline__2_2_v->position = __tmp_2_2at;
                __inline__2_2_v->model = __tmp_2_2quad.p3;
                __inline__2_2_v->color = m.color;
                __inline__2_2_v->uv = __tmp_2_2uv.p3;
                __inline__2_2_v + 1;
            }
        }
        [_vb setArray:vertexes count:4];
        cnPointerFree(vertexes);
        [__changed clear];
    }
    {
        EGCullFace* __tmp_3self = EGGlobal.context.cullFace;
        {
            unsigned int __inline__3_oldValue = [__tmp_3self disable];
            [((EGVertexArray*)(_vao)) draw];
            if(__inline__3_oldValue != GL_NONE) [__tmp_3self setValue:__inline__3_oldValue];
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

+ (EGSprite*)applyVisible:(ATReact*)visible material:(ATReact*)material position:(ATReact*)position {
    return [EGSprite spriteWithVisible:visible material:material position:position rect:[EGSprite rectReactMaterial:material anchor:GEVec2Make(0.0, 0.0)]];
}

+ (EGSprite*)applyMaterial:(ATReact*)material position:(ATReact*)position rect:(ATReact*)rect {
    return [EGSprite spriteWithVisible:[ATReact applyValue:@YES] material:material position:position rect:rect];
}

+ (EGSprite*)applyMaterial:(ATReact*)material position:(ATReact*)position {
    return [EGSprite spriteWithVisible:[ATReact applyValue:@YES] material:material position:position rect:[EGSprite rectReactMaterial:material anchor:GEVec2Make(0.0, 0.0)]];
}

- (ODClassType*)type {
    return [EGSprite type];
}

+ (EGVertexBufferDesc*)vbDesc {
    return _EGSprite_vbDesc;
}

+ (ODClassType*)type {
    return _EGSprite_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"visible=%@", self.visible];
    [description appendFormat:@", material=%@", self.material];
    [description appendFormat:@", position=%@", self.position];
    [description appendFormat:@", rect=%@", self.rect];
    [description appendString:@">"];
    return description;
}

@end


