#import "objd.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGGL.h"
@class EGSchedule;
@class EGAnimation;
@class EGMesh;
@class EGMeshModel;
#import "EGTypes.h"
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class TRCityAngle;
@class TRCity;
@class TRColor;
@class TR3D;
@class EGMatrix;
@class EGTexture;
@class EGFileTexture;

@class TRCityView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) EGMesh* expectedTrainModel;

+ (id)cityView;
- (id)init;
- (ODClassType*)type;
- (void)drawCity:(TRCity*)city;
+ (ODClassType*)type;
@end


