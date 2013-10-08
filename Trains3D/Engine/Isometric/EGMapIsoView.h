#import "objd.h"
#import "GEVec.h"
#import "EGMesh.h"
@class EGMapSso;
@class EGCameraIso;
@class GEMat4;
@class EGColorSource;
@class EGMaterial;

@class EGMapSsoView;

@interface EGMapSsoView : NSObject
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMesh* plane;

+ (id)mapSsoViewWithMap:(EGMapSso*)map;
- (id)initWithMap:(EGMapSso*)map;
- (ODClassType*)type;
- (EGVertexBuffer*)axisVertexBuffer;
- (void)drawLayout;
- (void)drawPlaneWithMaterial:(EGMaterial*)material;
+ (ODClassType*)type;
@end


