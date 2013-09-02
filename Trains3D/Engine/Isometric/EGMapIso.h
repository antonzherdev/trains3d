#import "objd.h"
@class CNChain;
@class CNRange;
@class CNRangeIterator;
@class CNPArray;
@class CNPArrayIterator;
@class CNMutablePArray;
#import "EGTypes.h"
@class EG;
#import "EGGL.h"
@class EGMesh;
@class EGMeshModel;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGTexture;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@protocol EGShaderSystem;
@class EGContext;
@class EGMutableMatrix;

@class EGMapSso;
@class EGMapSsoView;

@interface EGMapSso : NSObject
@property (nonatomic, readonly) EGSizeI size;
@property (nonatomic, readonly) EGRectI limits;
@property (nonatomic, readonly) id<CNSeq> fullTiles;
@property (nonatomic, readonly) id<CNSeq> partialTiles;
@property (nonatomic, readonly) id<CNSeq> allTiles;

+ (id)mapSsoWithSize:(EGSizeI)size;
- (id)initWithSize:(EGSizeI)size;
- (ODClassType*)type;
- (BOOL)isFullTile:(EGPointI)tile;
- (BOOL)isPartialTile:(EGPointI)tile;
- (EGRectI)cutRectForTile:(EGPointI)tile;
+ (CGFloat)ISO;
+ (ODClassType*)type;
@end


@interface EGMapSsoView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMesh* plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (ODClassType*)type;
- (void)drawLayout;
- (EGMesh*)createPlane;
- (void)drawPlaneWithMaterial:(EGMaterial*)material;
+ (ODClassType*)type;
@end


