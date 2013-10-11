#import "objd.h"
#import "GEVec.h"
@class EGVertexArray;
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
@class EGContext;
@class EGRenderTarget;
@class EGEnablingState;
@class EGCounter;
@class EGMatrixStack;

@class TRCityView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) EGVertexArray* expectedTrainModel;
@property (nonatomic, readonly) EGTexture* roofTexture;
@property (nonatomic, readonly) EGStandardMaterial* windowMaterial;
@property (nonatomic, readonly) EGVertexArray* vaoBody;
@property (nonatomic, readonly) EGVertexArray* vaoRoof;
@property (nonatomic, readonly) EGVertexArray* vaoWindows;

+ (id)cityView;
- (id)init;
- (ODClassType*)type;
- (void)drawCity:(TRCity*)city;
+ (ODClassType*)type;
@end


