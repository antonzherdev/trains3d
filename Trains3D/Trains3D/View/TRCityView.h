#import "objd.h"
#import "GEVec.h"
@class TRLevel;
@class EGVertexArray;
@class EGMesh;
@class EGStandardMaterial;
@class EGTexture;
@class EGGlobal;
@class TRModels;
@class EGColorSource;
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
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGVertexArray* expectedTrainModel;
@property (nonatomic, readonly) EGTexture* roofTexture;
@property (nonatomic, readonly) EGVertexArray* vaoBody;
@property (nonatomic, readonly) EGVertexArray* vaoRoof;
@property (nonatomic, readonly) EGVertexArray* vaoWindows;

+ (id)cityViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
+ (ODClassType*)type;
@end


