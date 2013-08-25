#import "objd.h"
@class CNBundle;
#import "EGGL.h"
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGMatrix;

@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;

@interface EGShaderProgram : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderProgramWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
+ (EGShaderProgram*)loadFromFilesVertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (EGShaderProgram*)linkFromStringsVertex:(NSString*)vertex fragment:(NSString*)fragment;
+ (EGShaderProgram*)linkFromShadersVertex:(GLuint)vertex fragment:(GLuint)fragment;
+ (GLuint)compileShaderForShaderType:(GLenum)shaderType source:(NSString*)source;
- (void)dealoc;
- (void)set;
- (void)clear;
- (void)drawF:(void(^)())f;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
- (EGShaderUniform*)uniformForName:(NSString*)name;
@end


@interface EGShader : NSObject
@property (nonatomic, readonly) EGShaderProgram* program;

+ (id)shaderWithProgram:(EGShaderProgram*)program;
- (id)initWithProgram:(EGShaderProgram*)program;
- (void)drawF:(void(^)())f;
- (void)set;
- (void)load;
- (void)clear;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
- (EGShaderUniform*)uniformForName:(NSString*)name;
@end


@interface EGShaderAttribute : NSObject
@property (nonatomic, readonly) GLint handle;

+ (id)shaderAttributeWithHandle:(GLint)handle;
- (id)initWithHandle:(GLint)handle;
- (NSUInteger)setFromBuffer:(EGVertexBuffer*)buffer valuesCount:(NSUInteger)valuesCount valuesType:(GLenum)valuesType shift:(NSUInteger)shift;
@end


@interface EGShaderUniform : NSObject
@property (nonatomic, readonly) GLint handle;

+ (id)shaderUniformWithHandle:(GLint)handle;
- (id)initWithHandle:(GLint)handle;
- (void)setMatrix:(EGMatrix*)matrix;
@end


