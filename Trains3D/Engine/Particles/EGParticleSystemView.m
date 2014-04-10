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
@synthesize maxCount = _maxCount;
@synthesize shader = _shader;
@synthesize material = _material;
@synthesize blendFunc = _blendFunc;
@synthesize index = _index;
@synthesize vaoRing = _vaoRing;

+ (instancetype)particleSystemViewWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    return [[EGParticleSystemView alloc] initWithSystem:system vbDesc:vbDesc maxCount:maxCount shader:shader material:material blendFunc:blendFunc];
}

- (instancetype)initWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    self = [super init];
    __weak EGParticleSystemView* _weakSelf = self;
    if(self) {
        _system = system;
        _vbDesc = vbDesc;
        _maxCount = maxCount;
        _shader = shader;
        _material = material;
        _blendFunc = blendFunc;
        _index = [self indexVertexCount:[self vertexCount] maxCount:_maxCount];
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

- (NSUInteger)vertexCount {
    @throw @"Method vertexCount is abstract";
}

- (id<EGIndexSource>)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount {
    @throw @"Method index is abstract";
}

- (NSUInteger)indexCount {
    @throw @"Method indexCount is abstract";
}

- (void)prepare {
    __vao = [_vaoRing next];
    [((EGVertexArray*)(__vao)) syncWait];
    __vbo = [((EGVertexArray*)(__vao)) mutableVertexBuffer];
    {
        EGMutableVertexBuffer* _ = __vbo;
        if(_ != nil) [_system writeToMaxCount:_maxCount array:[_ beginWriteCount:((unsigned int)([self vertexCount] * _maxCount))]];
    }
}

- (void)draw {
    [[_system lastWriteCount] waitAndOnSuccessAwait:1.0 f:^void(id n) {
        [((EGMutableVertexBuffer*)(__vbo)) endWrite];
        if(unumui(n) > 0) {
            EGEnablingState* __tmp_0_1_0self = EGGlobal.context.depthTest;
            {
                BOOL changed = [__tmp_0_1_0self disable];
                {
                    EGCullFace* __tmp_0_1_0self = EGGlobal.context.cullFace;
                    {
                        unsigned int oldValue = [__tmp_0_1_0self disable];
                        [_blendFunc applyDraw:^void() {
                            [((EGVertexArray*)(__vao)) drawParam:_material start:0 end:[self indexCount] * unumui(n)];
                        }];
                        if(oldValue != GL_NONE) [__tmp_0_1_0self setValue:oldValue];
                    }
                }
                if(changed) [__tmp_0_1_0self enable];
            }
        }
        [((EGVertexArray*)(__vao)) syncSet];
    }];
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
    [description appendFormat:@", maxCount=%lu", (unsigned long)self.maxCount];
    [description appendFormat:@", shader=%@", self.shader];
    [description appendFormat:@", material=%@", self.material];
    [description appendFormat:@", blendFunc=%@", self.blendFunc];
    [description appendString:@">"];
    return description;
}

@end


