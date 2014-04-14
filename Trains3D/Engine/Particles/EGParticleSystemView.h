#import "objd.h"
@class EGParticleSystem;
@class EGVertexBufferDesc;
@class EGShader;
@class EGBlendFunction;
@protocol EGIndexSource;
@class EGVertexArrayRing;
@class EGVBO;
@class EGVertexArray;
@class EGMutableVertexBuffer;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;
@class EGCullFace;
@protocol EGParticleSystemIndexArray;
@class EGIBO;

@class EGParticleSystemView;
@class EGParticleSystemViewIndexArray;

@interface EGParticleSystemView : NSObject {
@protected
    EGParticleSystem* _system;
    EGVertexBufferDesc* _vbDesc;
    EGShader* _shader;
    id _material;
    EGBlendFunction* _blendFunc;
    unsigned int _maxCount;
    unsigned int _vertexCount;
    unsigned int __indexCount;
    id<EGIndexSource> _index;
    EGVertexArrayRing* _vaoRing;
    EGVertexArray* __vao;
    EGMutableVertexBuffer* __vbo;
}
@property (nonatomic, readonly) EGParticleSystem* system;
@property (nonatomic, readonly) EGVertexBufferDesc* vbDesc;
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) id material;
@property (nonatomic, readonly) EGBlendFunction* blendFunc;
@property (nonatomic, readonly) unsigned int maxCount;
@property (nonatomic, readonly) unsigned int vertexCount;
@property (nonatomic, readonly) id<EGIndexSource> index;
@property (nonatomic, readonly) EGVertexArrayRing* vaoRing;

+ (instancetype)particleSystemViewWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc;
- (instancetype)initWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc;
- (ODClassType*)type;
- (unsigned int)indexCount;
- (id<EGIndexSource>)createIndexSource;
- (void)prepare;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGParticleSystemViewIndexArray : EGParticleSystemView
+ (instancetype)particleSystemViewIndexArrayWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc;
- (instancetype)initWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc;
- (ODClassType*)type;
- (unsigned int)indexCount;
- (id<EGIndexSource>)createIndexSource;
+ (ODClassType*)type;
@end


