#import "EGParticleSystem.h"

#import "EGVertex.h"
#import "EGShader.h"
#import "EGMaterial.h"
#import "EGIndex.h"
#import "EGMesh.h"
#import "EGContext.h"
@implementation EGParticleSystemView{
    id<EGParticleSystem> _system;
    EGVertexBufferDesc* _vbDesc;
    NSUInteger _maxCount;
    EGShader* _shader;
    id _material;
    EGBlendFunction* _blendFunc;
    CNVoidRefArray _vertexArr;
    EGMutableVertexBuffer* _vertexBuffer;
    id<EGIndexSource> _index;
    EGVertexArray* _vao;
}
static ODClassType* _EGParticleSystemView_type;
@synthesize system = _system;
@synthesize vbDesc = _vbDesc;
@synthesize maxCount = _maxCount;
@synthesize shader = _shader;
@synthesize material = _material;
@synthesize blendFunc = _blendFunc;
@synthesize vertexArr = _vertexArr;
@synthesize vertexBuffer = _vertexBuffer;
@synthesize index = _index;
@synthesize vao = _vao;

+ (id)particleSystemViewWithSystem:(id<EGParticleSystem>)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    return [[EGParticleSystemView alloc] initWithSystem:system vbDesc:vbDesc maxCount:maxCount shader:shader material:material blendFunc:blendFunc];
}

- (id)initWithSystem:(id<EGParticleSystem>)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(id)material blendFunc:(EGBlendFunction*)blendFunc {
    self = [super init];
    if(self) {
        _system = system;
        _vbDesc = vbDesc;
        _maxCount = maxCount;
        _shader = shader;
        _material = material;
        _blendFunc = blendFunc;
        _vertexArr = cnVoidRefArrayApplyTpCount(_vbDesc.dataType, _maxCount * [self vertexCount]);
        _vertexBuffer = [EGVBO mutDesc:_vbDesc];
        _index = [self indexVertexCount:[self vertexCount] maxCount:_maxCount];
        _vao = [[EGMesh meshWithVertex:_vertexBuffer index:_index] vaoShader:_shader];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGParticleSystemView_type = [ODClassType classTypeWithCls:[EGParticleSystemView class]];
}

- (NSUInteger)vertexCount {
    @throw @"Method vertexCount is abstract";
}

- (id<EGIndexSource>)indexVertexCount:(NSUInteger)vertexCount maxCount:(NSUInteger)maxCount {
    @throw @"Method index is abstract";
}

- (void)draw {
    id<CNSeq> particles = [_system particles];
    if([particles isEmpty]) return ;
    [EGGlobal.context.depthTest disabledF:^void() {
        [EGGlobal.context.cullFace disabledF:^void() {
            [_blendFunc applyDraw:^void() {
                __block NSInteger i = 0;
                __block CNVoidRefArray vertexPointer = _vertexArr;
                [particles forEach:^void(id particle) {
                    if(i < _maxCount) vertexPointer = [particle writeToArray:vertexPointer];
                    i++;
                }];
                NSUInteger n = uintMinB([particles count], _maxCount);
                NSUInteger vc = [self vertexCount];
                [_vertexBuffer setArray:_vertexArr count:((unsigned int)(vc * i))];
                [_vao drawParam:_material start:0 end:n * 3 * (vc - 2)];
            }];
        }];
    }];
}

- (void)dealloc {
    cnVoidRefArrayFree(_vertexArr);
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
    return [self.system isEqual:o.system] && [self.vbDesc isEqual:o.vbDesc] && self.maxCount == o.maxCount && [self.shader isEqual:o.shader] && [self.material isEqual:o.material] && [self.blendFunc isEqual:o.blendFunc];
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


@implementation EGEmissiveParticleSystem{
    CNList* __particles;
}
static ODClassType* _EGEmissiveParticleSystem_type;

+ (id)emissiveParticleSystem {
    return [[EGEmissiveParticleSystem alloc] init];
}

- (id)init {
    self = [super init];
    if(self) __particles = [CNList apply];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEmissiveParticleSystem_type = [ODClassType classTypeWithCls:[EGEmissiveParticleSystem class]];
}

- (id<CNSeq>)particles {
    return __particles;
}

- (id)generateParticle {
    @throw @"Method generateParticle is abstract";
}

- (void)generateParticlesWithDelta:(CGFloat)delta {
}

- (void)emitParticle {
    __particles = [CNList applyItem:[self generateParticle] tail:__particles];
}

- (void)updateWithDelta:(CGFloat)delta {
    __particles = [__particles filterF:^BOOL(id _) {
        return [_ isLive];
    }];
    [self generateParticlesWithDelta:delta];
    __block CNList* ps = [CNList apply];
    [__particles forEach:^void(id p) {
        [p updateWithDelta:delta];
        if([p isLive]) ps = [CNList applyItem:p tail:ps];
    }];
    __particles = ps;
}

- (BOOL)hasParticles {
    return !([__particles isEmpty]);
}

- (ODClassType*)type {
    return [EGEmissiveParticleSystem type];
}

+ (ODClassType*)type {
    return _EGEmissiveParticleSystem_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEmittedParticle{
    float _lifeLength;
    float __lifeTime;
}
static ODClassType* _EGEmittedParticle_type;
@synthesize lifeLength = _lifeLength;

+ (id)emittedParticleWithLifeLength:(float)lifeLength {
    return [[EGEmittedParticle alloc] initWithLifeLength:lifeLength];
}

- (id)initWithLifeLength:(float)lifeLength {
    self = [super init];
    if(self) _lifeLength = lifeLength;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEmittedParticle_type = [ODClassType classTypeWithCls:[EGEmittedParticle class]];
}

- (float)lifeTime {
    return __lifeTime;
}

- (BOOL)isLive {
    return __lifeTime <= _lifeLength;
}

- (void)updateWithDelta:(CGFloat)delta {
    __lifeTime += ((float)(delta));
    [self updateT:__lifeTime dt:((float)(delta))];
}

- (void)updateT:(float)t dt:(float)dt {
    @throw @"Method update is abstract";
}

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array {
    @throw @"Method writeTo is abstract";
}

- (ODClassType*)type {
    return [EGEmittedParticle type];
}

+ (ODClassType*)type {
    return _EGEmittedParticle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEmittedParticle* o = ((EGEmittedParticle*)(other));
    return eqf4(self.lifeLength, o.lifeLength);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + float4Hash(self.lifeLength);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"lifeLength=%f", self.lifeLength];
    [description appendString:@">"];
    return description;
}

@end


