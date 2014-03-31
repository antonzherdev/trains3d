#import "objd.h"
@protocol EGVertexBuffer;
@protocol EGIndexSource;
@class EGMutableVertexBuffer;
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;
@class EGShader;
@class EGFence;

@class EGVertexArray;
@class EGRouteVertexArray;
@class EGSimpleVertexArray;
@class EGMaterialVertexArray;
@class EGVertexArrayRing;

@interface EGVertexArray : NSObject {
@private
    CNLazy* __lazy_mutableVertexBuffer;
}
+ (instancetype)vertexArray;
- (instancetype)init;
- (ODClassType*)type;
- (id)mutableVertexBuffer;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)drawParam:(id)param;
- (void)draw;
- (void)syncWait;
- (void)syncSet;
- (void)syncF:(void(^)())f;
- (NSArray*)vertexBuffers;
- (id<EGIndexSource>)index;
- (void)vertexWriteCount:(unsigned int)count f:(void(^)(CNVoidRefArray))f;
+ (ODClassType*)type;
@end


@interface EGRouteVertexArray : EGVertexArray {
@private
    EGVertexArray* _standard;
    EGVertexArray* _shadow;
}
@property (nonatomic, readonly) EGVertexArray* standard;
@property (nonatomic, readonly) EGVertexArray* shadow;

+ (instancetype)routeVertexArrayWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow;
- (instancetype)initWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow;
- (ODClassType*)type;
- (EGVertexArray*)mesh;
- (void)drawParam:(id)param;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)draw;
- (void)syncF:(void(^)())f;
- (void)syncWait;
- (void)syncSet;
- (NSArray*)vertexBuffers;
- (id<EGIndexSource>)index;
+ (ODClassType*)type;
@end


@interface EGSimpleVertexArray : EGVertexArray {
@private
    unsigned int _handle;
    EGShader* _shader;
    NSArray* _vertexBuffers;
    id<EGIndexSource> _index;
    BOOL _isMutable;
    EGFence* _fence;
}
@property (nonatomic, readonly) unsigned int handle;
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) NSArray* vertexBuffers;
@property (nonatomic, readonly) id<EGIndexSource> index;
@property (nonatomic, readonly) BOOL isMutable;

+ (instancetype)simpleVertexArrayWithHandle:(unsigned int)handle shader:(EGShader*)shader vertexBuffers:(NSArray*)vertexBuffers index:(id<EGIndexSource>)index;
- (instancetype)initWithHandle:(unsigned int)handle shader:(EGShader*)shader vertexBuffers:(NSArray*)vertexBuffers index:(id<EGIndexSource>)index;
- (ODClassType*)type;
+ (EGSimpleVertexArray*)applyShader:(EGShader*)shader buffers:(NSArray*)buffers index:(id<EGIndexSource>)index;
- (void)bind;
- (void)unbind;
- (void)dealloc;
- (NSUInteger)count;
- (void)drawParam:(id)param;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)draw;
- (void)syncF:(void(^)())f;
- (void)syncWait;
- (void)syncSet;
+ (ODClassType*)type;
@end


@interface EGMaterialVertexArray : EGVertexArray {
@private
    EGVertexArray* _vao;
    id _material;
}
@property (nonatomic, readonly) EGVertexArray* vao;
@property (nonatomic, readonly) id material;

+ (instancetype)materialVertexArrayWithVao:(EGVertexArray*)vao material:(id)material;
- (instancetype)initWithVao:(EGVertexArray*)vao material:(id)material;
- (ODClassType*)type;
- (void)draw;
- (void)drawParam:(id)param;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)syncF:(void(^)())f;
- (void)syncWait;
- (void)syncSet;
- (NSArray*)vertexBuffers;
- (id<EGIndexSource>)index;
+ (ODClassType*)type;
@end


@interface EGVertexArrayRing : NSObject {
@private
    unsigned int _ringSize;
    EGVertexArray*(^_creator)(unsigned int);
    CNMQueue* __ring;
}
@property (nonatomic, readonly) unsigned int ringSize;
@property (nonatomic, readonly) EGVertexArray*(^creator)(unsigned int);

+ (instancetype)vertexArrayRingWithRingSize:(unsigned int)ringSize creator:(EGVertexArray*(^)(unsigned int))creator;
- (instancetype)initWithRingSize:(unsigned int)ringSize creator:(EGVertexArray*(^)(unsigned int))creator;
- (ODClassType*)type;
- (EGVertexArray*)next;
- (void)syncF:(void(^)(EGVertexArray*))f;
+ (ODClassType*)type;
@end


