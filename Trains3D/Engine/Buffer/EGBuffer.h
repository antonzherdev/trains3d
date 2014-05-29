#import "objd.h"
@class EGGlobal;
@class EGContext;
@class NSConditionLock;

@class EGBuffer;
@class EGMutableBuffer;
@class EGMappedBufferData;
@class EGBufferRing;

@interface EGBuffer : NSObject {
@protected
    CNPType* _dataType;
    unsigned int _bufferType;
    unsigned int _handle;
}
@property (nonatomic, readonly) CNPType* dataType;
@property (nonatomic, readonly) unsigned int bufferType;
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)bufferWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (instancetype)initWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (CNClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
- (void)dealloc;
- (void)bind;
- (unsigned int)stride;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGMutableBuffer : EGBuffer {
@protected
    unsigned int _usage;
    NSUInteger __length;
    NSUInteger __count;
    EGMappedBufferData* _mappedData;
}
@property (nonatomic, readonly) unsigned int usage;

+ (instancetype)mutableBufferWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle usage:(unsigned int)usage;
- (instancetype)initWithDataType:(CNPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle usage:(unsigned int)usage;
- (CNClassType*)type;
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
- (NSString*)description;
+ (CNClassType*)type;
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
- (CNClassType*)type;
- (BOOL)wasUpdated;
- (BOOL)beginWrite;
- (void)endWrite;
- (void)finish;
- (NSString*)description;
+ (CNClassType*)type;
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
- (CNClassType*)type;
- (id)next;
- (void)writeCount:(unsigned int)count f:(void(^)(void*))f;
- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(void*))f;
- (NSString*)description;
+ (CNClassType*)type;
@end


