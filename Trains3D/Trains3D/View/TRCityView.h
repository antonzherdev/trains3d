#import "objd.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGGL.h"
@class EGSchedule;
@class EGAnimation;
@class EGMesh;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
#import "EGTypes.h"
#import "EGMaterial.h"
@class EGMatrix;
@class TRCityAngle;
@class TRCity;
@class TRColor;
@class TR3D;

@class TRCityView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) EGMesh* expectedTrainModel;

+ (id)cityView;
- (id)init;
- (ODClassType*)type;
- (void)drawCity:(TRCity*)city;
+ (ODClassType*)type;
@end


