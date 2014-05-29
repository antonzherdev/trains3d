#import "EGVertex.h"

#import "GL.h"
#import "EGContext.h"
@implementation EGVertexBufferDesc
static CNClassType* _EGVertexBufferDesc_type;
@synthesize dataType = _dataType;
@synthesize position = _position;
@synthesize uv = _uv;
@synthesize normal = _normal;
@synthesize color = _color;
@synthesize model = _model;

+ (instancetype)vertexBufferDescWithDataType:(CNPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model {
    return [[EGVertexBufferDesc alloc] initWithDataType:dataType position:position uv:uv normal:normal color:color model:model];
}

- (instancetype)initWithDataType:(CNPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model {
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
    if(self == [EGVertexBufferDesc class]) _EGVertexBufferDesc_type = [CNClassType classTypeWithCls:[EGVertexBufferDesc class]];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"VertexBufferDesc(%@, %d, %d, %d, %d, %d)", _dataType, _position, _uv, _normal, _color, _model];
}

- (CNClassType*)type {
    return [EGVertexBufferDesc type];
}

+ (CNClassType*)type {
    return _EGVertexBufferDesc_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGVBO
static CNClassType* _EGVBO_type;

+ (void)initialize {
    [super initialize];
    if(self == [EGVBO class]) _EGVBO_type = [CNClassType classTypeWithCls:[EGVBO class]];
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

- (CNClassType*)type {
    return [EGVBO type];
}

+ (CNClassType*)type {
    return _EGVBO_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGVertexBuffer_impl

+ (instancetype)vertexBuffer_impl {
    return [[EGVertexBuffer_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (EGVertexBufferDesc*)desc {
    @throw @"Method desc is abstract";
}

- (NSUInteger)count {
    @throw @"Method count is abstract";
}

- (unsigned int)handle {
    @throw @"Method handle is abstract";
}

- (BOOL)isMutable {
    return NO;
}

- (void)bind {
    @throw @"Method bind is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGImmutableVertexBuffer
static CNClassType* _EGImmutableVertexBuffer_type;
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
    if(self == [EGImmutableVertexBuffer class]) _EGImmutableVertexBuffer_type = [CNClassType classTypeWithCls:[EGImmutableVertexBuffer class]];
}

- (void)bind {
    [EGGlobal.context bindVertexBufferBuffer:self];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ImmutableVertexBuffer(%@, %lu, %lu)", _desc, (unsigned long)_length, (unsigned long)_count];
}

- (BOOL)isMutable {
    return NO;
}

- (CNClassType*)type {
    return [EGImmutableVertexBuffer type];
}

+ (CNClassType*)type {
    return _EGImmutableVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMutableVertexBuffer
static CNClassType* _EGMutableVertexBuffer_type;
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
    if(self == [EGMutableVertexBuffer class]) _EGMutableVertexBuffer_type = [CNClassType classTypeWithCls:[EGMutableVertexBuffer class]];
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

- (NSString*)description {
    return [NSString stringWithFormat:@"MutableVertexBuffer(%@)", _desc];
}

- (CNClassType*)type {
    return [EGMutableVertexBuffer type];
}

+ (CNClassType*)type {
    return _EGMutableVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGVertexBufferRing
static CNClassType* _EGVertexBufferRing_type;
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
    if(self == [EGVertexBufferRing class]) _EGVertexBufferRing_type = [CNClassType classTypeWithCls:[EGVertexBufferRing class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"VertexBufferRing(%@, %u)", _desc, _usage];
}

- (CNClassType*)type {
    return [EGVertexBufferRing type];
}

+ (CNClassType*)type {
    return _EGVertexBufferRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

