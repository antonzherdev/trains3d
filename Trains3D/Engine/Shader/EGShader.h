#import "objd.h"
#import "EGGL.h"
#import "EGTypes.h"
#import "GEVec.h"
@class EGMesh;
@class EGIndexBuffer;
@class EGVertexBuffer;
@class GEMatrix;

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
- (void)drawMaterial:(id)material mesh:(EGMesh*)mesh;
- (void)drawMaterial:(id)material mesh:(EGMesh*)mesh start:(NSUInteger)start count:(NSUInteger)count;
- (void)loadVertexBuffer:(EGVertexBuffer*)vertexBuffer material:(id)material;
- (void)unloadMaterial:(id)material;
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
- (void)setMatrix:(GEMatrix*)matrix;
- (void)setColor:(EGColor)color;
- (void)setVec3:(GEVec3)vec3;
- (void)setNumber:(float)number;
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


