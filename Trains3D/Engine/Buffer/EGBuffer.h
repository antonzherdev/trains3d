#import "objd.h"
@class EGGlobal;
@class EGContext;

@class EGBuffer;
@class EGMutableBuffer;
@class EGMappedBufferData;
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
    unsigned int _usage;
    NSUInteger __length;
    NSUInteger __count;
    EGMappedBufferData* _mappedData;
}
@property (nonatomic, readonly) unsigned int usage;

+ (instancetype)mutableBufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle usage:(unsigned int)usage;
- (instancetype)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle usage:(unsigned int)usage;
- (ODClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
- (BOOL)isEmpty;
- (id)setData:(CNPArray*)data;
- (id)setArray:(void*)array count:(unsigned int)count;
- (void)writeCount:(unsigned int)count f:(void(^)(void*))f;
- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(void*))f;
- (EGMappedBufferData*)beginWriteCount:(unsigned int)count;
- (EGMappedBufferData*)mapCount:(unsigned int)count access:(unsigned int)access;
- (void)_finishMapping;
+ (ODClassType*)type;
@end


@interface EGMappedBufferData : NSObject {
@protected
    EGMutableBuffer* _buffer;
    void* _pointer;
    NSConditionLock* _lock;
    BOOL _finished;
    BOOL _updated;
}
@property (nonatomic, readonly) EGMutableBuffer* buffer;
@property (nonatomic, readonly) void* pointer;

+ (instancetype)mappedBufferDataWithBuffer:(EGMutableBuffer*)buffer pointer:(void*)pointer;
- (instancetype)initWithBuffer:(EGMutableBuffer*)buffer pointer:(void*)pointer;
- (ODClassType*)type;
- (BOOL)wasUpdated;
- (BOOL)beginWrite;
- (void)endWrite;
- (void)finish;
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


