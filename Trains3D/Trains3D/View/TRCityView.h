#import "objd.h"
@class EG;
#import "EGGL.h"
@class EGSchedule;
@class EGAnimation;
@class EGMesh;
@class EGMeshModel;
#import "EGTypes.h"
@class EGContext;
@class EGMutableMatrix;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial2;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class TRCityAngle;
@class TRCity;
@class TRColor;
@class TR3D;

@class TRCityView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) EGMesh* expectedTrainModel;

+ (id)cityView;
- (id)init;
- (void)drawCity:(TRCity*)city;
- (ODType*)type;
+ (ODType*)type;
@end


