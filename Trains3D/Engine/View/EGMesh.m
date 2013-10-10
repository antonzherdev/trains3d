#import "EGMesh.h"

#import "EGShader.h"
#import "EGContext.h"
NSString* EGMeshDataDescription(EGMeshData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGMeshData: "];
    [description appendFormat:@"uv=%@", GEVec2Description(self.uv)];
    [description appendFormat:@", normal=%@", GEVec3Description(self.normal)];
    [description appendFormat:@", position=%@", GEVec3Description(self.position)];
    [description appendString:@">"];
    return description;
}
ODPType* egMeshDataType() {
    static ODPType* _ret = nil;
    if(_ret == nil) _ret = [ODPType typeWithCls:[EGMeshDataWrap class] name:@"EGMeshData" size:sizeof(EGMeshData) wrap:^id(void* data, NSUInteger i) {
        return wrap(EGMeshData, ((EGMeshData*)(data))[i]);
    }];
    return _ret;
}
@implementation EGMeshDataWrap{
    EGMeshData _value;
}
@synthesize value = _value;

+ (id)wrapWithValue:(EGMeshData)value {
    return [[EGMeshDataWrap alloc] initWithValue:value];
}

- (id)initWithValue:(EGMeshData)value {
    self = [super init];
    if(self) _value = value;
    return self;
}

- (NSString*)description {
    return EGMeshDataDescription(_value);
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMeshDataWrap* o = ((EGMeshDataWrap*)(other));
    return EGMeshDataEq(_value, o.value);
}

- (NSUInteger)hash {
    return EGMeshDataHash(_value);
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end



@implementation EGMesh{
    EGVertexBuffer* _vertexBuffer;
    EGIndexBuffer* _indexBuffer;
}
static ODClassType* _EGMesh_type;
@synthesize vertexBuffer = _vertexBuffer;
@synthesize indexBuffer = _indexBuffer;

+ (id)meshWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer {
    return [[EGMesh alloc] initWithVertexBuffer:vertexBuffer indexBuffer:indexBuffer];
}

- (id)initWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer {
    self = [super init];
    if(self) {
        _vertexBuffer = vertexBuffer;
        _indexBuffer = indexBuffer;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMesh_type = [ODClassType classTypeWithCls:[EGMesh class]];
}

+ (EGMesh*)vec2VertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGMesh meshWithVertexBuffer:[[EGVertexBuffer vec2] setData:vertexData] indexBuffer:[[EGIndexBuffer apply] setData:indexData]];
}

+ (EGMesh*)applyVertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGMesh meshWithVertexBuffer:[[EGVertexBuffer mesh] setData:vertexData] indexBuffer:[[EGIndexBuffer apply] setData:indexData]];
}

+ (EGMesh*)applyDesc:(EGVertexBufferDesc*)desc vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData {
    return [EGMesh meshWithVertexBuffer:[[EGVertexBuffer applyDesc:desc] setData:vertexData] indexBuffer:[[EGIndexBuffer apply] setData:indexData]];
}

- (ODClassType*)type {
    return [EGMesh type];
}

+ (ODClassType*)type {
    return _EGMesh_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMesh* o = ((EGMesh*)(other));
    return [self.vertexBuffer isEqual:o.vertexBuffer] && [self.indexBuffer isEqual:o.indexBuffer];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.vertexBuffer hash];
    hash = hash * 31 + [self.indexBuffer hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"vertexBuffer=%@", self.vertexBuffer];
    [description appendFormat:@", indexBuffer=%@", self.indexBuffer];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBuffer{
    ODPType* _dataType;
    unsigned int _bufferType;
    GLuint _handle;
    NSUInteger __length;
    NSUInteger __count;
}
static ODClassType* _EGBuffer_type;
@synthesize dataType = _dataType;
@synthesize bufferType = _bufferType;
@synthesize handle = _handle;

+ (id)bufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(GLuint)handle {
    return [[EGBuffer alloc] initWithDataType:dataType bufferType:bufferType handle:handle];
}

- (id)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(GLuint)handle {
    self = [super init];
    if(self) {
        _dataType = dataType;
        _bufferType = bufferType;
        _handle = handle;
        __length = 0;
        __count = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBuffer_type = [ODClassType classTypeWithCls:[EGBuffer class]];
}

- (NSUInteger)length {
    return __length;
}

- (NSUInteger)count {
    return __count;
}

+ (EGBuffer*)applyDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType {
    return [EGBuffer bufferWithDataType:dataType bufferType:bufferType handle:egGenBuffer()];
}

- (void)dealoc {
    egDeleteBuffer(_handle);
}

- (id)setData:(CNPArray*)data {
    return [self setData:data usage:GL_STATIC_DRAW];
}

- (id)setArray:(CNVoidRefArray)array {
    return [self setArray:array usage:GL_STATIC_DRAW];
}

- (id)setData:(CNPArray*)data usage:(unsigned int)usage {
    [self bind];
    glBufferData(_bufferType, data.length, data.bytes, usage);
    __length = data.length;
    __count = data.count;
    return self;
}

- (id)setArray:(CNVoidRefArray)array usage:(unsigned int)usage {
    [self bind];
    glBufferData(_bufferType, array.length, array.bytes, usage);
    __length = array.length;
    __count = array.length / _dataType.size;
    return self;
}

- (id)updateStart:(NSUInteger)start count:(NSUInteger)count array:(CNVoidRefArray)array {
    [self bind];
    glBufferSubData(_bufferType, start * _dataType.size, count * _dataType.size, array.bytes);
    return self;
}

- (void)bind {
    glBindBuffer(_bufferType, _handle);
}

- (unsigned int)stride {
    return ((unsigned int)(_dataType.size));
}

- (ODClassType*)type {
    return [EGBuffer type];
}

+ (ODClassType*)type {
    return _EGBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGBuffer* o = ((EGBuffer*)(other));
    return [self.dataType isEqual:o.dataType] && self.bufferType == o.bufferType && GLuintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.dataType hash];
    hash = hash * 31 + self.bufferType;
    hash = hash * 31 + GLuintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"dataType=%@", self.dataType];
    [description appendFormat:@", bufferType=%d", self.bufferType];
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVertexBufferDesc{
    ODPType* _dataType;
    int _position;
    int _uv;
    int _normal;
    int _color;
    int _model;
}
static ODClassType* _EGVertexBufferDesc_type;
@synthesize dataType = _dataType;
@synthesize position = _position;
@synthesize uv = _uv;
@synthesize normal = _normal;
@synthesize color = _color;
@synthesize model = _model;

+ (id)vertexBufferDescWithDataType:(ODPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model {
    return [[EGVertexBufferDesc alloc] initWithDataType:dataType position:position uv:uv normal:normal color:color model:model];
}

- (id)initWithDataType:(ODPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model {
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
    _EGVertexBufferDesc_type = [ODClassType classTypeWithCls:[EGVertexBufferDesc class]];
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

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVertexBufferDesc* o = ((EGVertexBufferDesc*)(other));
    return [self.dataType isEqual:o.dataType] && self.position == o.position && self.uv == o.uv && self.normal == o.normal && self.color == o.color && self.model == o.model;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.dataType hash];
    hash = hash * 31 + self.position;
    hash = hash * 31 + self.uv;
    hash = hash * 31 + self.normal;
    hash = hash * 31 + self.color;
    hash = hash * 31 + self.model;
    return hash;
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


@implementation EGVertexBuffer{
    EGVertexBufferDesc* _desc;
}
static ODClassType* _EGVertexBuffer_type;
@synthesize desc = _desc;

+ (id)vertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle {
    return [[EGVertexBuffer alloc] initWithDesc:desc handle:handle];
}

- (id)initWithDesc:(EGVertexBufferDesc*)desc handle:(GLuint)handle {
    self = [super initWithDataType:desc.dataType bufferType:GL_ARRAY_BUFFER handle:handle];
    if(self) _desc = desc;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVertexBuffer_type = [ODClassType classTypeWithCls:[EGVertexBuffer class]];
}

+ (EGVertexBuffer*)applyDesc:(EGVertexBufferDesc*)desc {
    return [EGVertexBuffer vertexBufferWithDesc:desc handle:egGenBuffer()];
}

+ (EGVertexBuffer*)vec2 {
    return [EGVertexBuffer vertexBufferWithDesc:[EGVertexBufferDesc Vec2] handle:egGenBuffer()];
}

+ (EGVertexBuffer*)vec3 {
    return [EGVertexBuffer vertexBufferWithDesc:[EGVertexBufferDesc Vec3] handle:egGenBuffer()];
}

+ (EGVertexBuffer*)vec4 {
    return [EGVertexBuffer vertexBufferWithDesc:[EGVertexBufferDesc Vec4] handle:egGenBuffer()];
}

+ (EGVertexBuffer*)mesh {
    return [EGVertexBuffer vertexBufferWithDesc:[EGVertexBufferDesc mesh] handle:egGenBuffer()];
}

- (void)bind {
    [EGGlobal.context bindVertexBufferBuffer:self];
}

- (void)bindWithShader:(EGShader*)shader {
    [EGGlobal.context bindVertexBufferBuffer:self];
    [shader loadAttributesVbDesc:_desc];
}

- (void)unbindWithShader:(EGShader*)shader {
}

- (ODClassType*)type {
    return [EGVertexBuffer type];
}

+ (ODClassType*)type {
    return _EGVertexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVertexBuffer* o = ((EGVertexBuffer*)(other));
    return [self.desc isEqual:o.desc] && GLuintEq(self.handle, o.handle);
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.desc hash];
    hash = hash * 31 + GLuintHash(self.handle);
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"desc=%@", self.desc];
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGIndexBuffer{
    unsigned int _mode;
}
static ODClassType* _EGIndexBuffer_type;
@synthesize mode = _mode;

+ (id)indexBufferWithHandle:(GLuint)handle mode:(unsigned int)mode {
    return [[EGIndexBuffer alloc] initWithHandle:handle mode:mode];
}

- (id)initWithHandle:(GLuint)handle mode:(unsigned int)mode {
    self = [super initWithDataType:oduInt4Type() bufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle];
    if(self) _mode = mode;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGIndexBuffer_type = [ODClassType classTypeWithCls:[EGIndexBuffer class]];
}

+ (EGIndexBuffer*)apply {
    return [EGIndexBuffer indexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES];
}

- (void)draw {
    [self bind];
    [EGGlobal.context draw];
    glDrawElements(_mode, [self count], GL_UNSIGNED_INT, 0);
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [self bind];
    [EGGlobal.context draw];
    glDrawElements(_mode, count, GL_UNSIGNED_INT, 4 * start);
}

- (void)bind {
    [EGGlobal.context bindIndexBufferHandle:self.handle];
}

- (ODClassType*)type {
    return [EGIndexBuffer type];
}

+ (ODClassType*)type {
    return _EGIndexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGIndexBuffer* o = ((EGIndexBuffer*)(other));
    return GLuintEq(self.handle, o.handle) && self.mode == o.mode;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GLuintHash(self.handle);
    hash = hash * 31 + self.mode;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%@", GLuintDescription(self.handle)];
    [description appendFormat:@", mode=%d", self.mode];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEmptyIndexSource{
    unsigned int _mode;
}
static EGEmptyIndexSource* _EGEmptyIndexSource_triangleStrip;
static EGEmptyIndexSource* _EGEmptyIndexSource_triangles;
static EGEmptyIndexSource* _EGEmptyIndexSource_lines;
static ODClassType* _EGEmptyIndexSource_type;
@synthesize mode = _mode;

+ (id)emptyIndexSourceWithMode:(unsigned int)mode {
    return [[EGEmptyIndexSource alloc] initWithMode:mode];
}

- (id)initWithMode:(unsigned int)mode {
    self = [super init];
    if(self) _mode = mode;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGEmptyIndexSource_type = [ODClassType classTypeWithCls:[EGEmptyIndexSource class]];
    _EGEmptyIndexSource_triangleStrip = [EGEmptyIndexSource emptyIndexSourceWithMode:GL_TRIANGLE_STRIP];
    _EGEmptyIndexSource_triangles = [EGEmptyIndexSource emptyIndexSourceWithMode:GL_TRIANGLES];
    _EGEmptyIndexSource_lines = [EGEmptyIndexSource emptyIndexSourceWithMode:((unsigned int)(GL_LINES))];
}

- (void)draw {
    glDrawArrays(_mode, 0, [[EGGlobal.context vertexSource] count]);
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    glDrawArrays(_mode, start, count);
}

- (ODClassType*)type {
    return [EGEmptyIndexSource type];
}

+ (EGEmptyIndexSource*)triangleStrip {
    return _EGEmptyIndexSource_triangleStrip;
}

+ (EGEmptyIndexSource*)triangles {
    return _EGEmptyIndexSource_triangles;
}

+ (EGEmptyIndexSource*)lines {
    return _EGEmptyIndexSource_lines;
}

+ (ODClassType*)type {
    return _EGEmptyIndexSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGEmptyIndexSource* o = ((EGEmptyIndexSource*)(other));
    return self.mode == o.mode;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + self.mode;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"mode=%d", self.mode];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGArrayIndexSource{
    CNPArray* _array;
    unsigned int _mode;
}
static ODClassType* _EGArrayIndexSource_type;
@synthesize array = _array;
@synthesize mode = _mode;

+ (id)arrayIndexSourceWithArray:(CNPArray*)array mode:(unsigned int)mode {
    return [[EGArrayIndexSource alloc] initWithArray:array mode:mode];
}

- (id)initWithArray:(CNPArray*)array mode:(unsigned int)mode {
    self = [super init];
    if(self) {
        _array = array;
        _mode = mode;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGArrayIndexSource_type = [ODClassType classTypeWithCls:[EGArrayIndexSource class]];
}

- (void)draw {
    [EGGlobal.context bindIndexBufferHandle:0];
    glDrawElements(_mode, _array.count, GL_UNSIGNED_INT, _array.bytes);
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [EGGlobal.context bindIndexBufferHandle:0];
    glDrawElements(_mode, count, GL_UNSIGNED_INT, _array.bytes + 4 * start);
}

- (ODClassType*)type {
    return [EGArrayIndexSource type];
}

+ (ODClassType*)type {
    return _EGArrayIndexSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGArrayIndexSource* o = ((EGArrayIndexSource*)(other));
    return [self.array isEqual:o.array] && self.mode == o.mode;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.array hash];
    hash = hash * 31 + self.mode;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"array=%@", self.array];
    [description appendFormat:@", mode=%d", self.mode];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVoidRefArrayIndexSource{
    CNVoidRefArray _array;
    unsigned int _mode;
}
static ODClassType* _EGVoidRefArrayIndexSource_type;
@synthesize array = _array;
@synthesize mode = _mode;

+ (id)voidRefArrayIndexSourceWithArray:(CNVoidRefArray)array mode:(unsigned int)mode {
    return [[EGVoidRefArrayIndexSource alloc] initWithArray:array mode:mode];
}

- (id)initWithArray:(CNVoidRefArray)array mode:(unsigned int)mode {
    self = [super init];
    if(self) {
        _array = array;
        _mode = mode;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVoidRefArrayIndexSource_type = [ODClassType classTypeWithCls:[EGVoidRefArrayIndexSource class]];
}

- (void)draw {
    [EGGlobal.context bindIndexBufferHandle:0];
    glDrawElements(_mode, _array.length / 4, GL_UNSIGNED_INT, _array.bytes);
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [EGGlobal.context bindIndexBufferHandle:0];
    glDrawElements(_mode, count, GL_UNSIGNED_INT, _array.bytes + 4 * start);
}

- (ODClassType*)type {
    return [EGVoidRefArrayIndexSource type];
}

+ (ODClassType*)type {
    return _EGVoidRefArrayIndexSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGVoidRefArrayIndexSource* o = ((EGVoidRefArrayIndexSource*)(other));
    return CNVoidRefArrayEq(self.array, o.array) && self.mode == o.mode;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + CNVoidRefArrayHash(self.array);
    hash = hash * 31 + self.mode;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"array=%@", CNVoidRefArrayDescription(self.array)];
    [description appendFormat:@", mode=%d", self.mode];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGIndexSourceGap{
    id<EGIndexSource> _source;
    unsigned int _start;
    unsigned int _count;
}
static ODClassType* _EGIndexSourceGap_type;
@synthesize source = _source;
@synthesize start = _start;
@synthesize count = _count;

+ (id)indexSourceGapWithSource:(id<EGIndexSource>)source start:(unsigned int)start count:(unsigned int)count {
    return [[EGIndexSourceGap alloc] initWithSource:source start:start count:count];
}

- (id)initWithSource:(id<EGIndexSource>)source start:(unsigned int)start count:(unsigned int)count {
    self = [super init];
    if(self) {
        _source = source;
        _start = start;
        _count = count;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGIndexSourceGap_type = [ODClassType classTypeWithCls:[EGIndexSourceGap class]];
}

- (void)draw {
    [_source drawWithStart:((NSUInteger)(_start)) count:((NSUInteger)(_count))];
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [_source drawWithStart:((NSUInteger)(_start + start)) count:count];
}

- (ODClassType*)type {
    return [EGIndexSourceGap type];
}

+ (ODClassType*)type {
    return _EGIndexSourceGap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGIndexSourceGap* o = ((EGIndexSourceGap*)(other));
    return [self.source isEqual:o.source] && self.start == o.start && self.count == o.count;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + [self.source hash];
    hash = hash * 31 + self.start;
    hash = hash * 31 + self.count;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"source=%@", self.source];
    [description appendFormat:@", start=%d", self.start];
    [description appendFormat:@", count=%d", self.count];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVertexArray{
    GLuint _handle;
    id<CNSeq> _buffers;
}
static ODClassType* _EGVertexArray_type;
@synthesize handle = _handle;
@synthesize buffers = _buffers;

+ (id)vertexArrayWithHandle:(GLuint)handle buffers:(id<CNSeq>)buffers {
    return [[EGVertexArray alloc] initWithHandle:handle buffers:buffers];
}

- (id)initWithHandle:(GLuint)handle buffers:(id<CNSeq>)buffers {
    self = [super init];
    if(self) {
        _handle = handle;
        _buffers = buffers;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGVertexArray_type = [ODClassType classTypeWithCls:[EGVertexArray class]];
}

+ (EGVertexArray*)applyShader:(EGShader*)shader buffer:(EGVertexBuffer*)buffer {
    GLuint h = egGenVertexArray();
    [EGGlobal.context bindVertexArrayHandle:h];
    [buffer bind];
    [shader loadAttributesVbDesc:buffer.desc];
    [EGGlobal.context bindDefaultVertexArray];
    return [EGVertexArray vertexArrayWithHandle:h buffers:(@[buffer])];
}

- (void)bind {
    [EGGlobal.context bindVertexArrayHandle:_handle];
}

- (void)bindWithShader:(EGShader*)shader {
    [EGGlobal.context bindVertexArrayHandle:_handle];
}

- (void)unbindWithShader:(EGShader*)shader {
    [EGGlobal.context bindDefaultVertexArray];
}

- (void)dealloc {
    egDeleteVertexArray(_handle);
}

- (NSUInteger)count {
    return [((EGVertexBuffer*)([_buffers head])) count];
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
    EGVertexArray* o = ((EGVertexArray*)(other));
    return GLuintEq(self.handle, o.handle) && [self.buffers isEqual:o.buffers];
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GLuintHash(self.handle);
    hash = hash * 31 + [self.buffers hash];
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%@", GLuintDescription(self.handle)];
    [description appendFormat:@", buffers=%@", self.buffers];
    [description appendString:@">"];
    return description;
}

@end


