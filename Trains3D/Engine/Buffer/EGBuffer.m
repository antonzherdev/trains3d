#import "EGBuffer.h"

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


