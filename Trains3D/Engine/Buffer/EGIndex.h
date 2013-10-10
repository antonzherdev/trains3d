#import "objd.h"
#import "EGBuffer.h"
#import "GL.h"
@class EGGlobal;
@class EGContext;
@protocol EGVertexSource;

@class EGIndexBuffer;
@class EGEmptyIndexSource;
@class EGArrayIndexSource;
@class EGVoidRefArrayIndexSource;
@class EGIndexSourceGap;
@protocol EGIndexSource;

@protocol EGIndexSource<NSObject>
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
@end


@interface EGIndexBuffer : EGBuffer<EGIndexSource>
@property (nonatomic, readonly) unsigned int mode;

+ (id)indexBufferWithHandle:(GLuint)handle mode:(unsigned int)mode;
- (id)initWithHandle:(GLuint)handle mode:(unsigned int)mode;
- (ODClassType*)type;
+ (EGIndexBuffer*)apply;
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
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
+ (ODClassType*)type;
@end


