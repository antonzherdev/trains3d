#import "objd.h"
#import "GEVec.h"
#import "EGMesh.h"
#import "EGBuffer.h"
@class EGGlobal;
@class EGContext;

@class EGVertexBufferDesc;
@class EGVBO;
@class EGImmutableVertexBuffer;
@class EGMutableVertexBuffer;
@class EGVertexBufferRing;
@protocol EGVertexBuffer;

@interface EGVertexBufferDesc : NSObject {
@protected
    ODPType* _dataType;
    int _position;
    int _uv;
    int _normal;
    int _color;
    int _model;
}
@property (nonatomic, readonly) ODPType* dataType;
@property (nonatomic, readonly) int position;
@property (nonatomic, readonly) int uv;
@property (nonatomic, readonly) int normal;
@property (nonatomic, readonly) int color;
@property (nonatomic, readonly) int model;

+ (instancetype)vertexBufferDescWithDataType:(ODPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model;
- (instancetype)initWithDataType:(ODPType*)dataType position:(int)position uv:(int)uv normal:(int)normal color:(int)color model:(int)model;
- (ODClassType*)type;
- (unsigned int)stride;
+ (EGVertexBufferDesc*)Vec2;
+ (EGVertexBufferDesc*)Vec3;
+ (EGVertexBufferDesc*)Vec4;
+ (EGVertexBufferDesc*)mesh;
+ (ODClassType*)type;
@end


@interface EGVBO : NSObject
- (ODClassType*)type;
+ (id<EGVertexBuffer>)applyDesc:(EGVertexBufferDesc*)desc array:(void*)array count:(unsigned int)count;
+ (id<EGVertexBuffer>)applyDesc:(EGVertexBufferDesc*)desc data:(CNPArray*)data;
+ (id<EGVertexBuffer>)vec4Data:(CNPArray*)data;
+ (id<EGVertexBuffer>)vec3Data:(CNPArray*)data;
+ (id<EGVertexBuffer>)vec2Data:(CNPArray*)data;
+ (id<EGVertexBuffer>)meshData:(CNPArray*)data;
+ (EGMutableVertexBuffer*)mutDesc:(EGVertexBufferDesc*)desc usage:(unsigned int)usage;
+ (EGVertexBufferRing*)ringSize:(unsigned int)size desc:(EGVertexBufferDesc*)desc usage:(unsigned int)usage;
+ (EGMutableVertexBuffer*)mutVec2Usage:(unsigned int)usage;
+ (EGMutableVertexBuffer*)mutVec3Usage:(unsigned int)usage;
+ (EGMutableVertexBuffer*)mutVec4Usage:(unsigned int)usage;
+ (EGMutableVertexBuffer*)mutMeshUsage:(unsigned int)usage;
+ (ODClassType*)type;
@end


@protocol EGVertexBuffer<NSObject>
- (EGVertexBufferDesc*)desc;
- (NSUInteger)count;
- (unsigned int)handle;
- (BOOL)isMutable;
- (void)bind;
@end


@interface EGImmutableVertexBuffer : EGBuffer<EGVertexBuffer> {
@protected
    EGVertexBufferDesc* _desc;
    NSUInteger _length;
    NSUInteger _count;
}
@property (nonatomic, readonly) EGVertexBufferDesc* desc;
@property (nonatomic, readonly) NSUInteger length;
@property (nonatomic, readonly) NSUInteger count;

+ (instancetype)immutableVertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(unsigned int)handle length:(NSUInteger)length count:(NSUInteger)count;
- (instancetype)initWithDesc:(EGVertexBufferDesc*)desc handle:(unsigned int)handle length:(NSUInteger)length count:(NSUInteger)count;
- (ODClassType*)type;
- (void)bind;
+ (ODClassType*)type;
@end


@interface EGMutableVertexBuffer : EGMutableBuffer<EGVertexBuffer> {
@protected
    EGVertexBufferDesc* _desc;
}
@property (nonatomic, readonly) EGVertexBufferDesc* desc;

+ (instancetype)mutableVertexBufferWithDesc:(EGVertexBufferDesc*)desc handle:(unsigned int)handle usage:(unsigned int)usage;
- (instancetype)initWithDesc:(EGVertexBufferDesc*)desc handle:(unsigned int)handle usage:(unsigned int)usage;
- (ODClassType*)type;
- (BOOL)isMutable;
- (void)bind;
- (BOOL)isEmpty;
+ (ODClassType*)type;
@end


@interface EGVertexBufferRing : EGBufferRing {
@protected
    EGVertexBufferDesc* _desc;
    unsigned int _usage;
}
@property (nonatomic, readonly) EGVertexBufferDesc* desc;
@property (nonatomic, readonly) unsigned int usage;

+ (instancetype)vertexBufferRingWithRingSize:(unsigned int)ringSize desc:(EGVertexBufferDesc*)desc usage:(unsigned int)usage;
- (instancetype)initWithRingSize:(unsigned int)ringSize desc:(EGVertexBufferDesc*)desc usage:(unsigned int)usage;
- (ODClassType*)type;
+ (ODClassType*)type;
@end


