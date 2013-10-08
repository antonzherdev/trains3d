#import "objd.h"
#import "GL.h"
#import "GEVec.h"
@class EGMesh;
@class EGIndexBuffer;
@class EGVertexBuffer;
@class EGVertexBufferDesc;
@class GEMat4;

@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@class EGShaderSystem;
@protocol EGShaderTextBuilder;

@interface EGShaderProgram : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderProgramWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
+ (EGShaderProgram*)loadFromFilesVertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (EGShaderProgram*)applyVertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (EGShaderProgram*)linkFromShadersVertex:(GLuint)vertex fragment:(GLuint)fragment;
+ (GLuint)compileShaderForShaderType:(unsigned int)shaderType source:(NSString*)source;
- (void)dealoc;
- (void)set;
- (void)clear;
- (void)applyDraw:(void(^)())draw;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
- (EGShaderUniform*)uniformForName:(NSString*)name;
+ (NSInteger)version;
+ (ODClassType*)type;
@end


@interface EGShader : NSObject
@property (nonatomic, readonly) EGShaderProgram* program;

+ (id)shaderWithProgram:(EGShaderProgram*)program;
- (id)initWithProgram:(EGShaderProgram*)program;
- (ODClassType*)type;
- (void)drawParam:(id)param mesh:(EGMesh*)mesh;
- (void)drawParam:(id)param mesh:(EGMesh*)mesh start:(NSUInteger)start count:(NSUInteger)count;
- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb index:(CNPArray*)index mode:(unsigned int)mode;
- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb indexRef:(CNVoidRefArray)indexRef mode:(unsigned int)mode;
- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb mode:(unsigned int)mode;
- (void)loadVbDesc:(EGVertexBufferDesc*)vbDesc param:(id)param;
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
- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(unsigned int)valuesType shift:(NSUInteger)shift;
- (void)unbind;
+ (ODClassType*)type;
@end


@interface EGShaderUniform : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderUniformWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
- (void)setMatrix:(GEMat4*)matrix;
- (void)setVec4:(GEVec4)vec4;
- (void)setVec3:(GEVec3)vec3;
- (void)setF4:(float)f4;
- (void)setI4:(int)i4;
+ (ODClassType*)type;
@end


@interface EGShaderSystem : NSObject
+ (id)shaderSystem;
- (id)init;
- (ODClassType*)type;
- (void)drawParam:(id)param mesh:(EGMesh*)mesh;
- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb index:(CNPArray*)index mode:(unsigned int)mode;
- (void)drawParam:(id)param vb:(EGVertexBuffer*)vb mode:(unsigned int)mode;
- (EGShader*)shaderForParam:(id)param;
+ (ODClassType*)type;
@end


@protocol EGShaderTextBuilder<NSObject>
- (NSString*)versionString;
- (NSString*)vertexHeader;
- (NSString*)fragmentHeader;
- (NSString*)fragColorDeclaration;
- (BOOL)isFragColorDeclared;
- (NSInteger)version;
- (NSString*)ain;
- (NSString*)in;
- (NSString*)out;
- (NSString*)fragColor;
- (NSString*)texture2D;
@end


