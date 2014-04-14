#import "objd.h"
@class EGParticleSystem2;
@class EGVertexBufferDesc;
@class EGShader;
@class EGBlendFunction;
@protocol EGIndexSource;
@class EGIBO;
@class EGVertexArrayRing;
@class EGVBO;
@class EGVertexArray;
@class EGMutableVertexBuffer;
@class EGGlobal;
@class EGContext;
@class EGEnablingState;
@class EGCullFace;

@class EGParticleSystemView2;

@interface EGParticleSystemView2 : NSObject {
@protected
    EGParticleSystem2* _system;
    EGVertexBufferDesc* _vbDesc;
    EGShader* _shader;
    id _material;
    EGBlendFunction* _blendFunc;
    unsigned int _maxCount;
    unsigned int _vertexCount;
    unsigned int _indexCount;
    id<EGIndexSource> _index;
    EGVertexArrayRing* _vaoRing;
    EGVertexArray* __vao;
    EGMutableVertexBuffer* __vbo;
}
@property (nonatomic, readonly) EGParticleSystem2* system;
@property (nonatomic, readonly) EGVertexBufferDesc* vbDesc;
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) id material;
@property (nonatomic, readonly) EGBlendFunction* blendFunc;
@property (nonatomic, readonly) unsigned int maxCount;
@property (nonatomic, readonly) unsigned int vertexCount;
@property (nonatomic, readonly) unsigned int indexCount;
@property (nonatomic, readonly) id<EGIndexSource> index;
@property (nonatomic, readonly) EGVertexArrayRing* vaoRing;

+ (instancetype)particleSystemView2WithSystem:(EGParticleSystem2*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc;
- (instancetype)initWithSystem:(EGParticleSystem2*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc;
- (ODClassType*)type;
- (void)prepare;
- (void)draw;
+ (ODClassType*)type;
@end


