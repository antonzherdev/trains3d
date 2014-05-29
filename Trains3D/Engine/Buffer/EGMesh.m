#import "EGMesh.h"

#import "GEMat4.h"
#import "EGVertex.h"
#import "EGIndex.h"
#import "EGVertexArray.h"
#import "EGShader.h"
#import "EGShadow.h"
#import "EGMaterial.h"
#import "EGPlatformPlat.h"
#import "EGPlatform.h"
#import "EGContext.h"
#import "CNChain.h"
#import "GL.h"
#import "EGMatrixModel.h"
EGMeshData egMeshDataMulMat4(EGMeshData self, GEMat4* mat4) {
    return EGMeshDataMake(self.uv, (geVec4Xyz(([mat4 mulVec4:geVec4ApplyVec3W(self.normal, 0.0)]))), (geVec4Xyz(([mat4 mulVec4:geVec4ApplyVec3W(self.position, 1.0)]))));
}
EGMeshData egMeshDataUvAddVec2(EGMeshData self, GEVec2 vec2) {
    return EGMeshDataMake((geVec2AddVec2(self.uv, vec2)), self.normal, self.position);
}
NSString* egMeshDataDescription(EGMeshData self) {
    return [NSString stringWithFormat:@"MeshData(%@, %@, %@)", geVec2Description(self.uv), geVec3Description(self.normal), geVec3Description(self.position)];
}
BOOL egMeshDataIsEqualTo(EGMeshData self, EGMeshData to) {
    return geVec2IsEqualTo(self.uv, to.uv) && geVec3IsEqualTo(self.normal, to.normal) && geVec3IsEqualTo(self.position, to.position);
}
NSUInteger egMeshDataHash(EGMeshData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + geVec2Hash(self.uv);
    hash = hash * 31 + geVec3Hash(self.normal);
    hash = hash * 31 + geVec3Hash(self.position);
    return hash;
}
CNPType* egMeshDataType() {
    static CNPType* _ret = nil;
    if(_ret == nil) _ret = [CNPType typeWithCls:[EGMeshDataWrap class] name:@"EGMeshData" size:sizeof(EGMeshData) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGMeshData, ((EGMeshData*)(data))[i]);
    }];
    return _ret;
}
@implementation EGMeshDataWrap{
    EGMeshData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGMeshData)value {
    return [[EGMeshDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGMeshData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return egMeshDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMeshDataWrap* o = ((EGMeshDataWrap*)(other));
    return egMeshDataIsEqualTo(_value, o.value);
}

- (NSUInteger)hash {
    return egMeshDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end


@implementation EGMeshDataModel
static CNClassType* _EGMeshDataModel_type;
@synthesize vertex = _vertex;
@synthesize index = _index;

+ (instancetype)meshDataModelWithVertex:(CNPArray*)vertex index:(CNPArray*)index {
    return [[EGMeshDataModel alloc] initWithVertex:vertex index:index];
}

- (instancetype)initWithVertex:(CNPArray*)vertex index:(CNPArray*)index {
    self = [super init];
    if(self) {
        _vertex = vertex;
        _index = index;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMeshDataModel class]) _EGMeshDataModel_type = [CNClassType classTypeWithCls:[EGMeshDataModel class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MeshDataModel(%@, %@)", _vertex, _index];
}

- (CNClassType*)type {
    return [EGMeshDataModel type];
}

+ (CNClassType*)type {
    return _EGMeshDataModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMesh
static CNClassType* _EGMesh_type;
@synthesize vertex = _vertex;
@synthesize index = _index;

+ (instancetype)meshWithVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index {
    return [[EGMesh alloc] initWithVertex:vertex index:index];
}

- (instancetype)initWithVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index {
    self = [super init];
    if(self) {
        _vertex = vertex;
        _index = index;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMesh class]) _EGMesh_type = [CNClassType classTypeWithCls:[EGMesh class]];
}

+ (EGMesh*)vec2VertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGMesh meshWithVertex:[EGVBO vec2Data:vertexData] index:[EGIBO applyData:indexData]];
}

+ (EGMesh*)applyVertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGMesh meshWithVertex:[EGVBO meshData:vertexData] index:[EGIBO applyData:indexData]];
}

+ (EGMesh*)applyDesc:(EGVertexBufferDesc*)desc vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGMesh meshWithVertex:[EGVBO applyDesc:desc data:vertexData] index:[EGIBO applyData:indexData]];
}

- (EGVertexArray*)vaoShader:(EGShader*)shader {
    return [shader vaoVbo:_vertex ibo:((id<EGIndexBuffer>)(_index))];
}

- (EGVertexArray*)vaoShadow {
    return [self vaoShaderSystem:EGShadowShaderSystem.instance material:[EGColorSource applyColor:GEVec4Make(1.0, 1.0, 1.0, 1.0)] shadow:NO];
}

- (EGVertexArray*)vaoShadowMaterial:(EGColorSource*)material {
    return [self vaoShaderSystem:EGShadowShaderSystem.instance material:material shadow:NO];
}

- (EGVertexArray*)vaoMaterial:(id)material shadow:(BOOL)shadow {
    EGMaterialVertexArray* std = [EGMaterialVertexArray materialVertexArrayWithVao:[[material shader] vaoVbo:_vertex ibo:((id<EGIndexBuffer>)(_index))] material:material];
    if(shadow && egPlatform().shadows) return ((EGVertexArray*)([EGRouteVertexArray routeVertexArrayWithStandard:std shadow:[EGMaterialVertexArray materialVertexArrayWithVao:[[[material shaderSystem] shaderForParam:material renderTarget:EGShadowRenderTarget.aDefault] vaoVbo:_vertex ibo:((id<EGIndexBuffer>)(_index))] material:material]]));
    else return ((EGVertexArray*)(std));
}

- (EGVertexArray*)vaoShaderSystem:(EGShaderSystem*)shaderSystem material:(id)material shadow:(BOOL)shadow {
    EGMaterialVertexArray* std = [EGMaterialVertexArray materialVertexArrayWithVao:[[shaderSystem shaderForParam:material] vaoVbo:_vertex ibo:((id<EGIndexBuffer>)(_index))] material:material];
    if(shadow && egPlatform().shadows) return ((EGVertexArray*)([EGRouteVertexArray routeVertexArrayWithStandard:std shadow:[EGMaterialVertexArray materialVertexArrayWithVao:[[shaderSystem shaderForParam:material renderTarget:EGShadowRenderTarget.aDefault] vaoVbo:_vertex ibo:((id<EGIndexBuffer>)(_index))] material:material]]));
    else return ((EGVertexArray*)(std));
}

- (void)drawMaterial:(EGMaterial*)material {
    [material drawMesh:self];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Mesh(%@, %@)", _vertex, _index];
}

- (CNClassType*)type {
    return [EGMesh type];
}

+ (CNClassType*)type {
    return _EGMesh_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMeshModel
static CNClassType* _EGMeshModel_type;
@synthesize arrays = _arrays;

+ (instancetype)meshModelWithArrays:(NSArray*)arrays {
    return [[EGMeshModel alloc] initWithArrays:arrays];
}

- (instancetype)initWithArrays:(NSArray*)arrays {
    self = [super init];
    if(self) _arrays = arrays;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMeshModel class]) _EGMeshModel_type = [CNClassType classTypeWithCls:[EGMeshModel class]];
}

+ (EGMeshModel*)applyMeshes:(NSArray*)meshes {
    return [EGMeshModel applyShadow:NO meshes:meshes];
}

+ (EGMeshModel*)applyShadow:(BOOL)shadow meshes:(NSArray*)meshes {
    return [EGMeshModel meshModelWithArrays:[[[meshes chain] mapF:^EGVertexArray*(CNTuple* p) {
        return [((EGMesh*)(((CNTuple*)(p)).a)) vaoMaterial:((CNTuple*)(p)).b shadow:shadow];
    }] toArray]];
}

- (void)draw {
    for(EGVertexArray* _ in _arrays) {
        [((EGVertexArray*)(_)) draw];
    }
}

- (void)drawOnly:(unsigned int)only {
    if(only == 0) return ;
    __block unsigned int o = only;
    for(EGVertexArray* a in _arrays) {
        [((EGVertexArray*)(a)) draw];
        o--;
        if(o > 0) continue;
        else break;
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MeshModel(%@)", _arrays];
}

- (CNClassType*)type {
    return [EGMeshModel type];
}

+ (CNClassType*)type {
    return _EGMeshModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMeshUnite
static CNClassType* _EGMeshUnite_type;
@synthesize vertexSample = _vertexSample;
@synthesize indexSample = _indexSample;
@synthesize createVao = _createVao;
@synthesize mesh = _mesh;
@synthesize vao = _vao;

+ (instancetype)meshUniteWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(EGVertexArray*(^)(EGMesh*))createVao {
    return [[EGMeshUnite alloc] initWithVertexSample:vertexSample indexSample:indexSample createVao:createVao];
}

- (instancetype)initWithVertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample createVao:(EGVertexArray*(^)(EGMesh*))createVao {
    self = [super init];
    if(self) {
        _vertexSample = vertexSample;
        _indexSample = indexSample;
        _createVao = [createVao copy];
        _vbo = [EGVBO mutMeshUsage:GL_DYNAMIC_DRAW];
        _ibo = [EGIBO mutUsage:GL_DYNAMIC_DRAW];
        _mesh = [EGMesh meshWithVertex:_vbo index:_ibo];
        _vao = createVao(_mesh);
        __count = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMeshUnite class]) _EGMeshUnite_type = [CNClassType classTypeWithCls:[EGMeshUnite class]];
}

+ (EGMeshUnite*)applyMeshModel:(EGMeshDataModel*)meshModel createVao:(EGVertexArray*(^)(EGMesh*))createVao {
    return [EGMeshUnite meshUniteWithVertexSample:meshModel.vertex indexSample:meshModel.index createVao:createVao];
}

- (void)writeCount:(unsigned int)count f:(void(^)(EGMeshWriter*))f {
    EGMeshWriter* w = [self writerCount:count];
    f(w);
    [w flush];
}

- (void)writeMat4Array:(id<CNIterable>)mat4Array {
    EGMeshWriter* w = [self writerCount:((unsigned int)([mat4Array count]))];
    {
        id<CNIterator> __il__1i = [mat4Array iterator];
        while([__il__1i hasNext]) {
            GEMat4* _ = [__il__1i next];
            [w writeMat4:_];
        }
    }
    [w flush];
}

- (EGMeshWriter*)writerCount:(unsigned int)count {
    __count = count;
    return [EGMeshWriter meshWriterWithVbo:_vbo ibo:_ibo count:count vertexSample:_vertexSample indexSample:_indexSample];
}

- (void)draw {
    if(__count > 0) {
        EGMatrixStack* __tmp__il__0t_0self = EGGlobal.matrix;
        {
            [__tmp__il__0t_0self push];
            [[__tmp__il__0t_0self value] clear];
            [_vao draw];
            [__tmp__il__0t_0self pop];
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MeshUnite(%@, %@)", _vertexSample, _indexSample];
}

- (CNClassType*)type {
    return [EGMeshUnite type];
}

+ (CNClassType*)type {
    return _EGMeshUnite_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMeshWriter
static CNClassType* _EGMeshWriter_type;
@synthesize vbo = _vbo;
@synthesize ibo = _ibo;
@synthesize count = _count;
@synthesize vertexSample = _vertexSample;
@synthesize indexSample = _indexSample;

+ (instancetype)meshWriterWithVbo:(EGMutableVertexBuffer*)vbo ibo:(EGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample {
    return [[EGMeshWriter alloc] initWithVbo:vbo ibo:ibo count:count vertexSample:vertexSample indexSample:indexSample];
}

- (instancetype)initWithVbo:(EGMutableVertexBuffer*)vbo ibo:(EGMutableIndexBuffer*)ibo count:(unsigned int)count vertexSample:(CNPArray*)vertexSample indexSample:(CNPArray*)indexSample {
    self = [super init];
    if(self) {
        _vbo = vbo;
        _ibo = ibo;
        _count = count;
        _vertexSample = vertexSample;
        _indexSample = indexSample;
        _vertex = cnPointerApplyTpCount(egMeshDataType(), vertexSample.count * count);
        _index = cnPointerApplyTpCount(cnuInt4Type(), indexSample.count * count);
        __vp = _vertex;
        __ip = _index;
        __indexShift = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMeshWriter class]) _EGMeshWriter_type = [CNClassType classTypeWithCls:[EGMeshWriter class]];
}

- (void)writeMat4:(GEMat4*)mat4 {
    [self writeVertex:_vertexSample index:_indexSample mat4:mat4];
}

- (void)writeVertex:(CNPArray*)vertex mat4:(GEMat4*)mat4 {
    [self writeVertex:vertex index:_indexSample mat4:mat4];
}

- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index mat4:(GEMat4*)mat4 {
    {
        EGMeshData* __il__0__b = vertex.bytes;
        NSInteger __il__0__i = 0;
        while(__il__0__i < vertex.count) {
            {
                *(__vp) = egMeshDataMulMat4(*(__il__0__b), mat4);
                __vp++;
            }
            __il__0__i++;
            __il__0__b++;
        }
    }
    {
        unsigned int* __il__1__b = index.bytes;
        NSInteger __il__1__i = 0;
        while(__il__1__i < index.count) {
            {
                *(__ip) = *(__il__1__b) + __indexShift;
                __ip++;
            }
            __il__1__i++;
            __il__1__b++;
        }
    }
    __indexShift += ((unsigned int)(vertex.count));
}

- (void)writeMap:(EGMeshData(^)(EGMeshData))map {
    [self writeVertex:_vertexSample index:_indexSample map:map];
}

- (void)writeVertex:(CNPArray*)vertex map:(EGMeshData(^)(EGMeshData))map {
    [self writeVertex:vertex index:_indexSample map:map];
}

- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index map:(EGMeshData(^)(EGMeshData))map {
    {
        EGMeshData* __il__0__b = vertex.bytes;
        NSInteger __il__0__i = 0;
        while(__il__0__i < vertex.count) {
            {
                *(__vp) = map(*(__il__0__b));
                __vp++;
            }
            __il__0__i++;
            __il__0__b++;
        }
    }
    {
        unsigned int* __il__1__b = index.bytes;
        NSInteger __il__1__i = 0;
        while(__il__1__i < index.count) {
            {
                *(__ip) = *(__il__1__b) + __indexShift;
                __ip++;
            }
            __il__1__i++;
            __il__1__b++;
        }
    }
    __indexShift += ((unsigned int)(vertex.count));
}

- (void)flush {
    [_vbo setArray:_vertex count:((unsigned int)(_vertexSample.count * _count))];
    [_ibo setArray:_index count:((unsigned int)(_indexSample.count * _count))];
}

- (void)dealloc {
    cnPointerFree(_vertex);
    cnPointerFree(_index);
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MeshWriter(%@, %@, %u, %@, %@)", _vbo, _ibo, _count, _vertexSample, _indexSample];
}

- (CNClassType*)type {
    return [EGMeshWriter type];
}

+ (CNClassType*)type {
    return _EGMeshWriter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

