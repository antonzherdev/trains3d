#import "objd.h"
#import "GEVec.h"
@class EGMesh;
@class EGStandardMaterial;
@class EGTexture;
@class EGGlobal;
@class EGColorSource;
@class TRModels;
@class TRCity;
@class GEMat4;
@class EGMatrixModel;
@class TRCityAngle;
@class TRCityColor;
@class EGMaterial;
@class EGContext;
@class EGRenderTarget;
@class EGEnablingState;
@class EGCounter;
@class EGMatrixStack;

@class TRCityView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) EGMesh* expectedTrainModel;
@property (nonatomic, readonly) EGTexture* roofTexture;
@property (nonatomic, readonly) EGStandardMaterial* windowMaterial;
@property (nonatomic, readonly) EGMesh* vaoBody;
@property (nonatomic, readonly) EGMesh* vaoRoof;
@property (nonatomic, readonly) EGMesh* vaoWindows;

+ (id)cityView;
- (id)init;
- (ODClassType*)type;
- (void)drawCity:(TRCity*)city;
+ (ODClassType*)type;
@end


