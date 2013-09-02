#import "objd.h"
@class CNPArray;
@class CNPArrayIterator;
@class CNMutablePArray;
@class EG;
#import "EGGL.h"
#import "EGTypes.h"
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@protocol EGShaderSystem;
@class EGContext;
@class EGMutableMatrix;
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
@class TRSmokeShader;

@interface TRSmoke : NSObject<EGController>
@property (nonatomic, readonly, weak) TRTrain* train;

+ (id)smokeWithTrain:(TRTrain*)train;
- (id)initWithTrain:(TRTrain*)train;
- (ODClassType*)type;
- (CNList*)particles;
- (void)updateWithDelta:(CGFloat)delta;
- (void)createParticle;
+ (ODClassType*)type;
@end


@interface TRSmokeParticle : NSObject<EGController>
@property (nonatomic) EGVec3 position;
@property (nonatomic) EGVec3 speed;
@property (nonatomic) CGFloat time;

+ (id)smokeParticle;
- (id)init;
- (ODClassType*)type;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)isLive;
+ (NSInteger)lifeTime;
+ (CGFloat)dragCoefficient;
+ (ODClassType*)type;
@end


@interface TRSmokeView : NSObject
@property (nonatomic, readonly) EGVertexBuffer* positionBuffer;
@property (nonatomic, readonly) EGVertexBuffer* cornerBuffer;
@property (nonatomic, readonly) EGIndexBuffer* indexBuffer;
@property (nonatomic, readonly) TRSmokeShader* shader;

+ (id)smokeView;
- (id)init;
- (ODClassType*)type;
- (void)drawSmoke:(TRSmoke*)smoke;
+ (ODClassType*)type;
@end


@interface TRSmokeShader : NSObject
@property (nonatomic, readonly) EGShaderProgram* program;
@property (nonatomic, readonly) EGShaderAttribute* positionSlot;
@property (nonatomic, readonly) EGShaderAttribute* cornerSlot;
@property (nonatomic, readonly) EGShaderUniform* cUniform;
@property (nonatomic, readonly) EGShaderUniform* pUniform;

+ (id)smokeShader;
- (id)init;
- (ODClassType*)type;
- (void)applyPositionBuffer:(EGVertexBuffer*)positionBuffer cornerBuffer:(EGVertexBuffer*)cornerBuffer draw:(void(^)())draw;
+ (NSString*)vertex;
+ (NSString*)fragment;
+ (TRSmokeShader*)instance;
+ (ODClassType*)type;
@end


