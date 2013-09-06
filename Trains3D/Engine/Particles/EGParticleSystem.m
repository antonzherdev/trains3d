#import "EGParticleSystem.h"

#import "CNData.h"
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
        _vertexBuffer = [EGVertexBuffer applyStride:((NSUInteger)(8 * 4))];
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
    CNMutablePArray* positionArr = [CNMutablePArray applyTp:_dtp count:n * vc];
    CNMutablePArray* indexArr = [CNMutablePArray applyTp:oduInt4Type() count:n * 3 * (vc - 2)];
    __block NSInteger index = 0;
    [particles forEach:^void(id particle) {
        [particle writeToArray:positionArr];
        NSUInteger vci = vc - 2;
        while(vci > 0) {
            [indexArr writeUInt4:((unsigned int)(index))];
            [indexArr writeUInt4:((unsigned int)(index + 1))];
            [indexArr writeUInt4:((unsigned int)(index + 2))];
            index++;
            vci--;
        }
        index += 2;
    }];
    [_vertexBuffer setData:positionArr];
    [_indexBuffer setData:indexArr];
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


