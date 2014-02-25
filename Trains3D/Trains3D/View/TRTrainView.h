#import "objd.h"
#import "EGBillboardView.h"
#import "GEVec.h"
#import "TRCar.h"
@class EGTextureFormat;
@class EGTextureFilter;
@class EGGlobal;
@class EGColorSource;
@class EGBlendFunction;
@class TRSmoke;
@class TRCityColor;
@class EGProgress;
@class TRLevel;
@class TRModels;
@class TRTrain;
@class GEMat4;
@class EGMMatrixModel;
@class EGMatrixStack;
@class TRTrainType;
@class EGRigidBody;
@class EGVertexArray;
@class EGStandardMaterial;
@class EGNormalMap;
@class EGBlendMode;
@class EGMesh;
@class EGContext;
@class EGRenderTarget;

@class TRSmokeView;
@class TRTrainView;
@class TRCarModel;

@interface TRSmokeView : EGBillboardParticleSystemView
@property (nonatomic, readonly) TRSmoke* system;

+ (id)smokeViewWithSystem:(TRSmoke*)system;
- (id)initWithSystem:(TRSmoke*)system;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTrainView : NSObject
@property (nonatomic, readonly) TRLevel* level;

+ (id)trainViewWithLevel:(TRLevel*)level;
- (id)initWithLevel:(TRLevel*)level;
- (ODClassType*)type;
- (void)draw;
- (void)drawSmoke;
- (void)drawTrains:(id<CNSeq>)trains;
- (void)drawSmokeTrains:(id<CNSeq>)trains;
+ (GEVec4)crazyColorTime:(CGFloat)time;
- (void)drawDyingTrains:(id<CNSeq>)dyingTrains;
+ (ODClassType*)type;
@end


@interface TRCarModel : NSObject
@property (nonatomic, readonly) EGVertexArray* colorVao;
@property (nonatomic, readonly) EGVertexArray* blackVao;
@property (nonatomic, readonly) EGVertexArray* shadowVao;
@property (nonatomic, readonly) id texture;
@property (nonatomic, readonly) id normalMap;

+ (id)carModelWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(id)texture normalMap:(id)normalMap;
- (id)initWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(id)texture normalMap:(id)normalMap;
- (ODClassType*)type;
+ (EGStandardMaterial*)trainMaterialForDiffuse:(EGColorSource*)diffuse normalMap:(id)normalMap;
+ (TRCarModel*)applyColorMesh:(EGMesh*)colorMesh blackMesh:(EGMesh*)blackMesh shadowMesh:(EGMesh*)shadowMesh texture:(id)texture normalMap:(id)normalMap;
- (void)drawColor:(GEVec4)color;
+ (EGColorSource*)blackMaterial;
+ (ODClassType*)type;
@end


