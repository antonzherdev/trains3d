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
@class EGShaderUniformMat4;
@class EGShaderUniformVec4;
@class EGShaderUniformVec3;
@class EGShaderUniformF4;
@class EGShaderUniformI4;
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
- (EGShaderUniformMat4*)uniformMat4Name:(NSString*)name;
- (EGShaderUniformVec4*)uniformVec4Name:(NSString*)name;
- (EGShaderUniformVec3*)uniformVec3Name:(NSString*)name;
- (EGShaderUniformF4*)uniformF4Name:(NSString*)name;
- (EGShaderUniformI4*)uniformI4Name:(NSString*)name;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
+ (ODClassType*)type;
@end


@interface EGShaderAttribute : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderAttributeWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
- (void)_init;
- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(unsigned int)valuesType shift:(NSUInteger)shift;
+ (ODClassType*)type;
@end


@interface EGShaderUniformMat4 : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderUniformMat4WithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
- (void)applyMatrix:(GEMat4*)matrix;
+ (ODClassType*)type;
@end


@interface EGShaderUniformVec4 : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderUniformVec4WithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
- (void)applyVec4:(GEVec4)vec4;
+ (ODClassType*)type;
@end


@interface EGShaderUniformVec3 : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderUniformVec3WithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
- (void)applyVec3:(GEVec3)vec3;
+ (ODClassType*)type;
@end


@interface EGShaderUniformF4 : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderUniformF4WithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
- (void)applyF4:(float)f4;
+ (ODClassType*)type;
@end


@interface EGShaderUniformI4 : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderUniformI4WithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
- (void)applyI4:(int)i4;
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


