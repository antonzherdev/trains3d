#import "objd.h"
@class CNBundle;
#import "CNTypes.h"
@class EG;
@class EGContext;
@class EGMatrixStack;
@class EGMatrixModel;
#import "EGGL.h"
@class EGBuffer;
@class EGVertexBuffer;
@class EGIndexBuffer;
@class EGMatrix;
#import "EGTypes.h"
#import "EGVec.h"
@class EGColorSource;
@class EGColorSourceColor;
@class EGColorSourceTexture;
@class EGMaterial;
@class EGSimpleMaterial;
@class EGStandardMaterial;
@class EGTexture;
@class EGFileTexture;

@class EGShaderProgram;
@class EGShader;
@class EGShaderAttribute;
@class EGShaderUniform;
@protocol EGShaderSystem;

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
- (void)applyMaterial:(id)material draw:(void(^)())draw;
- (void)loadMaterial:(id)material;
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
- (void)setMatrix:(EGMatrix*)matrix;
- (void)setColor:(EGColor)color;
- (void)setVec3:(EGVec3)vec3;
- (void)setNumber:(float)number;
+ (ODClassType*)type;
@end


@protocol EGShaderSystem<NSObject>
- (void)applyMaterial:(id)material draw:(void(^)())draw;
- (EGShader*)shaderForMaterial:(id)material;
@end


