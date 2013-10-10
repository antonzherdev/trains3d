#import "EGMesh.h"

#import "EGVertex.h"
#import "EGIndex.h"
#import "EGShader.h"
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
    id<EGVertexSource> _vertex;
    id<EGIndexSource> _index;
}
static ODClassType* _EGMesh_type;
@synthesize vertex = _vertex;
@synthesize index = _index;

+ (id)meshWithVertex:(id<EGVertexSource>)vertex index:(id<EGIndexSource>)index {
    return [[EGMesh alloc] initWithVertex:vertex index:index];
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
    _EGMesh_type = [ODClassType classTypeWithCls:[EGMesh class]];
}

+ (EGMesh*)vec2VertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGMesh meshWithVertex:[EGVertexBuffer vec2Data:vertexData] index:[EGIndexBuffer applyData:indexData]];
}

+ (EGMesh*)applyVertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGMesh meshWithVertex:[EGVertexBuffer meshData:vertexData] index:[EGIndexBuffer applyData:indexData]];
}

+ (EGMesh*)applyDesc:(EGVertexBufferDesc*)desc vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGMesh meshWithVertex:[EGVertexBuffer applyDesc:desc data:vertexData] index:[EGIndexBuffer applyData:indexData]];
}

- (EGMesh*)vaoWithShader:(EGShader*)shader {
    return [EGMesh meshWithVertex:[shader vaoWithVbo:((EGVertexBuffer*)(_vertex))] index:_index];
}

- (EGMesh*)vaoWithMaterial:(EGMaterial*)material {
    return [EGMesh meshWithVertex:[[material shader] vaoWithVbo:((EGVertexBuffer*)(_vertex))] index:_index];
}

- (EGMesh*)vaoWithShaderSystem:(EGShaderSystem*)shaderSystem material:(id)material {
    return [EGMesh meshWithVertex:[shaderSystem vaoWithParam:material vbo:((EGVertexBuffer*)(_vertex))] index:_index];
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


