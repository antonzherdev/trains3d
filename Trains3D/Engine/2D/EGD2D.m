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
static CNVoidRefArray _EGD2D_vertexes;
static EGMutableVertexBuffer* _EGD2D_vb;
static EGVertexArray* _EGD2D_vaoForColor;
static EGVertexArray* _EGD2D_vaoForTexture;
static EGMutableVertexBuffer* _EGD2D_lineVb;
static CNVoidRefArray _EGD2D_lineVertexes;
static EGVertexArray* _EGD2D_lineVao;
static CNLazy* _EGD2D__lazy_circleVaoWithSegment;
static CNLazy* _EGD2D__lazy_circleVaoWithoutSegment;
static ODClassType* _EGD2D_type;

+ (void)initialize {
    [super initialize];
    if(self == [EGD2D class]) {
        _EGD2D_type = [ODClassType classTypeWithCls:[EGD2D class]];
        _EGD2D_vertexes = cnVoidRefArrayApplyTpCount(egBillboardBufferDataType(), 4);
        _EGD2D_vb = [EGVBO mutDesc:EGSprite.vbDesc];
        _EGD2D_vaoForColor = [[EGMesh meshWithVertex:_EGD2D_vb index:EGEmptyIndexSource.triangleStrip] vaoShader:[EGBillboardShaderSystem shaderForKey:[EGBillboardShaderKey billboardShaderKeyWithTexture:NO alpha:NO shadow:NO modelSpace:EGBillboardShaderSpace.camera]]];
        _EGD2D_vaoForTexture = [[EGMesh meshWithVertex:_EGD2D_vb index:EGEmptyIndexSource.triangleStrip] vaoShader:[EGBillboardShaderSystem shaderForKey:[EGBillboardShaderKey billboardShaderKeyWithTexture:YES alpha:NO shadow:NO modelSpace:EGBillboardShaderSpace.camera]]];
        _EGD2D_lineVb = [EGVBO mutMesh];
        _EGD2D_lineVertexes = cnVoidRefArrayApplyTpCount(egMeshDataType(), 2);
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
    CNVoidRefArray v = _EGD2D_vertexes;
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, (EGBillboardBufferDataMake(at, quad.p0, material.color, uv.p0)));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, (EGBillboardBufferDataMake(at, quad.p1, material.color, uv.p1)));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, (EGBillboardBufferDataMake(at, quad.p2, material.color, uv.p2)));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, (EGBillboardBufferDataMake(at, quad.p3, material.color, uv.p3)));
    [_EGD2D_vb setArray:_EGD2D_vertexes];
    {
        EGCullFace* __tmp_6self = EGGlobal.context.cullFace;
        {
            unsigned int oldValue = [__tmp_6self disable];
            if(material.texture == nil) [_EGD2D_vaoForColor drawParam:material];
            else [_EGD2D_vaoForTexture drawParam:material];
            if(oldValue != GL_NONE) [__tmp_6self setValue:oldValue];
        }
    }
}

+ (CNVoidRefArray)writeSpriteIn:(CNVoidRefArray)in material:(EGColorSource*)material at:(GEVec3)at quad:(GEQuad)quad uv:(GEQuad)uv {
    CNVoidRefArray v = cnVoidRefArrayWriteTpItem(in, EGBillboardBufferData, (EGBillboardBufferDataMake(at, quad.p0, material.color, uv.p0)));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, (EGBillboardBufferDataMake(at, quad.p1, material.color, uv.p1)));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, (EGBillboardBufferDataMake(at, quad.p2, material.color, uv.p2)));
    v = cnVoidRefArrayWriteTpItem(v, EGBillboardBufferData, (EGBillboardBufferDataMake(at, quad.p3, material.color, uv.p3)));
    return v;
}

+ (CNVoidRefArray)writeQuadIndexIn:(CNVoidRefArray)in i:(unsigned int)i {
    return cnVoidRefArrayWriteUInt4((cnVoidRefArrayWriteUInt4((cnVoidRefArrayWriteUInt4((cnVoidRefArrayWriteUInt4((cnVoidRefArrayWriteUInt4((cnVoidRefArrayWriteUInt4(in, i)), i + 1)), i + 2)), i + 1)), i + 2)), i + 3);
}

+ (void)drawLineMaterial:(EGColorSource*)material p0:(GEVec2)p0 p1:(GEVec2)p1 {
    CNVoidRefArray v = _EGD2D_lineVertexes;
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, (EGMeshDataMake((GEVec2Make(0.0, 0.0)), (GEVec3Make(0.0, 0.0, 1.0)), (geVec3ApplyVec2Z(p0, 0.0)))));
    v = cnVoidRefArrayWriteTpItem(v, EGMeshData, (EGMeshDataMake((GEVec2Make(1.0, 1.0)), (GEVec3Make(0.0, 0.0, 1.0)), (geVec3ApplyVec2Z(p1, 0.0)))));
    [_EGD2D_lineVb setArray:_EGD2D_lineVertexes];
    {
        EGCullFace* __tmp_4self = EGGlobal.context.cullFace;
        {
            unsigned int oldValue = [__tmp_4self disable];
            [_EGD2D_lineVao drawParam:material];
            if(oldValue != GL_NONE) [__tmp_4self setValue:oldValue];
        }
    }
}

+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative segmentColor:(GEVec4)segmentColor start:(CGFloat)start end:(CGFloat)end {
    EGCullFace* __tmp_0self = EGGlobal.context.cullFace;
    {
        unsigned int oldValue = [__tmp_0self disable];
        [[EGD2D circleVaoWithSegment] drawParam:[EGCircleParam circleParamWithColor:backColor strokeColor:strokeColor position:at radius:[EGD2D radiusPR:radius] relative:relative segment:[EGCircleSegment circleSegmentWithColor:segmentColor start:((float)(start)) end:((float)(end))]]];
        if(oldValue != GL_NONE) [__tmp_0self setValue:oldValue];
    }
}

+ (void)drawCircleBackColor:(GEVec4)backColor strokeColor:(GEVec4)strokeColor at:(GEVec3)at radius:(float)radius relative:(GEVec2)relative {
    EGCullFace* __tmp_0self = EGGlobal.context.cullFace;
    {
        unsigned int oldValue = [__tmp_0self disable];
        [[EGD2D circleVaoWithoutSegment] drawParam:[EGCircleParam circleParamWithColor:backColor strokeColor:strokeColor position:at radius:[EGD2D radiusPR:radius] relative:relative segment:nil]];
        if(oldValue != GL_NONE) [__tmp_0self setValue:oldValue];
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


