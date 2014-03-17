#import "objd.h"
#import "EGBillboardView.h"
#import "GEVec.h"
@class EGTextureFormat;
@class EGTextureFilter;
@class EGGlobal;
@class EGColorSource;
@class EGBlendFunction;
@class TRSmoke;
@class TRTrain;
@class TRTrainState;
@class TRCarState;
@class TRCarType;
@class GEMat4;
@class EGMMatrixModel;
@class EGMatrixStack;
@class TRLiveTrainState;
@class TRLiveCarState;
@class TRCityColor;
@class EGProgress;
@class TRModels;
@class TRTrainType;
@class EGStandardMaterial;
@class EGVertexArray;
@class EGNormalMap;
@class EGBlendMode;
@class EGMesh;
@class EGContext;
@class EGRenderTarget;

@class TRSmokeView;
@class TRTrainView;
@class TRTrainModels;
@class TRCarModel;

@interface TRSmokeView : EGBillboardParticleSystemView
+ (instancetype)smokeViewWithSystem:(TRSmoke*)system;
- (instancetype)initWithSystem:(TRSmoke*)system;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface TRTrainView : NSObject {
@private
    TRTrainModels* _models;
    TRTrain* _train;
    TRSmoke* _smoke;
    TRSmokeView* _smokeView;
}
@property (nonatomic, readonly) TRTrainModels* models;
@property (nonatomic, readonly) TRTrain* train;
@property (nonatomic, readonly) TRSmoke* smoke;
@property (nonatomic, readonly) TRSmokeView* smokeView;

+ (instancetype)trainViewWithModels:(TRTrainModels*)models train:(TRTrain*)train;
- (instancetype)initWithModels:(TRTrainModels*)models train:(TRTrain*)train;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)prepare;
- (void)draw;
- (void)drawSmoke;
+ (ODClassType*)type;
@end


@interface TRTrainModels : NSObject {
@private
    TRCarModel* _engineModel;
    TRCarModel* _carModel;
    TRCarModel* _expressEngineModel;
    TRCarModel* _expressCarModel;
}
+ (instancetype)trainModels;
- (instancetype)init;
- (ODClassType*)type;
+ (GEVec4)crazyColorTime:(CGFloat)time;
- (void)drawTrainState:(TRTrainState*)trainState carType:(TRCarType*)carType;
+ (ODClassType*)type;
@end


@interface TRCarModel : NSObject {
@private
    EGVertexArray* _colorVao;
    EGVertexArray* _blackVao;
    EGVertexArray* _shadowVao;
    id _texture;
    id _normalMap;
}
@property (nonatomic, readonly) EGVertexArray* colorVao;
@property (nonatomic, readonly) EGVertexArray* blackVao;
@property (nonatomic, readonly) EGVertexArray* shadowVao;
@property (nonatomic, readonly) id texture;
@property (nonatomic, readonly) id normalMap;

+ (instancetype)carModelWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(id)texture normalMap:(id)normalMap;
- (instancetype)initWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(id)texture normalMap:(id)normalMap;
- (ODClassType*)type;
+ (EGStandardMaterial*)trainMaterialForDiffuse:(EGColorSource*)diffuse normalMap:(id)normalMap;
+ (TRCarModel*)applyColorMesh:(EGMesh*)colorMesh blackMesh:(EGMesh*)blackMesh shadowMesh:(EGMesh*)shadowMesh texture:(id)texture normalMap:(id)normalMap;
- (void)drawColor:(GEVec4)color;
+ (EGStandardMaterial*)blackMaterial;
+ (ODClassType*)type;
@end


