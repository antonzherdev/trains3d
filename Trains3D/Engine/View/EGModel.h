#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGStandardShader;
@class EGSimpleColorShader;
#import "EGTypes.h"

@class EGMesh;

@interface EGMesh : NSObject
@property (nonatomic, readonly) EGVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) EGIndexBuffer* indexBuffer;
@property (nonatomic, readonly) EGSimpleColorShader* shader;

+ (id)meshWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer;
- (id)initWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer;
+ (EGMesh*)applyVertexData:(CNPArray*)vertexData index:(CNPArray*)index;
- (void)draw;
@end


