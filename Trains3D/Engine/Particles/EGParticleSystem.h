#import "objd.h"
#import "EGScene.h"
@class EGVertexBufferDesc;
@class EGBlendFunction;
@class EGMutableVertexBuffer;
@class EGVBO;
@class EGIndexBuffer;
@class EGMesh;
@class EGShader;
@class EGMaterial;
@class EGGlobal;
@class EGContext;
@class EGIndexSourceGap;
@class EGEnablingState;

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
@property (nonatomic, readonly) EGVertexBufferDesc* vbDesc;
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) EGBlendFunction* blendFunc;
@property (nonatomic, readonly) CNVoidRefArray vertexArr;
@property (nonatomic, readonly) EGMutableVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) EGIndexBuffer* indexBuffer;
@property (nonatomic, readonly) EGMesh* mesh;

+ (id)particleSystemViewWithVbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount blendFunc:(EGBlendFunction*)blendFunc;
- (id)initWithVbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount blendFunc:(EGBlendFunction*)blendFunc;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i;
- (EGShader*)shader;
- (EGMaterial*)material;
- (void)drawSystem:(EGParticleSystem*)system;
- (void)dealloc;
+ (ODClassType*)type;
@end


