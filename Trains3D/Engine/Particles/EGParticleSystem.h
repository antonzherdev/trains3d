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
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) EGMaterial* material;
@property (nonatomic, readonly) EGBlendFunction* blendFunc;
@property (nonatomic, readonly) CNVoidRefArray vertexArr;
@property (nonatomic, readonly) EGMutableVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) EGMutableIndexSourceGap* index;
@property (nonatomic, readonly) EGVertexArray* vao;

+ (id)particleSystemViewWithVbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(EGMaterial*)material blendFunc:(EGBlendFunction*)blendFunc;
- (id)initWithVbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(EGMaterial*)material blendFunc:(EGBlendFunction*)blendFunc;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i;
- (void)drawSystem:(EGParticleSystem*)system;
- (void)dealloc;
+ (ODClassType*)type;
@end


