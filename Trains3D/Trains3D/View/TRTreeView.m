#import "TRTreeView.h"

#import "PGVertex.h"
#import "GL.h"
#import "PGContext.h"
#import "PGMatrixModel.h"
#import "PGMaterial.h"
#import "CNChain.h"
#import "PGVertexArray.h"
#import "PGIndex.h"
#import "PGMesh.h"
#import "PGBuffer.h"
#import "CNFuture.h"
@implementation TRTreeShaderBuilder
static CNClassType* _TRTreeShaderBuilder_type;
@synthesize shadow = _shadow;

+ (instancetype)treeShaderBuilderWithShadow:(BOOL)shadow {
    return [[TRTreeShaderBuilder alloc] initWithShadow:shadow];
}

- (instancetype)initWithShadow:(BOOL)shadow {
    self = [super init];
    if(self) _shadow = shadow;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTreeShaderBuilder class]) _TRTreeShaderBuilder_type = [CNClassType classTypeWithCls:[TRTreeShaderBuilder class]];
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

- (PGShaderProgram*)program {
    return [PGShaderProgram applyName:@"Tree" vertex:[self vertex] fragment:[self fragment]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TreeShaderBuilder(%d)", _shadow];
}

- (CNClassType*)type {
    return [TRTreeShaderBuilder type];
}

+ (CNClassType*)type {
    return _TRTreeShaderBuilder_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTreeShader
static TRTreeShader* _TRTreeShader_instanceForShadow;
static TRTreeShader* _TRTreeShader_instance;
static PGVertexBufferDesc* _TRTreeShader_vbDesc;
static CNClassType* _TRTreeShader_type;
@synthesize shadow = _shadow;
@synthesize positionSlot = _positionSlot;
@synthesize modelSlot = _modelSlot;
@synthesize uvSlot = _uvSlot;
@synthesize uvShiverSlot = _uvShiverSlot;
@synthesize wcUniform = _wcUniform;
@synthesize pUniform = _pUniform;

+ (instancetype)treeShaderWithProgram:(PGShaderProgram*)program shadow:(BOOL)shadow {
    return [[TRTreeShader alloc] initWithProgram:program shadow:shadow];
}

- (instancetype)initWithProgram:(PGShaderProgram*)program shadow:(BOOL)shadow {
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
        _TRTreeShader_type = [CNClassType classTypeWithCls:[TRTreeShader class]];
        _TRTreeShader_instanceForShadow = [TRTreeShader treeShaderWithProgram:[[TRTreeShaderBuilder treeShaderBuilderWithShadow:YES] program] shadow:YES];
        _TRTreeShader_instance = [TRTreeShader treeShaderWithProgram:[[TRTreeShaderBuilder treeShaderBuilderWithShadow:NO] program] shadow:NO];
        _TRTreeShader_vbDesc = [PGVertexBufferDesc vertexBufferDescWithDataType:trTreeDataType() position:0 uv:((int)(5 * 4)) normal:-1 color:-1 model:((int)(3 * 4))];
    }
}

- (void)loadAttributesVbDesc:(PGVertexBufferDesc*)vbDesc {
    [_positionSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:3 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_position))];
    [_modelSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_model))];
    [_uvSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_uv))];
    [_uvShiverSlot setFromBufferWithStride:((NSUInteger)([vbDesc stride])) valuesCount:2 valuesType:GL_FLOAT shift:((NSUInteger)(vbDesc->_uv + 2 * 4))];
}

- (void)loadUniformsParam:(PGColorSource*)param {
    [_wcUniform applyMatrix:[[[PGGlobal matrix] value] wc]];
    [_pUniform applyMatrix:[[[PGGlobal matrix] value] p]];
    {
        PGTexture* _ = ((PGColorSource*)(param))->_texture;
        if(_ != nil) [[PGGlobal context] bindTextureTexture:_];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TreeShader(%d)", _shadow];
}

- (CNClassType*)type {
    return [TRTreeShader type];
}

+ (TRTreeShader*)instanceForShadow {
    return _TRTreeShader_instanceForShadow;
}

+ (TRTreeShader*)instance {
    return _TRTreeShader_instance;
}

+ (PGVertexBufferDesc*)vbDesc {
    return _TRTreeShader_vbDesc;
}

+ (CNClassType*)type {
    return _TRTreeShader_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

NSString* trTreeDataDescription(TRTreeData self) {
    return [NSString stringWithFormat:@"TreeData(%@, %@, %@, %@)", pgVec3Description(self.position), pgVec2Description(self.model), pgVec2Description(self.uv), pgVec2Description(self.uvShiver)];
}
BOOL trTreeDataIsEqualTo(TRTreeData self, TRTreeData to) {
    return pgVec3IsEqualTo(self.position, to.position) && pgVec2IsEqualTo(self.model, to.model) && pgVec2IsEqualTo(self.uv, to.uv) && pgVec2IsEqualTo(self.uvShiver, to.uvShiver);
}
NSUInteger trTreeDataHash(TRTreeData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + pgVec3Hash(self.position);
    hash = hash * 31 + pgVec2Hash(self.model);
    hash = hash * 31 + pgVec2Hash(self.uv);
    hash = hash * 31 + pgVec2Hash(self.uvShiver);
    return hash;
}
CNPType* trTreeDataType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[TRTreeDataWrap class] name:@"TRTreeData" size:sizeof(TRTreeData) wrap:^id(void* data, NSUInteger i) {
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
    return trTreeDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    TRTreeDataWrap* o = ((TRTreeDataWrap*)(other));
    return trTreeDataIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return trTreeDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation TRTreeView
static CNClassType* _TRTreeView_type;
@synthesize forest = _forest;
@synthesize texture = _texture;
@synthesize material = _material;
@synthesize vbs = _vbs;

+ (instancetype)treeViewWithForest:(TRForest*)forest {
    return [[TRTreeView alloc] initWithForest:forest];
}

- (instancetype)initWithForest:(TRForest*)forest {
    self = [super init];
    __weak TRTreeView* _weakSelf = self;
    if(self) {
        _forest = forest;
        _texture = [PGGlobal compressedTextureForFile:[TRForestType value:forest->_rules->_forestType].name filter:PGTextureFilter_linear];
        _material = [PGColorSource applyColor:PGVec4Make(1.0, 1.0, 1.0, 1.0) texture:_texture];
        _vbs = [[[intTo(1, 3) chain] mapF:^PGMutableVertexBuffer*(id _) {
            return [PGVBO mutDesc:[TRTreeShader vbDesc] usage:GL_DYNAMIC_DRAW];
        }] toArray];
        _vaos = [PGVertexArrayRing vertexArrayRingWithRingSize:3 creator:^PGVertexArray*(unsigned int _) {
            TRTreeView* _self = _weakSelf;
            if(_self != nil) return [[PGMesh meshWithVertex:((PGMutableVertexBuffer*)(nonnil([_self->_vbs applyIndex:((NSUInteger)(_))]))) index:[PGIBO mutUsage:GL_STREAM_DRAW]] vaoShader:[TRTreeShader instance]];
            else return nil;
        }];
        _shadowMaterial = [PGColorSource applyColor:PGVec4Make(1.0, 1.0, 1.0, 1.0) texture:_texture alphaTestLevel:0.1];
        _shadowVaos = [PGVertexArrayRing vertexArrayRingWithRingSize:3 creator:^PGVertexArray*(unsigned int _) {
            TRTreeView* _self = _weakSelf;
            if(_self != nil) return [[PGMesh meshWithVertex:((PGMutableVertexBuffer*)(nonnil([_self->_vbs applyIndex:((NSUInteger)(_))]))) index:[PGIBO mutUsage:GL_STREAM_DRAW]] vaoShader:[TRTreeShader instanceForShadow]];
            else return nil;
        }];
        _writer = [TRTreeWriter treeWriterWithForest:forest];
        __first = YES;
        __firstDrawInFrame = YES;
        __treesIndexCount = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTreeView class]) _TRTreeView_type = [CNClassType classTypeWithCls:[TRTreeView class]];
}

- (void)prepare {
    __firstDrawInFrame = YES;
    if(__first) {
        [self complete];
        __first = NO;
    }
}

- (void)complete {
    _vao = [_vaos next];
    _shadowVao = [_shadowVaos next];
    if(_vao != nil && _shadowVao != nil) {
        [((PGVertexArray*)(_shadowVao)) syncWait];
        [((PGVertexArray*)(_vao)) syncWait];
        NSUInteger n = [_forest treesCount];
        _vbo = [((PGMutableVertexBuffer*)(nonnil([((PGVertexArray*)(_vao)) mutableVertexBuffer]))) beginWriteCount:((unsigned int)(4 * n))];
        _ibo = [((PGMutableIndexBuffer*)([((PGVertexArray*)(_vao)) index])) beginWriteCount:((unsigned int)(6 * n))];
        _shadowIbo = [((PGMutableIndexBuffer*)([((PGVertexArray*)(_shadowVao)) index])) beginWriteCount:((unsigned int)(6 * n))];
        if(_vbo != nil && _ibo != nil && _shadowIbo != nil) {
            _writeFuture = [_writer writeToVbo:_vbo ibo:_ibo shadowIbo:_shadowIbo maxCount:((unsigned int)(n))];
        } else {
            [((PGMappedBufferData*)(_vbo)) finish];
            [((PGMappedBufferData*)(_ibo)) finish];
            [((PGMappedBufferData*)(_shadowIbo)) finish];
            _writeFuture = nil;
        }
    }
}

- (void)draw {
    if(_writeFuture != nil) {
        if(__firstDrawInFrame) {
            __treesIndexCount = unumui([((CNFuture*)(_writeFuture)) getResultAwait:1.0]);
            [((PGMappedBufferData*)(_vbo)) finish];
            [((PGMappedBufferData*)(_ibo)) finish];
            [((PGMappedBufferData*)(_shadowIbo)) finish];
            __firstDrawInFrame = NO;
        }
        if([[PGGlobal context]->_renderTarget isShadow]) {
            {
                PGCullFace* __tmp__il__0t_1t_0self = [PGGlobal context]->_cullFace;
                {
                    unsigned int __il__0t_1t_0oldValue = [__tmp__il__0t_1t_0self disable];
                    [((PGVertexArray*)(_shadowVao)) drawParam:_shadowMaterial start:0 end:__treesIndexCount];
                    if(__il__0t_1t_0oldValue != GL_NONE) [__tmp__il__0t_1t_0self setValue:__il__0t_1t_0oldValue];
                }
            }
            [((PGVertexArray*)(_shadowVao)) syncSet];
        } else {
            PGEnablingState* __il__0t_1f_0__tmp__il__0self = [PGGlobal context]->_blend;
            {
                BOOL __il__0t_1f_0__il__0changed = [__il__0t_1f_0__tmp__il__0self enable];
                {
                    [[PGGlobal context] setBlendFunction:[PGBlendFunction standard]];
                    {
                        PGCullFace* __tmp__il__0t_1f_0rp0self = [PGGlobal context]->_cullFace;
                        {
                            unsigned int __il__0t_1f_0rp0oldValue = [__tmp__il__0t_1f_0rp0self disable];
                            [((PGVertexArray*)(_vao)) drawParam:_material start:0 end:__treesIndexCount];
                            if(__il__0t_1f_0rp0oldValue != GL_NONE) [__tmp__il__0t_1f_0rp0self setValue:__il__0t_1f_0rp0oldValue];
                        }
                    }
                }
                if(__il__0t_1f_0__il__0changed) [__il__0t_1f_0__tmp__il__0self disable];
            }
            [((PGVertexArray*)(_vao)) syncSet];
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TreeView(%@)", _forest];
}

- (CNClassType*)type {
    return [TRTreeView type];
}

+ (CNClassType*)type {
    return _TRTreeView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation TRTreeWriter
static CNClassType* _TRTreeWriter_type;
@synthesize forest = _forest;

+ (instancetype)treeWriterWithForest:(TRForest*)forest {
    return [[TRTreeWriter alloc] initWithForest:forest];
}

- (instancetype)initWithForest:(TRForest*)forest {
    self = [super init];
    if(self) _forest = forest;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [TRTreeWriter class]) _TRTreeWriter_type = [CNClassType classTypeWithCls:[TRTreeWriter class]];
}

- (CNFuture*)writeToVbo:(PGMappedBufferData*)vbo ibo:(PGMappedBufferData*)ibo shadowIbo:(PGMappedBufferData*)shadowIbo maxCount:(unsigned int)maxCount {
    return [self lockAndOnSuccessFuture:[_forest trees] f:^id(NSArray* trees) {
        unsigned int ret = 0;
        if([vbo beginWrite]) {
            {
                TRTreeData* v = vbo->_pointer;
                if([ibo beginWrite]) {
                    {
                        unsigned int* i = ibo->_pointer;
                        if([shadowIbo beginWrite]) {
                            {
                                unsigned int* s = shadowIbo->_pointer;
                                ret = [self _writeToVbo:v ibo:i shadowIbo:s trees:trees maxCount:maxCount];
                            }
                            [shadowIbo endWrite];
                        }
                    }
                    [ibo endWrite];
                }
            }
            [vbo endWrite];
        }
        return numui4(ret);
    }];
}

- (unsigned int)_writeToVbo:(TRTreeData*)vbo ibo:(unsigned int*)ibo shadowIbo:(unsigned int*)shadowIbo trees:(NSArray*)trees maxCount:(unsigned int)maxCount {
    __block TRTreeData* a = vbo;
    __block unsigned int* ia = ibo;
    NSUInteger n = uintMinB([trees count], ((NSUInteger)(maxCount)));
    __block unsigned int* ib = shadowIbo + 6 * (n - 1);
    __block unsigned int j = 0;
    __block unsigned int i = 0;
    for(TRTree* tree in trees) {
        if(j < n) {
            {
                TRTreeTypeR __il__6rt_0tp = ((TRTree*)(tree))->_treeType;
                PGQuad __il__6rt_0mainUv = [TRTreeType value:__il__6rt_0tp].uvQuad;
                PGPlaneCoord __il__6rt_0planeCoord = PGPlaneCoordMake((PGPlaneMake((PGVec3Make(0.0, 0.0, 0.0)), (PGVec3Make(0.0, 0.0, 1.0)))), (PGVec3Make(1.0, 0.0, 0.0)), (PGVec3Make(0.0, 1.0, 0.0)));
                PGPlaneCoord __il__6rt_0mPlaneCoord = pgPlaneCoordSetY(__il__6rt_0planeCoord, (pgVec3Normalize((pgVec3AddVec3(__il__6rt_0planeCoord.y, (PGVec3Make([((TRTree*)(tree)) incline].x, 0.0, [((TRTree*)(tree)) incline].y)))))));
                PGQuad __il__6rt_0quad = pgRectStripQuad((pgRectMulVec2((pgRectCenterX((pgRectApplyXYSize(0.0, 0.0, [TRTreeType value:__il__6rt_0tp].size)))), ((TRTree*)(tree))->_size)));
                PGQuad3 __il__6rt_0quad3 = PGQuad3Make(__il__6rt_0mPlaneCoord, __il__6rt_0quad);
                PGQuad __il__6rt_0mQuad = PGQuadMake(pgVec3Xy(pgQuad3P0(__il__6rt_0quad3)), pgVec3Xy(pgQuad3P1(__il__6rt_0quad3)), pgVec3Xy(pgQuad3P2(__il__6rt_0quad3)), pgVec3Xy(pgQuad3P3(__il__6rt_0quad3)));
                CGFloat __il__6rt_0r = ((TRTree*)(tree))->_rustle * 0.1 * [TRTreeType value:__il__6rt_0tp].rustleStrength;
                PGQuad __il__6rt_0rustleUv = pgQuadAddVec2(__il__6rt_0mainUv, (PGVec2Make(pgRectWidth([TRTreeType value:__il__6rt_0tp].uv), 0.0)));
                PGVec3 __il__6rt_0at = pgVec3ApplyVec2Z(((TRTree*)(tree))->_position, 0.0);
                TRTreeData* __il__6rt_0v = a;
                __il__6rt_0v->position = __il__6rt_0at;
                __il__6rt_0v->model = __il__6rt_0mQuad.p0;
                __il__6rt_0v->uv = __il__6rt_0mainUv.p0;
                __il__6rt_0v->uvShiver = pgVec2AddVec2(__il__6rt_0rustleUv.p0, (PGVec2Make(((float)(__il__6rt_0r)), ((float)(-__il__6rt_0r)))));
                __il__6rt_0v++;
                __il__6rt_0v->position = __il__6rt_0at;
                __il__6rt_0v->model = __il__6rt_0mQuad.p1;
                __il__6rt_0v->uv = __il__6rt_0mainUv.p1;
                __il__6rt_0v->uvShiver = pgVec2AddVec2(__il__6rt_0rustleUv.p1, (PGVec2Make(((float)(-__il__6rt_0r)), ((float)(__il__6rt_0r)))));
                __il__6rt_0v++;
                __il__6rt_0v->position = __il__6rt_0at;
                __il__6rt_0v->model = __il__6rt_0mQuad.p2;
                __il__6rt_0v->uv = __il__6rt_0mainUv.p2;
                __il__6rt_0v->uvShiver = pgVec2AddVec2(__il__6rt_0rustleUv.p2, (PGVec2Make(((float)(__il__6rt_0r)), ((float)(-__il__6rt_0r)))));
                __il__6rt_0v++;
                __il__6rt_0v->position = __il__6rt_0at;
                __il__6rt_0v->model = __il__6rt_0mQuad.p3;
                __il__6rt_0v->uv = __il__6rt_0mainUv.p3;
                __il__6rt_0v->uvShiver = pgVec2AddVec2(__il__6rt_0rustleUv.p3, (PGVec2Make(((float)(-__il__6rt_0r)), ((float)(__il__6rt_0r)))));
                a = __il__6rt_0v + 1;
            }
            {
                *(ia + 0) = i;
                *(ia + 1) = i + 1;
                *(ia + 2) = i + 2;
                *(ia + 3) = i + 1;
                *(ia + 4) = i + 2;
                *(ia + 5) = i + 3;
                ia = ia + 6;
            }
            {
                *(ib + 0) = i;
                *(ib + 1) = i + 1;
                *(ib + 2) = i + 2;
                *(ib + 3) = i + 1;
                *(ib + 4) = i + 2;
                *(ib + 5) = i + 3;
                ib = ib + 6;
            }
            ib -= 12;
            i += 4;
            j++;
        }
    }
    return ((unsigned int)(6 * n));
}

- (NSString*)description {
    return [NSString stringWithFormat:@"TreeWriter(%@)", _forest];
}

- (CNClassType*)type {
    return [TRTreeWriter type];
}

+ (CNClassType*)type {
    return _TRTreeWriter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

