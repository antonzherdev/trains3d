#import "objd.h"
#import "GEVec.h"
#import "EGMesh.h"
@class EGMapSso;
@class EGMaterial;
@protocol EGVertexBuffer;
@class EGCameraIso;
@class GEMat4;
@class EGVBO;
@class EGEmptyIndexSource;
@class EGColorSource;
@class EGArrayIndexSource;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;

@class EGMapSsoView;

@interface EGMapSsoView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMaterial* material;
@property (nonatomic, readonly) EGMesh* plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map material:(EGMaterial*)material;
- (id)initWithMap:(EGMapSso*)map material:(EGMaterial*)material;
- (ODClassType*)type;
- (id<EGVertexBuffer>)axisVertexBuffer;
- (void)drawLayout;
- (void)draw;
+ (ODClassType*)type;
@end


