#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGStandardShader;
@class EGSimpleColorShader;
@class EGSimpleTextureShader;
#import "EGTypes.h"
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial2;
@class EGMaterialColor;
@class EGStandardMaterial;
@class EGMaterial;

@class EGMesh;
@class EGMeshModel;

@interface EGMesh : NSObject
@property (nonatomic, readonly) EGVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) EGIndexBuffer* indexBuffer;

+ (id)meshWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer;
- (id)initWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer;
+ (EGMesh*)applyVertexData:(CNPArray*)vertexData index:(CNPArray*)index;
- (void)drawWithMaterial:(EGMaterial2*)material;
@end


@interface EGMeshModel : NSObject
@property (nonatomic, readonly) id<CNSeq> meshes;

+ (id)meshModelWithMeshes:(id<CNSeq>)meshes;
- (id)initWithMeshes:(id<CNSeq>)meshes;
- (void)draw;
@end


