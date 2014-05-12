#import "EGBuffer.h"

#import "EGContext.h"
#import "GL.h"
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
@synthesize usage = _usage;

+ (instancetype)mutableBufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle usage:(unsigned int)usage {
    return [[EGMutableBuffer alloc] initWithDataType:dataType bufferType:bufferType handle:handle usage:usage];
}

- (instancetype)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle usage:(unsigned int)usage {
    self = [super initWithDataType:dataType bufferType:bufferType handle:handle];
    if(self) {
        _usage = usage;
        __length = 0;
        __count = 0;
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
    egCheckError();
    __length = data.length;
    __count = data.count;
    return self;
}

- (id)setArray:(void*)array count:(unsigned int)count {
    [self bind];
    __length = ((NSUInteger)(count * self.dataType.size));
    glBufferData(self.bufferType, ((long)(__length)), array, _usage);
    egCheckError();
    __count = ((NSUInteger)(count));
    return self;
}

- (void)writeCount:(unsigned int)count f:(void(^)(void*))f {
    [self mapCount:count access:GL_WRITE_ONLY f:f];
}

- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(void*))f {
    if(_mappedData != nil) return ;
    [self bind];
    __count = ((NSUInteger)(count));
    __length = ((NSUInteger)(count * self.dataType.size));
    glBufferData(self.bufferType, ((long)(__length)), NULL, _usage);
    {
        void* _ = egMapBuffer(self.bufferType, access);
        if(_ != nil) f;
    }
    egUnmapBuffer(self.bufferType);
    egCheckError();
}

- (EGMappedBufferData*)beginWriteCount:(unsigned int)count {
    return [self mapCount:count access:GL_WRITE_ONLY];
}

- (EGMappedBufferData*)mapCount:(unsigned int)count access:(unsigned int)access {
    if(_mappedData != nil) return nil;
    [self bind];
    __count = ((NSUInteger)(count));
    __length = ((NSUInteger)(count * self.dataType.size));
    glBufferData(self.bufferType, ((long)(__length)), NULL, _usage);
    {
        void* _ = egMapBuffer(self.bufferType, access);
        if(_ != nil) _mappedData = [EGMappedBufferData mappedBufferDataWithBuffer:self pointer:_];
        else _mappedData = nil;
    }
    egCheckError();
    return _mappedData;
}

- (void)_finishMapping {
    [self bind];
    egUnmapBuffer(self.bufferType);
    egCheckError();
    _mappedData = nil;
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
    [description appendFormat:@", usage=%u", self.usage];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMappedBufferData
static ODClassType* _EGMappedBufferData_type;
@synthesize buffer = _buffer;
@synthesize pointer = _pointer;

+ (instancetype)mappedBufferDataWithBuffer:(EGMutableBuffer*)buffer pointer:(void*)pointer {
    return [[EGMappedBufferData alloc] initWithBuffer:buffer pointer:pointer];
}

- (instancetype)initWithBuffer:(EGMutableBuffer*)buffer pointer:(void*)pointer {
    self = [super init];
    if(self) {
        _buffer = buffer;
        _pointer = pointer;
        _lock = [NSConditionLock conditionLockWithCondition:0];
        _finished = NO;
        _updated = NO;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    if(self == [EGMappedBufferData class]) _EGMappedBufferData_type = [ODClassType classTypeWithCls:[EGMappedBufferData class]];
}

- (BOOL)wasUpdated {
    return _updated;
}

- (BOOL)beginWrite {
    if(_finished) {
        return NO;
    } else {
        [_lock lock];
        if(_finished) {
            [_lock unlock];
            return NO;
        } else {
            return YES;
        }
    }
}

- (void)endWrite {
    _updated = YES;
    [_lock unlockWithCondition:1];
}

- (void)finish {
    [_lock lockWhenCondition:1];
    [_buffer _finishMapping];
    _finished = YES;
    [_lock unlock];
}

- (ODClassType*)type {
    return [EGMappedBufferData type];
}

+ (ODClassType*)type {
    return _EGMappedBufferData_type;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSMutableString* description = [NSMutableString stringWithFormat:@"<%@: ", NSStringFromClass([self class])];
    [description appendFormat:@"buffer=%@", self.buffer];
    [description appendFormat:@", pointer=%p", self.pointer];
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
    id buffer = (([__ring count] >= _ringSize) ? ((id)([__ring dequeue])) : _creator());
    [__ring enqueueItem:buffer];
    return buffer;
}

- (void)writeCount:(unsigned int)count f:(void(^)(void*))f {
    [[self next] writeCount:count f:f];
}

- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(void*))f {
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


