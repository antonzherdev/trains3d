#import "EGVertexArray.h"

#import "EGVertex.h"
#import "EGIndex.h"
#import "EGContext.h"
#import "EGShader.h"
#import "EGFence.h"
#import "GL.h"
@implementation EGVertexArray{
    CNLazy* __lazy_mutableVertexBuffer;
}
static ODClassType* _EGVertexArray_type;

+ (instancetype)vertexArray {
    return [[EGVertexArray alloc] init];
}

- (instancetype)init {
    self = [super init];
    __weak EGVertexArray* _weakSelf = self;
    if(self) __lazy_mutableVertexBuffer = [CNLazy lazyWithF:^id() {
        return [[[_weakSelf vertexBuffers] findWhere:^BOOL(id<EGVertexBuffer> _) {
            return [((id<EGVertexBuffer>)(_)) isKindOfClass:[EGMutableVertexBuffer class]];
        }] mapF:^EGMutableVertexBuffer*(id<EGVertexBuffer> _) {
            return ((EGMutableVertexBuffer*)(_));
        }];
    }];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGVertexArray class]) _EGVertexArray_type = [ODClassType classTypeWithCls:[EGVertexArray class]];
}

- (id)mutableVertexBuffer {
    return [__lazy_mutableVertexBuffer get];
}

- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end {
    @throw @"Method draw is abstract";
}

- (void)drawParam:(id)param {
    @throw @"Method draw is abstract";
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (void)syncF:(void(^)())f {
    @throw @"Method sync is abstract";
}

- (id<CNSeq>)vertexBuffers {
    @throw @"Method vertexBuffers is abstract";
}

- (id<EGIndexSource>)index {
    @throw @"Method index is abstract";
}

- (void)vertexWriteCount:(unsigned int)count f:(void(^)(CNVoidRefArray))f {
    [((EGMutableVertexBuffer*)([[self mutableVertexBuffer] get])) writeCount:count f:f];
}

- (ODClassType*)type {
    return [EGVertexArray type];
}

+ (ODClassType*)type {
    return _EGVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    return YES;
}

- (NSUInteger)hash {
    return 0;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGRouteVertexArray{
    EGVertexArray* _standard;
    EGVertexArray* _shadow;
}
static ODClassType* _EGRouteVertexArray_type;
@synthesize standard = _standard;
@synthesize shadow = _shadow;

+ (instancetype)routeVertexArrayWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow {
    return [[EGRouteVertexArray alloc] initWithStandard:standard shadow:shadow];
}

- (instancetype)initWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow {
    self = [super init];
    if(self) {
        _standard = standard;
        _shadow = shadow;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGRouteVertexArray class]) _EGRouteVertexArray_type = [ODClassType classTypeWithCls:[EGRouteVertexArray class]];
}

- (EGVertexArray*)mesh {
    if([EGGlobal.context.renderTarget isKindOfClass:[EGShadowRenderTarget class]]) return _shadow;
    else return _standard;
}

- (void)drawParam:(id)param {
    [[self mesh] drawParam:param];
}

- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end {
    [[self mesh] drawParam:param start:start end:end];
}

- (void)draw {
    [[self mesh] draw];
}

- (void)syncF:(void(^)())f {
    [[self mesh] syncF:f];
}

- (id<CNSeq>)vertexBuffers {
    return [[self mesh] vertexBuffers];
}

- (id<EGIndexSource>)index {
    return [[self mesh] index];
}

- (ODClassType*)type {
    return [EGRouteVertexArray type];
}

+ (ODClassType*)type {
    return _EGRouteVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGRouteVertexArray* o = ((EGRouteVertexArray*)(other));
    return [self.standard isEqual:o.standard] && [self.shadow isEqual:o.shadow];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.standard hash];
    hash = hash * 31 + [self.shadow hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"standard=%@", self.standard];
    [description appendFormat:@", shadow=%@", self.shadow];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGSimpleVertexArray{
    unsigned int _handle;
    EGShader* _shader;
    id<CNSeq> _vertexBuffers;
    id<EGIndexSource> _index;
    BOOL _isMutable;
    EGFence* _fence;
}
static ODClassType* _EGSimpleVertexArray_type;
@synthesize handle = _handle;
@synthesize shader = _shader;
@synthesize vertexBuffers = _vertexBuffers;
@synthesize index = _index;
@synthesize isMutable = _isMutable;

+ (instancetype)simpleVertexArrayWithHandle:(unsigned int)handle shader:(EGShader*)shader vertexBuffers:(id<CNSeq>)vertexBuffers index:(id<EGIndexSource>)index {
    return [[EGSimpleVertexArray alloc] initWithHandle:handle shader:shader vertexBuffers:vertexBuffers index:index];
}

- (instancetype)initWithHandle:(unsigned int)handle shader:(EGShader*)shader vertexBuffers:(id<CNSeq>)vertexBuffers index:(id<EGIndexSource>)index {
    self = [super init];
    if(self) {
        _handle = handle;
        _shader = shader;
        _vertexBuffers = vertexBuffers;
        _index = index;
        _isMutable = [_index isMutable] || [[[_vertexBuffers chain] findWhere:^BOOL(id<EGVertexBuffer> _) {
    return [((id<EGVertexBuffer>)(_)) isMutable];
}] isDefined];
        _fence = [EGFence fenceWithName:@"VAO"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSimpleVertexArray class]) _EGSimpleVertexArray_type = [ODClassType classTypeWithCls:[EGSimpleVertexArray class]];
}

+ (EGSimpleVertexArray*)applyShader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index {
    return [EGSimpleVertexArray simpleVertexArrayWithHandle:egGenVertexArray() shader:shader vertexBuffers:buffers index:index];
}

- (void)bind {
    [EGGlobal.context bindVertexArrayHandle:_handle vertexCount:((unsigned int)([((id<EGVertexBuffer>)([_vertexBuffers head])) count])) mutable:_isMutable];
}

- (void)unbind {
    [EGGlobal.context bindDefaultVertexArray];
}

- (void)dealloc {
    [EGGlobal.context deleteVertexArrayId:_handle];
}

- (NSUInteger)count {
    return [((id<EGVertexBuffer>)([_vertexBuffers head])) count];
}

- (void)drawParam:(id)param {
    if(!([_index isEmpty])) [_shader drawParam:param vao:self];
}

- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end {
    if(!([_index isEmpty])) [_shader drawParam:param vao:self start:start end:end];
}

- (void)draw {
    @throw @"No default material";
}

- (void)syncF:(void(^)())f {
    [_fence syncF:f];
}

- (ODClassType*)type {
    return [EGSimpleVertexArray type];
}

+ (ODClassType*)type {
    return _EGSimpleVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGSimpleVertexArray* o = ((EGSimpleVertexArray*)(other));
    return self.handle == o.handle && [self.shader isEqual:o.shader] && [self.vertexBuffers isEqual:o.vertexBuffers] && [self.index isEqual:o.index];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.handle;
    hash = hash * 31 + [self.shader hash];
    hash = hash * 31 + [self.vertexBuffers hash];
    hash = hash * 31 + [self.index hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%u", self.handle];
    [description appendFormat:@", shader=%@", self.shader];
    [description appendFormat:@", vertexBuffers=%@", self.vertexBuffers];
    [description appendFormat:@", index=%@", self.index];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMaterialVertexArray{
    EGVertexArray* _vao;
    id _material;
}
static ODClassType* _EGMaterialVertexArray_type;
@synthesize vao = _vao;
@synthesize material = _material;

+ (instancetype)materialVertexArrayWithVao:(EGVertexArray*)vao material:(id)material {
    return [[EGMaterialVertexArray alloc] initWithVao:vao material:material];
}

- (instancetype)initWithVao:(EGVertexArray*)vao material:(id)material {
    self = [super init];
    if(self) {
        _vao = vao;
        _material = material;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMaterialVertexArray class]) _EGMaterialVertexArray_type = [ODClassType classTypeWithCls:[EGMaterialVertexArray class]];
}

- (void)draw {
    [_vao drawParam:_material];
}

- (void)drawParam:(id)param {
    [_vao drawParam:param];
}

- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end {
    [_vao drawParam:param start:start end:end];
}

- (void)syncF:(void(^)())f {
    [_vao syncF:f];
}

- (id<CNSeq>)vertexBuffers {
    return [_vao vertexBuffers];
}

- (id<EGIndexSource>)index {
    return [_vao index];
}

- (ODClassType*)type {
    return [EGMaterialVertexArray type];
}

+ (ODClassType*)type {
    return _EGMaterialVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMaterialVertexArray* o = ((EGMaterialVertexArray*)(other));
    return [self.vao isEqual:o.vao] && [self.material isEqual:o.material];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.vao hash];
    hash = hash * 31 + [self.material hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vao=%@", self.vao];
    [description appendFormat:@", material=%@", self.material];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVertexArrayRing{
    unsigned int _ringSize;
    EGVertexArray*(^_creator)();
    CNMQueue* __ring;
}
static ODClassType* _EGVertexArrayRing_type;
@synthesize ringSize = _ringSize;
@synthesize creator = _creator;

+ (instancetype)vertexArrayRingWithRingSize:(unsigned int)ringSize creator:(EGVertexArray*(^)())creator {
    return [[EGVertexArrayRing alloc] initWithRingSize:ringSize creator:creator];
}

- (instancetype)initWithRingSize:(unsigned int)ringSize creator:(EGVertexArray*(^)())creator {
    self = [super init];
    if(self) {
        _ringSize = ringSize;
        _creator = creator;
        __ring = [CNMQueue queue];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGVertexArrayRing class]) _EGVertexArrayRing_type = [ODClassType classTypeWithCls:[EGVertexArrayRing class]];
}

- (EGVertexArray*)next {
    EGVertexArray* buffer = (([__ring count] >= _ringSize) ? [[__ring dequeue] get] : ((EGVertexArray*(^)())(_creator))());
    [__ring enqueueItem:buffer];
    return buffer;
}

- (void)syncF:(void(^)(EGVertexArray*))f {
    EGVertexArray* vao = [self next];
    [[self next] syncF:^void() {
        f(vao);
    }];
}

- (ODClassType*)type {
    return [EGVertexArrayRing type];
}

+ (ODClassType*)type {
    return _EGVertexArrayRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVertexArrayRing* o = ((EGVertexArrayRing*)(other));
    return self.ringSize == o.ringSize && [self.creator isEqual:o.creator];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.ringSize;
    hash = hash * 31 + [self.creator hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"ringSize=%u", self.ringSize];
    [description appendString:@">"];
    return description;
}

@end


