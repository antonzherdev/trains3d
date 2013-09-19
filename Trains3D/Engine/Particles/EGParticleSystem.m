#import "EGParticleSystem.h"

#import "EGMesh.h"
#import "GL.h"
#import "EGShader.h"
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
    [__particles forEach:^void(id _) {
        [_ updateWithDelta:delta];
    }];
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
    EGVertexBufferDesc* _vbDesc;
    NSUInteger _maxCount;
    EGBlendFunction _blendFunc;
    CNVoidRefArray _vertexArr;
    EGVertexBuffer* _vertexBuffer;
    CNVoidRefArray _indexArr;
    EGIndexBuffer* _indexBuffer;
    EGMesh* _mesh;
}
static ODClassType* _EGParticleSystemView_type;
@synthesize vbDesc = _vbDesc;
@synthesize maxCount = _maxCount;
@synthesize blendFunc = _blendFunc;
@synthesize vertexArr = _vertexArr;
@synthesize vertexBuffer = _vertexBuffer;
@synthesize indexArr = _indexArr;
@synthesize indexBuffer = _indexBuffer;
@synthesize mesh = _mesh;

+ (id)particleSystemViewWithVbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount blendFunc:(EGBlendFunction)blendFunc {
    return [[EGParticleSystemView alloc] initWithVbDesc:vbDesc maxCount:maxCount blendFunc:blendFunc];
}

- (id)initWithVbDesc:(EGVertexBufferDesc*)vbDesc maxCount:(NSUInteger)maxCount blendFunc:(EGBlendFunction)blendFunc {
    self = [super init];
    __weak EGParticleSystemView* _weakSelf = self;
    if(self) {
        _vbDesc = vbDesc;
        _maxCount = maxCount;
        _blendFunc = blendFunc;
        _vertexArr = cnVoidRefArrayApplyTpCount(_vbDesc.dataType, _maxCount * [self vertexCount]);
        _vertexBuffer = [[EGVertexBuffer applyDesc:_vbDesc] setArray:_vertexArr usage:GL_DYNAMIC_DRAW];
        _indexArr = ^CNVoidRefArray() {
            NSUInteger vc = [self vertexCount];
            CNVoidRefArray ia = cnVoidRefArrayApplyTpCount(oduInt4Type(), _maxCount * 3 * (vc - 2));
            __block CNVoidRefArray indexPointer = ia;
            [uintRange(_maxCount) forEach:^void(id i) {
                indexPointer = [_weakSelf writeIndexesToIndexPointer:indexPointer i:((unsigned int)(unumi(i) * vc))];
            }];
            return ia;
        }();
        _indexBuffer = [[EGIndexBuffer apply] setArray:_indexArr usage:GL_STATIC_DRAW];
        _mesh = [EGMesh meshWithVertexBuffer:_vertexBuffer indexBuffer:_indexBuffer];
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

- (EGShader*)shader {
    @throw @"Method shader is abstract";
}

- (EGMaterial*)material {
    @throw @"Method material is abstract";
}

- (void)drawSystem:(EGParticleSystem*)system {
    id<CNSeq> particles = [system particles];
    if([particles isEmpty]) return ;
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    egBlendFunctionApplyDraw(_blendFunc, ^void() {
        __block NSInteger i = 0;
        __block CNVoidRefArray vertexPointer = _vertexArr;
        [particles forEach:^void(id particle) {
            if(i < _maxCount) vertexPointer = [particle writeToArray:vertexPointer];
            i++;
        }];
        CGFloat n = min(((CGFloat)([particles count])), ((CGFloat)(_maxCount)));
        NSUInteger vc = [self vertexCount];
        [_vertexBuffer setArray:_vertexArr usage:GL_DYNAMIC_DRAW];
        [[self shader] drawParam:[self material] mesh:_mesh start:0 count:((NSUInteger)(n * 3 * (vc - 2)))];
    });
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
}

- (void)dealloc {
    cnVoidRefArrayFree(_indexArr);
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
    return [self.vbDesc isEqual:o.vbDesc] && self.maxCount == o.maxCount && EGBlendFunctionEq(self.blendFunc, o.blendFunc);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.vbDesc hash];
    hash = hash * 31 + self.maxCount;
    hash = hash * 31 + EGBlendFunctionHash(self.blendFunc);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vbDesc=%@", self.vbDesc];
    [description appendFormat:@", maxCount=%li", self.maxCount];
    [description appendFormat:@", blendFunc=%@", EGBlendFunctionDescription(self.blendFunc)];
    [description appendString:@">"];
    return description;
}

@end


