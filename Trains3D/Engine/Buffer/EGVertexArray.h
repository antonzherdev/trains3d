#import "objd.h"
@class EGGlobal;
@class EGContext;
@class EGRenderTarget;
@class EGShader;
@protocol EGIndexSource;
@protocol EGVertexBuffer;

@class EGVertexArray;
@class EGRouteVertexArray;
@class EGSimpleVertexArray;
@class EGMaterialVertexArray;

@interface EGVertexArray : NSObject
+ (id)vertexArray;
- (id)init;
- (ODClassType*)type;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)drawParam:(id)param;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGRouteVertexArray : EGVertexArray
@property (nonatomic, readonly) EGVertexArray* standard;
@property (nonatomic, readonly) EGVertexArray* shadow;

+ (id)routeVertexArrayWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow;
- (id)initWithStandard:(EGVertexArray*)standard shadow:(EGVertexArray*)shadow;
- (ODClassType*)type;
- (EGVertexArray*)mesh;
- (void)drawParam:(id)param;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGSimpleVertexArray : EGVertexArray
@property (nonatomic, readonly) unsigned int handle;
@property (nonatomic, readonly) EGShader* shader;
@property (nonatomic, readonly) id<CNSeq> buffers;
@property (nonatomic, readonly) id<EGIndexSource> index;
@property (nonatomic, readonly) BOOL isMutable;

+ (id)simpleVertexArrayWithHandle:(unsigned int)handle shader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index;
- (id)initWithHandle:(unsigned int)handle shader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index;
- (ODClassType*)type;
+ (EGSimpleVertexArray*)applyShader:(EGShader*)shader buffers:(id<CNSeq>)buffers index:(id<EGIndexSource>)index;
- (void)bind;
- (void)unbind;
- (void)dealloc;
- (NSUInteger)count;
- (void)drawParam:(id)param;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
- (void)draw;
+ (ODClassType*)type;
@end


@interface EGMaterialVertexArray : EGVertexArray
@property (nonatomic, readonly) EGVertexArray* vao;
@property (nonatomic, readonly) id material;

+ (id)materialVertexArrayWithVao:(EGVertexArray*)vao material:(id)material;
- (id)initWithVao:(EGVertexArray*)vao material:(id)material;
- (ODClassType*)type;
- (void)draw;
- (void)drawParam:(id)param;
- (void)drawParam:(id)param start:(NSUInteger)start end:(NSUInteger)end;
+ (ODClassType*)type;
@end


