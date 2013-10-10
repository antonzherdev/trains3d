#import "EGMesh.h"

#import "EGVertex.h"
#import "EGIndex.h"
#import "EGShader.h"
#import "EGMaterial.h"
#import "EGContext.h"
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



@implementation EGMesh
static ODClassType* _EGMesh_type;

+ (id)mesh {
    return [[EGMesh alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMesh_type = [ODClassType classTypeWithCls:[EGMesh class]];
}

- (id<EGVertexSource>)vertex {
    @throw @"Method vertex is abstract";
}

- (id<EGIndexSource>)index {
    @throw @"Method index is abstract";
}

+ (EGMesh*)vec2VertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGSimpleMesh simpleMeshWithVertex:[EGVertexBuffer vec2Data:vertexData] index:[EGIndexBuffer applyData:indexData]];
}

+ (EGMesh*)applyVertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGSimpleMesh simpleMeshWithVertex:[EGVertexBuffer meshData:vertexData] index:[EGIndexBuffer applyData:indexData]];
}

+ (EGMesh*)applyDesc:(EGVertexBufferDesc*)desc vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGSimpleMesh simpleMeshWithVertex:[EGVertexBuffer applyDesc:desc data:vertexData] index:[EGIndexBuffer applyData:indexData]];
}

+ (EGSimpleMesh*)applyVertex:(id<EGVertexSource>)vertex index:(id<EGIndexSource>)index {
    return [EGSimpleMesh simpleMeshWithVertex:vertex index:index];
}

- (EGMesh*)vaoWithShader:(EGShader*)shader {
    return [EGSimpleMesh simpleMeshWithVertex:[shader vaoWithVbo:((EGVertexBuffer*)([self vertex]))] index:[self index]];
}

- (EGMesh*)vaoWithMaterial:(EGMaterial*)material shadow:(BOOL)shadow {
    EGVertexArray* std = [[material shader] vaoWithVbo:((EGVertexBuffer*)([self vertex]))];
    if(shadow) return [EGRouteMesh routeMeshWithIndex:[self index] standard:std shadow:[[[material shaderSystem] shaderForParam:material renderTarget:EGShadowRenderTarget.aDefault] vaoWithVbo:((EGVertexBuffer*)([self vertex]))]];
    else return [EGMesh applyVertex:std index:[self index]];
}

- (EGMesh*)vaoWithShaderSystem:(EGShaderSystem*)shaderSystem material:(id)material shadow:(BOOL)shadow {
    EGVertexArray* std = [[shaderSystem shaderForParam:material] vaoWithVbo:((EGVertexBuffer*)([self vertex]))];
    if(shadow) return [EGRouteMesh routeMeshWithIndex:[self index] standard:std shadow:[[shaderSystem shaderForParam:material renderTarget:EGShadowRenderTarget.aDefault] vaoWithVbo:((EGVertexBuffer*)([self vertex]))]];
    else return [EGMesh applyVertex:std index:[self index]];
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


@implementation EGSimpleMesh{
    id<EGVertexSource> _vertex;
    id<EGIndexSource> _index;
}
static ODClassType* _EGSimpleMesh_type;
@synthesize vertex = _vertex;
@synthesize index = _index;

+ (id)simpleMeshWithVertex:(id<EGVertexSource>)vertex index:(id<EGIndexSource>)index {
    return [[EGSimpleMesh alloc] initWithVertex:vertex index:index];
}

- (id)initWithVertex:(id<EGVertexSource>)vertex index:(id<EGIndexSource>)index {
    self = [super init];
    if(self) {
        _vertex = vertex;
        _index = index;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGSimpleMesh_type = [ODClassType classTypeWithCls:[EGSimpleMesh class]];
}

- (ODClassType*)type {
    return [EGSimpleMesh type];
}

+ (ODClassType*)type {
    return _EGSimpleMesh_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSimpleMesh* o = ((EGSimpleMesh*)(other));
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


@implementation EGRouteMesh{
    id<EGIndexSource> _index;
    id<EGVertexSource> _standard;
    id<EGVertexSource> _shadow;
}
static ODClassType* _EGRouteMesh_type;
@synthesize index = _index;
@synthesize standard = _standard;
@synthesize shadow = _shadow;

+ (id)routeMeshWithIndex:(id<EGIndexSource>)index standard:(id<EGVertexSource>)standard shadow:(id<EGVertexSource>)shadow {
    return [[EGRouteMesh alloc] initWithIndex:index standard:standard shadow:shadow];
}

- (id)initWithIndex:(id<EGIndexSource>)index standard:(id<EGVertexSource>)standard shadow:(id<EGVertexSource>)shadow {
    self = [super init];
    if(self) {
        _index = index;
        _standard = standard;
        _shadow = shadow;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGRouteMesh_type = [ODClassType classTypeWithCls:[EGRouteMesh class]];
}

- (id<EGVertexSource>)vertex {
    if([EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]]) return _shadow;
    else return _standard;
}

- (ODClassType*)type {
    return [EGRouteMesh type];
}

+ (ODClassType*)type {
    return _EGRouteMesh_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRouteMesh* o = ((EGRouteMesh*)(other));
    return [self.index isEqual:o.index] && [self.standard isEqual:o.standard] && [self.shadow isEqual:o.shadow];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.index hash];
    hash = hash * 31 + [self.standard hash];
    hash = hash * 31 + [self.shadow hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"index=%@", self.index];
    [description appendFormat:@", standard=%@", self.standard];
    [description appendFormat:@", shadow=%@", self.shadow];
    [description appendString:@">"];
    return description;
}

@end


