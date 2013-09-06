#import "objd.h"
#import "ODType.h"
@class CNPArray;
@class CNPArrayIterator;
@class CNMutablePArray;
#import "EGGL.h"
#import "EGTypes.h"
@class EGMesh;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@class EGShaderSystem;
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGMeshModel;
@class EGTexture;
@class EGFileTexture;

@class EGParticleSystem;
@class EGParticleSystemView;
@protocol EGParticle;

@interface EGParticleSystem : NSObject<EGController>
+ (id)particleSystem;
- (id)init;
- (ODClassType*)type;
- (id<CNSeq>)particles;
- (id)generateParticle;
- (void)generateParticlesWithDelta:(CGFloat)delta;
- (void)emitParticle;
- (void)updateWithDelta:(CGFloat)delta;
+ (ODClassType*)type;
@end


@protocol EGParticle<EGController>
- (void)writeToArray:(CNMutablePArray*)array;
- (BOOL)isLive;
@end


@interface EGParticleSystemView : NSObject
@property (nonatomic, readonly) ODPType* dtp;
@property (nonatomic, readonly) EGVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) EGIndexBuffer* indexBuffer;

+ (id)particleSystemViewWithDtp:(ODPType*)dtp;
- (id)initWithDtp:(ODPType*)dtp;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (EGShader*)shader;
- (EGMaterial*)material;
- (void)drawSystem:(EGParticleSystem*)system;
+ (ODClassType*)type;
@end


