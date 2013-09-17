#import "objd.h"
#import "GL.h"
#import "EGTypes.h"
#import "GEVec.h"
@class EGMesh;
@class EGIndexBuffer;
@class EGVertexBuffer;
@class GEMat4;

@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@class EGShaderSystem;

@interface EGShaderProgram : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderProgramWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
+ (EGShaderProgram*)loadFromFilesVertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (EGShaderProgram*)applyVertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (EGShaderProgram*)linkFromShadersVertex:(GLuint)vertex fragment:(GLuint)fragment;
+ (GLuint)compileShaderForShaderType:(GLenum)shaderType source:(NSString*)source;
- (void)dealoc;
- (void)set;
- (void)clear;
- (void)applyDraw:(void(^)())draw;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
- (EGShaderUniform*)uniformForName:(NSString*)name;
+ (ODClassType*)type;
@end


@interface EGShader : NSObject
@property (nonatomic, readonly) EGShaderProgram* program;

+ (id)shaderWithProgram:(EGShaderProgram*)program;
- (id)initWithProgram:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)drawParam:(id)param mesh:(EGMesh*)mesh;
- (void)drawParam:(id)param mesh:(EGMesh*)mesh start:(NSUInteger)start count:(NSUInteger)count;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer param:(id)param;
- (void)unloadParam:(id)param;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
- (EGShaderUniform*)uniformForName:(NSString*)name;
+ (ODClassType*)type;
@end


@interface EGShaderAttribute : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderAttributeWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(GLenum)valuesType shift:(NSUInteger)shift;
+ (ODClassType*)type;
@end


@interface EGShaderUniform : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderUniformWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
- (void)setMatrix:(GEMat4*)matrix;
- (void)setColor:(EGColor)color;
- (void)setVec3:(GEVec3)vec3;
- (void)setF4:(float)f4;
+ (ODClassType*)type;
@end


@interface EGShaderSystem : NSObject
+ (id)shaderSystem;
- (id)init;
- (ODClassType*)type;
- (void)drawMaterial:(id)material mesh:(EGMesh*)mesh;
- (EGShader*)shaderForMaterial:(id)material;
+ (ODClassType*)type;
@end


