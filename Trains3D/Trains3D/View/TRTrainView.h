#import "objd.h"
#import "PGBillboardView.h"
#import "PGTexture.h"
#import "TRCar.h"
#import "PGVec.h"
#import "TRCity.h"
#import "TRTrain.h"
#import "PGMaterial.h"
@class PGGlobal;
@class TRSmoke;
@class CNFuture;
@class PGMatrixStack;
@class PGMat4;
@class PGMMatrixModel;
@class CNChain;
@class PGProgress;
@class TRModels;
@class PGVertexArray;
@class PGMesh;
@class PGContext;
@class PGRenderTarget;

@class TRSmokeView;
@class TRTrainView;
@class TRTrainModels;
@class TRCarModel;

@interface TRSmokeView : PGBillboardParticleSystemView
+ (instancetype)smokeViewWithSystem:(TRSmoke*)system;
- (instancetype)initWithSystem:(TRSmoke*)system;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRTrainView : NSObject {
@public
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
@public
    TRCarModel* _engineModel;
    TRCarModel* _carModel;
    TRCarModel* _expressEngineModel;
    TRCarModel* _expressCarModel;
}
+ (instancetype)trainModels;
- (instancetype)init;
- (CNClassType*)type;
+ (PGVec4)crazyColorTime:(CGFloat)time;
- (void)drawTrainState:(TRTrainState*)trainState carType:(TRCarTypeR)carType;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface TRCarModel : NSObject {
@public
    PGVertexArray* _colorVao;
    PGVertexArray* _blackVao;
    PGVertexArray* _shadowVao;
    PGTexture* _texture;
    PGTexture* _normalMap;
}
@property (nonatomic, readonly) PGVertexArray* colorVao;
@property (nonatomic, readonly) PGVertexArray* blackVao;
@property (nonatomic, readonly) PGVertexArray* shadowVao;
@property (nonatomic, readonly) PGTexture* texture;
@property (nonatomic, readonly) PGTexture* normalMap;

+ (instancetype)carModelWithColorVao:(PGVertexArray*)colorVao blackVao:(PGVertexArray*)blackVao shadowVao:(PGVertexArray*)shadowVao texture:(PGTexture*)texture normalMap:(PGTexture*)normalMap;
- (instancetype)initWithColorVao:(PGVertexArray*)colorVao blackVao:(PGVertexArray*)blackVao shadowVao:(PGVertexArray*)shadowVao texture:(PGTexture*)texture normalMap:(PGTexture*)normalMap;
- (CNClassType*)type;
+ (PGStandardMaterial*)trainMaterialForDiffuse:(PGColorSource*)diffuse normalMap:(PGTexture*)normalMap;
+ (TRCarModel*)applyColorMesh:(PGMesh*)colorMesh blackMesh:(PGMesh*)blackMesh shadowMesh:(PGMesh*)shadowMesh texture:(PGTexture*)texture normalMap:(PGTexture*)normalMap;
- (void)drawColor:(PGVec4)color;
- (NSString*)description;
+ (PGStandardMaterial*)blackMaterial;
+ (CNClassType*)type;
@end


