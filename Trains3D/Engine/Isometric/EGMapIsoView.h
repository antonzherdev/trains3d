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
@class EGVertexArray;
@class EGColorSource;
@class EGArrayIndexSource;
@class EGGlobal;
@class EGContext;
@class EGCullFace;

@class EGMapSsoView;

@interface EGMapSsoView : NSObject {
@protected
    EGMapSso* _map;
    EGMaterial* _material;
    CNLazy* __lazy_axisVertexBuffer;
    EGMesh* _plane;
    EGVertexArray* _planeVao;
}
@property (nonatomic, readonly) EGMapSso* map;
@property (nonatomic, readonly) EGMaterial* material;
@property (nonatomic, readonly) EGMesh* plane;

+ (instancetype)mapSsoViewWithMap:(EGMapSso*)map material:(EGMaterial*)material;
- (instancetype)initWithMap:(EGMapSso*)map material:(EGMaterial*)material;
- (CNClassType*)type;
- (id<EGVertexBuffer>)axisVertexBuffer;
- (void)drawLayout;
- (void)draw;
- (NSString*)description;
+ (CNClassType*)type;
@end


