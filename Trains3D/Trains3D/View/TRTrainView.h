#import "objd.h"
#import "GEVec.h"
@class TRLevel;
@class EGMaterial;
@class EGStandardMaterial;
@class EGTexture;
@class EGGlobal;
@class EGColorSource;
@class EGVertexArray;
@class TRModels;
@class EGMesh;
@class TRTrain;
@class TRSmoke;
@class TRSmokeView;
@class TRCar;
@class TRCarPosition;
@class GELineSegment;
@class GEMat4;
@class EGMatrixModel;
@class TRCityColor;
@class EGMatrixStack;
@class TRCarType;
@class EGContext;
@class EGRenderTarget;
@class EGRigidBody;

@class TRTrainView;

@interface TRTrainView : NSObject
@property (nonatomic, readonly) TRLevel* level;
@property (nonatomic, readonly) EGMaterial* blackMaterial;

+ (id)trainViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (EGStandardMaterial*)trainMaterialForDiffuse:(EGColorSource*)diffuse;
- (void)draw;
- (void)drawSmoke;
- (void)drawTrains:(id<CNSeq>)trains;
- (void)drawSmokeTrains:(id<CNSeq>)trains;
- (void)drawDyingTrains:(id<CNSeq>)dyingTrains;
- (void)updateWithDelta:(CGFloat)delta train:(TRTrain*)train;
+ (ODClassType*)type;
@end


