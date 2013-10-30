#import "objd.h"
#import "GEVec.h"
@class TRLevel;
@class TRModels;
@class EGGlobal;
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
@class EGRigidBody;
@class EGColorSource;
@class EGVertexArray;
@class EGStandardMaterial;
@class EGMesh;
@class EGBlendMode;
@class EGContext;
@class EGRenderTarget;

@class TRTrainView;
@class TRCarModel;

@interface TRTrainView : NSObject
@property (nonatomic, readonly) TRLevel* level;

+ (id)trainViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (void)drawSmoke;
- (void)drawTrains:(id<CNSeq>)trains;
- (void)drawSmokeTrains:(id<CNSeq>)trains;
- (void)drawDyingTrains:(id<CNSeq>)dyingTrains;
- (void)updateWithDelta:(CGFloat)delta train:(TRTrain*)train;
+ (ODClassType*)type;
@end


@interface TRCarModel : NSObject
@property (nonatomic, readonly) EGVertexArray* colorVao;
@property (nonatomic, readonly) EGVertexArray* blackVao;
@property (nonatomic, readonly) EGVertexArray* shadowVao;
@property (nonatomic, readonly) id texture;

+ (id)carModelWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(id)texture;
- (id)initWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(id)texture;
- (ODClassType*)type;
+ (EGStandardMaterial*)trainMaterialForDiffuse:(EGColorSource*)diffuse;
+ (TRCarModel*)applyColorMesh:(EGMesh*)colorMesh blackMesh:(EGMesh*)blackMesh shadowMesh:(EGMesh*)shadowMesh;
+ (TRCarModel*)applyColorMesh:(EGMesh*)colorMesh blackMesh:(EGMesh*)blackMesh shadowMesh:(EGMesh*)shadowMesh texture:(id)texture;
- (void)drawColor:(GEVec4)color;
+ (EGColorSource*)blackMaterial;
+ (ODClassType*)type;
@end


