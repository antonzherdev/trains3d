#import "objd.h"
@protocol EGParticleSystem;
@class EGVertexBufferDesc;
@class EGShader;
@class EGBlendFunction;
@protocol EGIndexSource;
@class EGVertexArrayRing;
@class EGVBO;
@class EGVertexArray;
@class EGGlobal;
@class EGContext;
@class EGCullFace;
@class EGEnablingState;
@class EGMutableIndexSourceGap;
@class EGIBO;

@class EGParticleSystemView;
@protocol EGIBOParticleSystemView;
@protocol EGIBOParticleSystemViewQuad;

@interface EGParticleSystemView : NSObject
@property (nonatomic, readonly) id<EGParticleSystem> system;
@property (nonatomic, readonly) EGVertexBufferDesc* vbDesc;
@property (nonatomic, readonly) NSUInteger maxCount;
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) id material;
@property (nonatomic, readonly) EGBlendFunction* blendFunc;
@property (nonatomic, readonly) id<EGIndexSource> index;
@property (nonatomic, readonly) EGVertexArrayRing* vaoRing;

+ (id)particleSystemViewWithSystem:(id<EGParticleSystem>)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc;
- (id)initWithSystem:(id<EGParticleSystem>)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc;
- (ODClassType*)type;
- (NSUInteger)vertexCount;
- (id<EGIndexSource>)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount;
- (NSUInteger)indexCount;
- (void)draw;
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


