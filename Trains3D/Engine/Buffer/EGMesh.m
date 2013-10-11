#import "EGMesh.h"

#import "EGVertex.h"
#import "EGIndex.h"
#import "EGShader.h"
#import "EGPlatform.h"
#import "EGContext.h"
#import "EGMaterial.h"
NSString* EGMeshDataDescription(EGMeshData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGMeshData: "];
    [description appendFormat:@"uv=%@", GEVec2Description(self.uv)];
    [description appendFormat:@", normal=%@", GEVec3Description(self.normal)];
    [description appendFormat:@", position=%@", GEVec3Description(self.position)];
    [description appendString:@">"];
    return description;
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



@implementation EGMesh{
    id<EGVertexBuffer> _vertex;
    id<EGIndexSource> _index;
}
static ODClassType* _EGMesh_type;
@synthesize vertex = _vertex;
@synthesize index = _index;

+ (id)meshWithVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index {
    return [[EGMesh alloc] initWithVertex:vertex index:index];
}

- (id)initWithVertex:(id<EGVertexBuffer>)vertex index:(id<EGIndexSource>)index {
    self = [super init];
    if(self) {
        _vertex = vertex;
        _index = index;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMesh_type = [ODClassType classTypeWithCls:[EGMesh class]];
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
    return [shader vaoVbo:_vertex ibo:_index];
}

- (EGVertexArray*)vaoMaterial:(id)material shadow:(BOOL)shadow {
    EGMaterialVertexArray* std = [EGMaterialVertexArray materialVertexArrayWithVao:[[material shader] vaoVbo:_vertex ibo:_index] material:material];
    if(shadow && egPlatform().shadows) return [EGRouteVertexArray routeVertexArrayWithStandard:std shadow:[EGMaterialVertexArray materialVertexArrayWithVao:[[[material shaderSystem] shaderForParam:material renderTarget:EGShadowRenderTarget.aDefault] vaoVbo:_vertex ibo:_index] material:material]];
    else return std;
}

- (EGVertexArray*)vaoShaderSystem:(EGShaderSystem*)shaderSystem material:(id)material shadow:(BOOL)shadow {
    EGMaterialVertexArray* std = [EGMaterialVertexArray materialVertexArrayWithVao:[[shaderSystem shaderForParam:material] vaoVbo:_vertex ibo:_index] material:material];
    if(shadow && egPlatform().shadows) return [EGRouteVertexArray routeVertexArrayWithStandard:std shadow:[EGMaterialVertexArray materialVertexArrayWithVao:[[shaderSystem shaderForParam:material renderTarget:EGShadowRenderTarget.aDefault] vaoVbo:_vertex ibo:_index] material:material]];
    else return std;
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMesh* o = ((EGMesh*)(other));
    return [self.vertex isEqual:o.vertex] && [self.index isEqual:o.index];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.vertex hash];
    hash = hash * 31 + [self.index hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vertex=%@", self.vertex];
    [description appendFormat:@", index=%@", self.index];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMeshModel{
    id<CNSeq> _arrays;
}
static ODClassType* _EGMeshModel_type;
@synthesize arrays = _arrays;

+ (id)meshModelWithArrays:(id<CNSeq>)arrays {
    return [[EGMeshModel alloc] initWithArrays:arrays];
}

- (id)initWithArrays:(id<CNSeq>)arrays {
    self = [super init];
    if(self) _arrays = arrays;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMeshModel_type = [ODClassType classTypeWithCls:[EGMeshModel class]];
}

+ (EGMeshModel*)applyMeshes:(id<CNSeq>)meshes {
    return [EGMeshModel applyShadow:NO meshes:meshes];
}

+ (EGMeshModel*)applyShadow:(BOOL)shadow meshes:(id<CNSeq>)meshes {
    return [EGMeshModel meshModelWithArrays:[[[meshes chain] map:^EGVertexArray*(CNTuple* p) {
        return [((EGMesh*)(p.a)) vaoMaterial:((EGMaterial*)(p.b)) shadow:shadow];
    }] toArray]];
}

- (void)draw {
    [_arrays forEach:^void(EGVertexArray* _) {
        [_ draw];
    }];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMeshModel* o = ((EGMeshModel*)(other));
    return [self.arrays isEqual:o.arrays];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.arrays hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"arrays=%@", self.arrays];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVertexArray
static ODClassType* _EGVertexArray_type;

+ (id)vertexArray {
    return [[EGVertexArray alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVertexArray_type = [ODClassType classTypeWithCls:[EGVertexArray class]];
}

- (void)drawParam:(id)param {
    @throw @"Method draw is abstract";
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (ODClassType*)type {
    return [EGVertexArray type];
}

+ (ODClassType*)type {
    return _EGVertexArray_type;
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


@implementation EGRouteVertexArray{
    EGVertexArray* _standard;
    EGVertexArray* _shadow;
}
static ODClassType* _EGRouteVertexArray_type;
@synthesize standard = _standard;
@synthesize shadow = _shadow;

+ (id)routeVertexArrayWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow {
    return [[EGRouteVertexArray alloc] initWithStandard:standard shadow:shadow];
}

- (id)initWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow {
    self = [super init];
    if(self) {
        _standard = standard;
        _shadow = shadow;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGRouteVertexArray_type = [ODClassType classTypeWithCls:[EGRouteVertexArray class]];
}

- (EGVertexArray*)mesh {
    if([EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]]) return _shadow;
    else return _standard;
}

- (void)drawParam:(id)param {
    [[self mesh] drawParam:param];
}

- (void)draw {
    [[self mesh] draw];
}

- (ODClassType*)type {
    return [EGRouteVertexArray type];
}

+ (ODClassType*)type {
    return _EGRouteVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRouteVertexArray* o = ((EGRouteVertexArray*)(other));
    return [self.standard isEqual:o.standard] && [self.shadow isEqual:o.shadow];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.standard hash];
    hash = hash * 31 + [self.shadow hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"standard=%@", self.standard];
    [description appendFormat:@", shadow=%@", self.shadow];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSimpleVertexArray{
    GLuint _handle;
    EGShader* _shader;
    id<CNSeq> _buffers;
    id<EGIndexSource> _index;
}
static ODClassType* _EGSimpleVertexArray_type;
@synthesize handle = _handle;
@synthesize shader = _shader;
@synthesize buffers = _buffers;
@synthesize index = _index;

+ (id)simpleVertexArrayWithHandle:(GLuint)handle shader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index {
    return [[EGSimpleVertexArray alloc] initWithHandle:handle shader:shader buffers:buffers index:index];
}

- (id)initWithHandle:(GLuint)handle shader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index {
    self = [super init];
    if(self) {
        _handle = handle;
        _shader = shader;
        _buffers = buffers;
        _index = index;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleVertexArray_type = [ODClassType classTypeWithCls:[EGSimpleVertexArray class]];
}

+ (EGSimpleVertexArray*)applyShader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index {
    return [EGSimpleVertexArray simpleVertexArrayWithHandle:egGenVertexArray() shader:shader buffers:buffers index:index];
}

- (void)bind {
    [EGGlobal.context bindVertexArrayHandle:_handle];
}

- (void)unbind {
    [EGGlobal.context bindDefaultVertexArray];
}

- (void)dealloc {
    egDeleteVertexArray(_handle);
}

- (NSUInteger)count {
    return [((id<EGVertexBuffer>)([_buffers head])) count];
}

- (void)drawParam:(id)param {
    [_shader drawParam:param vao:self];
}

- (void)draw {
    @throw @"No default material";
}

- (ODClassType*)type {
    return [EGSimpleVertexArray type];
}

+ (ODClassType*)type {
    return _EGSimpleVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSimpleVertexArray* o = ((EGSimpleVertexArray*)(other));
    return GLuintEq(self.handle, o.handle) && [self.shader isEqual:o.shader] && [self.buffers isEqual:o.buffers] && [self.index isEqual:o.index];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GLuintHash(self.handle);
    hash = hash * 31 + [self.shader hash];
    hash = hash * 31 + [self.buffers hash];
    hash = hash * 31 + [self.index hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%@", GLuintDescription(self.handle)];
    [description appendFormat:@", shader=%@", self.shader];
    [description appendFormat:@", buffers=%@", self.buffers];
    [description appendFormat:@", index=%@", self.index];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMaterialVertexArray{
    EGVertexArray* _vao;
    id _material;
}
static ODClassType* _EGMaterialVertexArray_type;
@synthesize vao = _vao;
@synthesize material = _material;

+ (id)materialVertexArrayWithVao:(EGVertexArray*)vao material:(id)material {
    return [[EGMaterialVertexArray alloc] initWithVao:vao material:material];
}

- (id)initWithVao:(EGVertexArray*)vao material:(id)material {
    self = [super init];
    if(self) {
        _vao = vao;
        _material = material;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMaterialVertexArray_type = [ODClassType classTypeWithCls:[EGMaterialVertexArray class]];
}

- (void)draw {
    [_vao drawParam:_material];
}

- (void)drawParam:(id)param {
    [_vao drawParam:param];
}

- (ODClassType*)type {
    return [EGMaterialVertexArray type];
}

+ (ODClassType*)type {
    return _EGMaterialVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMaterialVertexArray* o = ((EGMaterialVertexArray*)(other));
    return [self.vao isEqual:o.vao] && [self.material isEqual:o.material];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.vao hash];
    hash = hash * 31 + [self.material hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vao=%@", self.vao];
    [description appendFormat:@", material=%@", self.material];
    [description appendString:@">"];
    return description;
}

@end


