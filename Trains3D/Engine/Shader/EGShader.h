#import "objd.h"
#import "GL.h"
#import "GEVec.h"
@class EGMesh;
@class EGGlobal;
@class EGContext;
@protocol EGVertexSource;
@protocol EGIndexSource;
@class EGVertexBufferDesc;
@class EGVertexArray;
@class EGVertexBuffer;
@class GEMat4;

@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniformMat4;
@class EGShaderUniformVec4;
@class EGShaderUniformVec3;
@class EGShaderUniformVec2;
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
- (void)drawParam:(id)param vertex:(id<EGVertexSource>)vertex index:(id<EGIndexSource>)index;
- (void)loadAttributesVbDesc:(EGVertexBufferDesc*)vbDesc;
- (void)loadUniformsParam:(id)param;
- (EGShaderUniformMat4*)uniformMat4Name:(NSString*)name;
- (EGShaderUniformVec4*)uniformVec4Name:(NSString*)name;
- (EGShaderUniformVec3*)uniformVec3Name:(NSString*)name;
- (EGShaderUniformVec2*)uniformVec2Name:(NSString*)name;
- (EGShaderUniformF4*)uniformF4Name:(NSString*)name;
- (EGShaderUniformI4*)uniformI4Name:(NSString*)name;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
- (EGVertexArray*)vaoWithVbo:(EGVertexBuffer*)vbo;
+ (ODClassType*)type;
@end


@interface EGShaderAttribute : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderAttributeWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
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


@interface EGShaderUniformVec2 : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderUniformVec2WithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (ODClassType*)type;
- (void)applyVec2:(GEVec2)vec2;
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
- (void)drawParam:(id)param vertex:(id<EGVertexSource>)vertex index:(id<EGIndexSource>)index;
- (EGShader*)shaderForParam:(id)param;
- (EGVertexArray*)vaoWithParam:(id)param vbo:(EGVertexBuffer*)vbo;
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


