#import "EGBuffer.h"

@implementation EGBuffer{
    ODPType* _dataType;
    unsigned int _bufferType;
    GLuint _handle;
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
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGBuffer_type = [ODClassType classTypeWithCls:[EGBuffer class]];
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

- (void)dealoc {
    egDeleteBuffer(_handle);
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
    [description appendFormat:@", bufferType=%u", self.bufferType];
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


@implementation EGMutableBuffer{
    NSUInteger __length;
    NSUInteger __count;
}
static ODClassType* _EGMutableBuffer_type;

+ (id)mutableBufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(GLuint)handle {
    return [[EGMutableBuffer alloc] initWithDataType:dataType bufferType:bufferType handle:handle];
}

- (id)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(GLuint)handle {
    self = [super initWithDataType:dataType bufferType:bufferType handle:handle];
    if(self) {
        __length = 0;
        __count = 0;
    }
    
    return self;
}

+ (void)initialize {
    [super initialize];
    _EGMutableBuffer_type = [ODClassType classTypeWithCls:[EGMutableBuffer class]];
}

- (NSUInteger)length {
    return __length;
}

- (NSUInteger)count {
    return __count;
}

- (id)setData:(CNPArray*)data {
    [self bind];
    glBufferData(self.bufferType, data.length, data.bytes, GL_DYNAMIC_DRAW);
    __length = data.length;
    __count = data.count;
    return self;
}

- (id)setArray:(CNVoidRefArray)array {
    [self bind];
    glBufferData(self.bufferType, array.length, array.bytes, GL_DYNAMIC_DRAW);
    __length = array.length;
    __count = array.length / self.dataType.size;
    return self;
}

- (id)setArray:(CNVoidRefArray)array count:(unsigned int)count {
    [self bind];
    __length = ((NSUInteger)(count * self.dataType.size));
    glBufferData(self.bufferType, __length, array.bytes, GL_DYNAMIC_DRAW);
    __count = ((NSUInteger)(count));
    return self;
}

- (id)updateStart:(NSUInteger)start count:(NSUInteger)count array:(CNVoidRefArray)array {
    [self bind];
    glBufferSubData(self.bufferType, start * self.dataType.size, count * self.dataType.size, array.bytes);
    return self;
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
    [description appendFormat:@", handle=%@", GLuintDescription(self.handle)];
    [description appendString:@">"];
    return description;
}

@end


