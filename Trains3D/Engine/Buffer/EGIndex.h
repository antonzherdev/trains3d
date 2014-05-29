#import "objd.h"
#import "EGBuffer.h"
@class EGGlobal;
@class EGContext;

@class EGIndexSource_impl;
@class EGIBO;
@class EGIndexBuffer_impl;
@class EGImmutableIndexBuffer;
@class EGMutableIndexBuffer;
@class EGIndexBufferRing;
@class EGEmptyIndexSource;
@class EGArrayIndexSource;
@class EGIndexSourceGap;
@class EGMutableIndexSourceGap;
@protocol EGIndexSource;
@protocol EGIndexBuffer;

@protocol EGIndexSource<NSObject>
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (BOOL)isMutable;
- (BOOL)isEmpty;
- (NSString*)description;
@end


@interface EGIndexSource_impl : NSObject<EGIndexSource>
+ (instancetype)indexSource_impl;
- (instancetype)init;
@end


@interface EGIBO : NSObject
- (CNClassType*)type;
+ (EGImmutableIndexBuffer*)applyPointer:(unsigned int*)pointer count:(unsigned int)count;
+ (EGImmutableIndexBuffer*)applyData:(CNPArray*)data;
+ (EGMutableIndexBuffer*)mutMode:(unsigned int)mode usage:(unsigned int)usage;
+ (EGMutableIndexBuffer*)mutUsage:(unsigned int)usage;
+ (CNClassType*)type;
@end


@protocol EGIndexBuffer<EGIndexSource>
- (unsigned int)handle;
- (unsigned int)mode;
- (NSUInteger)count;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (NSString*)description;
@end


@interface EGIndexBuffer_impl : EGIndexSource_impl<EGIndexBuffer>
+ (instancetype)indexBuffer_impl;
- (instancetype)init;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
@end


@interface EGImmutableIndexBuffer : EGBuffer<EGIndexBuffer> {
@protected
    unsigned int _mode;
    NSUInteger _length;
    NSUInteger _count;
}
@property (nonatomic, readonly) unsigned int mode;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger count;

+ (instancetype)immutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count;
- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count;
- (CNClassType*)type;
- (void)bind;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGMutableIndexBuffer : EGMutableBuffer<EGIndexBuffer> {
@protected
    unsigned int _mode;
}
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)mutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode usage:(unsigned int)usage;
- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode usage:(unsigned int)usage;
- (CNClassType*)type;
- (BOOL)isMutable;
- (void)bind;
- (BOOL)isEmpty;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGIndexBufferRing : EGBufferRing {
@protected
    unsigned int _mode;
    unsigned int _usage;
}
@property (nonatomic, readonly) unsigned int mode;
@property (nonatomic, readonly) unsigned int usage;

+ (instancetype)indexBufferRingWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode usage:(unsigned int)usage;
- (instancetype)initWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode usage:(unsigned int)usage;
- (CNClassType*)type;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGEmptyIndexSource : EGIndexSource_impl {
@protected
    unsigned int _mode;
}
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)emptyIndexSourceWithMode:(unsigned int)mode;
- (instancetype)initWithMode:(unsigned int)mode;
- (CNClassType*)type;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (NSString*)description;
+ (EGEmptyIndexSource*)triangleStrip;
+ (EGEmptyIndexSource*)triangleFan;
+ (EGEmptyIndexSource*)triangles;
+ (EGEmptyIndexSource*)lines;
+ (CNClassType*)type;
@end


@interface EGArrayIndexSource : EGIndexSource_impl {
@protected
    CNPArray* _array;
    unsigned int _mode;
}
@property (nonatomic, readonly) CNPArray* array;
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)arrayIndexSourceWithArray:(CNPArray*)array mode:(unsigned int)mode;
- (instancetype)initWithArray:(CNPArray*)array mode:(unsigned int)mode;
- (CNClassType*)type;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGIndexSourceGap : EGIndexSource_impl {
@protected
    id<EGIndexSource> _source;
    unsigned int _start;
    unsigned int _count;
}
@property (nonatomic, readonly) id<EGIndexSource> source;
@property (nonatomic, readonly) unsigned int start;
@property (nonatomic, readonly) unsigned int count;

+ (instancetype)indexSourceGapWithSource:(id<EGIndexSource>)source start:(unsigned int)start count:(unsigned int)count;
- (instancetype)initWithSource:(id<EGIndexSource>)source start:(unsigned int)start count:(unsigned int)count;
- (CNClassType*)type;
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (NSString*)description;
+ (CNClassType*)type;
@end


@interface EGMutableIndexSourceGap : EGIndexSource_impl {
@protected
    id<EGIndexSource> _source;
    unsigned int _start;
    unsigned int _count;
}
@property (nonatomic, readonly) id<EGIndexSource> source;
@property (nonatomic) unsigned int start;
@property (nonatomic) unsigned int count;

+ (instancetype)mutableIndexSourceGapWithSource:(id<EGIndexSource>)source;
- (instancetype)initWithSource:(id<EGIndexSource>)source;
- (CNClassType*)type;
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (NSString*)description;
+ (CNClassType*)type;
@end


