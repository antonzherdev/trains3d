#import "objd.h"
@class CNBundle;
#import "CNTypes.h"
@class EG;
#import "EGGL.h"
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGMatrix;
@class EGContext;
@class EGMutableMatrix;
#import "EGTypes.h"
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGContext;
@class EGMutableMatrix;

@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@protocol EGShaderSystem;

@interface EGShaderProgram : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderProgramWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
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
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGShader : NSObject
@property (nonatomic, readonly) EGShaderProgram* program;

+ (id)shaderWithProgram:(EGShaderProgram*)program;
- (id)initWithProgram:(EGShaderProgram*)program;
- (void)applyContext:(EGContext*)context material:(id)material draw:(void(^)())draw;
- (void)loadContext:(EGContext*)context material:(id)material;
- (EGShaderAttribute*)attributeForName:(NSString*)name;
- (EGShaderUniform*)uniformForName:(NSString*)name;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGShaderAttribute : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderAttributeWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (void)setFromBufferWithStride:(NSUInteger)stride valuesCount:(NSUInteger)valuesCount valuesType:(GLenum)valuesType shift:(NSUInteger)shift;
- (ODType*)type;
+ (ODType*)type;
@end


@interface EGShaderUniform : NSObject
@property (nonatomic, readonly) GLuint handle;

+ (id)shaderUniformWithHandle:(GLuint)handle;
- (id)initWithHandle:(GLuint)handle;
- (void)setMatrix:(EGMatrix*)matrix;
- (void)setColor:(EGColor)color;
- (void)setVec3:(EGVec3)vec3;
- (void)setNumber:(float)number;
- (ODType*)type;
+ (ODType*)type;
@end


@protocol EGShaderSystem<NSObject>
- (void)applyContext:(EGContext*)context material:(id)material draw:(void(^)())draw;
- (EGShader*)shaderForContext:(EGContext*)context material:(id)material;
- (ODType*)type;
@end


