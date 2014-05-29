#import "EGParticleSystemView.h"

#import "EGParticleSystem.h"
#import "EGVertex.h"
#import "EGShader.h"
#import "EGMaterial.h"
#import "EGIndex.h"
#import "EGVertexArray.h"
#import "GL.h"
#import "EGBuffer.h"
#import "CNFuture.h"
#import "EGContext.h"
@implementation EGParticleSystemView
static CNClassType* _EGParticleSystemView_type;
@synthesize system = _system;
@synthesize vbDesc = _vbDesc;
@synthesize shader = _shader;
@synthesize material = _material;
@synthesize blendFunc = _blendFunc;
@synthesize maxCount = _maxCount;
@synthesize vertexCount = _vertexCount;
@synthesize index = _index;
@synthesize vaoRing = _vaoRing;

+ (instancetype)particleSystemViewWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    return [[EGParticleSystemView alloc] initWithSystem:system vbDesc:vbDesc shader:shader material:material blendFunc:blendFunc];
}

- (instancetype)initWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    self = [super init];
    __weak EGParticleSystemView* _weakSelf = self;
    if(self) {
        _system = system;
        _vbDesc = vbDesc;
        _shader = shader;
        _material = material;
        _blendFunc = blendFunc;
        _maxCount = system.maxCount;
        _vertexCount = [system vertexCount];
        __indexCount = [self indexCount];
        _index = [self createIndexSource];
        _vaoRing = [EGVertexArrayRing vertexArrayRingWithRingSize:3 creator:^EGSimpleVertexArray*(unsigned int _) {
            EGParticleSystemView* _self = _weakSelf;
            if(_self != nil) return [shader vaoVbo:[EGVBO mutDesc:vbDesc usage:GL_STREAM_DRAW] ibo:_self->_index];
            else return nil;
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGParticleSystemView class]) _EGParticleSystemView_type = [CNClassType classTypeWithCls:[EGParticleSystemView class]];
}

- (unsigned int)indexCount {
    @throw @"Method indexCount is abstract";
}

- (id<EGIndexSource>)createIndexSource {
    @throw @"Method createIndexSource is abstract";
}

- (void)prepare {
    __vao = [_vaoRing next];
    [((EGVertexArray*)(__vao)) syncWait];
    {
        EGMutableVertexBuffer* vbo = [((EGVertexArray*)(__vao)) mutableVertexBuffer];
        if(vbo != nil) {
            __data = [((EGMutableVertexBuffer*)(vbo)) beginWriteCount:_vertexCount * _maxCount];
            if(__data != nil) __lastWriteFuture = [_system writeToArray:__data];
            else __lastWriteFuture = nil;
        }
    }
}

- (void)draw {
    if(__data != nil) {
        [((EGMappedBufferData*)(__data)) finish];
        if([((EGMappedBufferData*)(__data)) wasUpdated] && __lastWriteFuture != nil) {
            CNTry* r = [((CNFuture*)(__lastWriteFuture)) waitResultPeriod:1.0];
            if(r != nil && [((CNTry*)(r)) isSuccess]) {
                unsigned int n = unumui4([((CNTry*)(r)) get]);
                if(n > 0) {
                    EGEnablingState* __tmp__il__0t_1t_1t_1t_0self = EGGlobal.context.depthTest;
                    {
                        BOOL __il__0t_1t_1t_1t_0changed = [__tmp__il__0t_1t_1t_1t_0self disable];
                        {
                            EGCullFace* __tmp__il__0t_1t_1t_1t_0rp0self = EGGlobal.context.cullFace;
                            {
                                unsigned int __il__0t_1t_1t_1t_0rp0oldValue = [__tmp__il__0t_1t_1t_1t_0rp0self disable];
                                EGEnablingState* __il__0t_1t_1t_1t_0rp0rp0__tmp__il__0self = EGGlobal.context.blend;
                                {
                                    BOOL __il__0t_1t_1t_1t_0rp0rp0__il__0changed = [__il__0t_1t_1t_1t_0rp0rp0__tmp__il__0self enable];
                                    {
                                        [EGGlobal.context setBlendFunction:_blendFunc];
                                        [((EGVertexArray*)(__vao)) drawParam:_material start:0 end:((NSUInteger)(__indexCount * n))];
                                    }
                                    if(__il__0t_1t_1t_1t_0rp0rp0__il__0changed) [__il__0t_1t_1t_1t_0rp0rp0__tmp__il__0self disable];
                                }
                                if(__il__0t_1t_1t_1t_0rp0oldValue != GL_NONE) [__tmp__il__0t_1t_1t_1t_0rp0self setValue:__il__0t_1t_1t_1t_0rp0oldValue];
                            }
                        }
                        if(__il__0t_1t_1t_1t_0changed) [__tmp__il__0t_1t_1t_1t_0self enable];
                    }
                }
                [((EGVertexArray*)(__vao)) syncSet];
            } else {
                cnLogInfoText(([NSString stringWithFormat:@"Incorrect result in particle system: %@", r]));
            }
        }
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ParticleSystemView(%@, %@, %@, %@, %@)", _system, _vbDesc, _shader, _material, _blendFunc];
}

- (CNClassType*)type {
    return [EGParticleSystemView type];
}

+ (CNClassType*)type {
    return _EGParticleSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGParticleSystemViewIndexArray
static CNClassType* _EGParticleSystemViewIndexArray_type;

+ (instancetype)particleSystemViewIndexArrayWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    return [[EGParticleSystemViewIndexArray alloc] initWithSystem:system vbDesc:vbDesc shader:shader material:material blendFunc:blendFunc];
}

- (instancetype)initWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    self = [super initWithSystem:system vbDesc:vbDesc shader:shader material:material blendFunc:blendFunc];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGParticleSystemViewIndexArray class]) _EGParticleSystemViewIndexArray_type = [CNClassType classTypeWithCls:[EGParticleSystemViewIndexArray class]];
}

- (unsigned int)indexCount {
    return [((id<EGParticleSystemIndexArray>)(self.system)) indexCount];
}

- (id<EGIndexSource>)createIndexSource {
    unsigned int* ia = [((id<EGParticleSystemIndexArray>)(self.system)) createIndexArray];
    EGImmutableIndexBuffer* ib = [EGIBO applyPointer:ia count:[self indexCount] * self.maxCount];
    cnPointerFree(ia);
    return ib;
}

- (NSString*)description {
    return @"ParticleSystemViewIndexArray";
}

- (CNClassType*)type {
    return [EGParticleSystemViewIndexArray type];
}

+ (CNClassType*)type {
    return _EGParticleSystemViewIndexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

