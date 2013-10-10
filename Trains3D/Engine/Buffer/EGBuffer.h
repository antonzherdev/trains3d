#import "objd.h"
#import "GL.h"

@class EGBuffer;

@interface EGBuffer : NSObject
@property (nonatomic, readonly) ODPType* dataType;
@property (nonatomic, readonly) unsigned int bufferType;
@property (nonatomic, readonly) GLuint handle;

+ (id)bufferWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(GLuint)handle;
- (id)initWithDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType handle:(GLuint)handle;
- (ODClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
+ (EGBuffer*)applyDataType:(ODPType*)dataType bufferType:(unsigned int)bufferType;
- (void)dealoc;
- (id)setData:(CNPArray*)data;
- (id)setArray:(CNVoidRefArray)array;
- (id)setData:(CNPArray*)data usage:(unsigned int)usage;
- (id)setArray:(CNVoidRefArray)array usage:(unsigned int)usage;
- (id)updateStart:(NSUInteger)start count:(NSUInteger)count array:(CNVoidRefArray)array;
- (void)bind;
- (unsigned int)stride;
+ (ODClassType*)type;
@end


