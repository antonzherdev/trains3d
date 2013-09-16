#import "objd.h"
#import "EGMesh.h"
#import "GEVec.h"
#import "EGTypes.h"
@class EGGlobal;
@class TRCity;
@class GEMat4;
@class EGMatrixModel;
@class TRCityAngle;
@class TRCityColor;
@class EGColorSource;
@class EGStandardMaterial;
@class TRModels;
@class EGAnimation;
@class EGMatrixStack;

@class TRCityView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) EGMesh* expectedTrainModel;

+ (id)cityView;
- (id)init;
- (ODClassType*)type;
- (void)drawCity:(TRCity*)city;
+ (ODType*)type;
@end


