#import "objd.h"
@class EGGlobal;
@class EGContext;

@class EGBuffer;
@class EGMutableBuffer;
@class EGBufferRing;

@interface EGBuffer : NSObject
@property (nonatomic, readonly) ODPType* dataType;
@property (nonatomic, readonly) unsigned int bufferType;
@property (nonatomic, readonly) unsigned int handle;

+ (instancetype)bufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (instancetype)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (ODClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
+ (EGBuffer*)applyDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType;
- (void)dealloc;
- (void)bind;
- (unsigned int)stride;
+ (ODClassType*)type;
@end


@interface EGMutableBuffer : EGBuffer
+ (instancetype)mutableBufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (instancetype)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (ODClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
- (BOOL)isEmpty;
- (id)setData:(CNPArray*)data;
- (id)setArray:(CNVoidRefArray)array;
- (id)setArray:(CNVoidRefArray)array count:(unsigned int)count;
- (id)updateStart:(NSUInteger)start count:(NSUInteger)count array:(CNVoidRefArray)array;
- (void)writeCount:(unsigned int)count f:(void(^)(CNVoidRefArray))f;
- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(CNVoidRefArray))f;
- (CNVoidRefArray)beginWriteCount:(unsigned int)count;
- (CNVoidRefArray)mapCount:(unsigned int)count access:(unsigned int)access;
- (void)unmap;
- (void)endWrite;
+ (ODClassType*)type;
@end


@interface EGBufferRing : NSObject
@property (nonatomic, readonly) unsigned int ringSize;
@property (nonatomic, readonly) id(^creator)();

+ (instancetype)bufferRingWithRingSize:(unsigned int)ringSize creator:(id(^)())creator;
- (instancetype)initWithRingSize:(unsigned int)ringSize creator:(id(^)())creator;
- (ODClassType*)type;
- (id)next;
- (void)writeCount:(unsigned int)count f:(void(^)(CNVoidRefArray))f;
- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(CNVoidRefArray))f;
+ (ODClassType*)type;
@end


