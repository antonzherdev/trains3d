#import "objd.h"
#import "GEVec.h"
@class TRLevel;
@class EGTexture;
@class EGGlobal;
@class EGVertexArray;
@class TRModels;
@class EGStandardMaterial;
@class EGMesh;
@class TRCity;
@class GEMat4;
@class EGMatrixModel;
@class TRCityAngle;
@class TRCityColor;
@class EGColorSource;
@class EGMatrixStack;
@class EGContext;
@class EGBlendFunction;
@class EGRenderTarget;
@class EGD2D;
@class EGCounter;
@class EGEnablingState;

@class TRCityView;

@interface TRCityView : NSObject
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGTexture* cityTexture;
@property (nonatomic, readonly) EGVertexArray* vaoBody;

+ (id)cityViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (void)drawExpected;
+ (ODClassType*)type;
@end


