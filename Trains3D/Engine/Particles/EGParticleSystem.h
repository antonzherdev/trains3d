#import "objd.h"
#import "EGScene.h"
@class EGVertexBufferDesc;
@class EGShader;
@class EGBlendFunction;
@class EGMutableVertexBuffer;
@class EGVBO;
@protocol EGIndexSource;
@class EGVertexArray;
@class EGMesh;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;
@class EGMutableIndexSourceGap;
@class EGIBO;

@class EGParticleSystemView;
@class EGEmissiveParticleSystem;
@class EGEmittedParticle;
@protocol EGParticleSystem;
@protocol EGParticle;
@protocol EGIBOParticleSystemView;
@protocol EGIBOParticleSystemViewQuad;

@protocol EGParticleSystem<EGUpdatable>
- (id<CNSeq>)particles;
- (void)updateWithDelta:(CGFloat)delta;
@end


@protocol EGParticle<EGUpdatable>
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
@end


@interface EGParticleSystemView : NSObject
@property (nonatomic, readonly) id<EGParticleSystem> system;
@property (nonatomic, readonly) EGVertexBufferDesc* vbDesc;
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) id material;
@property (nonatomic, readonly) EGBlendFunction* blendFunc;
@property (nonatomic, readonly) CNVoidRefArray vertexArr;
@property (nonatomic, readonly) EGMutableVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) id<EGIndexSource> index;
@property (nonatomic, readonly) EGVertexArray* vao;

+ (id)particleSystemViewWithSystem:(id<EGParticleSystem>)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc;
- (id)initWithSystem:(id<EGParticleSystem>)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (id<EGIndexSource>)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount;
- (NSUInteger)indexCount;
- (void)draw;
- (void)dealloc;
+ (ODClassType*)type;
@end


@protocol EGIBOParticleSystemView<NSObject>
- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i;
- (NSUInteger)vertexCount;
- (NSUInteger)indexCount;
- (EGMutableIndexSourceGap*)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount;
@end


@protocol EGIBOParticleSystemViewQuad<EGIBOParticleSystemView>
- (NSUInteger)vertexCount;
- (NSUInteger)indexCount;
- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i;
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
- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array;
+ (ODClassType*)type;
@end


