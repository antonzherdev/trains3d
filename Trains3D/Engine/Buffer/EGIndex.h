#import "objd.h"
#import "GL.h"
#import "EGBuffer.h"
@class EGGlobal;
@class EGContext;

@class EGIBO;
@class EGImmutableIndexBuffer;
@class EGMutableIndexBuffer;
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
- (GLuint)handle;
- (unsigned int)mode;
- (NSUInteger)count;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (void)bind;
@end


@interface EGImmutableIndexBuffer : EGBuffer<EGIndexBuffer>
@property (nonatomic, readonly) unsigned int mode;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger count;

+ (id)immutableIndexBufferWithHandle:(GLuint)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count;
- (id)initWithHandle:(GLuint)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGMutableIndexBuffer : EGMutableBuffer<EGIndexBuffer>
@property (nonatomic, readonly) GLuint handle;
@property (nonatomic, readonly) unsigned int mode;

+ (id)mutableIndexBufferWithHandle:(GLuint)handle mode:(unsigned int)mode;
- (id)initWithHandle:(GLuint)handle mode:(unsigned int)mode;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


@interface EGEmptyIndexSource : NSObject<EGIndexSource>
@property (nonatomic, readonly) unsigned int mode;

+ (id)emptyIndexSourceWithMode:(unsigned int)mode;
- (id)initWithMode:(unsigned int)mode;
- (ODClassType*)type;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (EGEmptyIndexSource*)triangleStrip;
+ (EGEmptyIndexSource*)triangles;
+ (EGEmptyIndexSource*)lines;
+ (ODClassType*)type;
@end


@interface EGArrayIndexSource : NSObject<EGIndexSource>
@property (nonatomic, readonly) CNPArray* array;
@property (nonatomic, readonly) unsigned int mode;

+ (id)arrayIndexSourceWithArray:(CNPArray*)array mode:(unsigned int)mode;
- (id)initWithArray:(CNPArray*)array mode:(unsigned int)mode;
- (ODClassType*)type;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (ODClassType*)type;
@end


@interface EGVoidRefArrayIndexSource : NSObject<EGIndexSource>
@property (nonatomic, readonly) CNVoidRefArray array;
@property (nonatomic, readonly) unsigned int mode;

+ (id)voidRefArrayIndexSourceWithArray:(CNVoidRefArray)array mode:(unsigned int)mode;
- (id)initWithArray:(CNVoidRefArray)array mode:(unsigned int)mode;
- (ODClassType*)type;
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (ODClassType*)type;
@end


@interface EGIndexSourceGap : NSObject<EGIndexSource>
@property (nonatomic, readonly) id<EGIndexSource> source;
@property (nonatomic, readonly) unsigned int start;
@property (nonatomic, readonly) unsigned int count;

+ (id)indexSourceGapWithSource:(id<EGIndexSource>)source start:(unsigned int)start count:(unsigned int)count;
- (id)initWithSource:(id<EGIndexSource>)source start:(unsigned int)start count:(unsigned int)count;
- (ODClassType*)type;
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (ODClassType*)type;
@end


@interface EGMutableIndexSourceGap : NSObject<EGIndexSource>
@property (nonatomic, readonly) id<EGIndexSource> source;
@property (nonatomic) unsigned int start;
@property (nonatomic) unsigned int count;

+ (id)mutableIndexSourceGapWithSource:(id<EGIndexSource>)source;
- (id)initWithSource:(id<EGIndexSource>)source;
- (ODClassType*)type;
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (ODClassType*)type;
@end


