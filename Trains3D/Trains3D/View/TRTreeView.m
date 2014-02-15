#import "TRTreeView.h"

#import "EGContext.h"
#import "EGMaterial.h"
#import "EGVertex.h"
#import "GL.h"
#import "TRTree.h"
#import "EGTexture.h"
#import "EGIndex.h"
#import "EGMesh.h"
#import "EGSprite.h"
@implementation TRTreeShaderBuilder{
    BOOL _shadow;
}
static ODClassType* _TRTreeShaderBuilder_type;
@synthesize shadow = _shadow;

+ (id)treeShaderBuilderWithShadow:(BOOL)shadow {
    return [[TRTreeShaderBuilder alloc] initWithShadow:shadow];
}

- (id)initWithShadow:(BOOL)shadow {
    self = [super init];
    if(self) _shadow = shadow;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTreeShaderBuilder class]) _TRTreeShaderBuilder_type = [ODClassType classTypeWithCls:[TRTreeShaderBuilder class]];
}

- (NSString*)vertex {
    return [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@ highp vec3 position;\n"
        "%@ lowp vec2 model;\n"
        "%@ mediump vec2 vertexUV;\n"
        "%@ mediump vec2 vertexUVShiver;\n"
        "\n"
        "%@ mediump vec2 UV;\n"
        "%@ mediump vec2 UVShiver;\n"
        "\n"
        "\n"
        "uniform mat4 wc;\n"
        "uniform mat4 p;\n"
        "\n"
        "void main(void) {\n"
        "   highp vec4 pos = wc*vec4(position, 1);\n"
        "   pos.x += model.x;\n"
        "   pos.y += model.y;\n"
        "   gl_Position = p*pos;\n"
        "   UV = vertexUV;\n"
        "   UVShiver = vertexUVShiver;\n"
        "}", [self vertexHeader], [self ain], [self ain], [self ain], [self ain], [self out], [self out]];
}

- (NSString*)fragment {
    return [NSString stringWithFormat:@"%@\n"
        "\n"
        "%@ mediump vec2 UV;\n"
        "%@ mediump vec2 UVShiver;\n"
        "uniform lowp sampler2D txt;\n"
        "%@\n"
        "%@\n"
        "\n"
        "void main(void) {%@\n"
        "   lowp vec4 t1 = %@(txt, UV);\n"
        "   lowp vec4 t2 = %@(txt, UVShiver);\n"
        "   %@ = vec4(t1.a) * t1 + vec4(1.0 - t1.a) * t2;\n"
        "  %@%@\n"
        "}", [self versionString], [self in], [self in], ((_shadow) ? @"uniform lowp float alphaTestLevel;" : @""), ((_shadow && [self version] > 100) ? @"out float depth;" : [NSString stringWithFormat:@"%@", [self fragColorDeclaration]]), ((_shadow && !([self isFragColorDeclared])) ? @"\n"
        "   lowp vec4 fragColor;" : @""), [self texture2D], [self texture2D], [self fragColor], ((_shadow) ? [NSString stringWithFormat:@"   if(%@.a < 0.1) {\n"
        "       discard;\n"
        "   }\n"
        "  ", [self fragColor]] : @""), ((_shadow && [self version] > 100) ? @"\n"
        "   depth = gl_FragCoord.z;" : @"")];
}

- (EGShaderProgram*)program {
    return [EGShaderProgram applyName:@"Tree" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)versionString {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)vertexHeader {
    return [NSString stringWithFormat:@"#version %ld", (long)[self version]];
}

- (NSString*)fragmentHeader {
    return [NSString stringWithFormat:@"#version %ld\n"
        "%@", (long)[self version], [self fragColorDeclaration]];
}

- (NSString*)fragColorDeclaration {
    if([self isFragColorDeclared]) return @"";
    else return @"out lowp vec4 fragColor;";
}

- (BOOL)isFragColorDeclared {
    return EGShaderProgram.version < 110;
}

- (NSInteger)version {
    return EGShaderProgram.version;
}

- (NSString*)ain {
    if([self version] < 150) return @"attribute";
    else return @"in";
}

- (NSString*)in {
    if([self version] < 150) return @"varying";
    else return @"in";
}

- (NSString*)out {
    if([self version] < 150) return @"varying";
    else return @"out";
}

- (NSString*)fragColor {
    if([self version] > 100) return @"fragColor";
    else return @"gl_FragColor";
}

- (NSString*)texture2D {
    if([self version] > 100) return @"texture";
    else return @"texture2D";
}

- (NSString*)shadowExt {
    if([self version] == 100 && [EGGlobal.settings shadowType] == EGShadowType.shadow2d) return @"#extension GL_EXT_shadow_samplers : require";
    else return @"";
}

- (NSString*)sampler2DShadow {
    if([EGGlobal.settings shadowType] == EGShadowType.shadow2d) return @"sampler2DShadow";
    else return @"sampler2D";
}

- (NSString*)shadow2DTexture:(NSString*)texture vec3:(NSString*)vec3 {
    if([EGGlobal.settings shadowType] == EGShadowType.shadow2d) return [NSString stringWithFormat:@"%@(%@, %@)", [self shadow2DEXT], texture, vec3];
    else return [NSString stringWithFormat:@"(%@(%@, %@.xy).x < %@.z ? 0.0 : 1.0)", [self texture2D], texture, vec3, vec3];
}

- (NSString*)blendMode:(EGBlendMode*)mode a:(NSString*)a b:(NSString*)b {
    return mode.blend(a, b);
}

- (NSString*)shadow2DEXT {
    if([self version] == 100) return @"shadow2DEXT";
    else return @"texture";
}

- (ODClassType*)type {
    return [TRTreeShaderBuilder type];
}

+ (ODClassType*)type {
    return _TRTreeShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTreeShaderBuilder* o = ((TRTreeShaderBuilder*)(other));
    return self.shadow == o.shadow;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.shadow;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"shadow=%d", self.shadow];
    [description appendString:@">"];
    return description;
}

@end


@implementation TRTreeShader{
    BOOL _shadow;
    EGShaderAttribute* _positionSlot;
    EGShaderAttribute* _modelSlot;
    EGShaderAttribute* _uvSlot;
    EGShaderAttribute* _uvShiverSlot;
    EGShaderUniformMat4* _wcUniform;
    EGShaderUniformMat4* _pUniform;
}
static TRTreeShader* _TRTreeShader_instanceForShadow;
static TRTreeShader* _TRTreeShader_instance;
static EGVertexBufferDesc* _TRTreeShader_vbDesc;
static ODClassType* _TRTreeShader_type;
@synthesize shadow = _shadow;
@synthesize positionSlot = _positionSlot;
@synthesize modelSlot = _modelSlot;
@synthesize uvSlot = _uvSlot;
@synthesize uvShiverSlot = _uvShiverSlot;
@synthesize wcUniform = _wcUniform;
@synthesize pUniform = _pUniform;

+ (id)treeShaderWithProgram:(EGShaderProgram*)program shadow:(BOOL)shadow {
    return [[TRTreeShader alloc] initWithProgram:program shadow:shadow];
}

- (id)initWithProgram:(EGShaderProgram*)program shadow:(BOOL)shadow {
    self = [super initWithProgram:program];
    if(self) {
        _shadow = shadow;
        _positionSlot = [self attributeForName:@"position"];
        _modelSlot = [self attributeForName:@"model"];
        _uvSlot = [self attributeForName:@"vertexUV"];
        _uvShiverSlot = [self attributeForName:@"vertexUVShiver"];
        _wcUniform = [self uniformMat4Name:@"wc"];
        _pUniform = [self uniformMat4Name:@"p"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTreeShader class]) {
        _TRTreeShader_type = [ODClassType classTypeWithCls:[TRTreeShader class]];
        _TRTreeShader_instanceForShadow = [TRTreeShader treeShaderWithProgram:[[TRTreeShaderBuilder treeShaderBuilderWithShadow:YES] program] shadow:YES];
        _TRTreeShader_instance = [TRTreeShader treeShaderWithProgram:[[TRTreeShaderBuilder treeShaderBuilderWithShadow:NO] program] shadow:NO];
        _TRTreeShader_vbDesc = [EGVertexBufferDesc vertexBufferDescWithDataType:trTreeDataType() position:0 uv:((int)(5 * 4)) normal:-1 color:-1 model:((int)(3 * 4))];
    }
}

- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.position))];
    [_modelSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.model))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv))];
    [_uvShiverSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc.uv + 2 * 4))];
}

- (void)loadUniformsParam:(EGColorSource*)param {
    [_wcUniform applyMatrix:[EGGlobal.matrix.value wc]];
    [_pUniform applyMatrix:EGGlobal.matrix.value.p];
    [EGGlobal.context bindTextureTexture:[param.texture get]];
}

- (ODClassType*)type {
    return [TRTreeShader type];
}

+ (TRTreeShader*)instanceForShadow {
    return _TRTreeShader_instanceForShadow;
}

+ (TRTreeShader*)instance {
    return _TRTreeShader_instance;
}

+ (EGVertexBufferDesc*)vbDesc {
    return _TRTreeShader_vbDesc;
}

+ (ODClassType*)type {
    return _TRTreeShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTreeShader* o = ((TRTreeShader*)(other));
    return [self.program isEqual:o.program] && self.shadow == o.shadow;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.program hash];
    hash = hash * 31 + self.shadow;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"program=%@", self.program];
    [description appendFormat:@", shadow=%d", self.shadow];
    [description appendString:@">"];
    return description;
}

@end


NSString* TRTreeDataDescription(TRTreeData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<TRTreeData: "];
    [description appendFormat:@"position=%@", GEVec3Description(self.position)];
    [description appendFormat:@", model=%@", GEVec2Description(self.model)];
    [description appendFormat:@", uv=%@", GEVec2Description(self.uv)];
    [description appendFormat:@", uvShiver=%@", GEVec2Description(self.uvShiver)];
    [description appendString:@">"];
    return description;
}
ODPType* trTreeDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[TRTreeDataWrap class] name:@"TRTreeData" size:sizeof(TRTreeData) wrap:^id(void* data, NSUInteger i) {
        return wrap(TRTreeData, ((TRTreeData*)(data))[i]);
    }];
    return _ret;
}
@implementation TRTreeDataWrap{
    TRTreeData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(TRTreeData)value {
    return [[TRTreeDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(TRTreeData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return TRTreeDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTreeDataWrap* o = ((TRTreeDataWrap*)(other));
    return TRTreeDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return TRTreeDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation TRTreeView{
    TRForest* _forest;
    EGTexture* _texture;
    EGColorSource* _material;
    EGMutableVertexBuffer* _vb;
    EGMutableIndexBuffer* _ib;
    EGMutableIndexBuffer* _ibShadow;
    EGVertexArray* _vao;
    EGColorSource* _shadowMaterial;
    EGVertexArray* _shadowVao;
}
static ODClassType* _TRTreeView_type;
@synthesize forest = _forest;
@synthesize texture = _texture;
@synthesize material = _material;

+ (id)treeViewWithForest:(TRForest*)forest {
    return [[TRTreeView alloc] initWithForest:forest];
}

- (id)initWithForest:(TRForest*)forest {
    self = [super init];
    if(self) {
        _forest = forest;
        _texture = [EGGlobal textureForFile:[NSString stringWithFormat:@"%@.png", _forest.rules.forestType.name] magFilter:GL_LINEAR minFilter:GL_LINEAR_MIPMAP_NEAREST];
        _material = [EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:_texture];
        _vb = [EGVBO mutDesc:TRTreeShader.vbDesc];
        _ib = [EGIBO mut];
        _ibShadow = [EGIBO mut];
        _vao = [[EGMesh meshWithVertex:_vb index:_ib] vaoShader:TRTreeShader.instance];
        _shadowMaterial = [EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0) texture:_texture alphaTestLevel:0.1];
        _shadowVao = [[EGMesh meshWithVertex:_vb index:_ibShadow] vaoShader:TRTreeShader.instanceForShadow];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTreeView class]) _TRTreeView_type = [ODClassType classTypeWithCls:[TRTreeView class]];
}

- (void)prepare {
    CNVoidRefArray ar = cnVoidRefArrayApplyTpCount(trTreeDataType(), ((NSUInteger)(4 * [[_forest trees] count])));
    CNVoidRefArray iar = cnVoidRefArrayApplyTpCount(oduInt4Type(), ((NSUInteger)(6 * [[_forest trees] count])));
    CNVoidRefArray ibr = cnVoidRefArrayApplyTpCount(oduInt4Type(), ((NSUInteger)(6 * [[_forest trees] count])));
    __block CNVoidRefArray a = ar;
    __block CNVoidRefArray ia = iar;
    NSInteger one = 4 * 6;
    __block CNVoidRefArray ibp = cnVoidRefArrayAddBytes(ibr, ((NSUInteger)(one * ([[_forest trees] count] - 1))));
    __block unsigned int i = 0;
    [[_forest trees] forEach:^void(TRTree* tree) {
        a = [self writeA:a tree:tree];
        ia = [EGD2D writeQuadIndexIn:ia i:i];
        [EGD2D writeQuadIndexIn:ibp i:i];
        ibp = cnVoidRefArraySubBytes(ibp, ((NSUInteger)(one)));
        i += 4;
    }];
    [_vb setArray:ar];
    [_ib setArray:iar];
    [_ibShadow setArray:ibr];
    cnVoidRefArrayFree(ar);
    cnVoidRefArrayFree(iar);
    cnVoidRefArrayFree(ibr);
}

- (void)draw {
    [EGBlendFunction.standard applyDraw:^void() {
        [EGGlobal.context.cullFace disabledF:^void() {
            if([EGGlobal.context.renderTarget isShadow]) [_shadowVao drawParam:_shadowMaterial];
            else [_vao drawParam:_material];
        }];
    }];
}

- (CNVoidRefArray)writeA:(CNVoidRefArray)a tree:(TRTree*)tree {
    TRTreeType* tp = tree.treeType;
    GEQuad mainUv = tp.uvQuad;
    GEPlaneCoord planeCoord = GEPlaneCoordMake(GEPlaneMake(GEVec3Make(0.0, 0.0, 0.0), GEVec3Make(0.0, 0.0, 1.0)), GEVec3Make(1.0, 0.0, 0.0), GEVec3Make(0.0, 1.0, 0.0));
    GEPlaneCoord mPlaneCoord = gePlaneCoordSetY(planeCoord, geVec3Normalize(geVec3AddVec3(planeCoord.y, GEVec3Make([tree incline].x, 0.0, [tree incline].y))));
    GEQuad quad = geRectStripQuad(geRectMulVec2(geRectCenterX(geRectApplyXYSize(0.0, 0.0, tp.size)), tree.size));
    GEQuad3 quad3 = GEQuad3Make(mPlaneCoord, quad);
    GEQuad mQuad = GEQuadMake(geVec3Xy(geQuad3P0(quad3)), geVec3Xy(geQuad3P1(quad3)), geVec3Xy(geQuad3P2(quad3)), geVec3Xy(geQuad3P3(quad3)));
    CGFloat r = tree.rustle * 0.1 * tp.rustleStrength;
    GEQuad rustleUv = geQuadAddVec2(mainUv, GEVec2Make(geRectWidth(tp.uv), 0.0));
    GEVec3 at = geVec3ApplyVec2Z(tree.position, 0.0);
    CNVoidRefArray v = cnVoidRefArrayWriteTpItem(a, TRTreeData, TRTreeDataMake(at, mQuad.p0, mainUv.p0, geVec2AddVec2(rustleUv.p0, GEVec2Make(((float)(r)), ((float)(-r))))));
    v = cnVoidRefArrayWriteTpItem(v, TRTreeData, TRTreeDataMake(at, mQuad.p1, mainUv.p1, geVec2AddVec2(rustleUv.p1, GEVec2Make(((float)(-r)), ((float)(r))))));
    v = cnVoidRefArrayWriteTpItem(v, TRTreeData, TRTreeDataMake(at, mQuad.p2, mainUv.p2, geVec2AddVec2(rustleUv.p2, GEVec2Make(((float)(r)), ((float)(-r))))));
    v = cnVoidRefArrayWriteTpItem(v, TRTreeData, TRTreeDataMake(at, mQuad.p3, mainUv.p3, geVec2AddVec2(rustleUv.p3, GEVec2Make(((float)(-r)), ((float)(r))))));
    return v;
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


