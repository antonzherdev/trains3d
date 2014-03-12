#import "objd.h"
#import "EGBuffer.h"
@class EGGlobal;
@class EGContext;

@class EGIBO;
@class EGImmutableIndexBuffer;
@class EGMutableIndexBuffer;
@class EGIndexBufferRing;
@class EGEmptyIndexSource;
@class EGArrayIndexSource;
@class EGVoidRefArrayIndexSource;
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
@end


@interface EGIBO : NSObject
- (ODClassType*)type;
+ (EGImmutableIndexBuffer*)applyArray:(CNVoidRefArray)array;
+ (EGImmutableIndexBuffer*)applyData:(CNPArray*)data;
+ (EGMutableIndexBuffer*)mut;
+ (EGMutableIndexBuffer*)mutMode:(unsigned int)mode;
+ (ODClassType*)type;
@end


@protocol EGIndexBuffer<EGIndexSource>
- (unsigned int)handle;
- (unsigned int)mode;
- (NSUInteger)count;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (void)bind;
@end


@interface EGImmutableIndexBuffer : EGBuffer<EGIndexBuffer> {
@private
    unsigned int _mode;
    NSUInteger _length;
    NSUInteger _count;
}
@property (nonatomic, readonly) unsigned int mode;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger count;

+ (instancetype)immutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count;
- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGMutableIndexBuffer : EGMutableBuffer<EGIndexBuffer> {
@private
    unsigned int _mode;
}
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)mutableIndexBufferWithHandle:(unsigned int)handle mode:(unsigned int)mode;
- (instancetype)initWithHandle:(unsigned int)handle mode:(unsigned int)mode;
- (ODClassType*)type;
- (BOOL)isMutable;
+ (ODClassType*)type;
@end


@interface EGIndexBufferRing : EGBufferRing {
@private
    unsigned int _mode;
}
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)indexBufferRingWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode;
- (instancetype)initWithRingSize:(unsigned int)ringSize mode:(unsigned int)mode;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGEmptyIndexSource : NSObject<EGIndexSource> {
@private
    unsigned int _mode;
}
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)emptyIndexSourceWithMode:(unsigned int)mode;
- (instancetype)initWithMode:(unsigned int)mode;
- (ODClassType*)type;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (EGEmptyIndexSource*)triangleStrip;
+ (EGEmptyIndexSource*)triangleFan;
+ (EGEmptyIndexSource*)triangles;
+ (EGEmptyIndexSource*)lines;
+ (ODClassType*)type;
@end


@interface EGArrayIndexSource : NSObject<EGIndexSource> {
@private
    CNPArray* _array;
    unsigned int _mode;
}
@property (nonatomic, readonly) CNPArray* array;
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)arrayIndexSourceWithArray:(CNPArray*)array mode:(unsigned int)mode;
- (instancetype)initWithArray:(CNPArray*)array mode:(unsigned int)mode;
- (ODClassType*)type;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (ODClassType*)type;
@end


@interface EGVoidRefArrayIndexSource : NSObject<EGIndexSource> {
@private
    CNVoidRefArray _array;
    unsigned int _mode;
}
@property (nonatomic, readonly) CNVoidRefArray array;
@property (nonatomic, readonly) unsigned int mode;

+ (instancetype)voidRefArrayIndexSourceWithArray:(CNVoidRefArray)array mode:(unsigned int)mode;
- (instancetype)initWithArray:(CNVoidRefArray)array mode:(unsigned int)mode;
- (ODClassType*)type;
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (ODClassType*)type;
@end


@interface EGIndexSourceGap : NSObject<EGIndexSource> {
@private
    id<EGIndexSource> _source;
    unsigned int _start;
    unsigned int _count;
}
@property (nonatomic, readonly) id<EGIndexSource> source;
@property (nonatomic, readonly) unsigned int start;
@property (nonatomic, readonly) unsigned int count;

+ (instancetype)indexSourceGapWithSource:(id<EGIndexSource>)source start:(unsigned int)start count:(unsigned int)count;
- (instancetype)initWithSource:(id<EGIndexSource>)source start:(unsigned int)start count:(unsigned int)count;
- (ODClassType*)type;
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (ODClassType*)type;
@end


@interface EGMutableIndexSourceGap : NSObject<EGIndexSource> {
@private
    id<EGIndexSource> _source;
    unsigned int _start;
    unsigned int _count;
}
@property (nonatomic, readonly) id<EGIndexSource> source;
@property (nonatomic) unsigned int start;
@property (nonatomic) unsigned int count;

+ (instancetype)mutableIndexSourceGapWithSource:(id<EGIndexSource>)source;
- (instancetype)initWithSource:(id<EGIndexSource>)source;
- (ODClassType*)type;
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (ODClassType*)type;
@end


