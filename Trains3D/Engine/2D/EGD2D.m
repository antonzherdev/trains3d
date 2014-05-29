#import "EGD2D.h"

#import "EGVertex.h"
#import "EGSprite.h"
#import "GL.h"
#import "EGVertexArray.h"
#import "EGIndex.h"
#import "EGSimpleShaderSystem.h"
#import "EGCircle.h"
#import "EGMaterial.h"
#import "EGTexture.h"
#import "EGContext.h"
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
static CNClassType* _EGD2D_type;

+ (void)initialize {
    [super initialize];
    if(self == [EGD2D class]) {
        _EGD2D_type = [CNClassType classTypeWithCls:[EGD2D class]];
        _EGD2D_vertexes = cnPointerApplyTpCount(egBillboardBufferDataType(), 4);
        _EGD2D_vb = [EGVBO mutDesc:EGSprite.vbDesc usage:GL_STREAM_DRAW];
        _EGD2D_vaoForColor = [[EGMesh meshWithVertex:_EGD2D_vb index:EGEmptyIndexSource.triangleStrip] vaoShader:[EGBillboardShaderSystem shaderForKey:[EGBillboardShaderKey billboardShaderKeyWithTexture:NO alpha:NO shadow:NO modelSpace:EGBillboardShaderSpace_camera]]];
        _EGD2D_vaoForTexture = [[EGMesh meshWithVertex:_EGD2D_vb index:EGEmptyIndexSource.triangleStrip] vaoShader:[EGBillboardShaderSystem shaderForKey:[EGBillboardShaderKey billboardShaderKeyWithTexture:YES alpha:NO shadow:NO modelSpace:EGBillboardShaderSpace_camera]]];
        _EGD2D_lineVb = [EGVBO mutMeshUsage:GL_STREAM_DRAW];
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
        EGTexture* __tmp_0p3l = material.texture;
        ((__tmp_0p3l != nil) ? [((EGTexture*)(material.texture)) uv] : geRectApplyXYWidthHeight(0.0, 0.0, 1.0, 1.0));
    })))];
}

+ (void)drawSpriteMaterial:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv {
    {
        EGBillboardBufferData* __il__0v = _EGD2D_vertexes;
        __il__0v->position = at;
        __il__0v->model = quad.p0;
        __il__0v->color = material.color;
        __il__0v->uv = uv.p0;
        __il__0v++;
        __il__0v->position = at;
        __il__0v->model = quad.p1;
        __il__0v->color = material.color;
        __il__0v->uv = uv.p1;
        __il__0v++;
        __il__0v->position = at;
        __il__0v->model = quad.p2;
        __il__0v->color = material.color;
        __il__0v->uv = uv.p2;
        __il__0v++;
        __il__0v->position = at;
        __il__0v->model = quad.p3;
        __il__0v->color = material.color;
        __il__0v->uv = uv.p3;
        __il__0v + 1;
    }
    [_EGD2D_vb setArray:_EGD2D_vertexes count:4];
    {
        EGCullFace* __tmp__il__2self = EGGlobal.context.cullFace;
        {
            unsigned int __il__2oldValue = [__tmp__il__2self disable];
            if(material.texture == nil) [_EGD2D_vaoForColor drawParam:material];
            else [_EGD2D_vaoForTexture drawParam:material];
            if(__il__2oldValue != GL_NONE) [__tmp__il__2self setValue:__il__2oldValue];
        }
    }
}

+ (EGBillboardBufferData*)writeSpriteIn:(EGBillboardBufferData*)in material:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv {
    EGBillboardBufferData* v = in;
    v->position = at;
    v->model = quad.p0;
    v->color = material.color;
    v->uv = uv.p0;
    v++;
    v->position = at;
    v->model = quad.p1;
    v->color = material.color;
    v->uv = uv.p1;
    v++;
    v->position = at;
    v->model = quad.p2;
    v->color = material.color;
    v->uv = uv.p2;
    v++;
    v->position = at;
    v->model = quad.p3;
    v->color = material.color;
    v->uv = uv.p3;
    return v + 1;
}

+ (unsigned int*)writeQuadIndexIn:(unsigned int*)in i:(unsigned int)i {
    *(in + 0) = i;
    *(in + 1) = i + 1;
    *(in + 2) = i + 2;
    *(in + 3) = i + 1;
    *(in + 4) = i + 2;
    *(in + 5) = i + 3;
    return in + 6;
}

+ (void)drawLineMaterial:(EGColorSource*)material p0:(GEVec2)p0 p1:(GEVec2)p1 {
    EGMeshData* v = _EGD2D_lineVertexes;
    v->position = geVec3ApplyVec2Z(p0, 0.0);
    v++;
    v->position = geVec3ApplyVec2Z(p1, 0.0);
    [_EGD2D_lineVb setArray:_EGD2D_lineVertexes count:2];
    {
        EGCullFace* __tmp__il__5self = EGGlobal.context.cullFace;
        {
            unsigned int __il__5oldValue = [__tmp__il__5self disable];
            [_EGD2D_lineVao drawParam:material];
            if(__il__5oldValue != GL_NONE) [__tmp__il__5self setValue:__il__5oldValue];
        }
    }
}

+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative segmentColor:(GEVec4)segmentColor start:(CGFloat)start end:(CGFloat)end {
    EGCullFace* __tmp__il__0self = EGGlobal.context.cullFace;
    {
        unsigned int __il__0oldValue = [__tmp__il__0self disable];
        [[EGD2D circleVaoWithSegment] drawParam:[EGCircleParam circleParamWithColor:backColor strokeColor:strokeColor position:at radius:[EGD2D radiusPR:radius] relative:relative segment:[EGCircleSegment circleSegmentWithColor:segmentColor start:((float)(start)) end:((float)(end))]]];
        if(__il__0oldValue != GL_NONE) [__tmp__il__0self setValue:__il__0oldValue];
    }
}

+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative {
    EGCullFace* __tmp__il__0self = EGGlobal.context.cullFace;
    {
        unsigned int __il__0oldValue = [__tmp__il__0self disable];
        [[EGD2D circleVaoWithoutSegment] drawParam:[EGCircleParam circleParamWithColor:backColor strokeColor:strokeColor position:at radius:[EGD2D radiusPR:radius] relative:relative segment:nil]];
        if(__il__0oldValue != GL_NONE) [__tmp__il__0self setValue:__il__0oldValue];
    }
}

+ (GEVec2)radiusPR:(float)r {
    float l = geVec2Length((geVec4Xy(([[[EGGlobal.matrix value] wcp] mulVec4:GEVec4Make(r, 0.0, 0.0, 0.0)]))));
    GEVec2i vps = [EGGlobal.context viewport].size;
    if(vps.y <= vps.x) return GEVec2Make((l * vps.y) / vps.x, l);
    else return GEVec2Make(l, (l * vps.x) / vps.y);
}

- (CNClassType*)type {
    return [EGD2D type];
}

+ (CNClassType*)type {
    return _EGD2D_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

