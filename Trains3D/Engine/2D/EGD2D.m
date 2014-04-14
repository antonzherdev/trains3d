#import "EGD2D.h"

#import "EGVertex.h"
#import "EGSprite.h"
#import "EGVertexArray.h"
#import "EGIndex.h"
#import "EGBillboardView.h"
#import "EGSimpleShaderSystem.h"
#import "EGCircle.h"
#import "EGMaterial.h"
#import "EGTexture.h"
#import "EGContext.h"
#import "GL.h"
#import "EGMatrixModel.h"
#import "GEMat4.h"
@implementation EGD2D
static EGBillboardBufferData* _EGD2D_vertexes;
static EGMutableVertexBuffer* _EGD2D_vb;
static EGVertexArray* _EGD2D_vaoForColor;
static EGVertexArray* _EGD2D_vaoForTexture;
static EGMutableVertexBuffer* _EGD2D_lineVb;
static EGMeshData* _EGD2D_lineVertexes;
static EGVertexArray* _EGD2D_lineVao;
static CNLazy* _EGD2D__lazy_circleVaoWithSegment;
static CNLazy* _EGD2D__lazy_circleVaoWithoutSegment;
static ODClassType* _EGD2D_type;

+ (void)initialize {
    [super initialize];
    if(self == [EGD2D class]) {
        _EGD2D_type = [ODClassType classTypeWithCls:[EGD2D class]];
        _EGD2D_vertexes = cnPointerApplyTpCount(egBillboardBufferDataType(), 4);
        _EGD2D_vb = [EGVBO mutDesc:EGSprite.vbDesc];
        _EGD2D_vaoForColor = [[EGMesh meshWithVertex:_EGD2D_vb index:EGEmptyIndexSource.triangleStrip] vaoShader:[EGBillboardShaderSystem shaderForKey:[EGBillboardShaderKey billboardShaderKeyWithTexture:NO alpha:NO shadow:NO modelSpace:EGBillboardShaderSpace.camera]]];
        _EGD2D_vaoForTexture = [[EGMesh meshWithVertex:_EGD2D_vb index:EGEmptyIndexSource.triangleStrip] vaoShader:[EGBillboardShaderSystem shaderForKey:[EGBillboardShaderKey billboardShaderKeyWithTexture:YES alpha:NO shadow:NO modelSpace:EGBillboardShaderSpace.camera]]];
        _EGD2D_lineVb = [EGVBO mutMesh];
        _EGD2D_lineVertexes = ({
            EGMeshData* pp = cnPointerApplyTpCount(egMeshDataType(), 2);
            EGMeshData* p = pp;
            p->uv = GEVec2Make(0.0, 0.0);
            p->normal = GEVec3Make(0.0, 0.0, 1.0);
            p++;
            p->uv = GEVec2Make(1.0, 1.0);
            p->normal = GEVec3Make(0.0, 0.0, 1.0);
            pp;
        });
        _EGD2D_lineVao = [[EGMesh meshWithVertex:_EGD2D_lineVb index:EGEmptyIndexSource.lines] vaoShader:[EGSimpleShaderSystem colorShader]];
        _EGD2D__lazy_circleVaoWithSegment = [CNLazy lazyWithF:^EGVertexArray*() {
            return [[EGMesh meshWithVertex:[EGVBO vec2Data:[ arrs(GEVec2, 4) {GEVec2Make(-1.0, -1.0), GEVec2Make(-1.0, 1.0), GEVec2Make(1.0, -1.0), GEVec2Make(1.0, 1.0)}]] index:EGEmptyIndexSource.triangleStrip] vaoShader:EGCircleShader.withSegment];
        }];
        _EGD2D__lazy_circleVaoWithoutSegment = [CNLazy lazyWithF:^EGVertexArray*() {
            return [[EGMesh meshWithVertex:[EGVBO vec2Data:[ arrs(GEVec2, 4) {GEVec2Make(-1.0, -1.0), GEVec2Make(-1.0, 1.0), GEVec2Make(1.0, -1.0), GEVec2Make(1.0, 1.0)}]] index:EGEmptyIndexSource.triangleStrip] vaoShader:EGCircleShader.withoutSegment];
        }];
    }
}

+ (EGVertexArray*)circleVaoWithSegment {
    return [_EGD2D__lazy_circleVaoWithSegment get];
}

+ (EGVertexArray*)circleVaoWithoutSegment {
    return [_EGD2D__lazy_circleVaoWithoutSegment get];
}

+ (void)install {
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at rect:(GERect)rect {
    [EGD2D drawSpriteMaterial:material at:at quad:geRectStripQuad(rect)];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad {
    [EGD2D drawSpriteMaterial:material at:at quad:quad uv:geRectUpsideDownStripQuad((({
        EGTexture* __tmp_0 = material.texture;
        ((__tmp_0 != nil) ? [((EGTexture*)(material.texture)) uv] : geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0));
    })))];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv {
    {
        EGBillboardBufferData* __inline__0_v = _EGD2D_vertexes;
        __inline__0_v->position = at;
        __inline__0_v->model = quad.p0;
        __inline__0_v->color = material.color;
        __inline__0_v->uv = uv.p0;
        __inline__0_v++;
        __inline__0_v->position = at;
        __inline__0_v->model = quad.p1;
        __inline__0_v->color = material.color;
        __inline__0_v->uv = uv.p1;
        __inline__0_v++;
        __inline__0_v->position = at;
        __inline__0_v->model = quad.p2;
        __inline__0_v->color = material.color;
        __inline__0_v->uv = uv.p2;
        __inline__0_v++;
        __inline__0_v->position = at;
        __inline__0_v->model = quad.p3;
        __inline__0_v->color = material.color;
        __inline__0_v->uv = uv.p3;
        __inline__0_v + 1;
    }
    [_EGD2D_vb setArray:_EGD2D_vertexes count:4];
    {
        EGCullFace* __tmp_2self = EGGlobal.context.cullFace;
        {
            unsigned int __inline__2_oldValue = [__tmp_2self disable];
            if(material.texture == nil) [_EGD2D_vaoForColor drawParam:material];
            else [_EGD2D_vaoForTexture drawParam:material];
            if(__inline__2_oldValue != GL_NONE) [__tmp_2self setValue:__inline__2_oldValue];
        }
    }
}

+ (void)drawLineMaterial:(EGColorSource*)material p0:(GEVec2)p0 p1:(GEVec2)p1 {
    EGMeshData* v = _EGD2D_lineVertexes;
    v->position = geVec3ApplyVec2Z(p0, 0.0);
    v++;
    v->position = geVec3ApplyVec2Z(p1, 0.0);
    [_EGD2D_lineVb setArray:_EGD2D_lineVertexes count:2];
    {
        EGCullFace* __tmp_5self = EGGlobal.context.cullFace;
        {
            unsigned int __inline__5_oldValue = [__tmp_5self disable];
            [_EGD2D_lineVao drawParam:material];
            if(__inline__5_oldValue != GL_NONE) [__tmp_5self setValue:__inline__5_oldValue];
        }
    }
}

+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative segmentColor:(GEVec4)segmentColor start:(CGFloat)start end:(CGFloat)end {
    EGCullFace* __tmp_0self = EGGlobal.context.cullFace;
    {
        unsigned int __inline__0_oldValue = [__tmp_0self disable];
        [[EGD2D circleVaoWithSegment] drawParam:[EGCircleParam circleParamWithColor:backColor strokeColor:strokeColor position:at radius:[EGD2D radiusPR:radius] relative:relative segment:[EGCircleSegment circleSegmentWithColor:segmentColor start:((float)(start)) end:((float)(end))]]];
        if(__inline__0_oldValue != GL_NONE) [__tmp_0self setValue:__inline__0_oldValue];
    }
}

+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative {
    EGCullFace* __tmp_0self = EGGlobal.context.cullFace;
    {
        unsigned int __inline__0_oldValue = [__tmp_0self disable];
        [[EGD2D circleVaoWithoutSegment] drawParam:[EGCircleParam circleParamWithColor:backColor strokeColor:strokeColor position:at radius:[EGD2D radiusPR:radius] relative:relative segment:nil]];
        if(__inline__0_oldValue != GL_NONE) [__tmp_0self setValue:__inline__0_oldValue];
    }
}

+ (GEVec2)radiusPR:(float)r {
    float l = geVec2Length((geVec4Xy(([[[EGGlobal.matrix value] wcp] mulVec4:GEVec4Make(r, 0.0, 0.0, 0.0)]))));
    GEVec2i vps = [EGGlobal.context viewport].size;
    if(vps.y <= vps.x) return GEVec2Make((l * vps.y) / vps.x, l);
    else return GEVec2Make(l, (l * vps.x) / vps.y);
}

- (ODClassType*)type {
    return [EGD2D type];
}

+ (ODClassType*)type {
    return _EGD2D_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


