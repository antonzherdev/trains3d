#import "objd.h"
#import "EGTypes.h"
#import "EGMaterial.h"
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGShader;
@class EGMesh;

@class EGParticleSystem;
@class EGParticle;
@class EGParticleSystemView;

@interface EGParticleSystem : NSObject<EGController>
+ (id)particleSystem;
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


@interface EGParticle : NSObject<EGController>
@property (nonatomic, readonly) float lifeLength;

+ (id)particleWithLifeLength:(float)lifeLength;
- (id)initWithLifeLength:(float)lifeLength;
- (ODClassType*)type;
- (float)lifeTime;
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
- (BOOL)isLive;
- (void)updateWithDelta:(CGFloat)delta;
- (void)updateT:(float)t dt:(float)dt;
+ (ODClassType*)type;
@end


@interface EGParticleSystemView : NSObject
@property (nonatomic, readonly) ODPType* dtp;
@property (nonatomic, readonly) EGBlendFunction blendFunc;
@property (nonatomic, readonly) EGVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) EGIndexBuffer* indexBuffer;

+ (id)particleSystemViewWithDtp:(ODPType*)dtp blendFunc:(EGBlendFunction)blendFunc;
- (id)initWithDtp:(ODPType*)dtp blendFunc:(EGBlendFunction)blendFunc;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i;
- (EGShader*)shader;
- (EGMaterial*)material;
- (void)drawSystem:(EGParticleSystem*)system;
+ (ODClassType*)type;
@end


