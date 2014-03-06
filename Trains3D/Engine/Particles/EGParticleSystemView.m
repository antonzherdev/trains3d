#import "EGParticleSystemView.h"

#import "EGParticleSystem.h"
#import "EGVertex.h"
#import "EGShader.h"
#import "EGMaterial.h"
#import "EGIndex.h"
#import "EGVertexArray.h"
#import "EGContext.h"
@implementation EGParticleSystemView{
    EGParticleSystem* _system;
    EGVertexBufferDesc* _vbDesc;
    NSUInteger _maxCount;
    EGShader* _shader;
    id _material;
    EGBlendFunction* _blendFunc;
    id<EGIndexSource> _index;
    EGVertexArrayRing* _vaoRing;
    EGVertexArray* __vao;
    EGMutableVertexBuffer* __vbo;
}
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
            return [_weakSelf.shader vaoVbo:[EGVBO mutDesc:_weakSelf.vbDesc] ibo:_weakSelf.index];
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
    [__vao syncWait];
    __vbo = [[__vao mutableVertexBuffer] get];
    [_system writeToMaxCount:_maxCount array:[__vbo beginWriteCount:((unsigned int)([self vertexCount] * _maxCount))]];
}

- (void)draw {
    [[_system lastWriteCount] forSuccessAwait:1.0 f:^void(id n) {
        [__vbo endWrite];
        if(unumui(n) > 0) [EGGlobal.context.depthTest disabledF:^void() {
            [EGGlobal.context.cullFace disabledF:^void() {
                [_blendFunc applyDraw:^void() {
                    [__vao drawParam:_material start:0 end:[self indexCount] * unumui(n)];
                }];
            }];
        }];
        [__vao syncSet];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGParticleSystemView* o = ((EGParticleSystemView*)(other));
    return self.system == o.system && [self.vbDesc isEqual:o.vbDesc] && self.maxCount == o.maxCount && [self.shader isEqual:o.shader] && [self.material isEqual:o.material] && [self.blendFunc isEqual:o.blendFunc];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.system hash];
    hash = hash * 31 + [self.vbDesc hash];
    hash = hash * 31 + self.maxCount;
    hash = hash * 31 + [self.shader hash];
    hash = hash * 31 + [self.material hash];
    hash = hash * 31 + [self.blendFunc hash];
    return hash;
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


