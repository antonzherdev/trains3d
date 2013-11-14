#import "objd.h"
#import "EGScene.h"
@class EGVertexBufferDesc;
@class EGShader;
@class EGMaterial;
@class EGBlendFunction;
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGMutableIndexSourceGap;
@class EGIBO;
@class EGVertexArray;
@class EGMesh;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;

@class EGParticleSystemView;
@class EGEmissiveParticleSystem;
@class EGEmittedParticle;
@protocol EGParticleSystem;
@protocol EGParticle;

@protocol EGParticleSystem<EGController>
- (id<CNSeq>)particles;
@end


@protocol EGParticle<EGController>
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
@end


@interface EGParticleSystemView : NSObject
@property (nonatomic, readonly) id<EGParticleSystem> system;
@property (nonatomic, readonly) EGVertexBufferDesc* vbDesc;
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) EGMaterial* material;
@property (nonatomic, readonly) EGBlendFunction* blendFunc;
@property (nonatomic, readonly) CNVoidRefArray vertexArr;
@property (nonatomic, readonly) EGMutableVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) EGMutableIndexSourceGap* index;
@property (nonatomic, readonly) EGVertexArray* vao;

+ (id)particleSystemViewWithSystem:(id<EGParticleSystem>)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(EGMaterial*)material blendFunc:(EGBlendFunction*)blendFunc;
- (id)initWithSystem:(id<EGParticleSystem>)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(EGMaterial*)material blendFunc:(EGBlendFunction*)blendFunc;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i;
- (void)draw;
- (void)dealloc;
+ (ODClassType*)type;
@end


@interface EGEmissiveParticleSystem : NSObject<EGParticleSystem>
+ (id)emissiveParticleSystem;
- (id)init;
- (ODClassType*)type;
- (id<CNSeq>)particles;
- (id)generateParticle;
- (void)generateParticlesWithDelta:(CGFloat)delta;
- (void)emitParticle;
- (void)updateWithDelta:(CGFloat)delta;
- (BOOL)hasParticles;
+ (ODClassType*)type;
@end


@interface EGEmittedParticle : NSObject<EGParticle>
@property (nonatomic, readonly) float lifeLength;

+ (id)emittedParticleWithLifeLength:(float)lifeLength;
- (id)initWithLifeLength:(float)lifeLength;
- (ODClassType*)type;
- (float)lifeTime;
- (BOOL)isLive;
- (void)updateWithDelta:(CGFloat)delta;
- (void)updateT:(float)t dt:(float)dt;
+ (ODClassType*)type;
@end


