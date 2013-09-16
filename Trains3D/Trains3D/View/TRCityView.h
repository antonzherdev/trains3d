#import "objd.h"
#import "EGMesh.h"
#import "GEVec.h"
#import "EGTypes.h"
@class EG;
@class TRCity;
@class GEMat4;
@class EGMatrixModel;
@class TRCityAngle;
@class TRColor;
@class EGColorSource;
@class EGStandardMaterial;
@class TR3D;
@class EGAnimation;
@class EGMatrixStack;

@class TRCityView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) EGMesh* expectedTrainModel;

+ (id)cityView;
- (id)init;
- (ODClassType*)type;
- (void)drawCity:(TRCity*)city;
+ (ODClassType*)type;
@end


