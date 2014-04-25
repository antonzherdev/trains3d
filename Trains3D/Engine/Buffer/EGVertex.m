#import "EGVertex.h"

#import "GL.h"
#import "EGContext.h"
@implementation EGVertexBufferDesc
static ODClassType* _EGVertexBufferDesc_type;
@synthesize dataType = _dataType;
@synthesize position = _position;
@synthesize uv = _uv;
@synthesize normal = _normal;
@synthesize color = _color;
@synthesize model = _model;

+ (instancetype)vertexBufferDescWithDataType:(ODPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model {
    return [[EGVertexBufferDesc alloc] initWithDataType:dataType position:position uv:uv normal:normal color:color model:model];
}

- (instancetype)initWithDataType:(ODPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model {
    self = [super init];
    if(self) {
        _dataType = dataType;
        _position = position;
        _uv = uv;
        _normal = normal;
        _color = color;
        _model = model;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGVertexBufferDesc class]) _EGVertexBufferDesc_type = [ODClassType classTypeWithCls:[EGVertexBufferDesc class]];
}

- (unsigned int)stride {
    return ((unsigned int)(_dataType.size));
}

+ (EGVertexBufferDesc*)Vec2 {
    return [EGVertexBufferDesc vertexBufferDescWithDataType:geVec2Type() position:-1 uv:0 normal:-1 color:-1 model:0];
}

+ (EGVertexBufferDesc*)Vec3 {
    return [EGVertexBufferDesc vertexBufferDescWithDataType:geVec3Type() position:0 uv:0 normal:0 color:-1 model:0];
}

+ (EGVertexBufferDesc*)Vec4 {
    return [EGVertexBufferDesc vertexBufferDescWithDataType:geVec4Type() position:0 uv:0 normal:0 color:0 model:0];
}

+ (EGVertexBufferDesc*)mesh {
    return [EGVertexBufferDesc vertexBufferDescWithDataType:egMeshDataType() position:((int)(5 * 4)) uv:0 normal:((int)(2 * 4)) color:-1 model:-1];
}

- (ODClassType*)type {
    return [EGVertexBufferDesc type];
}

+ (ODClassType*)type {
    return _EGVertexBufferDesc_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"dataType=%@", self.dataType];
    [description appendFormat:@", position=%d", self.position];
    [description appendFormat:@", uv=%d", self.uv];
    [description appendFormat:@", normal=%d", self.normal];
    [description appendFormat:@", color=%d", self.color];
    [description appendFormat:@", model=%d", self.model];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVBO
static ODClassType* _EGVBO_type;

+ (void)initialize {
    [super initialize];
    if(self == [EGVBO class]) _EGVBO_type = [ODClassType classTypeWithCls:[EGVBO class]];
}

+ (id<EGVertexBuffer>)applyDesc:(EGVertexBufferDesc*)desc array:(void*)array count:(unsigned int)count {
    unsigned int len = count * desc.dataType.size;
    EGImmutableVertexBuffer* vb = [EGImmutableVertexBuffer immutableVertexBufferWithDesc:desc handle:egGenBuffer() length:((NSUInteger)(len)) count:((NSUInteger)(count))];
    [vb bind];
    glBufferData(GL_ARRAY_BUFFER, ((long)(len)), array, GL_STATIC_DRAW);
    return vb;
}

+ (id<EGVertexBuffer>)applyDesc:(EGVertexBufferDesc*)desc data:(CNPArray*)data {
    EGImmutableVertexBuffer* vb = [EGImmutableVertexBuffer immutableVertexBufferWithDesc:desc handle:egGenBuffer() length:data.length count:data.count];
    [vb bind];
    glBufferData(GL_ARRAY_BUFFER, ((long)(data.length)), data.bytes, GL_STATIC_DRAW);
    return vb;
}

+ (id<EGVertexBuffer>)vec4Data:(CNPArray*)data {
    return [EGVBO applyDesc:[EGVertexBufferDesc Vec4] data:data];
}

+ (id<EGVertexBuffer>)vec3Data:(CNPArray*)data {
    return [EGVBO applyDesc:[EGVertexBufferDesc Vec3] data:data];
}

+ (id<EGVertexBuffer>)vec2Data:(CNPArray*)data {
    return [EGVBO applyDesc:[EGVertexBufferDesc Vec2] data:data];
}

+ (id<EGVertexBuffer>)meshData:(CNPArray*)data {
    return [EGVBO applyDesc:[EGVertexBufferDesc mesh] data:data];
}

+ (EGMutableVertexBuffer*)mutDesc:(EGVertexBufferDesc*)desc usage:(unsigned int)usage {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:desc handle:egGenBuffer() usage:usage];
}

+ (EGVertexBufferRing*)ringSize:(unsigned int)size desc:(EGVertexBufferDesc*)desc usage:(unsigned int)usage {
    return [EGVertexBufferRing vertexBufferRingWithRingSize:size desc:desc usage:usage];
}

+ (EGMutableVertexBuffer*)mutVec2Usage:(unsigned int)usage {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc Vec2] handle:egGenBuffer() usage:usage];
}

+ (EGMutableVertexBuffer*)mutVec3Usage:(unsigned int)usage {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc Vec3] handle:egGenBuffer() usage:usage];
}

+ (EGMutableVertexBuffer*)mutVec4Usage:(unsigned int)usage {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc Vec4] handle:egGenBuffer() usage:usage];
}

+ (EGMutableVertexBuffer*)mutMeshUsage:(unsigned int)usage {
    return [EGMutableVertexBuffer mutableVertexBufferWithDesc:[EGVertexBufferDesc mesh] handle:egGenBuffer() usage:usage];
}

- (ODClassType*)type {
    return [EGVBO type];
}

+ (ODClassType*)type {
    return _EGVBO_type;
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


@implementation EGImmutableVertexBuffer
static ODClassType* _EGImmutableVertexBuffer_type;
@synthesize desc = _desc;
@synthesize length = _length;
@synthesize count = _count;

+ (instancetype)immutableVertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(unsigned int)handle length:(NSUInteger)length count:(NSUInteger)count {
    return [[EGImmutableVertexBuffer alloc] initWithDesc:desc handle:handle length:length count:count];
}

- (instancetype)initWithDesc:(EGVertexBufferDesc*)desc handle:(unsigned int)handle length:(NSUInteger)length count:(NSUInteger)count {
    self = [super initWithDataType:desc.dataType bufferType:GL_ARRAY_BUFFER handle:handle];
    if(self) {
        _desc = desc;
        _length = length;
        _count = count;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGImmutableVertexBuffer class]) _EGImmutableVertexBuffer_type = [ODClassType classTypeWithCls:[EGImmutableVertexBuffer class]];
}

- (void)bind {
    [EGGlobal.context bindVertexBufferBuffer:self];
}

- (BOOL)isMutable {
    return NO;
}

- (ODClassType*)type {
    return [EGImmutableVertexBuffer type];
}

+ (ODClassType*)type {
    return _EGImmutableVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"desc=%@", self.desc];
    [description appendFormat:@", handle=%u", self.handle];
    [description appendFormat:@", length=%lu", (unsigned long)self.length];
    [description appendFormat:@", count=%lu", (unsigned long)self.count];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableVertexBuffer
static ODClassType* _EGMutableVertexBuffer_type;
@synthesize desc = _desc;

+ (instancetype)mutableVertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(unsigned int)handle usage:(unsigned int)usage {
    return [[EGMutableVertexBuffer alloc] initWithDesc:desc handle:handle usage:usage];
}

- (instancetype)initWithDesc:(EGVertexBufferDesc*)desc handle:(unsigned int)handle usage:(unsigned int)usage {
    self = [super initWithDataType:desc.dataType bufferType:GL_ARRAY_BUFFER handle:handle usage:usage];
    if(self) _desc = desc;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMutableVertexBuffer class]) _EGMutableVertexBuffer_type = [ODClassType classTypeWithCls:[EGMutableVertexBuffer class]];
}

- (BOOL)isMutable {
    return YES;
}

- (void)bind {
    [EGGlobal.context bindVertexBufferBuffer:self];
}

- (BOOL)isEmpty {
    return NO;
}

- (ODClassType*)type {
    return [EGMutableVertexBuffer type];
}

+ (ODClassType*)type {
    return _EGMutableVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"desc=%@", self.desc];
    [description appendFormat:@", handle=%u", self.handle];
    [description appendFormat:@", usage=%u", self.usage];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVertexBufferRing
static ODClassType* _EGVertexBufferRing_type;
@synthesize desc = _desc;
@synthesize usage = _usage;

+ (instancetype)vertexBufferRingWithRingSize:(unsigned int)ringSize desc:(EGVertexBufferDesc*)desc usage:(unsigned int)usage {
    return [[EGVertexBufferRing alloc] initWithRingSize:ringSize desc:desc usage:usage];
}

- (instancetype)initWithRingSize:(unsigned int)ringSize desc:(EGVertexBufferDesc*)desc usage:(unsigned int)usage {
    self = [super initWithRingSize:ringSize creator:^EGMutableVertexBuffer*() {
        return [EGMutableVertexBuffer mutableVertexBufferWithDesc:desc handle:egGenBuffer() usage:usage];
    }];
    if(self) {
        _desc = desc;
        _usage = usage;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGVertexBufferRing class]) _EGVertexBufferRing_type = [ODClassType classTypeWithCls:[EGVertexBufferRing class]];
}

- (ODClassType*)type {
    return [EGVertexBufferRing type];
}

+ (ODClassType*)type {
    return _EGVertexBufferRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"ringSize=%u", self.ringSize];
    [description appendFormat:@", desc=%@", self.desc];
    [description appendFormat:@", usage=%u", self.usage];
    [description appendString:@">"];
    return description;
}

@end


