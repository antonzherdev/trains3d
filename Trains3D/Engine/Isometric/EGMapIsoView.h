#import "objd.h"
#import "GEVec.h"
#import "EGMesh.h"
@class EGMapSso;
@protocol EGVertexBuffer;
@class EGCameraIso;
@class GEMat4;
@class EGVBO;
@class EGColorSource;
@class EGArrayIndexSource;
@class EGGlobal;
@class EGContext;
@class EGMaterial;
@class EGEnablingState;

@class EGMapSsoView;

@interface EGMapSsoView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMesh* plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (ODClassType*)type;
- (id<EGVertexBuffer>)axisVertexBuffer;
- (void)drawLayout;
- (void)drawPlaneWithMaterial:(EGMaterial*)material;
+ (ODClassType*)type;
@end


