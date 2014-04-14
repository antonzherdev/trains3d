#import "objd.h"
@class EGGlobal;
@class EGContext;

@class EGBuffer;
@class EGMutableBuffer;
@class EGBufferRing;

@interface EGBuffer : NSObject {
@protected
    ODPType* _dataType;
    unsigned int _bufferType;
    unsigned int _handle;
}
@property (nonatomic, readonly) ODPType* dataType;
@property (nonatomic, readonly) unsigned int bufferType;
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)bufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (instancetype)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (ODClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
- (void)dealloc;
- (void)bind;
- (unsigned int)stride;
+ (ODClassType*)type;
@end


@interface EGMutableBuffer : EGBuffer {
@protected
    NSUInteger __length;
    NSUInteger __count;
    unsigned int _usage;
}
+ (instancetype)mutableBufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (instancetype)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (ODClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
- (BOOL)isEmpty;
- (id)setData:(CNPArray*)data;
- (id)setArray:(void*)array count:(unsigned int)count;
- (void)writeCount:(unsigned int)count f:(void(^)(void*))f;
- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(void*))f;
- (void*)beginWriteCount:(unsigned int)count;
- (void*)mapCount:(unsigned int)count access:(unsigned int)access;
- (void)unmap;
- (void)endWrite;
+ (ODClassType*)type;
@end


@interface EGBufferRing : NSObject {
@protected
    unsigned int _ringSize;
    id(^_creator)();
    CNMQueue* __ring;
}
@property (nonatomic, readonly) unsigned int ringSize;
@property (nonatomic, readonly) id(^creator)();

+ (instancetype)bufferRingWithRingSize:(unsigned int)ringSize creator:(id(^)())creator;
- (instancetype)initWithRingSize:(unsigned int)ringSize creator:(id(^)())creator;
- (ODClassType*)type;
- (id)next;
- (void)writeCount:(unsigned int)count f:(void(^)(void*))f;
- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(void*))f;
+ (ODClassType*)type;
@end


