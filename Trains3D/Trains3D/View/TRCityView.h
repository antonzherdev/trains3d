#import "objd.h"
#import "GEVec.h"
@class TRLevel;
@class EGVertexArray;
@class EGMesh;
@class EGStandardMaterial;
@class EGTexture;
@class EGGlobal;
@class TRModels;
@class TRCity;
@class GEMat4;
@class EGMatrixModel;
@class TRCityAngle;
@class TRCityColor;
@class EGColorSource;
@class EGContext;
@class EGRenderTarget;
@class EGCounter;
@class EGMatrixStack;

@class TRCityView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGVertexArray* expectedTrainModel;
@property (nonatomic, readonly) EGTexture* cityTexture;
@property (nonatomic, readonly) EGVertexArray* vaoBody;

+ (id)cityViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


