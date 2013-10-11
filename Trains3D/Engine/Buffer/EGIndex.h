#import "objd.h"
#import "EGBuffer.h"
#import "GL.h"
@class EGGlobal;
@class EGContext;
@class EGVertexBuffer;

@class EGIndexBuffer;
@class EGMutableIndexBuffer;
@class EGEmptyIndexSource;
@class EGArrayIndexSource;
@class EGVoidRefArrayIndexSource;
@class EGIndexSourceGap;
@protocol EGIndexSource;

@protocol EGIndexSource<NSObject>
- (void)bind;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
@end


@interface EGIndexBuffer : EGBuffer<EGIndexSource>
@property (nonatomic, readonly) unsigned int mode;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger count;

+ (id)indexBufferWithHandle:(GLuint)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count;
- (id)initWithHandle:(GLuint)handle mode:(unsigned int)mode length:(NSUInteger)length count:(NSUInteger)count;
- (ODClassType*)type;
+ (EGIndexBuffer*)applyArray:(CNVoidRefArray)array;
+ (EGIndexBuffer*)applyData:(CNPArray*)data;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (void)bind;
+ (ODClassType*)type;
@end


@interface EGMutableIndexBuffer : EGMutableBuffer<EGIndexSource>
@property (nonatomic, readonly) GLuint handle;
@property (nonatomic, readonly) unsigned int mode;

+ (id)mutableIndexBufferWithHandle:(GLuint)handle mode:(unsigned int)mode;
- (id)initWithHandle:(GLuint)handle mode:(unsigned int)mode;
- (ODClassType*)type;
+ (EGMutableIndexBuffer*)apply;
+ (EGMutableIndexBuffer*)applyMode:(unsigned int)mode;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (void)bind;
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


