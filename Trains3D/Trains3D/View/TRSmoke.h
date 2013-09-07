#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGGL.h"
#import "EGTypes.h"
@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@class EGShaderSystem;
@class EGTexture;
@class EGFileTexture;
@class EGMatrix;
@class EGSurface;
@class EGSurfaceShader;
@class EGMesh;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
#import "EGVec.h"
#import "EGBillboard.h"
@class EGParticleSystem;
@class EGParticle;
@class EGParticleSystemView;
#import "EGMaterial.h"
@class TRTrainType;
@class TRTrain;
@class TREngineType;
@class TRCarType;
@class TRCar;
@class TRTrainGenerator;
@class TRRailConnector;
@class TRRailForm;
@class TRRailPoint;
@class TRRailPointCorrection;

@class TRSmoke;
@class TRSmokeParticle;
@class TRSmokeView;

@interface TRSmoke : EGBillboardParticleSystem
@property (nonatomic, readonly, weak) TRTrain* train;

+ (id)smokeWithTrain:(TRTrain*)train;
- (id)initWithTrain:(TRTrain*)train;
- (ODClassType*)type;
- (void)generateParticlesWithDelta:(CGFloat)delta;
- (TRSmokeParticle*)generateParticle;
+ (float)particleSize;
+ (EGQuad)modelQuad;
+ (EGQuadrant)textureQuadrant;
+ (EGVec4)defColor;
+ (ODClassType*)type;
@end


@interface TRSmokeParticle : EGBillboardParticle
@property (nonatomic) EGVec3 speed;

+ (id)smokeParticle;
- (id)init;
- (ODClassType*)type;
- (void)updateT:(float)t dt:(float)dt;
+ (NSInteger)dragCoefficient;
+ (ODClassType*)type;
@end


@interface TRSmokeView : EGBillboardParticleSystemView
+ (id)smokeView;
- (id)init;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


