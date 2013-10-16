#import "EGParticleSystem.h"

#import "EGVertex.h"
#import "EGShader.h"
#import "EGMaterial.h"
#import "EGIndex.h"
#import "EGMesh.h"
#import "EGContext.h"
@implementation EGParticleSystem{
    CNList* __particles;
}
static ODClassType* _EGParticleSystem_type;

+ (id)particleSystem {
    return [[EGParticleSystem alloc] init];
}

- (id)init {
    self = [super init];
    if(self) __particles = [CNList apply];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGParticleSystem_type = [ODClassType classTypeWithCls:[EGParticleSystem class]];
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
    return [EGParticleSystem type];
}

+ (ODClassType*)type {
    return _EGParticleSystem_type;
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


@implementation EGParticle{
    float _lifeLength;
    float __lifeTime;
}
static ODClassType* _EGParticle_type;
@synthesize lifeLength = _lifeLength;

+ (id)particleWithLifeLength:(float)lifeLength {
    return [[EGParticle alloc] initWithLifeLength:lifeLength];
}

- (id)initWithLifeLength:(float)lifeLength {
    self = [super init];
    if(self) _lifeLength = lifeLength;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGParticle_type = [ODClassType classTypeWithCls:[EGParticle class]];
}

- (float)lifeTime {
    return __lifeTime;
}

- (CNVoidRefArray)writeToArray:(CNVoidRefArray)array {
    @throw @"Method writeTo is abstract";
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

- (ODClassType*)type {
    return [EGParticle type];
}

+ (ODClassType*)type {
    return _EGParticle_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGParticle* o = ((EGParticle*)(other));
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


@implementation EGParticleSystemView{
    EGParticleSystem* _system;
    EGVertexBufferDesc* _vbDesc;
    NSUInteger _maxCount;
    EGShader* _shader;
    EGMaterial* _material;
    EGBlendFunction* _blendFunc;
    CNVoidRefArray _vertexArr;
    EGMutableVertexBuffer* _vertexBuffer;
    EGMutableIndexSourceGap* _index;
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

+ (id)particleSystemViewWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(EGMaterial*)material blendFunc:(EGBlendFunction*)blendFunc {
    return [[EGParticleSystemView alloc] initWithSystem:system vbDesc:vbDesc maxCount:maxCount shader:shader material:material blendFunc:blendFunc];
}

- (id)initWithSystem:(EGParticleSystem*)system vbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount shader:(EGShader*)shader material:(EGMaterial*)material blendFunc:(EGBlendFunction*)blendFunc {
    self = [super init];
    __weak EGParticleSystemView* _weakSelf = self;
    if(self) {
        _system = system;
        _vbDesc = vbDesc;
        _maxCount = maxCount;
        _shader = shader;
        _material = material;
        _blendFunc = blendFunc;
        _vertexArr = cnVoidRefArrayApplyTpCount(_vbDesc.dataType, _maxCount * [self vertexCount]);
        _vertexBuffer = [EGVBO mutDesc:_vbDesc];
        _index = ^EGMutableIndexSourceGap*() {
            NSUInteger vc = [self vertexCount];
            CNVoidRefArray ia = cnVoidRefArrayApplyTpCount(oduInt4Type(), _maxCount * 3 * (vc - 2));
            __block CNVoidRefArray indexPointer = ia;
            [uintRange(_maxCount) forEach:^void(id i) {
                indexPointer = [_weakSelf writeIndexesToIndexPointer:indexPointer i:((unsigned int)(unumi(i) * vc))];
            }];
            EGImmutableIndexBuffer* ib = [EGIBO applyArray:ia];
            cnVoidRefArrayFree(ia);
            return [EGMutableIndexSourceGap mutableIndexSourceGapWithSource:ib];
        }();
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

- (CNVoidRefArray)writeIndexesToIndexPointer:(CNVoidRefArray)indexPointer i:(unsigned int)i {
    @throw @"Method writeIndexesTo is abstract";
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
                [_vertexBuffer setArray:_vertexArr];
                _index.count = ((unsigned int)(n * 3 * (vc - 2)));
                [_vao drawParam:_material];
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
    [description appendFormat:@", maxCount=%li", self.maxCount];
    [description appendFormat:@", shader=%@", self.shader];
    [description appendFormat:@", material=%@", self.material];
    [description appendFormat:@", blendFunc=%@", self.blendFunc];
    [description appendString:@">"];
    return description;
}

@end


