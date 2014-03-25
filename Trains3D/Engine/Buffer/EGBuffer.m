#import "EGBuffer.h"

#import "GL.h"
#import "EGContext.h"
@implementation EGBuffer
static ODClassType* _EGBuffer_type;
@synthesize dataType = _dataType;
@synthesize bufferType = _bufferType;
@synthesize handle = _handle;

+ (instancetype)bufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle {
    return [[EGBuffer alloc] initWithDataType:dataType bufferType:bufferType handle:handle];
}

- (instancetype)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle {
    self = [super init];
    if(self) {
        _dataType = dataType;
        _bufferType = bufferType;
        _handle = handle;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGBuffer class]) _EGBuffer_type = [ODClassType classTypeWithCls:[EGBuffer class]];
}

- (NSUInteger)length {
    @throw @"Method length is abstract";
}

- (NSUInteger)count {
    @throw @"Method count is abstract";
}

+ (EGBuffer*)applyDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType {
    return [EGBuffer bufferWithDataType:dataType bufferType:bufferType handle:egGenBuffer()];
}

- (void)dealloc {
    [EGGlobal.context deleteBufferId:_handle];
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

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"dataType=%@", self.dataType];
    [description appendFormat:@", bufferType=%u", self.bufferType];
    [description appendFormat:@", handle=%u", self.handle];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableBuffer
static ODClassType* _EGMutableBuffer_type;

+ (instancetype)mutableBufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle {
    return [[EGMutableBuffer alloc] initWithDataType:dataType bufferType:bufferType handle:handle];
}

- (instancetype)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle {
    self = [super initWithDataType:dataType bufferType:bufferType handle:handle];
    if(self) {
        __length = 0;
        __count = 0;
        _usage = GL_DYNAMIC_DRAW;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMutableBuffer class]) _EGMutableBuffer_type = [ODClassType classTypeWithCls:[EGMutableBuffer class]];
}

- (NSUInteger)length {
    return __length;
}

- (NSUInteger)count {
    return __count;
}

- (BOOL)isEmpty {
    return __count > 0;
}

- (id)setData:(CNPArray*)data {
    [self bind];
    glBufferData(self.bufferType, ((long)(data.length)), data.bytes, _usage);
    __length = data.length;
    __count = data.count;
    return self;
}

- (id)setArray:(CNVoidRefArray)array {
    [self bind];
    glBufferData(self.bufferType, ((long)(array.length)), array.bytes, _usage);
    __length = array.length;
    __count = array.length / self.dataType.size;
    return self;
}

- (id)setArray:(CNVoidRefArray)array count:(unsigned int)count {
    [self bind];
    __length = ((NSUInteger)(count * self.dataType.size));
    glBufferData(self.bufferType, ((long)(__length)), array.bytes, _usage);
    __count = ((NSUInteger)(count));
    return self;
}

- (id)updateStart:(NSUInteger)start count:(NSUInteger)count array:(CNVoidRefArray)array {
    [self bind];
    glBufferSubData(self.bufferType, ((long)(start * self.dataType.size)), ((long)(count * self.dataType.size)), array.bytes);
    return self;
}

- (void)writeCount:(unsigned int)count f:(void(^)(CNVoidRefArray))f {
    [self mapCount:count access:GL_WRITE_ONLY f:f];
}

- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(CNVoidRefArray))f {
    [self bind];
    __count = ((NSUInteger)(count));
    __length = ((NSUInteger)(count * self.dataType.size));
    glBufferData(self.bufferType, ((long)(__length)), ((VoidRef)(nil)), _usage);
    VoidRef ref = egMapBuffer(self.bufferType, access);
    f((CNVoidRefArrayMake(__length, ref)));
    egUnmapBuffer(self.bufferType);
}

- (CNVoidRefArray)beginWriteCount:(unsigned int)count {
    return [self mapCount:count access:GL_WRITE_ONLY];
}

- (CNVoidRefArray)mapCount:(unsigned int)count access:(unsigned int)access {
    [self bind];
    __count = ((NSUInteger)(count));
    __length = ((NSUInteger)(count * self.dataType.size));
    glBufferData(self.bufferType, ((long)(__length)), ((VoidRef)(nil)), _usage);
    return CNVoidRefArrayMake(__length, (egMapBuffer(self.bufferType, access)));
}

- (void)unmap {
    [self bind];
    egUnmapBuffer(self.bufferType);
}

- (void)endWrite {
    [self bind];
    egUnmapBuffer(self.bufferType);
}

- (ODClassType*)type {
    return [EGMutableBuffer type];
}

+ (ODClassType*)type {
    return _EGMutableBuffer_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"dataType=%@", self.dataType];
    [description appendFormat:@", bufferType=%u", self.bufferType];
    [description appendFormat:@", handle=%u", self.handle];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGBufferRing
static ODClassType* _EGBufferRing_type;
@synthesize ringSize = _ringSize;
@synthesize creator = _creator;

+ (instancetype)bufferRingWithRingSize:(unsigned int)ringSize creator:(id(^)())creator {
    return [[EGBufferRing alloc] initWithRingSize:ringSize creator:creator];
}

- (instancetype)initWithRingSize:(unsigned int)ringSize creator:(id(^)())creator {
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
    if(self == [EGBufferRing class]) _EGBufferRing_type = [ODClassType classTypeWithCls:[EGBufferRing class]];
}

- (id)next {
    id buffer = (([__ring count] >= _ringSize) ? [[__ring dequeue] get] : ((id(^)())(_creator))());
    [__ring enqueueItem:buffer];
    return buffer;
}

- (void)writeCount:(unsigned int)count f:(void(^)(CNVoidRefArray))f {
    [[self next] writeCount:count f:f];
}

- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(CNVoidRefArray))f {
    [[self next] mapCount:count access:access f:f];
}

- (ODClassType*)type {
    return [EGBufferRing type];
}

+ (ODClassType*)type {
    return _EGBufferRing_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"ringSize=%u", self.ringSize];
    [description appendString:@">"];
    return description;
}

@end


