#import "EGIndex.h"

#import "EGContext.h"
#import "EGVertex.h"
@implementation EGIndexBuffer{
    unsigned int _mode;
    NSUInteger _length;
    NSUInteger _count;
}
static ODClassType* _EGIndexBuffer_type;
@synthesize mode = _mode;
@synthesize length = _length;
@synthesize count = _count;

+ (id)indexBufferWithHandle:(GLuint)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count {
    return [[EGIndexBuffer alloc] initWithHandle:handle mode:mode length:length count:count];
}

- (id)initWithHandle:(GLuint)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count {
    self = [super initWithDataType:oduInt4Type() bufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle];
    if(self) {
        _mode = mode;
        _length = length;
        _count = count;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGIndexBuffer_type = [ODClassType classTypeWithCls:[EGIndexBuffer class]];
}

+ (EGIndexBuffer*)applyArray:(CNVoidRefArray)array {
    EGIndexBuffer* ib = [EGIndexBuffer indexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES length:array.length count:array.length / 4];
    [ib bind];
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, array.length, array.bytes, GL_STATIC_DRAW);
    return ib;
}

+ (EGIndexBuffer*)applyData:(CNPArray*)data {
    EGIndexBuffer* ib = [EGIndexBuffer indexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES length:data.length count:data.count];
    [ib bind];
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, data.length, data.bytes, GL_STATIC_DRAW);
    return ib;
}

- (void)draw {
    [self bind];
    [EGGlobal.context draw];
    glDrawElements(_mode, _count, GL_UNSIGNED_INT, 0);
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
    return GLuintEq(self.handle, o.handle) && self.mode == o.mode && self.length == o.length && self.count == o.count;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    hash = hash * 31 + GLuintHash(self.handle);
    hash = hash * 31 + self.mode;
    hash = hash * 31 + self.length;
    hash = hash * 31 + self.count;
    return hash;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%@", GLuintDescription(self.handle)];
    [description appendFormat:@", mode=%d", self.mode];
    [description appendFormat:@", length=%li", self.length];
    [description appendFormat:@", count=%li", self.count];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableIndexBuffer{
    GLuint _handle;
    unsigned int _mode;
}
static ODClassType* _EGMutableIndexBuffer_type;
@synthesize handle = _handle;
@synthesize mode = _mode;

+ (id)mutableIndexBufferWithHandle:(GLuint)handle mode:(unsigned int)mode {
    return [[EGMutableIndexBuffer alloc] initWithHandle:handle mode:mode];
}

- (id)initWithHandle:(GLuint)handle mode:(unsigned int)mode {
    self = [super initWithDataType:oduInt4Type() bufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle];
    if(self) {
        _handle = handle;
        _mode = mode;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMutableIndexBuffer_type = [ODClassType classTypeWithCls:[EGMutableIndexBuffer class]];
}

+ (EGMutableIndexBuffer*)apply {
    return [EGMutableIndexBuffer mutableIndexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES];
}

+ (EGMutableIndexBuffer*)applyMode:(unsigned int)mode {
    return [EGMutableIndexBuffer mutableIndexBufferWithHandle:egGenBuffer() mode:mode];
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
    [EGGlobal.context bindIndexBufferHandle:_handle];
}

- (ODClassType*)type {
    return [EGMutableIndexBuffer type];
}

+ (ODClassType*)type {
    return _EGMutableIndexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if(self == other) return YES;
    if(!(other) || !([[self class] isEqual:[other class]])) return NO;
    EGMutableIndexBuffer* o = ((EGMutableIndexBuffer*)(other));
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


