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
#import "EGMatrixModel.h"
NSString* EGMeshDataDescription(EGMeshData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGMeshData: "];
    [description appendFormat:@"uv=%@", GEVec2Description(self.uv)];
    [description appendFormat:@", normal=%@", GEVec3Description(self.normal)];
    [description appendFormat:@", position=%@", GEVec3Description(self.position)];
    [description appendString:@">"];
    return description;
}
EGMeshData egMeshDataMulMat4(EGMeshData self, GEMat4* mat4) {
    return EGMeshDataMake(self.uv, (geVec4Xyz(([mat4 mulVec4:geVec4ApplyVec3W(self.normal, 0.0)]))), (geVec4Xyz(([mat4 mulVec4:geVec4ApplyVec3W(self.position, 1.0)]))));
}
EGMeshData egMeshDataUvAddVec2(EGMeshData self, GEVec2 vec2) {
    return EGMeshDataMake((geVec2AddVec2(self.uv, vec2)), self.normal, self.position);
}
ODPType* egMeshDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGMeshDataWrap class] name:@"EGMeshData" size:sizeof(EGMeshData) wrap:^id(void* data, NSUInteger i) {
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
    return EGMeshDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMeshDataWrap* o = ((EGMeshDataWrap*)(other));
    return EGMeshDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGMeshDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation EGMeshDataModel
static ODClassType* _EGMeshDataModel_type;
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
    if(self == [EGMeshDataModel class]) _EGMeshDataModel_type = [ODClassType classTypeWithCls:[EGMeshDataModel class]];
}

- (ODClassType*)type {
    return [EGMeshDataModel type];
}

+ (ODClassType*)type {
    return _EGMeshDataModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vertex=%@", self.vertex];
    [description appendFormat:@", index=%@", self.index];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMesh
static ODClassType* _EGMesh_type;
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
    if(self == [EGMesh class]) _EGMesh_type = [ODClassType classTypeWithCls:[EGMesh class]];
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

- (ODClassType*)type {
    return [EGMesh type];
}

+ (ODClassType*)type {
    return _EGMesh_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vertex=%@", self.vertex];
    [description appendFormat:@", index=%@", self.index];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMeshModel
static ODClassType* _EGMeshModel_type;
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
    if(self == [EGMeshModel class]) _EGMeshModel_type = [ODClassType classTypeWithCls:[EGMeshModel class]];
}

+ (EGMeshModel*)applyMeshes:(NSArray*)meshes {
    return [EGMeshModel applyShadow:NO meshes:meshes];
}

+ (EGMeshModel*)applyShadow:(BOOL)shadow meshes:(NSArray*)meshes {
    return [EGMeshModel meshModelWithArrays:[[[meshes chain] map:^EGVertexArray*(CNTuple* p) {
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

- (ODClassType*)type {
    return [EGMeshModel type];
}

+ (ODClassType*)type {
    return _EGMeshModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"arrays=%@", self.arrays];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMeshUnite
static ODClassType* _EGMeshUnite_type;
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
        _vbo = [EGVBO mutMesh];
        _ibo = [EGIBO mut];
        _mesh = [EGMesh meshWithVertex:_vbo index:_ibo];
        _vao = _createVao(_mesh);
        __count = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMeshUnite class]) _EGMeshUnite_type = [ODClassType classTypeWithCls:[EGMeshUnite class]];
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
    [mat4Array forEach:^void(GEMat4* _) {
        [w writeMat4:_];
    }];
    [w flush];
}

- (EGMeshWriter*)writerCount:(unsigned int)count {
    __count = count;
    return [EGMeshWriter meshWriterWithVbo:_vbo ibo:_ibo count:count vertexSample:_vertexSample indexSample:_indexSample];
}

- (void)draw {
    if(__count > 0) {
        EGMatrixStack* __tmp_0_0self = EGGlobal.matrix;
        {
            [__tmp_0_0self push];
            [[__tmp_0_0self value] clear];
            [_vao draw];
            [__tmp_0_0self pop];
        }
    }
}

- (ODClassType*)type {
    return [EGMeshUnite type];
}

+ (ODClassType*)type {
    return _EGMeshUnite_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vertexSample=%@", self.vertexSample];
    [description appendFormat:@", indexSample=%@", self.indexSample];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMeshWriter
static ODClassType* _EGMeshWriter_type;
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
        _vertex = cnVoidRefArrayApplyTpCount(egMeshDataType(), _vertexSample.count * _count);
        _index = cnVoidRefArrayApplyTpCount(oduInt4Type(), _indexSample.count * _count);
        __vp = _vertex;
        __ip = _index;
        __indexShift = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMeshWriter class]) _EGMeshWriter_type = [ODClassType classTypeWithCls:[EGMeshWriter class]];
}

- (void)writeMat4:(GEMat4*)mat4 {
    [self writeVertex:_vertexSample index:_indexSample mat4:mat4];
}

- (void)writeVertex:(CNPArray*)vertex mat4:(GEMat4*)mat4 {
    [self writeVertex:vertex index:_indexSample mat4:mat4];
}

- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index mat4:(GEMat4*)mat4 {
    [vertex forRefEach:^void(VoidRef r) {
        __vp = cnVoidRefArrayWriteTpItem(__vp, EGMeshData, (egMeshDataMulMat4(*(((EGMeshData*)(r))), mat4)));
    }];
    [index forRefEach:^void(VoidRef r) {
        __ip = cnVoidRefArrayWriteUInt4(__ip, *(((unsigned int*)(r))) + __indexShift);
    }];
    __indexShift += ((unsigned int)(vertex.count));
}

- (void)writeMap:(EGMeshData(^)(EGMeshData))map {
    [self writeVertex:_vertexSample index:_indexSample map:map];
}

- (void)writeVertex:(CNPArray*)vertex map:(EGMeshData(^)(EGMeshData))map {
    [self writeVertex:vertex index:_indexSample map:map];
}

- (void)writeVertex:(CNPArray*)vertex index:(CNPArray*)index map:(EGMeshData(^)(EGMeshData))map {
    [vertex forRefEach:^void(VoidRef r) {
        __vp = cnVoidRefArrayWriteTpItem(__vp, EGMeshData, map(*(((EGMeshData*)(r)))));
    }];
    [index forRefEach:^void(VoidRef r) {
        __ip = cnVoidRefArrayWriteUInt4(__ip, *(((unsigned int*)(r))) + __indexShift);
    }];
    __indexShift += ((unsigned int)(vertex.count));
}

- (void)flush {
    [_vbo setArray:_vertex];
    [_ibo setArray:_index];
}

- (void)dealloc {
    cnVoidRefArrayFree(_vertex);
    cnVoidRefArrayFree(_index);
}

- (ODClassType*)type {
    return [EGMeshWriter type];
}

+ (ODClassType*)type {
    return _EGMeshWriter_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vbo=%@", self.vbo];
    [description appendFormat:@", ibo=%@", self.ibo];
    [description appendFormat:@", count=%u", self.count];
    [description appendFormat:@", vertexSample=%@", self.vertexSample];
    [description appendFormat:@", indexSample=%@", self.indexSample];
    [description appendString:@">"];
    return description;
}

@end


