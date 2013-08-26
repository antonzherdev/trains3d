#import "EGModel.h"

#import "CNData.h"
#import "EGBuffer.h"
#import "EGStandardShader.h"
@implementation EGMesh{
    EGVertexBuffer* _vertexBuffer;
    EGIndexBuffer* _indexBuffer;
    EGSimpleColorShader* _shader;
}
@synthesize vertexBuffer = _vertexBuffer;
@synthesize indexBuffer = _indexBuffer;
@synthesize shader = _shader;

+ (id)meshWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer {
    return [[EGMesh alloc] initWithVertexBuffer:vertexBuffer indexBuffer:indexBuffer];
}

- (id)initWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer {
    self = [super init];
    if(self) {
        _vertexBuffer = vertexBuffer;
        _indexBuffer = indexBuffer;
        _shader = [EGSimpleColorShader simpleColorShader];
    }
    
    return self;
}

+ (EGMesh*)applyVertexData:(CNPArray*)vertexData index:(CNPArray*)index {
    return [EGMesh meshWithVertexBuffer:[[EGVertexBuffer applyStride:((NSUInteger)(8 * 4))] setData:vertexData] indexBuffer:[[EGIndexBuffer apply] setData:index]];
}

- (void)draw {
    [_vertexBuffer bind];
    _shader.color = EGColorMake(0.0, 1.0, 0.0, 1.0);
    [_shader drawF:^void() {
        [_indexBuffer draw];
    }];
    [_vertexBuffer unbind];
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


