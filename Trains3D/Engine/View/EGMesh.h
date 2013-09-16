#import "objd.h"
#import "GEVec.h"
#import "GL.h"

@class EGMesh;
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
typedef struct EGMeshData EGMeshData;

struct EGMeshData {
    GEVec2 uv;
    GEVec3 normal;
    GEVec3 position;
};
static inline EGMeshData EGMeshDataMake(GEVec2 uv, GEVec3 normal, GEVec3 position) {
    return (EGMeshData){uv, normal, position};
}
static inline BOOL EGMeshDataEq(EGMeshData s1, EGMeshData s2) {
    return GEVec2Eq(s1.uv, s2.uv) && GEVec3Eq(s1.normal, s2.normal) && GEVec3Eq(s1.position, s2.position);
}
static inline NSUInteger EGMeshDataHash(EGMeshData self) {
    NSUInteger hash = 0;
    hash = hash * 31 + GEVec2Hash(self.uv);
    hash = hash * 31 + GEVec3Hash(self.normal);
    hash = hash * 31 + GEVec3Hash(self.position);
    return hash;
}
static inline NSString* EGMeshDataDescription(EGMeshData self) {
    NSMutableString* description = [NSMutableString stringWithString:@"<EGMeshData: "];
    [description appendFormat:@"uv=%@", GEVec2Description(self.uv)];
    [description appendFormat:@", normal=%@", GEVec3Description(self.normal)];
    [description appendFormat:@", position=%@", GEVec3Description(self.position)];
    [description appendString:@">"];
    return description;
}
ODType* egMeshDataType();
@interface EGMeshDataWrap : NSObject
@property (readonly, nonatomic) EGMeshData value;

+ (id)wrapWithValue:(EGMeshData)value;
- (id)initWithValue:(EGMeshData)value;
@end



@interface EGMesh : NSObject
@property (nonatomic, readonly) EGVertexBuffer* vertexBuffer;
@property (nonatomic, readonly) EGIndexBuffer* indexBuffer;

+ (id)meshWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer;
- (id)initWithVertexBuffer:(EGVertexBuffer*)vertexBuffer indexBuffer:(EGIndexBuffer*)indexBuffer;
- (ODClassType*)type;
+ (EGMesh*)applyDataType:(ODPType*)dataType vertexData:(CNPArray*)vertexData indexData:(CNPArray*)indexData;
+ (EGMesh*)quadVertexBuffer:(EGVertexBuffer*)vertexBuffer;
+ (ODType*)type;
@end


@interface EGBuffer : NSObject
@property (nonatomic, readonly) ODPType* dataType;
@property (nonatomic, readonly) GLenum bufferType;
@property (nonatomic, readonly) GLuint handle;

+ (id)bufferWithDataType:(ODPType*)dataType bufferType:(GLenum)bufferType handle:(GLuint)handle;
- (id)initWithDataType:(ODPType*)dataType bufferType:(GLenum)bufferType handle:(GLuint)handle;
- (ODClassType*)type;
- (NSUInteger)length;
- (NSUInteger)count;
+ (EGBuffer*)applyDataType:(ODPType*)dataType bufferType:(GLenum)bufferType;
- (void)dealoc;
- (id)setData:(CNPArray*)data;
- (id)setArray:(CNVoidRefArray)array;
- (id)setData:(CNPArray*)data usage:(GLenum)usage;
- (id)setArray:(CNVoidRefArray)array usage:(GLenum)usage;
- (id)updateStart:(NSUInteger)start count:(NSUInteger)count array:(CNVoidRefArray)array;
- (void)bind;
- (void)unbind;
- (void)applyDraw:(void(^)())draw;
- (NSUInteger)stride;
+ (ODType*)type;
@end


@interface EGVertexBuffer : EGBuffer
+ (id)vertexBufferWithDataType:(ODPType*)dataType handle:(GLuint)handle;
- (id)initWithDataType:(ODPType*)dataType handle:(GLuint)handle;
- (ODClassType*)type;
+ (EGVertexBuffer*)applyDataType:(ODPType*)dataType;
+ (ODType*)type;
@end


@interface EGIndexBuffer : EGBuffer
+ (id)indexBufferWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
+ (EGIndexBuffer*)apply;
- (void)draw;
- (void)drawWithStart:(NSUInteger)start count:(NSUInteger)count;
- (void)drawByQuads;
+ (ODType*)type;
@end


