#import "EGParticleSystemView2.h"

#import "EGParticleSystem2.h"
#import "EGVertex.h"
#import "EGShader.h"
#import "EGMaterial.h"
#import "EGIndex.h"
#import "EGVertexArray.h"
#import "EGContext.h"
#import "GL.h"
@implementation EGParticleSystemView2
static ODClassType* _EGParticleSystemView2_type;
@synthesize system = _system;
@synthesize vbDesc = _vbDesc;
@synthesize shader = _shader;
@synthesize material = _material;
@synthesize blendFunc = _blendFunc;
@synthesize maxCount = _maxCount;
@synthesize vertexCount = _vertexCount;
@synthesize indexCount = _indexCount;
@synthesize index = _index;
@synthesize vaoRing = _vaoRing;

+ (instancetype)particleSystemView2WithSystem:(EGParticleSystem2*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    return [[EGParticleSystemView2 alloc] initWithSystem:system vbDesc:vbDesc shader:shader material:material blendFunc:blendFunc];
}

- (instancetype)initWithSystem:(EGParticleSystem2*)system vbDesc:(EGVertexBufferDesc*)vbDesc shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    self = [super init];
    __weak EGParticleSystemView2* _weakSelf = self;
    if(self) {
        _system = system;
        _vbDesc = vbDesc;
        _shader = shader;
        _material = material;
        _blendFunc = blendFunc;
        _maxCount = _system.maxCount;
        _vertexCount = [_system vertexCount];
        _indexCount = [_system indexCount];
        _index = ({
            unsigned int* ia = [_system createIndexArray];
            EGImmutableIndexBuffer* ib = [EGIBO applyPointer:ia count:_indexCount * _maxCount];
            cnPointerFree(ia);
            ib;
        });
        _vaoRing = [EGVertexArrayRing vertexArrayRingWithRingSize:3 creator:^EGSimpleVertexArray*(unsigned int _) {
            EGParticleSystemView2* _self = _weakSelf;
            if(_self != nil) return [_self->_shader vaoVbo:[EGVBO mutDesc:_self->_vbDesc] ibo:_self->_index];
            else return nil;
        }];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGParticleSystemView2 class]) _EGParticleSystemView2_type = [ODClassType classTypeWithCls:[EGParticleSystemView2 class]];
}

- (void)prepare {
    __vao = [_vaoRing next];
    [((EGVertexArray*)(__vao)) syncWait];
    __vbo = [((EGVertexArray*)(__vao)) mutableVertexBuffer];
    {
        EGMutableVertexBuffer* _ = __vbo;
        if(_ != nil) [_system writeToArray:[_ beginWriteCount:_vertexCount * _maxCount]];
    }
}

- (void)draw {
    CNTry* __inline__0___tr = [[_system count] waitResultPeriod:1.0];
    if(__inline__0___tr != nil) {
        if([__inline__0___tr isSuccess]) {
            id n = [__inline__0___tr get];
            {
                [((EGMutableVertexBuffer*)(__vbo)) endWrite];
                if(unumui4(n) > 0) {
                    EGEnablingState* __tmp_0_1_0self = EGGlobal.context.depthTest;
                    {
                        BOOL __inline__0_1_0_changed = [__tmp_0_1_0self disable];
                        {
                            EGCullFace* __tmp_0_1_0self = EGGlobal.context.cullFace;
                            {
                                unsigned int __inline__0_1_0_oldValue = [__tmp_0_1_0self disable];
                                EGEnablingState* __inline__0_1_0___tmp_0self = EGGlobal.context.blend;
                                {
                                    BOOL __inline__0_1_0___inline__0_changed = [__inline__0_1_0___tmp_0self enable];
                                    {
                                        [EGGlobal.context setBlendFunction:_blendFunc];
                                        [((EGVertexArray*)(__vao)) drawParam:_material start:0 end:((NSUInteger)(_indexCount * unumui4(n)))];
                                    }
                                    if(__inline__0_1_0___inline__0_changed) [__inline__0_1_0___tmp_0self disable];
                                }
                                if(__inline__0_1_0_oldValue != GL_NONE) [__tmp_0_1_0self setValue:__inline__0_1_0_oldValue];
                            }
                        }
                        if(__inline__0_1_0_changed) [__tmp_0_1_0self enable];
                    }
                }
                [((EGVertexArray*)(__vao)) syncSet];
            }
        }
    }
}

- (ODClassType*)type {
    return [EGParticleSystemView2 type];
}

+ (ODClassType*)type {
    return _EGParticleSystemView2_type;
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


