#import "objd.h"
@class CNChain;
@class CNRange;
@class CNRangeIterator;
@class CNPArray;
@class CNPArrayIterator;
#import "EGTypes.h"
@class EG;
#import "EGGL.h"
@class EGMesh;
@class EGMeshModel;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial2;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMaterial;
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
- (BOOL)isFullTile:(EGPointI)tile;
- (BOOL)isPartialTile:(EGPointI)tile;
- (EGRectI)cutRectForTile:(EGPointI)tile;
- (ODType*)type;
+ (CGFloat)ISO;
+ (ODType*)type;
@end


@interface EGMapSsoView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMeshModel* plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (void)drawLayout;
- (EGMesh*)createPlane;
- (void)drawPlane;
- (ODType*)type;
+ (ODType*)type;
@end


