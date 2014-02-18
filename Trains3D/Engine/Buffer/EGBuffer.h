#import "objd.h"

@class EGBuffer;
@class EGMutableBuffer;
@class EGBufferRing;

@interface EGBuffer : NSObject
@property (nonatomic, readonly) ODPType* dataType;
@property (nonatomic, readonly) unsigned int bufferType;
@property (nonatomic, readonly) unsigned int handle;

+ (id)bufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (id)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
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
+ (id)mutableBufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
- (id)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(unsigned int)handle;
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
+ (ODClassType*)type;
@end


@interface EGBufferRing : NSObject
@property (nonatomic, readonly) unsigned int ringSize;
@property (nonatomic, readonly) id(^creator)();

+ (id)bufferRingWithRingSize:(unsigned int)ringSize creator:(id(^)())creator;
- (id)initWithRingSize:(unsigned int)ringSize creator:(id(^)())creator;
- (ODClassType*)type;
- (id)next;
- (void)writeCount:(unsigned int)count f:(void(^)(CNVoidRefArray))f;
- (void)mapCount:(unsigned int)count access:(unsigned int)access f:(void(^)(CNVoidRefArray))f;
+ (ODClassType*)type;
@end


