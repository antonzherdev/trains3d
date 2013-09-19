#import "objd.h"
#import "GEVec.h"
@class EGMesh;
@class EGFileTexture;
@class EGGlobal;
@class EGStandardMaterial;
@class EGColorSource;
@class TRCity;
@class GEMat4;
@class EGMatrixModel;
@class TRCityAngle;
@class TRCityColor;
@class TRModels;
@class EGMaterial;
@class EGAnimation;
@class EGMatrixStack;

@class TRCityView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) EGMesh* expectedTrainModel;
@property (nonatomic, readonly) EGFileTexture* roofTexture;
@property (nonatomic, readonly) EGStandardMaterial* windowMaterial;

+ (id)cityView;
- (id)init;
- (ODClassType*)type;
- (void)drawCity:(TRCity*)city;
+ (ODClassType*)type;
@end


