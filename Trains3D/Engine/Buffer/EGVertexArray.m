#import "EGVertexArray.h"

#import "EGContext.h"
#import "EGShader.h"
#import "EGIndex.h"
#import "EGVertex.h"
#import "EGFence.h"
#import "GL.h"
@implementation EGVertexArray
static ODClassType* _EGVertexArray_type;

+ (id)vertexArray {
    return [[EGVertexArray alloc] init];
}

- (id)init {
    self = [super init];
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGVertexArray class]) _EGVertexArray_type = [ODClassType classTypeWithCls:[EGVertexArray class]];
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

+ (id)routeVertexArrayWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow {
    return [[EGRouteVertexArray alloc] initWithStandard:standard shadow:shadow];
}

- (id)initWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow {
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
    id<CNSeq> _buffers;
    id<EGIndexSource> _index;
    BOOL _isMutable;
    EGFence* _fence;
}
static ODClassType* _EGSimpleVertexArray_type;
@synthesize handle = _handle;
@synthesize shader = _shader;
@synthesize buffers = _buffers;
@synthesize index = _index;
@synthesize isMutable = _isMutable;

+ (id)simpleVertexArrayWithHandle:(unsigned int)handle shader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index {
    return [[EGSimpleVertexArray alloc] initWithHandle:handle shader:shader buffers:buffers index:index];
}

- (id)initWithHandle:(unsigned int)handle shader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index {
    self = [super init];
    if(self) {
        _handle = handle;
        _shader = shader;
        _buffers = buffers;
        _index = index;
        _isMutable = [_index isMutable] || [[[_buffers chain] findWhere:^BOOL(id<EGVertexBuffer> _) {
    return [((id<EGVertexBuffer>)(_)) isMutable];
}] isDefined];
        _fence = [EGFence fence];
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGSimpleVertexArray class]) _EGSimpleVertexArray_type = [ODClassType classTypeWithCls:[EGSimpleVertexArray class]];
}

+ (EGSimpleVertexArray*)applyShader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index {
    return [EGSimpleVertexArray simpleVertexArrayWithHandle:egGenVertexArray() shader:shader buffers:buffers index:index];
}

- (void)bind {
    [EGGlobal.context bindVertexArrayHandle:_handle vertexCount:((unsigned int)([((id<EGVertexBuffer>)([_buffers head])) count])) mutable:_isMutable];
}

- (void)unbind {
    [EGGlobal.context bindDefaultVertexArray];
}

- (void)dealloc {
    egDeleteVertexArray(_handle);
}

- (NSUInteger)count {
    return [((id<EGVertexBuffer>)([_buffers head])) count];
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
    return self.handle == o.handle && [self.shader isEqual:o.shader] && [self.buffers isEqual:o.buffers] && [self.index isEqual:o.index];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.handle;
    hash = hash * 31 + [self.shader hash];
    hash = hash * 31 + [self.buffers hash];
    hash = hash * 31 + [self.index hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%u", self.handle];
    [description appendFormat:@", shader=%@", self.shader];
    [description appendFormat:@", buffers=%@", self.buffers];
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

+ (id)materialVertexArrayWithVao:(EGVertexArray*)vao material:(id)material {
    return [[EGMaterialVertexArray alloc] initWithVao:vao material:material];
}

- (id)initWithVao:(EGVertexArray*)vao material:(id)material {
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


