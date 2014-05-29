#import "EGIndex.h"

#import "GL.h"
#import "EGContext.h"
@implementation EGIndexSource_impl

+ (instancetype)indexSource_impl {
    return [[EGIndexSource_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)bind {
}

- (void)draw {
    @throw @"Method draw is abstract";
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    @throw @"Method drawWith is abstract";
}

- (BOOL)isMutable {
    return NO;
}

- (BOOL)isEmpty {
    return NO;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGIBO
static CNClassType* _EGIBO_type;

+ (void)initialize {
    [super initialize];
    if(self == [EGIBO class]) _EGIBO_type = [CNClassType classTypeWithCls:[EGIBO class]];
}

+ (EGImmutableIndexBuffer*)applyPointer:(unsigned int*)pointer count:(unsigned int)count {
    EGImmutableIndexBuffer* ib = [EGImmutableIndexBuffer immutableIndexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES length:((NSUInteger)(count * 4)) count:((NSUInteger)(count))];
    [ib bind];
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, ((long)(count * 4)), pointer, GL_STATIC_DRAW);
    return ib;
}

+ (EGImmutableIndexBuffer*)applyData:(CNPArray*)data {
    EGImmutableIndexBuffer* ib = [EGImmutableIndexBuffer immutableIndexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES length:data.length count:data.count];
    [ib bind];
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, ((long)(data.length)), data.bytes, GL_STATIC_DRAW);
    return ib;
}

+ (EGMutableIndexBuffer*)mutMode:(unsigned int)mode usage:(unsigned int)usage {
    return [EGMutableIndexBuffer mutableIndexBufferWithHandle:egGenBuffer() mode:mode usage:usage];
}

+ (EGMutableIndexBuffer*)mutUsage:(unsigned int)usage {
    return [EGIBO mutMode:GL_TRIANGLES usage:usage];
}

- (CNClassType*)type {
    return [EGIBO type];
}

+ (CNClassType*)type {
    return _EGIBO_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGIndexBuffer_impl

+ (instancetype)indexBuffer_impl {
    return [[EGIndexBuffer_impl alloc] init];
}

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)draw {
    [EGGlobal.context draw];
    NSUInteger n = [self count];
    if(n > 0) glDrawElements([self mode], ((int)(n)), GL_UNSIGNED_INT, NULL);
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [EGGlobal.context draw];
    if(count > 0) glDrawElements([self mode], ((int)(count)), GL_UNSIGNED_INT, ((unsigned int*)(4 * start)));
    egCheckError();
}

- (unsigned int)handle {
    @throw @"Method handle is abstract";
}

- (unsigned int)mode {
    @throw @"Method mode is abstract";
}

- (NSUInteger)count {
    @throw @"Method count is abstract";
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGImmutableIndexBuffer
static CNClassType* _EGImmutableIndexBuffer_type;
@synthesize mode = _mode;
@synthesize length = _length;
@synthesize count = _count;

+ (instancetype)immutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count {
    return [[EGImmutableIndexBuffer alloc] initWithHandle:handle mode:mode length:length count:count];
}

- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count {
    self = [super initWithDataType:cnuInt4Type() bufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle];
    if(self) {
        _mode = mode;
        _length = length;
        _count = count;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGImmutableIndexBuffer class]) _EGImmutableIndexBuffer_type = [CNClassType classTypeWithCls:[EGImmutableIndexBuffer class]];
}

- (void)bind {
    [EGGlobal.context bindIndexBufferHandle:self.handle];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ImmutableIndexBuffer(%u, %lu, %lu)", _mode, (unsigned long)_length, (unsigned long)_count];
}

- (void)draw {
    [EGGlobal.context draw];
    NSUInteger n = [self count];
    if(n > 0) glDrawElements([self mode], ((int)(n)), GL_UNSIGNED_INT, NULL);
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [EGGlobal.context draw];
    if(count > 0) glDrawElements([self mode], ((int)(count)), GL_UNSIGNED_INT, ((unsigned int*)(4 * start)));
    egCheckError();
}

- (BOOL)isMutable {
    return NO;
}

- (BOOL)isEmpty {
    return NO;
}

- (CNClassType*)type {
    return [EGImmutableIndexBuffer type];
}

+ (CNClassType*)type {
    return _EGImmutableIndexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMutableIndexBuffer
static CNClassType* _EGMutableIndexBuffer_type;
@synthesize mode = _mode;

+ (instancetype)mutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode usage:(unsigned int)usage {
    return [[EGMutableIndexBuffer alloc] initWithHandle:handle mode:mode usage:usage];
}

- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode usage:(unsigned int)usage {
    self = [super initWithDataType:cnuInt4Type() bufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle usage:usage];
    if(self) _mode = mode;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMutableIndexBuffer class]) _EGMutableIndexBuffer_type = [CNClassType classTypeWithCls:[EGMutableIndexBuffer class]];
}

- (BOOL)isMutable {
    return YES;
}

- (void)bind {
    [EGGlobal.context bindIndexBufferHandle:self.handle];
}

- (BOOL)isEmpty {
    return NO;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MutableIndexBuffer(%u)", _mode];
}

- (void)draw {
    [EGGlobal.context draw];
    NSUInteger n = [self count];
    if(n > 0) glDrawElements([self mode], ((int)(n)), GL_UNSIGNED_INT, NULL);
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [EGGlobal.context draw];
    if(count > 0) glDrawElements([self mode], ((int)(count)), GL_UNSIGNED_INT, ((unsigned int*)(4 * start)));
    egCheckError();
}

- (CNClassType*)type {
    return [EGMutableIndexBuffer type];
}

+ (CNClassType*)type {
    return _EGMutableIndexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGIndexBufferRing
static CNClassType* _EGIndexBufferRing_type;
@synthesize mode = _mode;
@synthesize usage = _usage;

+ (instancetype)indexBufferRingWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode usage:(unsigned int)usage {
    return [[EGIndexBufferRing alloc] initWithRingSize:ringSize mode:mode usage:usage];
}

- (instancetype)initWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode usage:(unsigned int)usage {
    self = [super initWithRingSize:ringSize creator:^EGMutableIndexBuffer*() {
        return [EGMutableIndexBuffer mutableIndexBufferWithHandle:egGenBuffer() mode:mode usage:usage];
    }];
    if(self) {
        _mode = mode;
        _usage = usage;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGIndexBufferRing class]) _EGIndexBufferRing_type = [CNClassType classTypeWithCls:[EGIndexBufferRing class]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"IndexBufferRing(%u, %u)", _mode, _usage];
}

- (CNClassType*)type {
    return [EGIndexBufferRing type];
}

+ (CNClassType*)type {
    return _EGIndexBufferRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGEmptyIndexSource
static EGEmptyIndexSource* _EGEmptyIndexSource_triangleStrip;
static EGEmptyIndexSource* _EGEmptyIndexSource_triangleFan;
static EGEmptyIndexSource* _EGEmptyIndexSource_triangles;
static EGEmptyIndexSource* _EGEmptyIndexSource_lines;
static CNClassType* _EGEmptyIndexSource_type;
@synthesize mode = _mode;

+ (instancetype)emptyIndexSourceWithMode:(unsigned int)mode {
    return [[EGEmptyIndexSource alloc] initWithMode:mode];
}

- (instancetype)initWithMode:(unsigned int)mode {
    self = [super init];
    if(self) _mode = mode;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGEmptyIndexSource class]) {
        _EGEmptyIndexSource_type = [CNClassType classTypeWithCls:[EGEmptyIndexSource class]];
        _EGEmptyIndexSource_triangleStrip = [EGEmptyIndexSource emptyIndexSourceWithMode:GL_TRIANGLE_STRIP];
        _EGEmptyIndexSource_triangleFan = [EGEmptyIndexSource emptyIndexSourceWithMode:GL_TRIANGLE_FAN];
        _EGEmptyIndexSource_triangles = [EGEmptyIndexSource emptyIndexSourceWithMode:GL_TRIANGLES];
        _EGEmptyIndexSource_lines = [EGEmptyIndexSource emptyIndexSourceWithMode:GL_LINES];
    }
}

- (void)draw {
    [EGGlobal.context draw];
    glDrawArrays(_mode, 0, ((int)([EGGlobal.context vertexBufferCount])));
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [EGGlobal.context draw];
    if(count > 0) glDrawArrays(_mode, ((int)(start)), ((int)(count)));
    egCheckError();
}

- (NSString*)description {
    return [NSString stringWithFormat:@"EmptyIndexSource(%u)", _mode];
}

- (CNClassType*)type {
    return [EGEmptyIndexSource type];
}

+ (EGEmptyIndexSource*)triangleStrip {
    return _EGEmptyIndexSource_triangleStrip;
}

+ (EGEmptyIndexSource*)triangleFan {
    return _EGEmptyIndexSource_triangleFan;
}

+ (EGEmptyIndexSource*)triangles {
    return _EGEmptyIndexSource_triangles;
}

+ (EGEmptyIndexSource*)lines {
    return _EGEmptyIndexSource_lines;
}

+ (CNClassType*)type {
    return _EGEmptyIndexSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGArrayIndexSource
static CNClassType* _EGArrayIndexSource_type;
@synthesize array = _array;
@synthesize mode = _mode;

+ (instancetype)arrayIndexSourceWithArray:(CNPArray*)array mode:(unsigned int)mode {
    return [[EGArrayIndexSource alloc] initWithArray:array mode:mode];
}

- (instancetype)initWithArray:(CNPArray*)array mode:(unsigned int)mode {
    self = [super init];
    if(self) {
        _array = array;
        _mode = mode;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGArrayIndexSource class]) _EGArrayIndexSource_type = [CNClassType classTypeWithCls:[EGArrayIndexSource class]];
}

- (void)draw {
    [EGGlobal.context bindIndexBufferHandle:0];
    NSUInteger n = _array.count;
    if(n > 0) glDrawElements(_mode, ((int)(n)), GL_UNSIGNED_INT, _array.bytes);
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [EGGlobal.context bindIndexBufferHandle:0];
    if(count > 0) glDrawElements(_mode, ((int)(count)), GL_UNSIGNED_INT, _array.bytes + 4 * start);
    egCheckError();
}

- (NSString*)description {
    return [NSString stringWithFormat:@"ArrayIndexSource(%@, %u)", _array, _mode];
}

- (CNClassType*)type {
    return [EGArrayIndexSource type];
}

+ (CNClassType*)type {
    return _EGArrayIndexSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGIndexSourceGap
static CNClassType* _EGIndexSourceGap_type;
@synthesize source = _source;
@synthesize start = _start;
@synthesize count = _count;

+ (instancetype)indexSourceGapWithSource:(id<EGIndexSource>)source start:(unsigned int)start count:(unsigned int)count {
    return [[EGIndexSourceGap alloc] initWithSource:source start:start count:count];
}

- (instancetype)initWithSource:(id<EGIndexSource>)source start:(unsigned int)start count:(unsigned int)count {
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
    if(self == [EGIndexSourceGap class]) _EGIndexSourceGap_type = [CNClassType classTypeWithCls:[EGIndexSourceGap class]];
}

- (void)bind {
    [_source bind];
}

- (void)draw {
    if(_count > 0) [_source drawWithStart:((NSUInteger)(_start)) count:((NSUInteger)(_count))];
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    if(count > 0) [_source drawWithStart:((NSUInteger)(_start + start)) count:count];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"IndexSourceGap(%@, %u, %u)", _source, _start, _count];
}

- (CNClassType*)type {
    return [EGIndexSourceGap type];
}

+ (CNClassType*)type {
    return _EGIndexSourceGap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

@implementation EGMutableIndexSourceGap
static CNClassType* _EGMutableIndexSourceGap_type;
@synthesize source = _source;
@synthesize start = _start;
@synthesize count = _count;

+ (instancetype)mutableIndexSourceGapWithSource:(id<EGIndexSource>)source {
    return [[EGMutableIndexSourceGap alloc] initWithSource:source];
}

- (instancetype)initWithSource:(id<EGIndexSource>)source {
    self = [super init];
    if(self) {
        _source = source;
        _start = 0;
        _count = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMutableIndexSourceGap class]) _EGMutableIndexSourceGap_type = [CNClassType classTypeWithCls:[EGMutableIndexSourceGap class]];
}

- (void)bind {
    [_source bind];
}

- (void)draw {
    if(_count > 0) [_source drawWithStart:((NSUInteger)(_start)) count:((NSUInteger)(_count))];
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    if(count > 0) [_source drawWithStart:((NSUInteger)(_start + start)) count:count];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"MutableIndexSourceGap(%@)", _source];
}

- (CNClassType*)type {
    return [EGMutableIndexSourceGap type];
}

+ (CNClassType*)type {
    return _EGMutableIndexSourceGap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

@end

