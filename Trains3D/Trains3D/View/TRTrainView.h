#import "objd.h"
#import "EGBillboardView.h"
#import "EGTexture.h"
#import "TRCar.h"
#import "GEVec.h"
#import "TRCity.h"
#import "TRTrain.h"
#import "EGMaterial.h"
@class EGGlobal;
@class TRSmoke;
@class CNFuture;
@class EGMatrixStack;
@class GEMat4;
@class EGMMatrixModel;
@class CNChain;
@class EGProgress;
@class TRModels;
@class EGVertexArray;
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
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTrainView : NSObject {
@protected
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
- (CNClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (void)complete;
- (void)draw;
- (void)drawSmoke;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTrainModels : NSObject {
@protected
    TRCarModel* _engineModel;
    TRCarModel* _carModel;
    TRCarModel* _expressEngineModel;
    TRCarModel* _expressCarModel;
}
+ (instancetype)trainModels;
- (instancetype)init;
- (CNClassType*)type;
+ (GEVec4)crazyColorTime:(CGFloat)time;
- (void)drawTrainState:(TRTrainState*)trainState carType:(TRCarTypeR)carType;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRCarModel : NSObject {
@protected
    EGVertexArray* _colorVao;
    EGVertexArray* _blackVao;
    EGVertexArray* _shadowVao;
    EGTexture* _texture;
    EGTexture* _normalMap;
}
@property (nonatomic, readonly) EGVertexArray* colorVao;
@property (nonatomic, readonly) EGVertexArray* blackVao;
@property (nonatomic, readonly) EGVertexArray* shadowVao;
@property (nonatomic, readonly) EGTexture* texture;
@property (nonatomic, readonly) EGTexture* normalMap;

+ (instancetype)carModelWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(EGTexture*)texture normalMap:(EGTexture*)normalMap;
- (instancetype)initWithColorVao:(EGVertexArray*)colorVao blackVao:(EGVertexArray*)blackVao shadowVao:(EGVertexArray*)shadowVao texture:(EGTexture*)texture normalMap:(EGTexture*)normalMap;
- (CNClassType*)type;
+ (EGStandardMaterial*)trainMaterialForDiffuse:(EGColorSource*)diffuse normalMap:(EGTexture*)normalMap;
+ (TRCarModel*)applyColorMesh:(EGMesh*)colorMesh blackMesh:(EGMesh*)blackMesh shadowMesh:(EGMesh*)shadowMesh texture:(EGTexture*)texture normalMap:(EGTexture*)normalMap;
- (void)drawColor:(GEVec4)color;
- (NSString*)description;
+ (EGStandardMaterial*)blackMaterial;
+ (CNClassType*)type;
@end


