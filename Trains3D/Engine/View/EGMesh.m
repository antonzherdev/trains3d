#import "EGMesh.h"

#import "CNData.h"
#import "EGBuffer.h"
#import "EGSimpleShaderSystem.h"
#import "EGMaterial.h"
@implementation EGMesh{
    EGVertexBuffer* _vertexBuffer;
    EGIndexBuffer* _indexBuffer;
}
static ODType* _EGMesh_type;
@synthesize vertexBuffer = _vertexBuffer;
@synthesize indexBuffer = _indexBuffer;

+ (id)meshWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer {
    return [[EGMesh alloc] initWithVertexBuffer:vertexBuffer indexBuffer:indexBuffer];
}

- (id)initWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer {
    self = [super init];
    if(self) {
        _vertexBuffer = vertexBuffer;
        _indexBuffer = indexBuffer;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMesh_type = [ODType typeWithCls:[EGMesh class]];
}

+ (EGMesh*)applyVertexData:(CNPArray*)vertexData index:(CNPArray*)index {
    return [EGMesh meshWithVertexBuffer:[[EGVertexBuffer applyStride:((NSUInteger)(8 * 4))] setData:vertexData] indexBuffer:[[EGIndexBuffer apply] setData:index]];
}

- (void)drawWithMaterial:(EGMaterial*)material {
    [_vertexBuffer applyDraw:^void() {
        [material applyDraw:^void() {
            [_indexBuffer draw];
        }];
    }];
}

- (ODType*)type {
    return _EGMesh_type;
}

+ (ODType*)type {
    return _EGMesh_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMesh* o = ((EGMesh*)(other));
    return [self.vertexBuffer isEqual:o.vertexBuffer] && [self.indexBuffer isEqual:o.indexBuffer];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.vertexBuffer hash];
    hash = hash * 31 + [self.indexBuffer hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vertexBuffer=%@", self.vertexBuffer];
    [description appendFormat:@", indexBuffer=%@", self.indexBuffer];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMeshModel{
    id<CNSeq> _meshes;
}
static ODType* _EGMeshModel_type;
@synthesize meshes = _meshes;

+ (id)meshModelWithMeshes:(id<CNSeq>)meshes {
    return [[EGMeshModel alloc] initWithMeshes:meshes];
}

- (id)initWithMeshes:(id<CNSeq>)meshes {
    self = [super init];
    if(self) _meshes = meshes;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMeshModel_type = [ODType typeWithCls:[EGMeshModel class]];
}

- (void)draw {
    [_meshes forEach:^void(CNTuple* p) {
        [((EGMesh*)(p.a)) drawWithMaterial:((EGMaterial*)(p.b))];
    }];
}

- (ODType*)type {
    return _EGMeshModel_type;
}

+ (ODType*)type {
    return _EGMeshModel_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMeshModel* o = ((EGMeshModel*)(other));
    return [self.meshes isEqual:o.meshes];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.meshes hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"meshes=%@", self.meshes];
    [description appendString:@">"];
    return description;
}

@end


