#import "EGIndex.h"

#import "GL.h"
#import "EGContext.h"
@implementation EGIBO
static ODClassType* _EGIBO_type;

+ (void)initialize {
    [super initialize];
    if(self == [EGIBO class]) _EGIBO_type = [ODClassType classTypeWithCls:[EGIBO class]];
}

+ (EGImmutableIndexBuffer*)applyArray:(CNVoidRefArray)array {
    EGImmutableIndexBuffer* ib = [EGImmutableIndexBuffer immutableIndexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES length:array.length count:array.length / 4];
    [ib bind];
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, ((long)(array.length)), array.bytes, GL_STATIC_DRAW);
    return ib;
}

+ (EGImmutableIndexBuffer*)applyData:(CNPArray*)data {
    EGImmutableIndexBuffer* ib = [EGImmutableIndexBuffer immutableIndexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES length:data.length count:data.count];
    [ib bind];
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, ((long)(data.length)), data.bytes, GL_STATIC_DRAW);
    return ib;
}

+ (EGMutableIndexBuffer*)mut {
    return [EGMutableIndexBuffer mutableIndexBufferWithHandle:egGenBuffer() mode:GL_TRIANGLES];
}

+ (EGMutableIndexBuffer*)mutMode:(unsigned int)mode {
    return [EGMutableIndexBuffer mutableIndexBufferWithHandle:egGenBuffer() mode:mode];
}

- (ODClassType*)type {
    return [EGIBO type];
}

+ (ODClassType*)type {
    return _EGIBO_type;
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


@implementation EGImmutableIndexBuffer
static ODClassType* _EGImmutableIndexBuffer_type;
@synthesize mode = _mode;
@synthesize length = _length;
@synthesize count = _count;

+ (instancetype)immutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count {
    return [[EGImmutableIndexBuffer alloc] initWithHandle:handle mode:mode length:length count:count];
}

- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count {
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
    if(self == [EGImmutableIndexBuffer class]) _EGImmutableIndexBuffer_type = [ODClassType classTypeWithCls:[EGImmutableIndexBuffer class]];
}

- (void)bind {
    [EGGlobal.context bindIndexBufferHandle:self.handle];
}

- (void)draw {
    [EGGlobal.context draw];
    NSUInteger n = [self count];
    if(n > 0) glDrawElements([self mode], ((int)(n)), GL_UNSIGNED_INT, cnVoidRefApplyI(0));
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [EGGlobal.context draw];
    if(count > 0) glDrawElements([self mode], ((int)(count)), GL_UNSIGNED_INT, cnVoidRefApplyI(4 * start));
    egCheckError();
}

- (BOOL)isMutable {
    return NO;
}

- (BOOL)isEmpty {
    return NO;
}

- (ODClassType*)type {
    return [EGImmutableIndexBuffer type];
}

+ (ODClassType*)type {
    return _EGImmutableIndexBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%u", self.handle];
    [description appendFormat:@", mode=%u", self.mode];
    [description appendFormat:@", length=%lu", (unsigned long)self.length];
    [description appendFormat:@", count=%lu", (unsigned long)self.count];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableIndexBuffer
static ODClassType* _EGMutableIndexBuffer_type;
@synthesize mode = _mode;

+ (instancetype)mutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode {
    return [[EGMutableIndexBuffer alloc] initWithHandle:handle mode:mode];
}

- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode {
    self = [super initWithDataType:oduInt4Type() bufferType:GL_ELEMENT_ARRAY_BUFFER handle:handle];
    if(self) _mode = mode;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMutableIndexBuffer class]) _EGMutableIndexBuffer_type = [ODClassType classTypeWithCls:[EGMutableIndexBuffer class]];
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

- (void)draw {
    [EGGlobal.context draw];
    NSUInteger n = [self count];
    if(n > 0) glDrawElements([self mode], ((int)(n)), GL_UNSIGNED_INT, cnVoidRefApplyI(0));
    egCheckError();
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [EGGlobal.context draw];
    if(count > 0) glDrawElements([self mode], ((int)(count)), GL_UNSIGNED_INT, cnVoidRefApplyI(4 * start));
    egCheckError();
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"handle=%u", self.handle];
    [description appendFormat:@", mode=%u", self.mode];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGIndexBufferRing
static ODClassType* _EGIndexBufferRing_type;
@synthesize mode = _mode;

+ (instancetype)indexBufferRingWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode {
    return [[EGIndexBufferRing alloc] initWithRingSize:ringSize mode:mode];
}

- (instancetype)initWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode {
    self = [super initWithRingSize:ringSize creator:^EGMutableIndexBuffer*() {
        return [EGMutableIndexBuffer mutableIndexBufferWithHandle:egGenBuffer() mode:mode];
    }];
    if(self) _mode = mode;
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGIndexBufferRing class]) _EGIndexBufferRing_type = [ODClassType classTypeWithCls:[EGIndexBufferRing class]];
}

- (ODClassType*)type {
    return [EGIndexBufferRing type];
}

+ (ODClassType*)type {
    return _EGIndexBufferRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"ringSize=%u", self.ringSize];
    [description appendFormat:@", mode=%u", self.mode];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGEmptyIndexSource
static EGEmptyIndexSource* _EGEmptyIndexSource_triangleStrip;
static EGEmptyIndexSource* _EGEmptyIndexSource_triangleFan;
static EGEmptyIndexSource* _EGEmptyIndexSource_triangles;
static EGEmptyIndexSource* _EGEmptyIndexSource_lines;
static ODClassType* _EGEmptyIndexSource_type;
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
        _EGEmptyIndexSource_type = [ODClassType classTypeWithCls:[EGEmptyIndexSource class]];
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

- (void)bind {
}

- (BOOL)isMutable {
    return NO;
}

- (BOOL)isEmpty {
    return NO;
}

- (ODClassType*)type {
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

+ (ODClassType*)type {
    return _EGEmptyIndexSource_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"mode=%u", self.mode];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGArrayIndexSource
static ODClassType* _EGArrayIndexSource_type;
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
    if(self == [EGArrayIndexSource class]) _EGArrayIndexSource_type = [ODClassType classTypeWithCls:[EGArrayIndexSource class]];
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

- (void)bind {
}

- (BOOL)isMutable {
    return NO;
}

- (BOOL)isEmpty {
    return NO;
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"array=%@", self.array];
    [description appendFormat:@", mode=%u", self.mode];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGVoidRefArrayIndexSource
static ODClassType* _EGVoidRefArrayIndexSource_type;
@synthesize array = _array;
@synthesize mode = _mode;

+ (instancetype)voidRefArrayIndexSourceWithArray:(CNVoidRefArray)array mode:(unsigned int)mode {
    return [[EGVoidRefArrayIndexSource alloc] initWithArray:array mode:mode];
}

- (instancetype)initWithArray:(CNVoidRefArray)array mode:(unsigned int)mode {
    self = [super init];
    if(self) {
        _array = array;
        _mode = mode;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGVoidRefArrayIndexSource class]) _EGVoidRefArrayIndexSource_type = [ODClassType classTypeWithCls:[EGVoidRefArrayIndexSource class]];
}

- (void)bind {
    [EGGlobal.context bindIndexBufferHandle:0];
}

- (void)draw {
    [EGGlobal.context draw];
    NSUInteger n = _array.length / 4;
    if(n > 0) glDrawElements(_mode, ((int)(n)), GL_UNSIGNED_INT, _array.bytes);
}

- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count {
    [EGGlobal.context draw];
    if(count > 0) glDrawElements(_mode, ((int)(count)), GL_UNSIGNED_INT, _array.bytes + 4 * start);
    egCheckError();
}

- (BOOL)isMutable {
    return NO;
}

- (BOOL)isEmpty {
    return NO;
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"array=%@", CNVoidRefArrayDescription(self.array)];
    [description appendFormat:@", mode=%u", self.mode];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGIndexSourceGap
static ODClassType* _EGIndexSourceGap_type;
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
    if(self == [EGIndexSourceGap class]) _EGIndexSourceGap_type = [ODClassType classTypeWithCls:[EGIndexSourceGap class]];
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

- (BOOL)isMutable {
    return NO;
}

- (BOOL)isEmpty {
    return NO;
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"source=%@", self.source];
    [description appendFormat:@", start=%u", self.start];
    [description appendFormat:@", count=%u", self.count];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableIndexSourceGap
static ODClassType* _EGMutableIndexSourceGap_type;
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
    if(self == [EGMutableIndexSourceGap class]) _EGMutableIndexSourceGap_type = [ODClassType classTypeWithCls:[EGMutableIndexSourceGap class]];
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

- (BOOL)isMutable {
    return NO;
}

- (BOOL)isEmpty {
    return NO;
}

- (ODClassType*)type {
    return [EGMutableIndexSourceGap type];
}

+ (ODClassType*)type {
    return _EGMutableIndexSourceGap_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"source=%@", self.source];
    [description appendString:@">"];
    return description;
}

@end


