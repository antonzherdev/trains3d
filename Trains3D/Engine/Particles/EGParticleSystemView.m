#import "EGParticleSystemView.h"

#import "EGParticleSystem.h"
#import "EGVertex.h"
#import "EGShader.h"
#import "EGMaterial.h"
#import "EGIndex.h"
#import "EGVertexArray.h"
#import "EGContext.h"
#import "GL.h"
@implementation EGParticleSystemView
static ODClassType* _EGParticleSystemView_type;
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
        _maxCount = _system.maxCount;
        _vertexCount = [_system vertexCount];
        __indexCount = [self indexCount];
        _index = [self createIndexSource];
        _vaoRing = [EGVertexArrayRing vertexArrayRingWithRingSize:3 creator:^EGSimpleVertexArray*(unsigned int _) {
            EGParticleSystemView* _self = _weakSelf;
            if(_self != nil) return [_self->_shader vaoVbo:[EGVBO mutDesc:_self->_vbDesc] ibo:_self->_index];
            else return nil;
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGParticleSystemView class]) _EGParticleSystemView_type = [ODClassType classTypeWithCls:[EGParticleSystemView class]];
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
    __vbo = [((EGVertexArray*)(__vao)) mutableVertexBuffer];
    {
        EGMutableVertexBuffer* vbo = __vbo;
        if(vbo != nil) {
            void* r = [vbo beginWriteCount:_vertexCount * _maxCount];
            if(r != nil) __lastWriteFuture = [_system writeToArray:r];
            else __lastWriteFuture = nil;
        }
    }
}

- (void)draw {
    if(__lastWriteFuture != nil) {
        [((EGMutableVertexBuffer*)(__vbo)) endWrite];
        CNTry* r = [((CNFuture*)(__lastWriteFuture)) waitResultPeriod:1.0];
        if(r != nil && [((CNTry*)(r)) isSuccess]) {
            unsigned int n = unumui4([((CNTry*)(r)) get]);
            if(n > 0) {
                EGEnablingState* __tmp_0_2_1_0self = EGGlobal.context.depthTest;
                {
                    BOOL __inline__0_2_1_0_changed = [__tmp_0_2_1_0self disable];
                    {
                        EGCullFace* __tmp_0_2_1_0self = EGGlobal.context.cullFace;
                        {
                            unsigned int __inline__0_2_1_0_oldValue = [__tmp_0_2_1_0self disable];
                            EGEnablingState* __inline__0_2_1_0___tmp_0self = EGGlobal.context.blend;
                            {
                                BOOL __inline__0_2_1_0___inline__0_changed = [__inline__0_2_1_0___tmp_0self enable];
                                {
                                    [EGGlobal.context setBlendFunction:_blendFunc];
                                    [((EGVertexArray*)(__vao)) drawParam:_material start:0 end:((NSUInteger)(__indexCount * n))];
                                }
                                if(__inline__0_2_1_0___inline__0_changed) [__inline__0_2_1_0___tmp_0self disable];
                            }
                            if(__inline__0_2_1_0_oldValue != GL_NONE) [__tmp_0_2_1_0self setValue:__inline__0_2_1_0_oldValue];
                        }
                    }
                    if(__inline__0_2_1_0_changed) [__tmp_0_2_1_0self enable];
                }
            }
            [((EGVertexArray*)(__vao)) syncSet];
        } else {
            cnLogApplyText(([NSString stringWithFormat:@"Incorrect result in particle system: %@", r]));
        }
    }
}

- (ODClassType*)type {
    return [EGParticleSystemView type];
}

+ (ODClassType*)type {
    return _EGParticleSystemView_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"system=%@", self.system];
    [description appendFormat:@", vbDesc=%@", self.vbDesc];
    [description appendFormat:@", shader=%@", self.shader];
    [description appendFormat:@", material=%@", self.material];
    [description appendFormat:@", blendFunc=%@", self.blendFunc];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGParticleSystemViewIndexArray
static ODClassType* _EGParticleSystemViewIndexArray_type;

+ (instancetype)particleSystemViewIndexArrayWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    return [[EGParticleSystemViewIndexArray alloc] initWithSystem:system vbDesc:vbDesc shader:shader material:material blendFunc:blendFunc];
}

- (instancetype)initWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    self = [super initWithSystem:system vbDesc:vbDesc shader:shader material:material blendFunc:blendFunc];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGParticleSystemViewIndexArray class]) _EGParticleSystemViewIndexArray_type = [ODClassType classTypeWithCls:[EGParticleSystemViewIndexArray class]];
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

- (ODClassType*)type {
    return [EGParticleSystemViewIndexArray type];
}

+ (ODClassType*)type {
    return _EGParticleSystemViewIndexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"system=%@", self.system];
    [description appendFormat:@", vbDesc=%@", self.vbDesc];
    [description appendFormat:@", shader=%@", self.shader];
    [description appendFormat:@", material=%@", self.material];
    [description appendFormat:@", blendFunc=%@", self.blendFunc];
    [description appendString:@">"];
    return description;
}

@end


