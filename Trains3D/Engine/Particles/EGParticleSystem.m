#import "EGParticleSystem.h"

#import "EGMesh.h"
#import "EGShader.h"
#import "EGMaterial.h"
#import "EGTexture.h"
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
    @throw @"Method generateParticlesWith is abstract";
}

- (void)emitParticle {
    __particles = [CNList applyObject:[self generateParticle] tail:__particles];
}

- (void)updateWithDelta:(CGFloat)delta {
    [self generateParticlesWithDelta:delta];
    __particles = [__particles filterF:^BOOL(id _) {
        return [_ isLive];
    }];
    [__particles forEach:^void(id _) {
        [_ updateWithDelta:delta];
    }];
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
    ODPType* _dtp;
    EGVertexBuffer* _vertexBuffer;
    EGIndexBuffer* _indexBuffer;
}
static ODClassType* _EGParticleSystemView_type;
@synthesize dtp = _dtp;
@synthesize vertexBuffer = _vertexBuffer;
@synthesize indexBuffer = _indexBuffer;

+ (id)particleSystemViewWithDtp:(ODPType*)dtp {
    return [[EGParticleSystemView alloc] initWithDtp:dtp];
}

- (id)initWithDtp:(ODPType*)dtp {
    self = [super init];
    if(self) {
        _dtp = dtp;
        _vertexBuffer = [EGVertexBuffer applyStride:_dtp.size];
        _indexBuffer = [EGIndexBuffer apply];
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

- (EGShader*)shader {
    @throw @"Method shader is abstract";
}

- (EGMaterial*)material {
    @throw @"Method material is abstract";
}

- (void)drawSystem:(EGParticleSystem*)system {
    id<CNSeq> particles = [system particles];
    NSUInteger n = [particles count];
    if(n == 0) return ;
    glDisable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    NSUInteger vc = [self vertexCount];
    CNVoidRefArray vertexArr = cnVoidRefArrayApplyTpCount(_dtp, n * vc);
    CNVoidRefArray indexArr = cnVoidRefArrayApplyTpCount(oduInt4Type(), n * 3 * (vc - 2));
    __block CNVoidRefArray indexPointer = indexArr;
    __block CNVoidRefArray vertexPointer = vertexArr;
    __block unsigned int index = 0;
    [particles forEach:^void(id particle) {
        vertexPointer = [particle writeToArray:vertexPointer];
        NSUInteger vci = vc - 2;
        while(vci > 0) {
            indexPointer = cnVoidRefArrayWriteUInt4(indexPointer, index);
            indexPointer = cnVoidRefArrayWriteUInt4(indexPointer, index + 1);
            indexPointer = cnVoidRefArrayWriteUInt4(indexPointer, index + 2);
            index++;
            vci--;
        }
        index += 2;
    }];
    [_vertexBuffer setTp:_dtp array:vertexArr];
    [_indexBuffer setTp:oduInt4Type() array:indexArr];
    cnVoidRefArrayFree(vertexArr);
    cnVoidRefArrayFree(indexArr);
    [[self shader] drawMaterial:[self material] mesh:[EGMesh meshWithVertexBuffer:_vertexBuffer indexBuffer:_indexBuffer]];
    glDisable(GL_BLEND);
    glEnable(GL_CULL_FACE);
    glEnable(GL_DEPTH_TEST);
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
    return [self.dtp isEqual:o.dtp];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.dtp hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"dtp=%@", self.dtp];
    [description appendString:@">"];
    return description;
}

@end


