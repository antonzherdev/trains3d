#import "EGVertexArray.h"

#import "EGVertex.h"
#import "EGIndex.h"
#import "EGContext.h"
#import "EGShader.h"
#import "CNChain.h"
#import "EGFence.h"
#import "GL.h"
@implementation EGVertexArray
static CNClassType* _EGVertexArray_type;

+ (instancetype)vertexArray {
    return [[EGVertexArray alloc] init];
}

- (instancetype)init {
    self = [super init];
    __weak EGVertexArray* _weakSelf = self;
    if(self) __lazy_mutableVertexBuffer = [CNLazy lazyWithF:^EGMutableVertexBuffer*() {
        EGVertexArray* _self = _weakSelf;
        if(_self != nil) return ((EGMutableVertexBuffer*)([[_self vertexBuffers] findWhere:^BOOL(id<EGVertexBuffer> _) {
            return [((id<EGVertexBuffer>)(_)) isKindOfClass:[EGMutableVertexBuffer class]];
        }]));
        else return nil;
    }];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGVertexArray class]) _EGVertexArray_type = [CNClassType classTypeWithCls:[EGVertexArray class]];
}

- (EGMutableVertexBuffer*)mutableVertexBuffer {
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

- (void)syncWait {
    @throw @"Method syncWait is abstract";
}

- (void)syncSet {
    @throw @"Method syncSet is abstract";
}

- (void)syncF:(void(^)())f {
    @throw @"Method sync is abstract";
}

- (NSArray*)vertexBuffers {
    @throw @"Method vertexBuffers is abstract";
}

- (id<EGIndexSource>)index {
    @throw @"Method index is abstract";
}

- (void)vertexWriteCount:(unsigned int)count f:(void(^)(void*))f {
    [((EGMutableVertexBuffer*)(((EGMutableVertexBuffer*)([self mutableVertexBuffer])))) writeCount:count f:f];
}

- (NSString*)description {
    return @"VertexArray";
}

- (CNClassType*)type {
    return [EGVertexArray type];
}

+ (CNClassType*)type {
    return _EGVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGRouteVertexArray
static CNClassType* _EGRouteVertexArray_type;
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
    if(self == [EGRouteVertexArray class]) _EGRouteVertexArray_type = [CNClassType classTypeWithCls:[EGRouteVertexArray class]];
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

- (void)syncWait {
    [[self mesh] syncWait];
}

- (void)syncSet {
    [[self mesh] syncSet];
}

- (NSArray*)vertexBuffers {
    return [[self mesh] vertexBuffers];
}

- (id<EGIndexSource>)index {
    return [[self mesh] index];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"RouteVertexArray(%@, %@)", _standard, _shadow];
}

- (CNClassType*)type {
    return [EGRouteVertexArray type];
}

+ (CNClassType*)type {
    return _EGRouteVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGSimpleVertexArray
static CNClassType* _EGSimpleVertexArray_type;
@synthesize handle = _handle;
@synthesize shader = _shader;
@synthesize vertexBuffers = _vertexBuffers;
@synthesize index = _index;
@synthesize isMutable = _isMutable;

+ (instancetype)simpleVertexArrayWithHandle:(unsigned int)handle shader:(EGShader*)shader vertexBuffers:(NSArray*)vertexBuffers index:(id<EGIndexSource>)index {
    return [[EGSimpleVertexArray alloc] initWithHandle:handle shader:shader vertexBuffers:vertexBuffers index:index];
}

- (instancetype)initWithHandle:(unsigned int)handle shader:(EGShader*)shader vertexBuffers:(NSArray*)vertexBuffers index:(id<EGIndexSource>)index {
    self = [super init];
    if(self) {
        _handle = handle;
        _shader = shader;
        _vertexBuffers = vertexBuffers;
        _index = index;
        _isMutable = [index isMutable] || [[vertexBuffers chain] findWhere:^BOOL(id<EGVertexBuffer> _) {
            return [((id<EGVertexBuffer>)(_)) isMutable];
        }] != nil;
        _fence = [EGFence fenceWithName:@"VAO"];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSimpleVertexArray class]) _EGSimpleVertexArray_type = [CNClassType classTypeWithCls:[EGSimpleVertexArray class]];
}

+ (EGSimpleVertexArray*)applyShader:(EGShader*)shader buffers:(NSArray*)buffers index:(id<EGIndexSource>)index {
    return [EGSimpleVertexArray simpleVertexArrayWithHandle:egGenVertexArray() shader:shader vertexBuffers:buffers index:index];
}

- (void)bind {
    [EGGlobal.context bindVertexArrayHandle:_handle vertexCount:({
        id<EGVertexBuffer> __tmp_0rp1 = [_vertexBuffers head];
        ((__tmp_0rp1 != nil) ? ((unsigned int)([((id<EGVertexBuffer>)([_vertexBuffers head])) count])) : ((unsigned int)(0)));
    }) mutable:_isMutable];
}

- (void)unbind {
    [EGGlobal.context bindDefaultVertexArray];
}

- (void)dealloc {
    [EGGlobal.context deleteVertexArrayId:_handle];
}

- (NSUInteger)count {
    id<EGVertexBuffer> __tmp = [_vertexBuffers head];
    if(__tmp != nil) return [((id<EGVertexBuffer>)([_vertexBuffers head])) count];
    else return 0;
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

- (void)syncWait {
    [_fence clientWait];
}

- (void)syncSet {
    [_fence set];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"SimpleVertexArray(%u, %@, %@, %@)", _handle, _shader, _vertexBuffers, _index];
}

- (CNClassType*)type {
    return [EGSimpleVertexArray type];
}

+ (CNClassType*)type {
    return _EGSimpleVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMaterialVertexArray
static CNClassType* _EGMaterialVertexArray_type;
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
    if(self == [EGMaterialVertexArray class]) _EGMaterialVertexArray_type = [CNClassType classTypeWithCls:[EGMaterialVertexArray class]];
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

- (void)syncWait {
    [_vao syncWait];
}

- (void)syncSet {
    [_vao syncSet];
}

- (NSArray*)vertexBuffers {
    return [_vao vertexBuffers];
}

- (id<EGIndexSource>)index {
    return [_vao index];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MaterialVertexArray(%@, %@)", _vao, _material];
}

- (CNClassType*)type {
    return [EGMaterialVertexArray type];
}

+ (CNClassType*)type {
    return _EGMaterialVertexArray_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGVertexArrayRing
static CNClassType* _EGVertexArrayRing_type;
@synthesize ringSize = _ringSize;
@synthesize creator = _creator;

+ (instancetype)vertexArrayRingWithRingSize:(unsigned int)ringSize creator:(EGVertexArray*(^)(unsigned int))creator {
    return [[EGVertexArrayRing alloc] initWithRingSize:ringSize creator:creator];
}

- (instancetype)initWithRingSize:(unsigned int)ringSize creator:(EGVertexArray*(^)(unsigned int))creator {
    self = [super init];
    if(self) {
        _ringSize = ringSize;
        _creator = [creator copy];
        __ring = [CNMQueue queue];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGVertexArrayRing class]) _EGVertexArrayRing_type = [CNClassType classTypeWithCls:[EGVertexArrayRing class]];
}

- (EGVertexArray*)next {
    EGVertexArray* buffer = (([__ring count] >= _ringSize) ? ((EGVertexArray*)(nonnil([__ring dequeue]))) : ((EGVertexArray*)(_creator(((unsigned int)([__ring count]))))));
    [__ring enqueueItem:buffer];
    return buffer;
}

- (void)syncF:(void(^)(EGVertexArray*))f {
    EGVertexArray* vao = [self next];
    [[self next] syncF:^void() {
        f(vao);
    }];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"VertexArrayRing(%u)", _ringSize];
}

- (CNClassType*)type {
    return [EGVertexArrayRing type];
}

+ (CNClassType*)type {
    return _EGVertexArrayRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

